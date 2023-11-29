//
//  UIApplicatio+topView.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//
import UIKit

extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication
        .shared
        .windows
        .filter {$0.isKeyWindow}.first?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}

extension UIViewController {
    static func instantiateFromNib() -> Self? {
        func instantiateFromNib<T: UIViewController>(_ viewType: T.Type) -> T? {
            return Bundle.main.loadNibNamed(String(describing: T.self),
                                     owner: nil, options: nil)?.first
            as? T
        }

        return instantiateFromNib(self)
    }
}
