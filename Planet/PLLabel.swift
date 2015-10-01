//
//  PLLabel.swift
//  Planet
//
//  Created by Ty Schultz on 9/29/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
@IBDesignable
class PLLabel: UILabel {

    
    
    //This allows the variable to show up in the inspector of the storybaord
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0 //creates a mask like you would in photoshop. so that it shows the corner radius
            
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
