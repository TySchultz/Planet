//
//  MasterViewController.swift
//  Planet
//
//  Created by Ty Schultz on 9/28/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate
import Crashlytics
import CVCalendar
import EasyAnimation

class MasterViewController: UITableViewController {
    
    var currentEvents : NSMutableArray!

    @IBOutlet weak var headerTitleView: UIView!
    @IBOutlet weak var header: UIView!
    var navImage  :UIImageView!

    @IBOutlet weak var scheduleNavLBL: UILabel!
    @IBOutlet weak var calendarNavLBL: UILabel!
    
    @IBOutlet weak var scheduleNavBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var calenderNavBottomConstraint: NSLayoutConstraint!
    
    var sorting  :Bool = false
    var currentTypeStackIndex   = 0
    var currentCourseStackIndex = 0
    var numberOfSelections = 0
    var currentDates : NSMutableArray = []

    var currentDate : NSDate!
    var shouldShowDaysOut = true
    var animationFinished = true

    var testView : UIView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    
    @IBOutlet weak var monthLabel: UILabel!


    let types = ["Test","Quiz","Homework","Project","Meeting", "Presentation"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.estimatedRowHeight = 80.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        currentDate = NSDate(timeIntervalSinceNow: -60*60)
        currentEvents = getDays()

        setup()
        
        if currentEvents.count == 0 {
            showEmptyTable()
        }else{
            hideEmptyTable()
        }
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        currentEvents = getDays()
        self.tableView.reloadData()
//        setup()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }

    
    func setup () {

        self.tableView.tableFooterView = UIView()
        
        currentTypeStackIndex = 0
        currentCourseStackIndex = 0
        
        
        self.visibleCells = self.tableView.visibleCells

        self.calendarView.frame = CGRectMake(16, 0, header.frame.size.width-16, 300)
        self.calendarView.backgroundColor = UIColor.clearColor()
        self.menuView.backgroundColor = UIColor.clearColor()
        monthLabel.text = CVDate(date: NSDate()).globalDescription

        self.calendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        self.calendarView.animatorDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self

        self.tableView.setNeedsUpdateConstraints()
        self.tableView.setNeedsLayout()
        
        self.calendarView.alpha = 0.0
        self.menuView.alpha = 0.0
        
        self.header.frame = CGRectMake(0, 0, self.view.frame.width, 0)
        self.tableView.sendSubviewToBack(header)
        
        self.headerTitleView.frame = CGRectMake(0, 0, self.view.frame.size.width, 50)
        self.headerTitleView.center = self.navigationController!.navigationBar.center

        self.scheduleNavLBL.transform = CGAffineTransformMakeScale(1.0, 1.0)
        self.calendarNavLBL.transform = CGAffineTransformMakeScale(0.7, 0.7)
        
        
        scheduleNavBottomConstraint.constant = 15
        calenderNavBottomConstraint.constant = 0
        //currentEvents = []
    }
 
    
    
    func getDays() -> NSMutableArray{
        let realme = try? Realm()
        let days = realme!.objects(Event).filter("date >= %@", currentDate.beginningOfDay).sorted("date")
        
        let allDays    :NSMutableArray = []
        let singleCell :NSMutableArray = []

        if days.count > 0 {
            allDays.addObject(singleCell)
        }
        var currentIndex = 0
        
        for day in days  {
            let cell = allDays[currentIndex] as! NSMutableArray
            //Check if there are no current events in the cell
            if cell.count > 0 {
                let object = cell.firstObject as! Event
                if checkForSameDate(object.date, secondDate: day.date){
                    cell.addObject(day) //Both are same day so add to same
                }else{
                    //If the days do not match up. Create a new cell and add it to the array
                    //Also increase the counter so that it checks the created cell next time
                    let newCell :NSMutableArray = []
                    newCell.addObject(day)
                    allDays.addObject(newCell)
                    currentIndex += 1
                    currentDates.addObject(day.date)

                }
            }else{
                cell.addObject(day)
            }
        }
        
        return allDays
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table View
     override   func tableView(tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return (currentEvents?.count) ?? 0
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    

    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> DayCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DayCell", forIndexPath: indexPath) as! DayCell

        

        let singleDay = currentEvents![indexPath.row] as! NSMutableArray
        let firstObject = singleDay.firstObject as! Event
        
        let dateDay = firstObject.date.toString(format: DateFormat.Custom("EEEE"))
        
        cell.dayTitle.text  = "\(dateDay)"
        
        if  1...9 ~= firstObject.date.day {
            cell.dayNumber.text = "0\(firstObject.date.day)"
        }else{
            cell.dayNumber.text = "\(firstObject.date.day)"
        }
        
        for subv in cell.eventStack.arrangedSubviews {
            subv.removeFromSuperview()
        }
        
        for subv in cell.circleStack.arrangedSubviews {
            subv.removeFromSuperview()
        }
        
        let sortedDays = singleDay.sortedArrayUsingComparator {
            (obj1, obj2) -> NSComparisonResult in
            
            let p1 = obj1 as! Event
            let p2 = obj2 as! Event
            let result = p1.course.name.compare(p2.course.name)
            return result
        }
        for item in sortedDays {
            if let event = item as? Event {
                let label = UILabel(frame: CGRectMake(0, 0, 50, 20))
                label.text = "\(event.type) - \(event.course.name)"
                label.font = UIFont(name: "Avenir Book", size: 15.0)
                label.heightAnchor.constraintEqualToConstant(20).active = true
                cell.eventStack.addArrangedSubview(label)
                
                let circle = UIView(frame: CGRectMake(0, 0, 4, 4))
                circle.layer.cornerRadius = 4
                circle.backgroundColor =  Course().colorForType(event.course.color)
                circle.layer.masksToBounds = true
                circle.heightAnchor.constraintEqualToConstant(8).active = true
                circle.widthAnchor.constraintEqualToConstant(8).active = true
                cell.circleStack.addArrangedSubview(circle)
            }
        }
        
        
        //Calculate days in advance 
        let today = NSDate()
        let dayDifference = today.difference(firstObject.date, unitFlags: NSCalendarUnit.Day).day + 1
        if (dayDifference < 30){
            //If today
            cell.dayNumber.textColor = UIColor.lightGrayColor()

            if firstObject.date.day == today.day {
                cell.numberOfObjects.text = "today"
                cell.dayNumber.textColor = PLBlue
            }else if dayDifference == 1 {
                cell.numberOfObjects.text = "\(dayDifference) day"
            }else{
                cell.numberOfObjects.text = "\(dayDifference) days"
            }

        }else{
            let monthDifference = today.difference(firstObject.date, unitFlags: NSCalendarUnit.Month).month + 1

            cell.numberOfObjects.text = "\(monthDifference) months"

        }
        return cell
    }

    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let navController = storyboard.instantiateViewControllerWithIdentifier("EditNav") as! UINavigationController
        
        let viewController = navController.viewControllers.first as! EditCellViewController
        let singleDay = currentEvents![indexPath.row] as! NSMutableArray
        let firstEvent = singleDay.firstObject as! Event
        viewController.date = firstEvent.date
        
        self.presentViewController(navController, animated: true) { () -> Void in
            
        }
    }
    
    func filterCourses() -> String {
        var courseString = ""
//        for item in coursesStack.arrangedSubviews {
//            if let stack = item as? UIStackView{
//                for i in stack.arrangedSubviews {
//                    if let button = i as? UIButton where button.alpha == 1.0 {
//                        var tmpString = ""
//                        if courseString == "" {
//                            tmpString = "course.name = " + "'" + (button.titleLabel?.text)! + "'"
//                        }else{
//                            tmpString = " OR course.name = " + "'" + (button.titleLabel?.text)! + "'"
//                        }
//                        courseString.appendContentsOf(tmpString)
//                    }
//                }
//            }
//        }
//        
        return courseString
    }
    
    func filterType() -> String{
        var typeString = ""
        
//        for item in typeStack.arrangedSubviews {
//            if let stack = item as? UIStackView{
//                for i in stack.arrangedSubviews {
//                    if let button = i as? UIButton where button.alpha == 1.0 {
//                        var tmpString = ""
//                        if typeString == "" {
//                            tmpString = "type = " + "'" + (button.titleLabel?.text)! + "'"
//                        }else{
//                            tmpString = " OR type = " + "'" + (button.titleLabel?.text)! + "'"
//                        }
//                        typeString.appendContentsOf(tmpString)
//                    }
//                }
//            }
//        }
        
        return  typeString
    }
    
    
    
    
    func getFilteredDays(courseFilter : String, typeFilter : String) -> Results<Event> {
        
//        let courseFilter = filterCourses()
//        let typeFilter = filterType()
        
        
        let realme = try? Realm()
        var days = realme!.objects(Event).filter("date >= %@", NSDate().beginningOfDay).sorted("date")
        
        
        //Both course and type
        if courseFilter != "" && typeFilter != "" {
            days = days.filter(courseFilter).sorted("date")
            days = days.filter(typeFilter).sorted("date")
            
        }
            //Only course
        else if courseFilter != "" && typeFilter == "" {
            days = days.filter(courseFilter).sorted("date")
            
        }
            //only type
        else if courseFilter == ""  && typeFilter != ""  {
            days = days.filter(typeFilter).sorted("date")
        }else{
            days = days.filter("type = 'NONE'")
        }
        //None
        
        return days
    }
    
    func reloadDays(courseFilter : String, typeFilter : String){
        
        
        let days = getFilteredDays(courseFilter,typeFilter: typeFilter)
        if days.count > 0{
            let allDays :NSMutableArray = []
            let singleCell :NSMutableArray = []
            let first = days.first
            allDays.addObject(singleCell)
            singleCell.addObject(first!)
            var currentIndex = 0
            
            for day in days  {
                if day != first {
                    // if same date then add to current array
                    let array = allDays[currentIndex] as! NSMutableArray
                    let firstObject = array.firstObject as! Event
                    if checkForSameDate(firstObject.date, secondDate: day.date){
                        allDays[currentIndex].addObject(day)
                    }
                        //If not then create new array and add to that array
                    else{
                        let newCell :NSMutableArray = []
                        newCell.addObject(day)
                        allDays.addObject(newCell)
                        currentIndex++
                    }
                }
            }
            currentEvents = allDays
        }else{
            currentEvents = []
        }
        
        tableView.reloadData()
    }
    
    func checkForSameDate(firstDate : NSDate, secondDate : NSDate) -> Bool{
        
        if firstDate.day == secondDate.day{
            return true
        } else {
            return false
        }
    }
    
    
    func removeFromStacks (sender : UIButton){
//        for  stack in typeStack.arrangedSubviews as! [UIStackView] {
//            for button in stack.arrangedSubviews as! [UIButton] {
//                if button.titleLabel?.text == sender.titleLabel?.text{
//                    UIView.animateWithDuration(0.2, animations: { () -> Void in
//                        button.alpha = 0.3
//                        button.tag = 0
//                    })
//                    break
//                }
//            }
//        }
//        
//        for stack in coursesStack.arrangedSubviews as! [UIStackView] {
//            for button in stack.arrangedSubviews as! [UIButton] {
//                if button.titleLabel?.text == sender.titleLabel?.text{
//                    UIView.animateWithDuration(0.2, animations: { () -> Void in
//                        button.alpha = 0.3
//                        button.tag = 0
//                    })
//                    break
//                }
//            }
//        }
//        for button in navStackView.arrangedSubviews as! [UIButton] {
//            if button.titleLabel?.text == sender.titleLabel?.text{
//                UIView.animateWithDuration(0.2, animations: { () -> Void in
//                    button.hidden = true
//                    }, completion: { (Bool) -> Void in
//                        button.removeFromSuperview()
//                })
//                break
//            }
//            
//        }
    }
    
    func validAddToStack(stack : UIStackView, let stackNumber : Int) -> Bool {
        
        var currentWidth :CGFloat = 0.0
        let viewWidth = view.frame.size.width
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
    
    func addButtonToStack(type : String, color : Int, stackView : UIStackView){
        let label = createButton(type)
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
    
    func createButton(title : String) -> UIButton{
        let height :CGFloat = 40.0
        let button = UIButton(frame: CGRectMake(0, 0, 100, height))
        button.setTitle(title, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "Avenir Book", size: 15)
        button.backgroundColor = PLBlue
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.layer.cornerRadius = button.frame.size.height/2
        button.layer.masksToBounds = true
        button.titleLabel?.textAlignment = NSTextAlignment.Center
        button.sizeToFit()
        button.heightAnchor.constraintEqualToConstant(height).active = true
        button.widthAnchor.constraintEqualToConstant(button.frame.size.width+30).active = true
        button.alpha = 0.3
        button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
//        button.addTarget(button, action: "expand", forControlEvents: UIControlEvents.TouchUpInside)
//        button.addTarget(button, action: "expand", forControlEvents: UIControlEvents.TouchDragOutside)
//        button.addTarget(button, action: "shrink", forControlEvents: UIControlEvents.TouchDown)

        return button
    }
    
    
//    @IBAction func showSort(sender: UIButton) {
//        
//            if !self.sorting {
//
//                self.sorting = true
//
////                self.coursesStack.alpha = 1.0
////                self.typeStack.alpha = 1.0
////                self.headerCourseLBL.alpha = 1.0
////                self.headerTypeLBL.alpha = 1.0
////                
//
//                
//                UIView.animateWithDuration(0.4, delay: 0.2 , usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                    self.header.frame = CGRectMake(0, 0, self.view.frame.width, 350)
//                    
//                    }, completion: { (Bool) -> Void in
//                        self.tableView.beginUpdates()
//                        self.tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 350)
//                        self.tableView.endUpdates()
//                        self.tableView.bringSubviewToFront(self.header)
//                })
//                    
//           
//                let cells = tableView.visibleCells
//                for i in cells {
//                    let cell: UITableViewCell = i as UITableViewCell
//                    cell.transform = CGAffineTransformMakeTranslation(0, 0)
//                }
//
//                var index = 0
//                
//                for a in cells {
//                    let cell: UITableViewCell = a as UITableViewCell
//                    UIView.animateWithDuration(0.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                        cell.transform = CGAffineTransformMakeTranslation(0, 305);
//                        }, completion: nil)
//                    
//                    index += 1
//                }
//                
//                
//            }else{
//                self.sorting = false
//                self.tableView.sendSubviewToBack(header)
//                
//
//                UIView.animateWithDuration(0.4, delay: 0.05 , usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
////                    self.header.frame = CGRectMake(0, 0, self.view.frame.width, 45)
////                    self.coursesStack.alpha = 0.0
////                    self.typeStack.alpha = 0.0
////                    self.headerCourseLBL.alpha = 0.0
////                    self.headerTypeLBL.alpha = 0.0
////
//                    }, completion: nil)
//            
//                let cells = tableView.visibleCells
//
//                for i in cells {
//                    let cell: UITableViewCell = i as UITableViewCell
//                    cell.transform = CGAffineTransformMakeTranslation(0, 305)
//                }
//            
//                var index = 0
//                
//                for a in cells {
//                    let cell: UITableViewCell = a as UITableViewCell
//                    UIView.animateWithDuration(0.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                        cell.transform = CGAffineTransformMakeTranslation(0, 0);
//                        }, completion: nil)
//                    
//                    index += 1
//                }
//                
//                self.tableView.tableFooterView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 0)
////                
////                var indexPaths :[NSIndexPath] = []
////                let count = cells.count
//////                
////                for i in count...count+4 {
////                    guard self.tableView.numberOfRowsInSection(0) > i
////                    else{
////                        break
////                    }
////                    indexPaths.append(NSIndexPath(forRow: i, inSection: 0))
////                }
//////
////                self.tableView.beginUpdates()
////                self.tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
////                self.tableView.endUpdates()
//             
//                
//        }
//    }
    
//    func buttonPressed(sender : UIButton){
//
//        
//        //button in header is tapped and not selected
//        if sender.tag == 0 {
//            numberOfSelections++ 
//            sender.alpha = 1.0
//            sender.tag = 1
//        }
//        //Button in header is tapped and already selected
//        else if sender.tag == 1 {
//            numberOfSelections--
//            sender.alpha = 0.3
//            sender.tag = 0
//            
//            self.removeFromStacks(sender)
//
//        }
//
//        if numberOfSelections == 0 {
//            currentEvents = getDays()
//            tableView.reloadData()
//        }else{
//            reloadDays()
//        }
//    }
    @IBAction func showProfile(sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let viewController = storyboard.instantiateViewControllerWithIdentifier("profile")
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func createNewEvent(sender: UIButton) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let viewController = storyboard.instantiateViewControllerWithIdentifier("AddNav")
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func clearOutStackView(stack : UIStackView){
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    func didSelectDayView(dayView: DayView) {
        currentDate = dayView.date.convertedDate()
        currentEvents.removeAllObjects()
        currentEvents = getDays()
        self.tableView.reloadData()
        //        animateTable(0.4)
        print("\(calendarView.presentedDate.commonDescription) is selected!")
    }
    
    /**
     Update the navigatoin bar when tapped
     
     - parameter sender: button tapped
     */
    @IBAction func changeHeaderView(sender: UIButton) {
        
        let smallHeight :CGFloat = 0
        let largeHeight :CGFloat = 15
        var schedule = 0
        
        //Show Calendar
        if scheduleNavBottomConstraint.constant == largeHeight {
            scheduleNavBottomConstraint.constant = smallHeight
            calenderNavBottomConstraint.constant = largeHeight
            scheduleNavLBL.textColor = PLBlue
            calendarNavLBL.textColor = UIColor.blackColor()
            schedule = 1
            
            self.calendarView.commitCalendarViewUpdate()
            self.menuView.commitMenuViewUpdate()
            
        }else{
            scheduleNavBottomConstraint.constant = largeHeight
            calenderNavBottomConstraint.constant = smallHeight
            scheduleNavLBL.textColor = UIColor.blackColor()
            calendarNavLBL.textColor = PLBlue
            schedule = 0
            
            self.currentDate = NSDate().beginningOfDay
            currentEvents = getDays()
        }
//        self.header.layer.masksToBounds = true
        
        if schedule == 0 {
            if (self.emptyImage != nil) {
                self.emptyImage.center = CGPointMake(self.tableView.center.x, self.view.center.y-100)
                self.emptyTitle.frame = CGRectMake(0, self.emptyImage.frame.origin.y+self.emptyImage.frame.height, self.view.frame.width, 30)
                self.emptySubTitle.frame = CGRectMake(0, self.emptyTitle.frame.origin.y+self.emptyTitle.frame.height, self.view.frame.width, 30)
            }
       
            UIView.animateAndChainWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: {
                self.scheduleNavLBL.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.calendarNavLBL.transform = CGAffineTransformMakeScale(0.7, 0.7)
                self.header.frame = CGRectMake(0, 0, self.view.frame.size.width, 0)
                self.tableView.tableHeaderView = self.header
                self.headerTitleView.layoutIfNeeded()

                self.calendarView.alpha = 0.0
                self.menuView.alpha = 0.0
                

                }, completion:  { (Bool) in
                })
          
        }else{
            UIView.animateAndChainWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: { 
                
                self.visibleCells = self.tableView.visibleCells
                
                self.scheduleNavLBL.transform = CGAffineTransformMakeScale(0.7, 0.7)
                self.calendarNavLBL.transform = CGAffineTransformMakeScale(1.0, 1.0)
                self.header.frame = CGRectMake(0, 0, self.view.frame.size.width, 340)
                if (self.emptyImage != nil) {
                    self.emptyImage.center = CGPointMake(self.tableView.center.x, self.view.center.y+50)
                    self.emptyTitle.frame = CGRectMake(0, self.emptyImage.frame.origin.y+self.emptyImage.frame.height, self.view.frame.width, 30)
                    self.emptySubTitle.frame = CGRectMake(0, self.emptyTitle.frame.origin.y+self.emptyTitle.frame.height, self.view.frame.width, 30)
                }
                
                //Allows the table to notice the different size header
                self.tableView.tableHeaderView = self.header
                //Animates the schedule and calendar labels in the nav
                self.headerTitleView.layoutIfNeeded()
                }, completion: nil)
            
            //Animate alpha on delay of when header expands
            UIView.animateAndChainWithDuration(0.5, delay: 0.15, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
                
                self.calendarView.alpha = 1.0
                self.menuView.alpha = 1.0
               
            }, completion: nil)
            
           
        }
    }
    
    var visibleCells :[UITableViewCell]!
    
    func animateAllRows(){
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in visibleCells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in visibleCells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(0.3, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    var emptyImage : UIImageView!
    var emptyTitle : UILabel!
    var emptySubTitle : UILabel!
    
    func showEmptyTable(){
        
        emptyImage = UIImageView(image: UIImage(named: "masterEmpty"))
        emptyImage.contentMode = .Center
        
        emptyTitle = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        emptyTitle.text = "YAY!"
        emptyTitle.font = UIFont(name: "Avenir Book", size: 22)
        emptyTitle.textColor = UIColor.lightGrayColor()
        emptyTitle.textAlignment = NSTextAlignment.Center
        self.tableView.addSubview(emptyTitle)
        
        emptySubTitle = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        emptySubTitle.text = "You have nothing to do. Go Party!  🎉"
        emptySubTitle.font = UIFont(name: "Avenir Book", size: 17)
        emptySubTitle.textColor = UIColor.lightGrayColor()
        emptySubTitle.textAlignment = NSTextAlignment.Center
        self.tableView.addSubview(emptySubTitle)
        
        
        self.tableView.addSubview(emptyImage)
        emptyImage.center = CGPointMake(self.tableView.center.x, self.view.center.y-100)
        emptyTitle.frame = CGRectMake(0, emptyImage.frame.origin.y+emptyImage.frame.height, self.view.frame.width, 30)
        emptySubTitle.frame = CGRectMake(0, emptyTitle.frame.origin.y+emptyTitle.frame.height, self.view.frame.width, 30)
    }

    func hideEmptyTable() {
        if (emptyImage != nil) {
            emptyImage.removeFromSuperview()
        }
        
        if (emptyTitle != nil) {
            emptyTitle.removeFromSuperview()
        }
        
        if (emptySubTitle != nil) {
            emptySubTitle.removeFromSuperview()
        }
    }
}

extension UITableViewController {
    
    func animateTable(duration : Double) {
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(duration, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    func hideSection(section : Int) {
//        tableView.reloadData()
//
//        let cells = tableView.visibleCells
//        let tableHeight: CGFloat = tableView.bounds.size.height
//        
//        for i in cells {
//            let cell: UITableViewCell = i as UITableViewCell
//            
//            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
//        }
//        
//        var index = 0
//        
//        for a in cells {
//            let cell: UITableViewCell = a as UITableViewCell
//            UIView.animateWithDuration(duration, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                cell.transform = CGAffineTransformMakeTranslation(0, 0);
//                }, completion: nil)
//            
//            index += 1
//        }
        
        var e :[NSIndexPath] = []
        for index in 0...self.tableView.numberOfRowsInSection(section) {
            e.append(NSIndexPath(forRow: index, inSection: section))
        }
        
        self.tableView.reloadRowsAtIndexPaths(e, withRowAnimation: UITableViewRowAnimation.Bottom)
        
    }

    
    
    func expandHeader(height : CGFloat) {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, 0)
        }
        
    }
}


//MARK:  - Master IB Actions
extension MasterViewController {
    
    @IBAction func profileButtonPressed(sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let navController = storyboard.instantiateViewControllerWithIdentifier("ProfileNav") as! UINavigationController//Uses the view created in the sotryboard so we have autolayout as! intro
        
        //        viewController.delegate = self
        let viewController = navController.viewControllers.first as! ClassesTableViewController
        
        self.presentViewController(navController, animated: true, completion: nil)

    }
    
    @IBAction func sortButtonPressed(sender: UIButton) {
        
    }
    
    
    @IBAction func addEventPressed(sender: UIButton) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let navController = storyboard.instantiateViewControllerWithIdentifier("AddNav") as! UINavigationController//Uses the view created in the sotryboard so we have autolayout as! intro
        
        //        viewController.delegate = self
        let viewController = navController.viewControllers.first as! AddEventViewController
        
        viewController.delegate = self
        
        self.presentViewController(navController, animated: true, completion: nil)
        
    }
}


extension MasterViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
            UIView.animateAndChainWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: {
                self.monthLabel.alpha = 1.0
                }, completion: nil).animateAndChainWithDuration(0.3, delay: 0.2, options: .CurveEaseInOut, animations: {
                    self.monthLabel.alpha = 0.0
                    }, completion: nil)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: CVCalendarDayView) -> Bool {
        let day = dayView.date.day
        let month = dayView.date.month
        guard currentDates.count != 0 else {
            return false
        }
        
        for item in currentDates{
            if let singleDay = item as? NSDate where singleDay.day == day && singleDay.month == month {
                return true
            }
        }
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: CVCalendarDayView) -> [UIColor] {
        
        let color = PLBlue
        
        return [color] // return 1 dot
        
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 15
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
}


extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 0
    }
}

// MARK: - Calendar View IB Actions

extension CalendarViewController {
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





