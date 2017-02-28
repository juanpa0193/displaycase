//
//  MaterialTextField.swift
//  jp's-showcase
//
//  Created by JuanPa Villa on 2/25/17.
//  Copyright © 2017 JuanPa Villa. All rights reserved.
//

import UIKit

class MaterialTextField: UITextField {

    override func awakeFromNib() {
        layer.cornerRadius = 2.0
        layer.borderColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.1).cgColor
        layer.borderWidth = 1.0
        
    }
    
    //For Place Holder
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
    
        return bounds.insetBy(dx: 10, dy: 0)
    }
    
    //For editable text
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 10, dy: 0)
    }

}
