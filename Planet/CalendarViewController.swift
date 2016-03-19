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
    var currentDates : NSMutableArray = []
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
        
        
        if currentEvents.count == 0 {
            showEmptyTable()
        }else{
            hideEmptyTable()
        }
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
        currentEvents = getDays()
        calendarView.commitCalendarViewUpdate()
        self.tableView.reloadData()
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
                circle.backgroundColor =  Course().colorForType(event.course.color)
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
                        currentDates.addObject(day.date)
                    }
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
        self.tableView.reloadData()
//        animateTable(0.4)
        print("\(calendarView.presentedDate.commonDescription) is selected!")
    }
    
    
    var emptyImage : UIImageView!
    var emptyTitle : UILabel!
    var emptySubTitle : UILabel!
    
    func showEmptyTable(){
        
        emptyImage = UIImageView(image: UIImage(named: "calEmpty"))
        emptyImage.contentMode = .Center
        emptyImage.transform = CGAffineTransformMakeScale(0.5, 0.5)
        
        emptyTitle = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        emptyTitle.text = "Here's a Medal"
        emptyTitle.font = UIFont(name: "Avenir Book", size: 22)
        emptyTitle.textColor = UIColor.lightGrayColor()
        emptyTitle.textAlignment = NSTextAlignment.Center
        self.tableView.addSubview(emptyTitle)
        
        emptySubTitle = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        emptySubTitle.text = "Your calendar is empty (:"
        emptySubTitle.font = UIFont(name: "Avenir Book", size: 17)
        emptySubTitle.textColor = UIColor.lightGrayColor()
        emptySubTitle.textAlignment = NSTextAlignment.Center
        emptySubTitle.numberOfLines = 0
        emptySubTitle.widthAnchor.constraintEqualToConstant(self.view.frame.width-40).active = true
        self.tableView.addSubview(emptySubTitle)
        
        
        self.tableView.addSubview(emptyImage)
        emptyImage.center = CGPointMake(self.tableView.center.x, self.tableView.center.y+80)
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
        
        let color = PLOrange
        
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



