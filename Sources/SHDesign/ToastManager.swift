//
//  ToastManager.swift
//
//
//  Created by Sahib Hussain on 08/02/24.
//

import UIKit

struct ToastManager {
    
    static func show(
        _ title: String,
        subTitle: String = "",
        image: UIImage? = nil,
        haptic: UINotificationFeedbackGenerator.FeedbackType = .success)
    {
        DispatchQueue.main.async {
            if let image = image {
                let toast = Toast.default(
                    image: image,
                    title: title,
                    subtitle: subTitle
                )
                toast.show(haptic: haptic)
            }else {
                let toast = Toast.text(title, subtitle: subTitle)
                toast.show(haptic: haptic)
            }
        }
    }
    
    static func showSuccess(_ title: String, subtitle: String = "", completion: (() -> Void)? = nil) {
        show(title, subTitle: subtitle, image: UIImage(systemName: "checkmark.seal.fill"), haptic: .success)
        DispatchQueue.main.asyncAfter(wallDeadline: .now()+1) {
            completion?()
        }
    }
    
    static func showError(_ title: String, subtitle: String = "", completion: (() -> Void)? = nil) {
        show(title, subTitle: subtitle, image: UIImage(systemName: "xmark.seal"), haptic: .error)
        DispatchQueue.main.asyncAfter(wallDeadline: .now()+1) {
            completion?()
        }
    }
    
}
