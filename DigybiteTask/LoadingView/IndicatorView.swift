//
//  IndicatorView.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation
import UIKit
class Indicator {

    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var message: UILabel = UILabel()
    var title: UILabel = UILabel()
    var action: UIButton = UIButton()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func showActivityIndicator(uiView: UIView) {
        container.frame = uiView.frame
        container.center = CGPoint(x: 200.0, y: uiView.frame.size.height / 2)
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)

        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }
    func showAlert(uiView: UIView, alertTitle: String, alertMessage: String) {
        container.frame = uiView.frame
        container.center = CGPoint(x: 200.0, y: uiView.frame.size.height / 2)
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        loadingView.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        title.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        title.text = alertTitle
        title.textColor = .white
        title.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        message.frame = CGRect(x: 30, y: 0, width: 180, height: 100)
        message.text = alertTitle
        message.numberOfLines = 0
        message.textColor = .white
        message.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(message)
        container.addSubview(loadingView)
        uiView.addSubview(container)
    }

    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }

    func UIColorFromHex(rgbValue: UInt32, alpha: Double = 1.0) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
