//
//  ViewController.swift
//  AssessmentTask
//
//  Created by Adel Aref on 04/12/2021.
//
//

import Foundation
import UIKit
import RxSwift

extension UIViewController: loadingViewable {}

extension Reactive where Base: UIViewController {

    /// Bindable sink for `startAnimating()`, `stopAnimating()` methods.
    public var isAnimating: Binder<Bool> {
        return Binder(self.base, binding: { (viewController, active) in
            if active {
                viewController.startAnimating()
            } else {
                viewController.stopAnimating()
            }
        })
    }

}
