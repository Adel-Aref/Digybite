//
//  ViewController.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import Foundation
import UIKit
import RxSwift

extension UIViewController: errorViewable {}

extension Reactive where Base: UIViewController {

    /// Bindable sink for isError() method.
    public var isError: Binder<ErrorMessage> {
        return Binder(self.base, binding: { (viewController, error) in
            viewController.showError(with: error)
        })
    }
}

protocol errorViewable {
    func showError(with: ErrorMessage)
}
extension errorViewable where Self: UIViewController {
    func showError(with: ErrorMessage) {
        let alertController =
            UIAlertController(title: with.title, message: with.message, preferredStyle: UIAlertController.Style.alert)
        let okAction =
            UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {(action) in
            if let action = with.action {
                action()
            }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

public struct ErrorMessage {
    let title: String?
    let message: String?
    let action: (() -> Void)?
}
