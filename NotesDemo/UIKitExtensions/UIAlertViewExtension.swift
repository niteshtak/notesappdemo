//
//  UIAlertViewExtension.swift
//  NotesUIKit
//
//  Created by Nitesh Tak on 27/12/20.
//

import UIKit

typealias ActionCallback = (UIAlertAction) -> ()

enum AlertAction {
    case cancel
    case ok
    case custom(String, ActionCallback)
    case destructive(String, ActionCallback)
}

extension AlertAction {

    var title: String {
        switch self {
        case .cancel:
            return "Cancel"
        case .ok:
            return "OK"
        case .custom(let title, _),
             .destructive(let title, _):
            return title
        }
    }
    
    var style: UIAlertAction.Style {
        switch self {
        case .cancel:
            return .cancel
        case .ok, .custom:
            return .default
        case .destructive:
            return .destructive
        }
    }
    
    var handler: ActionCallback? {
        switch self {
        case .cancel, .ok:
            return nil
        case .custom(_, let handler),
             .destructive(_, let handler):
            return handler
        }
    }
    
    var action: UIAlertAction {
        return UIAlertAction(title: title, style: style, handler: handler)
    }
}

extension UIAlertController {
    static func showAlert(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert, actions: [AlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0.action) }
        UIViewController.topViewController()?.present(alert, animated: true, completion: nil)
    }
}

