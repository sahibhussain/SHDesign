//
//  CustomNavigationStack.swift
//  SHDesign
//
//  Created by Sahib Hussain on 28/05/25.
//

import SwiftUI

public struct CustomSwipeNavigation<Content: View>: View {
    
    @Binding var path: NavigationPath
    @ViewBuilder var content: Content
    
    @State private var customGesture: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer()
        gesture.name = UUID().uuidString
        gesture.isEnabled = true
        return gesture
    }()
    
    public var body: some View {
        NavigationStack(path: $path) {
            content
                .background {
                    AttachGestureView(gesture: $customGesture)
                }
        }
        .toolbar(.hidden, for: .navigationBar)
        .environment(\.popGestureID, customGesture.name)
        .onReceive(NotificationCenter.default.publisher(for: .init(customGesture.name ?? ""))) { info in
            if let userInfo = info.userInfo, let status = userInfo["status"] as? Bool {
                customGesture.isEnabled = status
            }
        }
    }
    
}

fileprivate struct PopNotificationID: EnvironmentKey {
    static var defaultValue: String?
}

fileprivate extension EnvironmentValues {
    var popGestureID: String? {
        get {
            self[PopNotificationID.self]
        }
        set {
            self[PopNotificationID.self] = newValue
        }
    }
}

public extension View {
    @ViewBuilder
    func enableFullSwipeGesture(_ isEnabled: Bool) -> some View {
        self
            .modifier(FullSwipeModifier(isEnabled: isEnabled))
    }
}

fileprivate struct FullSwipeModifier: ViewModifier {
    var isEnabled: Bool
    @Environment(\.popGestureID) private var gestureID
    func body(content: Content) -> some View {
        content
            .onAppear(perform: {
                guard let gestureID else { return }
                NotificationCenter.default.post(name: .init(gestureID), object: nil, userInfo: ["status": isEnabled])
            })
            .onChange(of: isEnabled) { newValue in
                guard let gestureID else { return }
                NotificationCenter.default.post(name: .init(gestureID), object: nil, userInfo: ["status": newValue])
            }
            .onDisappear {
                guard let gestureID else { return }
                NotificationCenter.default.post(name: .init(gestureID), object: nil, userInfo: ["status": isEnabled])
            }
    }
}


fileprivate struct AttachGestureView: UIViewRepresentable {
    
    @Binding var gesture: UIPanGestureRecognizer
    
    func makeUIView(context: Context) -> UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
            if let parentViewController = uiView.parentViewController, let navigationController = parentViewController.navigationController {
                if let _ = navigationController.view.gestureRecognizers?.first(where: { $0.name == gesture.name }) {
                    print("Already Attached")
                } else {
                    navigationController.addFullSwipeGesture(gesture)
                    print("Attached")
                }
            }
        }
    }
}

fileprivate extension UINavigationController {
    func addFullSwipeGesture(_ gesture: UIPanGestureRecognizer) {
        guard let gestureSelector = interactivePopGestureRecognizer?.value(forKey: "targets") else { print("not found"); return }
        gesture.setValue(gestureSelector, forKey: "targets")
        view.addGestureRecognizer(gesture)
    }
}

fileprivate extension UIView {
    var parentViewController: UIViewController? {
        sequence(first: self, next: { $0.next }).first(where: { $0 is UIViewController }) as? UIViewController
    }
}
