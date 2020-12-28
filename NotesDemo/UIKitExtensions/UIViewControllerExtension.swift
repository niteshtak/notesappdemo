//
//  UIViewControllerExtension.swift
//  NotesUIKit
//
//  Created by Nitesh Tak on 27/12/20.
//

import UIKit

extension UIViewController {

    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! SceneDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            if let visible = nav.visibleViewController, !visible.isBeingDismissed {
                return topViewController(base: visible)
            }
            if let top = nav.topViewController {
                return topViewController(base: top)
            }
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController, !presented.isBeingDismissed {
            return topViewController(base: presented)
        }
       
        return base
    }
}
