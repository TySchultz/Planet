//
//  CalendarViewController.swift
//  Planet
//
//  Created by Ty Schultz on 10/13/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import SwiftMoment
import CVCalendar
import SwiftDate
import RealmSwift

class CalendarViewController: UITableViewController {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysOutSwitch: UISwitch!

    var currentEvents : NSMutableArray!
    var currentDate : NSDate!
    
    var delegate : OverheadViewController!

    
    @IBOutlet weak var navView: UIView!
    var shouldShowDaysOut = true
    var animationFinished = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        headerView.frame = CGRectMake(0, 0, view.frame.size.width, 380)
        headerView.backgroundColor = UIColor.whiteColor()
        navView.frame = CGRectMake(0, 40, view.frame.size.width-40, 35)

        calendarView.frame = CGRectMake(16, 0, headerView.frame.size.width-32, 300)
        menuView.frame = CGRectMake(16, 0, headerView.frame.size.width-32, 32)
        
        monthLabel.text = CVDate(date: NSDate()).globalDescription
        
        self.shouldShowDaysOut = false
        
        
        currentDate = NSDate(timeIntervalSinceNow: -60*60)
        
        tableView.estimatedRowHeight = 80.0;
        tableView.rowHeight = UITableViewAutomaticDimension;

        currentEvents = getDays()
        
        self.tableView.tableFooterView = UIView()
        
        tableView.reloadData()

//        calendarView.calendarAppearanceDelegate = self
//        calendarView.calendarDelegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    override func viewWillAppear(animated: Bool) {
           tableView.reloadData()
    }
    //MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
        cell.dayNumber.text = "\(firstObject.date.day)"
        
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
                
                let circle = UIView(frame: CGRectMake(0, 0, 8, 8))
                circle.layer.cornerRadius = 4
                circle.backgroundColor =  Course().colorForType(ColorType(rawValue: event.course.color)!)
                circle.layer.masksToBounds = true
                circle.heightAnchor.constraintEqualToConstant(20).active = true
                circle.widthAnchor.constraintEqualToConstant(8).active = true
                cell.circleStack.addArrangedSubview(circle)
            }
        }
        
        cell.numberOfObjects.text = "\(sortedDays.count) events"

        return cell
    }
    
    
    func getDays() -> NSMutableArray{
        let realme = try? Realm()
        
        let days = realme!.objects(Event).filter("date >= %@", currentDate.beginningOfDay).sorted("date")
        
        let allDays    :NSMutableArray = []
        let singleCell :NSMutableArray = []
        if let first = days.first {
            allDays.addObject(singleCell)
            singleCell.addObject(first)
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
        }
        
        return allDays
    }
    
    func checkForSameDate(firstDate : NSDate, secondDate : NSDate) -> Bool{
        
        if firstDate.day == secondDate.day{
            return true
        } else {
            return false
        }
    }
    
    
    
    func didSelectDayView(dayView: DayView) {
        currentDate = dayView.date.convertedDate()
        currentEvents.removeAllObjects()
        currentEvents = getDays()
        animateTable(0.4)
        print("\(calendarView.presentedDate.commonDescription) is selected!")
    }
}


extension CalendarViewController: CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
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
        
        let red = PLPurple
        let green = PLGreen
        let blue = PLBlue
        
        let color = PLBlue
        
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


extension CalendarViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 0
    }
}

// MARK: - IB Actions

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



