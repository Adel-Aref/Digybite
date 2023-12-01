//
//  DigybiteShadowView.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import UIKit

class DigybiteShadowView: UIView {
    
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
        backgroundColor = .clear
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 4
    }
    
}
