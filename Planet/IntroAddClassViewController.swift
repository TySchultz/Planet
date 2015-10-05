//
//  IntroAddClassViewController.swift
//  Planet
//
//  Created by Ty Schultz on 9/28/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import AKPickerView_Swift
class IntroAddClassViewController: UIViewController, UITextViewDelegate, AKPickerViewDelegate, AKPickerViewDataSource{

    @IBOutlet weak var colorScrollView: UIScrollView!

    @IBOutlet weak var hourPicker: AKPickerView!
    @IBOutlet weak var minutePicker: AKPickerView!

    
    @IBOutlet weak var classTimeField: UITextField!
    @IBOutlet weak var classNameField: UITextField!
    var parent : IntroViewController!
    
    

    @IBOutlet weak var oldButton: PLButton!
    
    var hour :Int  = 0
    
    var minute :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classNameField.becomeFirstResponder() //Shows keyboard when view opens. Automaticallly makes this textfield selected

        //I set the tags just so i can tell which is which when the datasource methods are called.
        //tag doesnt do anything really
        hourPicker.tag = 1
        minutePicker.tag = 2
        
//        //Delegate means it sends calls to this class. so the pickerview did select item at the bottom is a delegate method
//        hourPicker.delegate = self
//        hourPicker.dataSource = self
//        
//        hourPicker.interitemSpacing = 10.0
//        hourPicker.highlightedTextColor = UIColor.blueColor()

        
        //Datasource means this class provides data. so the number of itesms in pickerview and pickerview title for item
        configurePickerView(minutePicker)
        configurePickerView(hourPicker)


        
        hourPicker.selectItem(12)
        minutePicker.selectItem(6)
        
        
        colorScrollView.contentSize = CGSizeMake(800, 50)
    }
    
    
    func configurePickerView( picker :AKPickerView){
        //Datasource means this class provides data. so the number of itesms in pickerview and pickerview title for item
        picker.delegate = self
        picker.dataSource = self

        picker.interitemSpacing = 10.0
        picker.highlightedTextColor = UIColor.blackColor()
        picker.textColor = UIColor.lightGrayColor()
        picker.font = UIFont(name: "Avenir Book", size: 18)!
        picker.highlightedFont = UIFont(name: "Avenir Book", size: 18)!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var closeView: UIButton!

    @IBAction func submitClass(sender: UIButton) {
        //Checks to see if we have a color selected
        if !(oldButton != nil){
            UIView.animateWithDuration(0.2, delay: 0.0, options: [.CurveEaseInOut, .Autoreverse], animations: { () -> Void in
                self.colorScrollView.backgroundColor = UIColor.redColor()
                
            }, completion: { (Bool) -> Void in
                    self.colorScrollView.backgroundColor = UIColor.clearColor()
            })
            
        }else{
            classNameField.resignFirstResponder() //Hides Keyboard
            
            //If we were sending back time. 
            //parent.addTime(hour, minute)  hour and minute are set when the things scroll
            
            self.dismissViewControllerAnimated(true) { () -> Void in
                self.parent.addClass(self.classNameField.text!, color: self.oldButton.backgroundColor!)//Add textfield text to parent
            }//hide the viewController
        }
    }
    
    @IBAction func closeViewPressed(sender: UIButton) {
        classNameField.resignFirstResponder() //Hides Keyboard
        
        self.dismissViewControllerAnimated(true, completion: nil) //hide the viewController
    }
    
    
    func numberOfItemsInPickerView(pickerView: AKPickerView) -> Int {
        
        if pickerView.tag == 1 {
            return 24
        }else{
            return 12
        }
    }
   
   
    func pickerView(pickerView: AKPickerView, var titleForItem item: Int) -> String {
        
        if pickerView.tag == 1 {
            if item > 11 {
                item = item - 12
            }
            return "\(item+1)"
            
        }else{
            return "\(item*5)"
        }
    }

    //When the picker view changes
    func pickerView(pickerView: AKPickerView, didSelectItem item: Int) {
        if pickerView.tag == 1 {
            hour = item
        }else{
            minute = item
        }
    }
    
    @IBAction func colorButtonPressed(sender: PLButton) {
        if !(oldButton != nil) {
            oldButton = sender
        }else{
            oldButton.setTitle(" ", forState: UIControlState.Normal)
            oldButton = sender
        }
        sender.setTitle("✓", forState: UIControlState.Normal)
    }
}
