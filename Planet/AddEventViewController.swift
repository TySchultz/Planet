//
//  AddEventViewController.swift
//  Planet
//
//  Created by Ty Schultz on 1/19/16.
//  Copyright © 2016 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift
import CVCalendar
import Crashlytics


class AddEventViewController: UITableViewController {
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    @IBOutlet weak var typeStackLBL: UILabel!
    @IBOutlet weak var classStackLBL: UILabel!
    @IBOutlet weak var header: UIView!
    
    @IBOutlet weak var classStack: UIStackView!
    @IBOutlet weak var typeStack: UIStackView!
    
    @IBOutlet weak var createButton: UIButton!
    //Calendar
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysOutSwitch: UISwitch!
    var shouldShowDaysOut = true
    var animationFinished = true
    
    
    var delegate : OverheadViewController!

    
    var currentCourses : Results<Course>!
    var chosenCourse : Course!
    
    var currentCourseName = ""
    var currentEventType = ""
    var currentDateChoice = NSDate().beginningOfDay
    
    var currentTypeStackIndex = 0
    var currentCourseStackIndex = 0
    
    
    let types = ["Test","Quiz","Homework","Project","Meeting", "Presentation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.calendarView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width-40, height: 300)
        
        self.calendarView.calendarAppearanceDelegate = self
    
        // Animator delegate [Unnecessary]
        self.calendarView.animatorDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        self.calendarView.backgroundColor = UIColor.whiteColor()
        self.menuView.backgroundColor = UIColor.whiteColor()
        
        
        self.view.setNeedsUpdateConstraints()
        self.view.setNeedsLayout()
        
        setup()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        setup()
    }
    
    override func viewDidDisappear(animated: Bool) {
        clearOutStackView(typeStack)
        clearOutStackView(classStack)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
        
    }
    
    func setup () {
        
        monthLabel.text = CVDate( date: NSDate()).globalDescription
        
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
            addButtonToStack(type,color:MAINTHEMECOLOR, stackView: typeStack)
        }
        
        self.header.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 700.0)
        
        
        self.createButton.layer.cornerRadius = 16.0
        createButton.layer.borderWidth = 1.0
        createButton.layer.borderColor = PLBlue.CGColor
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
    
    func addButtonToStack(type : String,color : Int, stackView : UIStackView){
        let label = createButton(type, type: stackView.tag)
        label.backgroundColor = Course().colorForType(color)
        
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
        let height :CGFloat = 40.0
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
        label.alpha = 1.0
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
            sender.tag = 1
            removeFromStack(sender, stack:classStack)
            
            currentCourseName =  (sender.titleLabel?.text)!
            
            
        }
            //Button in header is tapped and already selected
        else if sender.tag == 1 {
            sender.tag = 0
            showStack(classStack)
            
            currentCourseName = ""
            
        }
        
    }
    
    func typeButtonPressed(sender : UIButton){
        
        print("\(sender.tag)")
        //button in header is tapped and not selected
        if sender.tag == 0 {
            sender.tag = 1
            removeFromStack(sender, stack: typeStack)
            currentEventType = sender.titleLabel!.text!
        }
            //Button in header is tapped and already selected
        else if sender.tag == 1 {
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
                    button.tag = 0
                    }, completion: { (Bool) -> Void in
                })
            }
        }
    }
    
    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil) //hide the viewController
    }
    
    
    @IBAction func createEvent(sender: UIButton) {
        
        
        
        if emptySelection(){
            return
        }
        
        let realm = try! Realm()
        
        //Creates a new course
        let newEvent = Event()
        newEvent.date = currentDateChoice
        newEvent.serverID = randomStringWithLength(12) as String
        newEvent.type = currentEventType
        
        let realmCourse = realm.objects(Course).filter("name = '\(currentCourseName)'")
        newEvent.course = realmCourse.first
        
        try! realm.write { () -> Void in
            realm.add(newEvent)
        }
        
        Answers.logContentViewWithName("Add Event", contentType: "", contentId: "", customAttributes: ["type":currentEventType, "course":(realmCourse.first?.name)!])

        self.delegate.hideEmptyState()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func emptySelection() -> Bool {
        classStackLBL.text = "Class"
        classStackLBL.textColor = UIColor.blackColor()
        typeStackLBL.text = "Type"
        typeStackLBL.textColor = UIColor.blackColor()

        if currentCourseName == "" {
            classStackLBL.text = "Class - Hey you need one of these"
            classStackLBL.textColor = PLOrange
            return true
        }else if currentEventType == "" {
            typeStackLBL.text = "Type - Hey you need one of these"
            typeStackLBL.textColor = PLOrange
            return true
        }
        return false
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    func didSelectDayView(dayView: DayView) {
        print(NSDate().beginningOfDay)
        print(dayView.date.convertedDate()!.beginningOfDay)
        
        currentDateChoice = dayView.date.convertedDate()!.beginningOfDay
        print("\(calendarView.presentedDate.commonDescription) is selected!")
    }
}




extension AddEventViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func didSelectDayView(dayView: CVCalendarDayView, animationDidFinish: Bool) {
        let date = dayView.date
        print("\(calendarView.presentedDate.commonDescription) is selected!")
    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            self.monthLabel.text =  date.globalDescription
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date.day
        let randomDay = Int(arc4random_uniform(31))
        if day == randomDay {
            return true
        }
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        let day = dayView.date.day
        
        let red = CGFloat(arc4random_uniform(600) / 255)
        let green = CGFloat(arc4random_uniform(600) / 255)
        let blue = CGFloat(arc4random_uniform(600) / 255)
        
        let color = UIColor.clearColor()
        
        let numberOfDots = Int(arc4random_uniform(3) + 1)
        switch(numberOfDots) {
        case 2:
            return [color, color]
        case 3:
            return [color, color, color]
        default:
            return [color] // return 1 dot
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 13
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
}


extension AddEventViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 0
    }
}


// MARK: - IB Actions

extension AddEventViewController {
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on {
            calendarView.changeDaysOutShowingState(false)
            shouldShowDaysOut = true
        } else {
            calendarView.changeDaysOutShowingState(true)
            shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(sender: AnyObject) {
        calendarView.changeMode(.WeekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.MonthView)
    }
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
}

