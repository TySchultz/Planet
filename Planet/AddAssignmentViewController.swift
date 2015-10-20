//
//  AddAssignmentViewController.swift
//  Planet
//
//  Created by Nick Armold on 10/7/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift
import CVCalendar

class AddAssignmentViewController: UIViewController {
    
    
    @IBOutlet weak var classStack: UIStackView!
    @IBOutlet weak var typeStack: UIStackView!
    
    var currentCourses : Results<Course>!
    var chosenCourse : Course!
    
    var currentCourseName = ""
    var currentEventType = ""

    var currentDayAdditions = 0

    var currentTypeStackIndex = 0
    var currentCourseStackIndex = 0
    
    
    let types = ["Test","Quiz","Homework","Project","Presentation","Meeting"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    override func viewWillAppear(animated: Bool) {
        setup()
    }
    
    override func viewDidDisappear(animated: Bool) {
        clearOutStackView(typeStack)
        clearOutStackView(classStack)
    }
    
    func setup () {
        
        
        currentTypeStackIndex = 0
        currentCourseStackIndex = 0
        
        clearOutStackView(typeStack)
        clearOutStackView(classStack)
        
        
        let realme = try? Realm()
        
        typeStack.tag = 1
        classStack.tag = 0
        
        let allCourses = realme!.objects(Course)
        for course in allCourses  {
            addButtonToStack(course.name,color:course.color, stackView: classStack)
        }
        
        for type in types {
            addButtonToStack(type,color:"PLBLUE", stackView: typeStack)
        }
    }
    
    
    func clearOutStackView(stack : UIStackView){
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    
    func validAddToStack(stack : UIStackView, let stackNumber : Int) -> Bool {
        
        var currentWidth :CGFloat = 0.0
        let viewWidth = view.frame.size.width - 150
        for view in stack.arrangedSubviews {
            currentWidth += view.frame.size.width + 8
        }
        
        if currentWidth > viewWidth {
            if stackNumber == 0 {
                currentCourseStackIndex += 1
            }else{
                currentTypeStackIndex += 1
            }
            return false
        }
        return true
    }
    
    func addButtonToStack(type : String,color : String, stackView : UIStackView){
        let label = createButton(type, type: stackView.tag)
        label.backgroundColor = Course().colorForType(ColorType(rawValue: color)!)

        var currentStackIndex = 0
        if stackView.tag == 0 {
            currentStackIndex = currentCourseStackIndex
        }else{
            currentStackIndex = currentTypeStackIndex
        }
        
        if stackView.arrangedSubviews.count == 0 {
            let newStack = UIStackView(frame: CGRectMake(0, 0, 200, 10))
            newStack.axis = .Horizontal
            newStack.alignment = .Leading
            newStack.spacing = 8.0
            stackView.addArrangedSubview(newStack)
            newStack.addArrangedSubview(label)
        }else{
            let currentStack = stackView.arrangedSubviews[currentStackIndex] as! UIStackView
            currentStack.addArrangedSubview(label)
            if !validAddToStack(currentStack,stackNumber: stackView.tag) {
                currentStack.removeArrangedSubview(label)
                let newStack = UIStackView(frame: CGRectMake(0, 0, 200, 10))
                newStack.axis = .Horizontal
                newStack.alignment = .Fill
                newStack.distribution = .EqualSpacing
                newStack.spacing = 8.0
                stackView.addArrangedSubview(newStack)
                newStack.addArrangedSubview(label)
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    newStack.addArrangedSubview(label)
                })
            }
        }
        
    }
    
    func createButton(title : String, type: Int) -> UIButton{
        let height :CGFloat = 24.0
        let label = UIButton(frame: CGRectMake(0, 0, 100, height))
        label.setTitle(title, forState: UIControlState.Normal)
        label.titleLabel?.font = UIFont(name: "Avenir Book", size: 15)
        label.backgroundColor = PLBlue
        label.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        label.layer.cornerRadius = label.frame.size.height/2
        label.layer.masksToBounds = true
        label.titleLabel?.textAlignment = NSTextAlignment.Center
        label.sizeToFit()
        label.heightAnchor.constraintEqualToConstant(height).active = true
        label.widthAnchor.constraintEqualToConstant(label.frame.size.width+30).active = true
        label.alpha = 0.3
        if type == 0 {
            label.addTarget(self, action: "classButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        }else{
            label.addTarget(self, action: "typeButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        }
        return label
    }
    
    
    func classButtonPressed(sender : UIButton){
        
        print("\(sender.tag)")
        //button in header is tapped and not selected
        if sender.tag == 0 {
            sender.alpha = 1.0
            sender.tag = 1
            removeFromStack(sender, stack:classStack)
            
            currentCourseName =  (sender.titleLabel?.text)!
            
    
        }
        //Button in header is tapped and already selected
        else if sender.tag == 1 {
            sender.alpha = 0.3
            sender.tag = 0
            showStack(classStack)
            
            currentCourseName = ""

        }
        
    }
    
    func typeButtonPressed(sender : UIButton){
        
        print("\(sender.tag)")
        //button in header is tapped and not selected
        if sender.tag == 0 {
            sender.alpha = 1.0
            sender.tag = 1
            removeFromStack(sender, stack: typeStack)
            currentEventType = sender.titleLabel!.text!
        }
            //Button in header is tapped and already selected
        else if sender.tag == 1 {
            sender.alpha = 0.3
            sender.tag = 0
            
            showStack(typeStack)
            currentEventType = ""
        }
    }


    
    func removeFromStack(sender : UIButton ,stack : UIStackView){
        for  stack in stack.arrangedSubviews as! [UIStackView] {
            var found = false
            for button in stack.arrangedSubviews as! [UIButton] {
                if button == sender{
//                    UIView.animateWithDuration(0.2, animations: { () -> Void in
//                        button.alpha = 0.0
//                        button.hidden = true
//                        }, completion: { (Bool) -> Void in
////                            stack.removeArrangedSubview(button)
//                    })
                    found = true
                }
            }
            if !found {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    stack.hidden = true
                    }, completion: { (Bool) -> Void in

                })
            }else{
                for button in stack.arrangedSubviews as! [UIButton] {
                    if button != sender{
                                            UIView.animateWithDuration(0.2, animations: { () -> Void in
                                                button.alpha = 0.0
                                                button.hidden = true
                                                }, completion: { (Bool) -> Void in
                        //                            stack.removeArrangedSubview(button)
                                            })
                        found = true
                    }
                }
            }
        }
    }
    
    func showStack(stack : UIStackView){
        for  stack in stack.arrangedSubviews as! [UIStackView] {
            if stack.hidden == true {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    stack.hidden = false
                })
            }
            for button in stack.arrangedSubviews as! [UIButton] {
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                        button.hidden = false
                        button.alpha = 0.3
                        button.tag = 0
                        }, completion: { (Bool) -> Void in
                })
                }
            }
    }

    
    
    
//    
//    func addButtonsToStack(){
//        
//        
//        let realme = try? Realm()
//        
//        let allCourses = realme!.objects(Course)
//
//        for singleCourse in allCourses {
//            let button = UIButton(frame: CGRectMake(0, 0, 250, 250))
//            button.backgroundColor = PLBlue
//            button.setTitle(singleCourse.name, forState: UIControlState.Normal)
//            button.layer.cornerRadius = 18
//            button.addTarget(self, action: "classButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
//            classStack.addArrangedSubview(button)
//        }
//    }

    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil) //hide the viewController
    }
    

    @IBAction func createEvent(sender: UIButton) {
        
        let realm = try! Realm()
        
        //Creates a new course
        let newEvent = Event()
        newEvent.date = NSDate(timeIntervalSinceNow: 0).add(years: 0, months: 0, weeks: 0, days: currentDayAdditions, hours: 0, minutes: 0, seconds: 0)
        newEvent.serverID = randomStringWithLength(12) as String
        newEvent.type = currentEventType

        let realmCourse = realm.objects(Course).filter("name = '\(currentCourseName)'")
        newEvent.course = realmCourse.first
        
        realm.write { () -> Void in
            realm.add(newEvent)
        }
        
        showStack(typeStack)
        showStack(classStack)

    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        var randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            var length = UInt32 (letters.length)
            var rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
 
    @IBAction func addDayButtonPressed(sender: UIButton) {
        
        currentDayAdditions = sender.tag
        sender.backgroundColor = PLBlue
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
