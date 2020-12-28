//
//  ClosureWrapper.swift
//  notesdemo
//
//  Created by Nitesh Tak on 27/12/20.
//

import Foundation

import UIKit

typealias TargetClosure<T> = (T) -> ()

class ClosureWrapper<T>: NSObject {
    let closure: TargetClosure<T>
    init(_ closure: @escaping TargetClosure<T>) {
        self.closure = closure
    }
}

extension UIButton {
    
    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }
    
    private var targetClosure: TargetClosure<UIButton>? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? ClosureWrapper<UIButton> else { return nil }
            return closureWrapper.closure
        }
        set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, ClosureWrapper(newValue), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func addTargetClosure(closure: @escaping TargetClosure<UIButton>) {
        targetClosure = closure
        addTarget(self, action: #selector(UIButton.closureAction), for: .touchUpInside)
    }
    
    @IBAction func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }
}
