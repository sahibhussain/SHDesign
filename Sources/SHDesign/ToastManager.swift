//
//  ToastManager.swift
//  SahibDesign
//
//  Created by Sahib Hussain on 13/09/22.
//

import UIKit

struct ToastManager {
    
    static func show(
        _ title: String,
        subTitle: String = "",
        image: UIImage? = nil,
        haptic: UINotificationFeedbackGenerator.FeedbackType = .success)
    {
        
        let config = ToastConfiguration(autoHide: true, enablePanToClose: true, displayTime: 2, animationTime: 0.2)
        
        if let image = image {
            let toast = Toast.default(
                image: image,
                title: title,
                subtitle: subTitle,
                config: config
            )
            toast.show(haptic: haptic)
        }else {
            let toast = Toast.text(title, subtitle: subTitle)
            toast.show(haptic: haptic)
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
