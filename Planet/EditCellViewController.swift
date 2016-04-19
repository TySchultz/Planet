//
//  EditCellViewController.swift
//  Planet
//
//  Created by Ty Schultz on 3/2/16.
//  Copyright © 2016 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftDate
import Crashlytics

class EditCellViewController: UITableViewController {

    @IBOutlet weak var daysAway: UILabel!
    @IBOutlet weak var dayNumber: UILabel!
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var colorStack: UIStackView!
    @IBOutlet weak var deleteStack: UIStackView!
    @IBOutlet weak var nameStack: UIStackView!
    
    @IBOutlet weak var header: UIView!
    
    var currentEvents : NSMutableArray!
    var date : NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentEvents = []
        setup()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    
    
    func setup () {
        self.navigationController?.navigationBar.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = PLBlue

        self.header.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 600.0)
        
        currentEvents.removeAllObjects()
        
        let realme = try! Realm()

        let events = realme.objects(Event).filter("date == %@", date.beginningOfDay)
     
        for event in events {
            currentEvents.addObject(event)
        }
        
        guard events.count != 0 else {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        let firstObject = events.first! as Event

        let dateDay = firstObject.date.toString(format: DateFormat.Custom("EEEE"))
        
        dayOfWeek.text  = "\(dateDay)"
        
        if  1...9 ~= firstObject.date.day {
            dayNumber.text = "0\(firstObject.date.day)"
        }else{
            dayNumber.text = "\(firstObject.date.day)"
        }
        
        for subv in nameStack.arrangedSubviews {
            subv.removeFromSuperview()
        }
        
        for subv in colorStack.arrangedSubviews {
            subv.removeFromSuperview()
        }
        
        for subv in deleteStack.arrangedSubviews {
            subv.removeFromSuperview()
        }
        
        
        let sortedDays = currentEvents.sortedArrayUsingComparator {
            (obj1, obj2) -> NSComparisonResult in
            
            let p1 = obj1 as! Event
            let p2 = obj2 as! Event
            let result = p1.course.name.compare(p2.course.name)
            return result
        }
        
        currentEvents.removeAllObjects()
        var index = 0
        for item in sortedDays {
            
            if let event = item as? Event {
                currentEvents.addObject(event)
                
                let label = UILabel(frame: CGRectMake(0, 0, 50, 20))
                label.text = "\(event.type) - \(event.course.name)"
                label.font = UIFont(name: "Avenir Book", size: 18.0)
                label.heightAnchor.constraintEqualToConstant(40).active = true
                nameStack.addArrangedSubview(label)
                
                let circle = UIView(frame: CGRectMake(0, 0, 4, 4))
                circle.layer.cornerRadius = 4.0
                circle.backgroundColor =  Course().colorForType(event.course.color)
                circle.layer.masksToBounds = true
                circle.heightAnchor.constraintEqualToConstant(40).active = true
                circle.widthAnchor.constraintEqualToConstant(8).active = true
                colorStack.addArrangedSubview(circle)
                
                let delete = UIButton(frame: CGRectMake(0,0,80,40))
                delete.setTitle("Delete", forState: UIControlState.Normal)
                delete.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                delete.titleLabel?.font = UIFont(name: "Avenir Book", size: 14.0)
                delete.heightAnchor.constraintEqualToConstant(40).active = true
                delete.backgroundColor = PLRed
                delete.layer.masksToBounds = true
                delete.layer.cornerRadius = 4.0
                delete.tag = index
                delete.addTarget(self, action: "deleteButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                deleteStack.addArrangedSubview(delete)
                
                index++
            }
        }
        
        
        //Calculate days in advance
        let today = NSDate()
        let dayDifference = today.difference(firstObject.date, unitFlags: NSCalendarUnit.Day).day + 1
        if (dayDifference < 30){
            //If today
            dayNumber.textColor = UIColor.lightGrayColor()
            
            if firstObject.date.day == today.day {
                daysAway.text = "today"
                dayNumber.textColor = PLBlue
            }else if dayDifference == 1 {
                daysAway.text = "\(dayDifference) day away"
            }else{
                daysAway.text = "\(dayDifference) days away"
            }
            
        }else{
            let monthDifference = today.difference(firstObject.date, unitFlags: NSCalendarUnit.Month).month + 1
            
            daysAway.text = "\(monthDifference) months away"
            
        }
    }
    
    
    @IBAction func deleteButtonPressed(sender : UIButton) {
        
        let realme = try! Realm()
        sender.enabled = false
        var tmpIndex = 0
        
        print("count: \(currentEvents!.count)")
        
        for item in currentEvents! {
            if let event = item as? Event {
                
                if tmpIndex == sender.tag{
                    try! realme.write {
                        realme.delete(event)
                    }
                    break
                }else{
                    tmpIndex++
                }
            }
        }
        currentEvents.removeObjectAtIndex(sender.tag)
        
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.setup()
            }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
    @IBAction func closePressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil) //hide the viewController

        
    }

  
}
