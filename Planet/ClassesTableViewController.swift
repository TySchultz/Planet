//
//  ClassesTableViewController.swift
//  Planet
//
//  Created by Ty Schultz on 1/26/16.
//  Copyright © 2016 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift

class ClassesTableViewController: UITableViewController {

    
    @IBOutlet weak var header: UIView!
    
    var hidden = true
    
    var index = 0
    var delegate : OverheadViewController!

    var realm : Realm?
    
    var currentCourses : Results<Course>?
    var editEnabled : Bool = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        
        header.frame = CGRectMake(0, 0, view.frame.size.width, HEADERHEIGHT)

        
        realm = try? Realm()
        
        currentCourses = realm!.objects(Course)
        self.tableView.reloadData()
        
        if currentCourses?.count == 0{
            showEmptyTable()
        }else{
            hideEmptyTable()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return currentCourses?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CourseCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as! CourseCell
        
        let singleCourse = currentCourses![indexPath.row]
        
        cell.deleteButton.tag = indexPath.row
        cell.classTitle.text =  singleCourse.name
        cell.colorSquare.backgroundColor = singleCourse.colorForType(singleCourse.color)
        //Disable Button
        cell.deleteButton.backgroundColor = UIColor.clearColor()
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            if self.editEnabled {
                cell.deleteButton.enabled = true
                cell.deleteWidth.constant = 70.0
                cell.colorSquareWidth.constant = 0.0
                cell.deleteButton.backgroundColor = PLRed
            }else{
                cell.deleteButton.enabled = false
                cell.deleteWidth.constant = 0.0
                cell.colorSquareWidth.constant = 45.0
                cell.deleteButton.backgroundColor = UIColor.clearColor()
            }
            cell.layoutIfNeeded()
        }, completion: nil)
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            let asyncRealm = try? Realm()

            let ee = asyncRealm!.objects(Event).filter("course = %@", singleCourse)
            let numberOfEvents = ee.count
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                
                cell.upcomingEvents.text = "\(numberOfEvents) Upcoming Events"
            }
        }
        return cell
    }
 
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidDisappear(animated: Bool) {
        editEnabled = false
    }
    

    
    @IBAction func editButtonPressed(sender: UIButton) {
        if editEnabled {
            editEnabled = false
        }else{
            editEnabled = true
        }
        tableView.reloadData()
    }
    
    
    @IBAction func deleteButtonPressed(sender : UIButton) {
        let realme = try! Realm()
        
        sender.enabled = false
        var tmpIndex = 0
        
        print("count: \(currentCourses!.count)")
        
        for course in currentCourses!  {
            if tmpIndex == sender.tag{
                
                print(course.name)
                let p : NSPredicate = NSPredicate(format: "course = %@", course)
                let events = realme.objects(Event).filter(p)
                
                try! realme.write {
                    for event in events {
                        realme.delete(event)
                    }
                    realme.delete(course)
                }
                
                editEnabled = false
                self.tableView.reloadData()
                self.animateTable(0.3)
                
              
                
                self.delegate.reloadControllers()
                
                
                
                break
            }else{
                tmpIndex++
            }
        }
        if currentCourses?.count == 0 {
            showEmptyTable()
        }
       
    }
    
    @IBAction func addClassPressed(sender: UIButton) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let navController = storyboard.instantiateViewControllerWithIdentifier("AddClassNav") as! UINavigationController//Uses the view created in the sotryboard so we have autolayout as! intro
        
//        viewController.delegate = self
        let viewController = navController.viewControllers.first as! IntroAddClassViewController
        
        viewController.delegate = self
        
        editEnabled = false
        
        
        self.presentViewController(navController, animated: true) { () -> Void in
            
        }
        
    }
    
    
    var emptyImage : UIImageView!
    var emptyTitle : UILabel!
    var emptySubTitle : UILabel!
    
    func showEmptyTable(){
        
        emptyImage = UIImageView(image: UIImage(named: "classEmpty"))
        emptyImage.contentMode = .Center
        
        emptyTitle = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        emptyTitle.text = "No Class Today!"
        emptyTitle.font = UIFont(name: "Avenir Book", size: 22)
        emptyTitle.textColor = UIColor.lightGrayColor()
        emptyTitle.textAlignment = NSTextAlignment.Center
        self.tableView.addSubview(emptyTitle)
        
        emptySubTitle = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-40, height: 30))
        emptySubTitle.text = "Well you haven't added any yet..."
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
