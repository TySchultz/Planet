//
//  AddObjectCell.swift
//  Planet
//
//  Created by Ty Schultz on 3/25/16.
//  Copyright © 2016 Ty Schultz. All rights reserved.
//

import UIKit

class AddObjectCell: UITableViewCell, UITextFieldDelegate{

    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var addImage: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.textField.delegate = self
        self.doneButton.setTitleColor(PLBlue, forState: UIControlState.Normal)
        
        self.colorButton.backgroundColor = PLBlue
        self.colorButton.layer.cornerRadius = self.colorButton.frame.size.width/2
        self.colorButton.transform = CGAffineTransformMakeScale(0.0, 0.0)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        beginEditing()
    }
}
//MARK: - Interface

extension AddObjectCell {
    
    func beginEditing (){
        self.doneButton.alpha = 1.0
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.addImage.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.colorButton.transform = CGAffineTransformMakeScale(1.0, 1.0)

            }, completion: nil)
        
        let defaults = NSUserDefaults.standardUserDefaults()

        let hasCourseColorChosenBefore = defaults.objectForKey("CourseColorChosenBefore") as? Bool
        if hasCourseColorChosenBefore == nil {

            UIView.animateAndChainWithDuration(0.6, delay: 0.4, options: UIViewAnimationOptions.CurveEaseInOut, animations:{
                self.colorButton.transform = CGAffineTransformMakeScale(0.85, 0.85)
                
            }){ (Bool) in
                
            }.animateAndChainWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.colorButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                
                }, completion: { (Bool) in
                    
            }).animateAndChainWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.colorButton.transform = CGAffineTransformMakeScale(0.8, 0.8)
                
                }, completion: { (Bool) in
                    
            }).animateAndChainWithDuration(0.6, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.colorButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
                
                }, completion: { (Bool) in
            })
        }
    }
    
    func endedEditing (){
        textField.resignFirstResponder()
        textField.text = ""
        self.doneButton.alpha = 0.0
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.addImage.transform = CGAffineTransformMakeScale(1, 1)
            self.colorButton.transform = CGAffineTransformMakeScale(0.0, 0.0)

            }, completion: nil)
    }
    
    func changeColorButtonBackground(color : UIColor){
        self.colorButton.transform = CGAffineTransformMakeScale(0.85, 0.85)

        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.colorButton.transform = CGAffineTransformMakeScale(1.0, 1.0)
            self.colorButton.backgroundColor = color
            }, completion: nil)
    }
}



//MARK: - IBActions

extension AddObjectCell {
    
    @IBAction func doneButtonPressed(sender: UIButton) {
        
        endedEditing()
    }
}

