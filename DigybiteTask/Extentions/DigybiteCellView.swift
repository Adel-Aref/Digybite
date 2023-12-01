//
//  DigybiteCellView.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import UIKit

class DigybiteCellView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .lightText
        layer.cornerRadius = 15
        
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 1)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 4.0
    }
    
    func setCustomCorner(_ raduis: CGFloat) {
        layer.cornerRadius = raduis
    }
}
