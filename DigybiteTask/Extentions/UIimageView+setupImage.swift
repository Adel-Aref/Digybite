//
//  UIimageView+setupImage.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    func setImage(strUrl: String?, name: String) {
        guard let url = URL(string: strUrl ?? "") else {
            self.image = UIImage(named: name)
            return
        }
        self.sd_setImage(with: url, placeholderImage: UIImage(named: name))
    }
}
