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

//    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var days    = [AnyObject]()
    var things    = [AnyObject]()

    var events  = [Int]()
    
    var currentEvents : NSMutableArray!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    var bottomBar :UIView!
    var topBar :UIView!
    
    
    var count = 0
    
    let BOTTOMBARHEIGHT :CGFloat = 45.0
    let TOPBARHEIGHT :CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let realme = try? Realm()
//        currentEvents = realme!.objects(Event).sorted("date")
        
        
        let navImage = UIImageView(frame: CGRectMake(0, 0, 32, 32))
        navImage.image = UIImage(named: "navBarImage")
        navImage.center = CGPointMake((self.navigationController?.navigationBar.center.x)!, (self.navigationController?.navigationBar.center.y)!-20)
        self.navigationController?.navigationBar.addSubview(navImage)


        
        tableView.estimatedRowHeight = 80.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        currentEvents = getDays()
    }
    
    func getDays() -> NSMutableArray{
        let realme = try? Realm()
        let days = realme!.objects(Event).sorted("date")
//        days.dropFirst()
        
        var allDays    :NSMutableArray = []
        var singleCell :NSMutableArray = []
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
                    var newCell :NSMutableArray = []
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
    
    

    override func viewWillAppear(animated: Bool) {
//        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        currentEvents = getDays()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        for item in singleDay {
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
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
  


}

