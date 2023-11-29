//
//  BaseController.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation
import UIKit

class BaseController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func popViewController(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }
}
