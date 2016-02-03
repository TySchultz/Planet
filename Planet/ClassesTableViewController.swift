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
    
    var realm : Realm?
    
    var currentCourses : Results<Course>?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        
        cell.classTitle.text =  singleCourse.name
        cell.colorSquare.backgroundColor = singleCourse.colorForType(singleCourse.colorEnum)
        
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
    
//    func setup(){
//        
//        index = 0
//        
//        clearOutStackView(colorStack)
//        clearOutStackView(coursesStack)
//        
//        let realme = try? Realm()
//        
//        currentCourses = realme!.objects(Course)
//        for course in currentCourses!  {
//            
//            addCourses(course)
//        }
//        
//        self.numberOfClasses.text = "\(currentCourses!.count)"
//        
//        header.frame = CGRectMake(0, 0, view.frame.size.width, 600)
//        self.tableView.tableFooterView = UIView()
//
//    }
    
 
    
    func clearOutStackView(stack : UIStackView){
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    

    
    
    //TODO: Delete all events connected to that course when deleting course
    func deleteButtonPressed(sender : UIButton) {
        let realme = try! Realm()
        
        var tmpIndex = 0
        
        print("count: \(currentCourses!.count)"   )
        
        for course in currentCourses!  {
            if tmpIndex == sender.tag{
                
                try! realme.write {
                    realme.delete(course)
                }
                break
            }else{
                tmpIndex++
            }
        }
    }
    
    @IBAction func addClassPressed(sender: UIButton) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let viewController = storyboard.instantiateViewControllerWithIdentifier("IntroAddClass") as! IntroAddClassViewController//Uses the view created in the sotryboard so we have autolayout as! intro
        
        viewController.delegate = self
        
        self.presentViewController(viewController, animated: true) { () -> Void in
            
        }
        
    }
    
   
}
