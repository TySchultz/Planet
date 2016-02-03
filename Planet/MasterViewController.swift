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
class MasterViewController: UITableViewController {
    
    var currentEvents : NSMutableArray!

    @IBOutlet weak var headerBackground: UIView!
    @IBOutlet weak var header: UIView!
    var navImage  :UIImageView!

    var sorting  :Bool = false


    
    var currentTypeStackIndex   = 0
    var currentCourseStackIndex = 0
    var numberOfSelections = 0
    
    
    @IBOutlet weak var coursesStack: UIStackView!
    @IBOutlet weak var typeStack: UIStackView!
    
    var delegate : OverheadViewController!

    
    
    @IBOutlet weak var navScrollView: UIScrollView!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var navStackView: UIStackView!
    
    
    let types = ["Test","Quiz","Homework","Project","Presentation","Meeting"]

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.bringSubviewToFront(header)
        self.navigationController?.navigationBar.hidden = false
    
        

        tableView.estimatedRowHeight = 80.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        currentEvents = getDays()
        tableView.reloadData()
        
        setup()
      
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        currentEvents = getDays()
        setup()

    }
    

    
    func setup () {
        
        coursesStack.alpha = 0.0
        
        self.tableView.tableFooterView = UIView()
        
        currentTypeStackIndex = 0
        currentCourseStackIndex = 0
        
//        clearOutStackView(typeStack)
        clearOutStackView(coursesStack)
//        clearOutStackView(navStackView)
        
        let realme = try? Realm()
        
//        typeStack.tag = 1
        coursesStack.tag = 0
        
        let allCourses = realme!.objects(Course)
        for course in allCourses  {
            addButtonToStack(course.name, color:course.color, stackView: 	coursesStack)
        }
        
//        for type in types {
//            addButtonToStack(type,color:"PLBLUE", stackView: typeStack)
//        }

        
        header.frame = CGRectMake(0, 0, view.frame.size.width, HEADERHEIGHT)
        tableView.reloadData()
        self.tableView.reloadData()
        //currentEvents = []
    }
    
    func getDays() -> NSMutableArray{
        let realme = try? Realm()
        let days = realme!.objects(Event).filter("date >= %@", NSDate().beginningOfDay).sorted("date")
        
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
                    currentIndex++
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (currentEvents?.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> DayCell {
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
                circle.layer.cornerRadius = 2
                circle.backgroundColor =  Course().colorForType(ColorType(rawValue: event.course.color)!)
                circle.layer.masksToBounds = true
                circle.heightAnchor.constraintEqualToConstant(16).active = true
                circle.widthAnchor.constraintEqualToConstant(4).active = true
                cell.circleStack.addArrangedSubview(circle)
            }
        }
        
        
        //Calculate days in advance 
        let today = NSDate()
        if today.month == firstObject.date.month {
            //If today
            if firstObject.date.day == today.day {
                cell.numberOfObjects.text = "today"
                cell.dayNumber.textColor = PLBlue
            }else{
                cell.numberOfObjects.text = "\(firstObject.date.day-today.day) days"
                cell.dayNumber.textColor = UIColor.lightGrayColor()
            }
        }else{
            cell.numberOfObjects.text = "\(firstObject.date.month-today.month) months"

        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let testingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width-100, height: self.view.frame.size.height-200))
//        testingView.backgroundColor = PLBlue
//        testingView.layer.cornerRadius = 8.0
//        testingView.layer.masksToBounds = true
//        testingView.center = self.view.center
//        self.view.addSubview(testingView)
        
    }
    
    func filterCourses() -> String {
        var courseString = ""
        for item in coursesStack.arrangedSubviews {
            if let stack = item as? UIStackView{
                for i in stack.arrangedSubviews {
                    if let button = i as? UIButton where button.alpha == 1.0 {
                        var tmpString = ""
                        if courseString == "" {
                            tmpString = "course.name = " + "'" + (button.titleLabel?.text)! + "'"
                        }else{
                            tmpString = " OR course.name = " + "'" + (button.titleLabel?.text)! + "'"
                        }
                        courseString.appendContentsOf(tmpString)
                    }
                }
            }
        }
        
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
    
    
    
    
    func getFilteredDays() -> Results<Event> {
        
        let courseFilter = filterCourses()
        let typeFilter = filterType()
        
        
        let realme = try? Realm()
        var days = realme!.objects(Event).filter("date >= %@", NSDate().dateByAddingTimeInterval(-60*60)).sorted("date")
        
        
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
    
    func reloadDays(){
        
        
        let days = getFilteredDays()
        if days.count > 0{
            let allDays :NSMutableArray = []
            let singleCell :NSMutableArray = []
            let first = days.first
            allDays.addObject(singleCell)
            singleCell.addObject(first!)
            var currentIndex = 0
            
            for day in days  {
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
        
        for stack in coursesStack.arrangedSubviews as! [UIStackView] {
            for button in stack.arrangedSubviews as! [UIButton] {
                if button.titleLabel?.text == sender.titleLabel?.text{
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        button.alpha = 0.3
                        button.tag = 0
                    })
                    break
                }
            }
        }
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
    
    func addButtonToStack(type : String, color : String, stackView : UIStackView){
        let label = createButton(type)
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
    
    func createButton(title : String) -> UIButton{
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
        label.alpha = 0.3
        label.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        label.addTarget(label, action: "expand", forControlEvents: UIControlEvents.TouchUpInside)
        label.addTarget(label, action: "expand", forControlEvents: UIControlEvents.TouchDragOutside)
        label.addTarget(label, action: "shrink", forControlEvents: UIControlEvents.TouchDown)

        return label
    }
    
    
    @IBAction func showSort(sender: UIButton) {
        
        
        self.hideSection(0)
//            if !self.sorting {
//                self.header.frame = CGRectMake(0, 0, self.view.frame.width, 200)
//                self.sorting = true
//                
//            }else{
//                self.header.frame = CGRectMake(0, 0, self.view.frame.width, 45)
//                self.coursesStack.alpha = 0.0
//                self.sorting = false
//                self.animateTable(0.5)
//            }
    }
    
    func buttonPressed(sender : UIButton){
        
        
        //button in header is tapped and not selected
        if sender.tag == 0 {
            numberOfSelections++ 
//            navImage.alpha = 0.0
            sender.alpha = 1.0
            sender.tag = 1
            
            let newButton = createButton((sender.titleLabel?.text)!)
            newButton.alpha = 1.0
            newButton.tag = 2
            newButton.hidden = true
            newButton.backgroundColor = sender.backgroundColor
            newButton.heightAnchor.constraintEqualToConstant(24).active = true
            newButton.frame = CGRectMake(0, 0, 100, 24.0)
            newButton.layer.cornerRadius = newButton.frame.size.height/2

//            self.navStackView.addArrangedSubview(newButton)
            
//            let size = navScrollView.contentSize
//            navScrollView.contentSize = CGSizeMake(size.width+newButton.frame.size.width+8, 30)
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                newButton.hidden = false
            })
        }
        //Button in header is tapped and already selected
        else if sender.tag == 1 {
            numberOfSelections--
            sender.alpha = 0.3
            sender.tag = 0
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                //                sender.alpha = 0.3
                }, completion: { (Bool) -> Void in
                    //                    sender.removeFromSuperview()
                    self.removeFromStacks(sender)
//                    if self.navStackView.arrangedSubviews.count == 1 { self.navImage.alpha = 1.0 }
                    
            })

        }
//        //button in navigation bar is tapped
//        else if sender.tag == 2 {
//            numberOfSelections--
//            UIView.animateWithDuration(0.2, animations: { () -> Void in
//                sender.hidden = true
//                self.removeFromStacks(sender)
//                
//                }, completion: { (Bool) -> Void in
//                    sender.removeFromSuperview()
//                    print(self.navStackView.arrangedSubviews.count)
//                    if self.navStackView.arrangedSubviews.count < 1 { self.navImage.alpha = 1.0 }
//            })
//            
//
//        }
        if numberOfSelections == 0 {
            currentEvents = getDays()
            tableView.reloadData()
        }else{
            reloadDays()
        }
    }
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

    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let yPosition = scrollView.contentOffset.y
        
        if yPosition < 0 {
            var headerFrame = header.frame
            headerFrame.origin.y = yPosition

            print(yPosition)
            header.frame = headerFrame
        }
    }
}

extension UITableViewController {
    
    func animateTable(duration : Double) {
        tableView.reloadData()
        
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

