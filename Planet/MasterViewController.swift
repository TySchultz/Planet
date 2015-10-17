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
    
    var currentEvents :Results<(Event)>?

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
        currentEvents = realme!.objects(Event).sorted("date")
        
        
        let navImage = UIImageView(frame: CGRectMake(0, 0, 32, 32))
        navImage.image = UIImage(named: "navBarImage")
        navImage.center = CGPointMake((self.navigationController?.navigationBar.center.x)!, (self.navigationController?.navigationBar.center.y)!-20)
        self.navigationController?.navigationBar.addSubview(navImage)
        
   
        
        objects = [15,16,17,18,19,15,16,15,16,17,18,19,15,16,15,16,17,18,19,15,16]
        days = ["Monday","Tuesday","Wednesday","Thursdsay","Friday","Saturday","Sunday","Monday","Tuesday","Wednesday","Thursdsay","Friday","Saturday","Sunday","Monday","Tuesday","Wednesday","Thursdsay","Friday","Saturday","Sunday"]
        events = [2,4,1,2,3,2,0,2,3,1,2,4,2,1,2,4,1,3,1,2,1]
        things = ["Test","HW","QUIZ","Presentation","Project","Midterm","Essay","Test","HW","QUIZ","Presentation","Project","Midterm","Essay","Test","HW","QUIZ","Presentation","Project","Midterm","Essay"]

        
        tableView.estimatedRowHeight = 80.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
    }

    override func viewWillAppear(animated: Bool) {
//        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
        
        let realme = try? Realm()
        currentEvents = realme!.objects(Event).sorted("date")
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

        let singleEvent = currentEvents![indexPath.row]
        
        let dateDay = singleEvent.date.toString(format: DateFormat.Custom("EEEE"))
        
        cell.dayTitle.text  = "\(dateDay)"
        cell.dayNumber.text = "\(singleEvent.date.day)"
        
        for subv in cell.eventStack.arrangedSubviews {
            subv.removeFromSuperview()
        }
        
        for subv in cell.circleStack.arrangedSubviews {
            subv.removeFromSuperview()
        }
        
//        for var i = 0; i < events[indexPath.row]; i++ {
            let label = UILabel(frame: CGRectMake(0, 0, 50, 20))
            label.text = "\(singleEvent.type) - \(singleEvent.course.name)"
            label.font = UIFont(name: "Avenir Book", size: 15.0)
            label.heightAnchor.constraintEqualToConstant(20).active = true
            cell.eventStack.addArrangedSubview(label)
            
            
            let circle = UIView(frame: CGRectMake(0, 0, 8, 8))
            circle.layer.cornerRadius = 4
            if events[indexPath.row] == 1{
                circle.backgroundColor = PLBlue
            }else {
                circle.backgroundColor = PLPurple
            }
            circle.layer.masksToBounds = true
            circle.heightAnchor.constraintEqualToConstant(20).active = true
            circle.widthAnchor.constraintEqualToConstant(8).active = true
            cell.circleStack.addArrangedSubview(circle)
//        }
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
    
    
    func createDays(){
        let realm = try? Realm()
        currentEvents = realm?.objects(Event)
    }
    
    
    func createTestDays(){
        let newEvent = Event()
        newEvent.serverID = "testEvent"

        let realm = try? Realm()
        realm!.write({ () -> Void in
            realm!.add(newEvent)
        })
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let yPosition = scrollView.contentOffset.y
        
//        var frame = bottomBar.frame
//        frame.origin.y = yPosition + self.view.frame.size.height - BOTTOMBARHEIGHT
//        bottomBar.frame = frame
//        var frame2 = topBar.frame
//        frame2.origin.y = yPosition + TOPBARHEIGHT
//        topBar.frame = frame2
    }


}

