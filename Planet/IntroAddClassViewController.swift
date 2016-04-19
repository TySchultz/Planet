//
//  IntroAddClassViewController.swift
//  Planet
//
//  Created by Ty Schultz on 9/28/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit

import RealmSwift
import Crashlytics
class IntroAddClassViewController: UITableViewController, UITextViewDelegate{

    @IBOutlet weak var header: UIView!

    @IBOutlet weak var classNameField: UITextField!

    @IBOutlet weak var createClassButton: UIButton!
    
    @IBOutlet weak var topColorStack: UIStackView!
    @IBOutlet weak var bottomColorStack: UIStackView!
    
    @IBOutlet weak var classNameLBL: UILabel!
    var currentColor : Int = 0
    
    var delegate : ClassesTableViewController?
    var hour :Int  = 0
    
    var minute :Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classNameField.becomeFirstResponder() //Shows keyboard when view opens. Automaticallly makes this textfield selected

        createClassButton.layer.cornerRadius = 16.0
        createClassButton.layer.borderWidth = 1.0
        createClassButton.layer.borderColor = PLBlue.CGColor
        
        
        var index = 0
        for button in topColorStack.arrangedSubviews as! [UIButton] {
                setupButton(button, index: index)
                index++
        }
        for button in bottomColorStack.arrangedSubviews as! [UIButton] {
                setupButton(button, index: index)
                index++
        }
        
        header.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 500.0)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func setupButton (button : UIButton, index : Int){
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        button.backgroundColor = buttonColor(index)
        button.tag = index
    }
    
    func buttonColor(index : Int) -> UIColor {
        switch index{
        case 0:
            return PLOrange
        case 1:
            return PLLightGreen
        case 2:
            return PLGray
        case 3:
            return PLRed
        case 4:
            return PLLightBlue
        case 5:
            return PLBlue
        case 6:
            return PLGreen
        case 7:
            return PLPurple
        default:
            return PLBlue
        }
    }
    
//    /**
//     Returns the UIColor corresponding to the colorType
//     
//     - parameter type: the type of color ColorType
//     
//     - returns: the UIColor
//     */
//    func colorForType(type : Int) -> UIColor {
//        switch type{
//        case 0:
//            return PLBlue
//        case 1:
//            return PLGreen
//        case 2:
//            return PLPurple
//        case 3:
//            return PLGray
//        case 4:
//            return PLRed
//        case 5:
//            return PLOrange
//        case 6:
//            return PLYellow
//        case 7:
//            return PLLightBlue
//        case default:
//            return PLBlue
//        }
//    }


    @IBAction func submitClass(sender: UIButton) {
        //Checks to see if we have a color selected
        
        if self.classNameField.text == "" {
            classNameLBL.text = "Class name - One of these might help you out?"
            classNameLBL.textColor = PLOrange
            return
        }
        
        let newCourse = Course()
        newCourse.name = self.classNameField.text!
        newCourse.serverID = self.classNameField.text!
        newCourse.color = currentColor
    
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
            try! realme!.write({ () -> Void in
                realme!.add(newCourse)
            })
            
            self.delegate?.hideEmptyTable()
            //Hides this view. When it hides at the completion call the add class method
            self.dismissViewControllerAnimated(true) { () -> Void in
                //                    self.parent.addClass(self.classNameField.text!, color: self.oldButton.backgroundColor!)
//                    self.delegate?.animateTable(0.5)
                self.delegate?.delegate.setupSort()
                Answers.logContentViewWithName("Add Course", contentType: "", contentId: "", customAttributes: ["color":self.currentColor, "name":self.classNameField.text!])
            }
        }else{
            classNameLBL.text = "Class name - Have you used that already?"
            classNameLBL.textColor = PLOrange
            return
        }
//        }
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
    
    @IBAction func colorButtonPressed(sender: UIButton) {
        self.currentColor = sender.tag
        for button in topColorStack.arrangedSubviews as! [UIButton] {
            button.setTitle("", forState: UIControlState.Normal)
        }
        for button in bottomColorStack.arrangedSubviews as! [UIButton] {
            button.setTitle("", forState: UIControlState.Normal)
        }
        sender.setTitle("✓", forState: UIControlState.Normal)
    }
}
