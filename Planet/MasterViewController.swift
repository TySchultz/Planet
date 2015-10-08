//
//  MasterViewController.swift
//  Planet
//
//  Created by Ty Schultz on 9/28/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift


class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
    var days    = [AnyObject]()
    var things    = [AnyObject]()

    var events  = [Int]()
    
    var currentEvents :Results<(Event)>?

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var footerView: UIView!
    
    var bottomBar :UIView!
    var topBar :UIView!
    
    
    let BOTTOMBARHEIGHT :CGFloat = 45.0
    let TOPBARHEIGHT :CGFloat = 40.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        
        self.headerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60)
        self.footerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: BOTTOMBARHEIGHT)

        
        self.navigationController?.navigationBarHidden = true
        
        bottomBar = UIView(frame: CGRect(x: 0, y: self.view.frame.size.height-BOTTOMBARHEIGHT, width: self.view.frame.size.width, height: BOTTOMBARHEIGHT))
        bottomBar.backgroundColor = PLBlue
        self.tableView.addSubview(bottomBar)
        self.tableView.bringSubviewToFront(bottomBar)
        
        topBar = UIView(frame: CGRect(x: 30, y: 20, width: self.view.frame.size.width-60, height: TOPBARHEIGHT))
        topBar.backgroundColor = PLBlue
        topBar.layer.cornerRadius = TOPBARHEIGHT/2
        topBar.layer.masksToBounds = true
        self.tableView.addSubview(topBar)
        self.tableView.bringSubviewToFront(topBar)
        
        
        let calendarButton = UIButton(frame: CGRectMake(0, 0, 200, BOTTOMBARHEIGHT))
        calendarButton.center = CGPointMake(bottomBar.frame.size.width/2, BOTTOMBARHEIGHT/2)
        calendarButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        calendarButton.setTitle("Calendar", forState: UIControlState.Normal)
        bottomBar.addSubview(calendarButton)
        
        
        let settingsButton = UIButton(frame: CGRectMake(0, 0, 45, BOTTOMBARHEIGHT))
        settingsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        settingsButton.setTitle("o", forState: UIControlState.Normal)
        bottomBar.addSubview(settingsButton)
        
        let addClassButton = UIButton(frame: CGRectMake(0, 0, 800, BOTTOMBARHEIGHT))
       // calendarButton.center = CGPointMake()
        addClassButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        addClassButton.setTitle("+", forState: UIControlState.Normal)
        bottomBar.addSubview(addClassButton)
        
        addClassButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        
        objects = [15,16,17,18,19,15,16,15,16,17,18,19,15,16,15,16,17,18,19,15,16]
        days = ["Monday","Tuesday","Wednesday","Thursdsay","Friday","Saturday","Sunday","Monday","Tuesday","Wednesday","Thursdsay","Friday","Saturday","Sunday","Monday","Tuesday","Wednesday","Thursdsay","Friday","Saturday","Sunday"]
        events = [2,4,1,2,3,2,0,2,3,1,2,4,2,1,2,4,1,3,1,2,1]
        things = ["Test","HW","QUIZ","Presentation","Project","Midterm","Essay","Test","HW","QUIZ","Presentation","Project","Midterm","Essay","Test","HW","QUIZ","Presentation","Project","Midterm","Essay"]

        
        tableView.estimatedRowHeight = 80.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        
        
       // createTestDays()
        createDays()
    }
    
    func pressed(sender: UIButton!) {
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let viewController = storyboard.instantiateViewControllerWithIdentifier("AddAssignment") as! AddAssignmentViewController //Uses the view created in the sotryboard so we have autolayout
        
//        let navControl = UINavigationController(rootViewController: viewController)
//        
//        navControl.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        self.presentViewController(viewController, animated: true) { () -> Void in
            
        }

        
        
    }

    override func viewWillAppear(animated: Bool) {
//        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//
//    func insertNewObject(sender: AnyObject) {
//        objects.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> DayCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DayCell", forIndexPath: indexPath) as! DayCell

//        cell.dayNumber.text = "15"
        cell.dayTitle.text  = "\(days[indexPath.row])"
        cell.dayNumber.text = "\(objects[indexPath.row])"
        
        for subv in cell.eventStack.arrangedSubviews {
            subv.removeFromSuperview()
        }
        
        for subv in cell.circleStack.arrangedSubviews {
            subv.removeFromSuperview()
        }
        
        for var i = 0; i < events[indexPath.row]; i++ {
            let label = UILabel(frame: CGRectMake(0, 0, 50, 20))
            label.text = things[indexPath.row] as? String
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
    
    
    func createDays(){
        let realm = try? Realm()
        currentEvents = realm?.objects(Event)
    }
    
    
    func createTestDays(){
        let newEvent = Event()
        newEvent.name = "testEvent"
        newEvent.serverID = "testEvent"

        let realm = try? Realm()
        realm!.write({ () -> Void in
            realm!.add(newEvent)
        })
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        let yPosition = scrollView.contentOffset.y
        
        var frame = bottomBar.frame
        frame.origin.y = yPosition + self.view.frame.size.height - BOTTOMBARHEIGHT
        bottomBar.frame = frame
        
        var frame2 = topBar.frame
        frame2.origin.y = yPosition + TOPBARHEIGHT
        topBar.frame = frame2
        
        
    }


}

