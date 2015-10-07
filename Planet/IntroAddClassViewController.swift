//
//  IntroAddClassViewController.swift
//  Planet
//
//  Created by Ty Schultz on 9/28/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import AKPickerView_Swift

import RealmSwift

class IntroAddClassViewController: UIViewController, UITextViewDelegate, AKPickerViewDelegate, AKPickerViewDataSource{

    @IBOutlet weak var colorScrollView: UIScrollView!

    @IBOutlet weak var hourPicker: AKPickerView!
    @IBOutlet weak var minutePicker: AKPickerView!

    @IBOutlet weak var classNameHDR: UILabel!
    @IBOutlet weak var buttonStack: UIStackView!
    
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
        
        //Datasource means this class provides data. so the number of itesms in pickerview and pickerview title for item
        configurePickerView(minutePicker)
        configurePickerView(hourPicker)
        
        hourPicker.selectItem(12)
        minutePicker.selectItem(6)
        
        addButtonsToStack()
        
        
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
            //Creates a new course
            let newCourse = Course()
            newCourse.name = self.classNameField.text!
            newCourse.serverID = self.classNameField.text!
            
            let realme = try? Realm()
            
            var alreadyCreated = false
            
            //Gets all the courses from our local database
            //loops through and checks for a used name
            let allCourses = realme!.objects(Course)
            for singleCourse in allCourses where singleCourse.name == self.classNameField.text!{
                alreadyCreated = true
            }
            
            if !alreadyCreated {
                classNameField.resignFirstResponder() //Hides Keyboard

                //Creates the new course object and add it to our database.
                realme!.write({ () -> Void in
                    realme!.add(newCourse)
                })
                
                //Hides this view. When it hides at the completion call the add class method
                self.dismissViewControllerAnimated(true) { () -> Void in
                    self.parent.addClass(self.classNameField.text!, color: self.oldButton.backgroundColor!)
                }
            }else{
                classNameHDR.text = "Already used class name"
                classNameHDR.textColor = UIColor.redColor()
                animateErrorTextField()
            }
        }
    }
    
    func animateErrorTextField(){
        UIView.animateWithDuration(0.2, delay: 0.0, options:  UIViewAnimationOptions.Autoreverse, animations: { () -> Void in
            self.classNameField.backgroundColor = UIColor.redColor()
            }, completion: { (Bool) -> Void in
                self.classNameField.backgroundColor = UIColor.clearColor()
        })
    }
    
    @IBAction func closeViewPressed(sender: UIButton) {
        classNameField.resignFirstResponder() //Hides Keyboard
        
        self.dismissViewControllerAnimated(true, completion: nil) //hide the viewController
    }
    
    func addButtonsToStack(){
        let colors = [PLBlack, PLBlue, PLGray, PLGreen, PLOrange, PLPurple]
        for var i = 0; i < 10; i++ {
            let button = UIButton(frame: CGRectMake(0, 0, 42, 42))
            button.backgroundColor = colors[i%colors.count]
            button.heightAnchor.constraintEqualToConstant(42).active = true
            button.widthAnchor.constraintEqualToConstant(42).active = true
            button.layer.cornerRadius = 21
            button.addTarget(self, action: "colorButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            buttonStack.addArrangedSubview(button)
        }
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
