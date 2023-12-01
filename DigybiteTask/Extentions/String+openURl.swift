//
//  String+openURl.swift
//  DigybiteTask
//
//  Created by Adel Aref on 01/12/2023.
//

import Foundation
import SafariServices


extension String {
    func openInSafari() {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        guard let url = URL(string: self) else { return }
        let vc = SFSafariViewController(url: url, configuration: config)
        UIApplication.getTopViewController()?.present(vc, animated: true)
    }
}
