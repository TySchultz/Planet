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
    
    var emptyImage : UIImageView!
    var emptyTitle : UILabel!
    var emptySubTitle : UILabel!
    
    
    let types = ["Test","Quiz","Homework","Project","Meeting", "Presentation"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ClassesTableViewController.stopAdding(_:)))
        self.tableView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidDisappear(animated: Bool) {
        editEnabled = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        

        
        realm = try? Realm()
        
        currentCourses = realm!.objects(Course)
        self.tableView.reloadData()
        
//        if currentCourses?.count == 0{
//            showEmptyTable()
//        }else{
//            hideEmptyTable()
//        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            var count = currentCourses?.count ?? 0
            count += 1
            return count
        }else{
            return types.count + 1
        }
        
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            
        
            if indexPath.row + 1 == self.tableView(tableView, numberOfRowsInSection: indexPath.section){
                let cell = tableView.dequeueReusableCellWithIdentifier("AddObjectCell", forIndexPath: indexPath) as! AddObjectCell
                
                return cell

            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as! CourseCell
                
                let singleCourse = currentCourses![indexPath.row]
                
                cell.deleteButton.tag = indexPath.row
                cell.classTitle.text =  singleCourse.name
                cell.colorSquare.backgroundColor = singleCourse.colorForType(singleCourse.color)
                cell.colorSquare.layer.cornerRadius = 22
                //Disable Button

                UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    if self.editEnabled {
                        cell.deleteButton.enabled = true
                        cell.deleteWidth.constant = 70.0
                        cell.colorSquareWidth.constant = 0.0
                        cell.deleteButton.backgroundColor = PLRed
                    }else{
                        //                        cell.deleteButton.enabled = false
                        cell.deleteWidth.constant = 0.0
                        cell.colorSquareWidth.constant = 45.0
                        cell.deleteButton.backgroundColor = UIColor.clearColor()
                    }
                    cell.layoutIfNeeded()
                    }, completion: nil)

                
                //        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                //        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                //            // do some task
                //            let asyncRealm = try? Realm()
                //
                //            let ee = asyncRealm!.objects(Event).filter("course = %@", singleCourse)
                //            let numberOfEvents = ee.count
                //
                //            dispatch_async(dispatch_get_main_queue()) {
                //                // update some UI
                //                
                //                cell.upcomingEvents.text = "\(numberOfEvents) Upcoming Events"
                //            }
                //        }
                return cell
            }
        }else{
            if indexPath.row + 1 == self.tableView(tableView, numberOfRowsInSection: indexPath.section){
                let cell = tableView.dequeueReusableCellWithIdentifier("AddObjectCell", forIndexPath: indexPath) as! AddObjectCell
                cell.textField.placeholder = "Add Type of Event"
                return cell
                
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("CourseCell", forIndexPath: indexPath) as! CourseCell
                
                cell.deleteButton.tag = indexPath.row
                cell.classTitle.text =  types[indexPath.row]
                cell.colorSquare.backgroundColor = PLBlue
                cell.colorSquare.layer.cornerRadius = 22
                //Disable Button
//                cell.deleteButton.backgroundColor = UIColor.clearColor()
                
                
                UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    if self.editEnabled {
                        cell.deleteButton.enabled = true
                        cell.deleteWidth.constant = 70.0
                        cell.colorSquareWidth.constant = 0.0
                        cell.deleteButton.backgroundColor = PLRed
                    }else{
//                        cell.deleteButton.enabled = false
                        cell.deleteWidth.constant = 0.0
                        cell.colorSquareWidth.constant = 45.0
                        cell.deleteButton.backgroundColor = UIColor.clearColor()
                    }
                    cell.layoutIfNeeded()
                    }, completion: nil)

                
                return cell
            }
        }
    }
 
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
//        let ce = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0)-1, inSection: 0)) as! AddObjectCell
//        ce.textField.resignFirstResponder()
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
        
        let contentView = sender.superview
        let cell = contentView?.superview as! CourseCell
        
        print("count: \(currentCourses!.count)")
        
        for course in currentCourses!  {
            
            //Find the correct course
            if course.name == cell.classTitle.text{
//                
                let p : NSPredicate = NSPredicate(format: "course = %@", argumentArray: [course])
                let events = realme.objects(Event).filter(p)
                
                try! realme.write {
                    for event in events {
                        realme.delete(event)
                    }
                    realme.delete(course)
                }
                
                
//                editEnabled = false
//                self.animateTable(0.3)
                
              
                
//                self.delegate.reloadControllers()
                
                break
            }else{
                tmpIndex++
            }
        }
        
        self.tableView.deleteRowsAtIndexPaths([tableView.indexPathForCell(cell)!], withRowAnimation: UITableViewRowAnimation.Middle)
        currentCourses = realm!.objects(Course)
//        self.tableView.reloadData()
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
}

//MARK: - Header and Footer 
extension ClassesTableViewController {
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 40))
        headerView.backgroundColor = UIColor.whiteColor()

        var lineWidth = headerView.frame.width/2-32
        var xPosition :CGFloat = 0.0
        let title = UILabel(frame: CGRectMake(16, 8, tableView.frame.size.width, headerView.frame.height))
        if section == 0 {
            title.text = " CLASSES"
            lineWidth = headerView.frame.width/2-45
            xPosition = headerView.frame.width/2+45
        }else{
            title.text = " TYPES"
            lineWidth = headerView.frame.width/2-32
            xPosition = headerView.frame.width/2+32

        }
        title.font = UIFont(name: "Avenir Book", size: 11.0)
        title.textColor = PLBlue
        title.textAlignment = NSTextAlignment.Center

        //Adds spacing between letters
        let attributedString = NSMutableAttributedString(string: title.text!)
        attributedString.addAttribute(NSKernAttributeName, value: 5.0, range: NSMakeRange(0, title.text!.characters.count))
        title.attributedText = attributedString

    
        
        let leftLine = UIView(frame: CGRect(x: 0, y: headerView.frame.height/2, width: lineWidth, height: 1))
        leftLine.backgroundColor = UIColor.lightGrayColor()
        leftLine.alpha = 0.3
        
        
        let rightLine = UIView(frame: CGRect(x: xPosition, y: headerView.frame.height/2, width: lineWidth, height: 1))
        rightLine.backgroundColor = UIColor.lightGrayColor()
        rightLine.alpha = 0.3
        
        headerView.addSubview(leftLine)
        headerView.addSubview(rightLine)
        headerView.addSubview(title)
        title.center = headerView.center
        return headerView
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 80))
//      
//        
//        let addImage = UIImageView(frame: CGRectMake(16, 8, 45, 45))
//        addImage.image = UIImage(named: "addButtonDark")
//        addImage.contentMode = .ScaleAspectFit
//        footerView.addSubview(addImage)
//        
//        let textField = UITextField(frame: CGRectMake(80, 8, footerView.frame.width-80, 45))
//        textField.placeholder = "Add Course"
//        
//        
//        footerView.addSubview(textField)
//            
//        
//        footerView.backgroundColor = UIColor.whiteColor()
//        
//        
//        
//        return footerView
//    }
//    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 80.0
//    }
    
    
    func submitClass(className : String) {
        
        if className == "" {
            return
        }
        
        let newCourse = Course()
        newCourse.name = className
        newCourse.serverID = className
        newCourse.color = 0 //TODO: add color chooser
        
        let realme = try? Realm()
        
        var alreadyCreated = false
        
        //Gets all the courses from our local database
        //loops through and checks for a used name
        let allCourses = realme!.objects(Course)
        for singleCourse in allCourses where singleCourse.name == className{
            alreadyCreated = true
        }
        
        if !alreadyCreated {
            
            //Creates the new course object and add it to our database.
            try! realme!.write({ () -> Void in
                realme!.add(newCourse)
            })
            let count = self.tableView.numberOfRowsInSection(0)
            self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: count-1, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Middle)
//            self.delegate?.hideEmptyTable()
            //Hides this view. When it hides at the completion call the add class method
//            self.dismissViewControllerAnimated(true) { () -> Void in
                //                    self.parent.addClass(self.classNameField.text!, color: self.oldButton.backgroundColor!)
                //                    self.delegate?.animateTable(0.5)
//                self.delegate?.delegate.setupSort()
//                Answers.logContentViewWithName("Add Course", contentType: "", contentId: "", customAttributes: ["color":self.currentColor, "name":self.classNameField.text!])
            
        }else{
//            classNameLBL.text = "Class name - Have you used that already?"
//            classNameLBL.textColor = PLOrange
            return
        }
    }

}

//MARK: - TableView Swipe Edit
extension ClassesTableViewController {
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    override func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CourseCell
//
//        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            cell.deleteButton.enabled = true
//            cell.deleteWidth.constant = 70.0
//            cell.colorSquareWidth.constant = 0.0
//            cell.deleteButton.backgroundColor = PLRed
//            cell.layoutIfNeeded()
//            }, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CourseCell
//        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            cell.deleteButton.enabled = false
//            cell.deleteWidth.constant = 0.0
//            cell.colorSquareWidth.constant = 45.0
//            cell.deleteButton.backgroundColor = UIColor.clearColor()
//            cell.layoutIfNeeded()
//            }, completion: nil)
    }
    
//    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
//        return []
//    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as! CourseCell
//        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                cell.deleteButton.enabled = true
//                cell.deleteWidth.constant = 70.0
//                cell.colorSquareWidth.constant = 0.0
//                cell.deleteButton.backgroundColor = PLRed
//            cell.layoutIfNeeded()
//            }, completion: nil)
    }
}

//MARK: - IBActions
extension ClassesTableViewController {
    @IBAction func closeButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addPressed(sender: UIButton) {
        let view = sender.superview!
        let cell = view.superview as! AddObjectCell
        print(cell.textField.text)
        
        
        submitClass(cell.textField.text!)
        cell.textField.text = ""
        cell.textField.placeholder = "Add Course"
       
    }
    
    
    func stopAdding(tap : UITapGestureRecognizer) {
        
        let ce = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0)-1, inSection: 0)) as! AddObjectCell
        ce.endedEditing()
    }
    
    @IBAction func chooseColor(sender: UIButton) {
        let colorView = UIView(frame: self.view.frame)
        
        let defaults = NSUserDefaults.standardUserDefaults()
//        defaults.setBool(true, forKey: "CourseColorChosenBefore")

        
        colorView.backgroundColor = UIColor.whiteColor()
        colorView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.height)
        
        self.view.addSubview(colorView)
        
        self.tableView.scrollEnabled = false
        
        UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            colorView.transform = CGAffineTransformMakeTranslation(0, self.tableView.contentOffset.y-60)
            }, completion: nil)
        
        
        let circleOne   = createCircle(PLRed, row: 0, column: 0)
        let circleTwo   = createCircle(PLOrange, row: 0, column: 1)
        let circleThree = createCircle(PLLightGreen, row: 0, column: 2)
        
        let circleFour   = createCircle(PLGreen, row: 1, column: 0)
        let circleFive  = createCircle(PLPurple, row: 1, column: 1)
        let circleSix = createCircle(PLGray, row: 1, column: 2)
        
        let circleSeven  = createCircle(PLBlue, row: 2, column: 0)
        let circleEight   = createCircle(PLLightBlue, row: 2, column: 1)
        let circleNine = createCircle(PLBlue, row: 2, column: 2)

        colorView.addSubview(circleOne)
        colorView.addSubview(circleTwo)
        colorView.addSubview(circleThree)
        
        colorView.addSubview(circleFour)
        colorView.addSubview(circleFive)
        colorView.addSubview(circleSix)

        colorView.addSubview(circleSeven)
        colorView.addSubview(circleEight)
        colorView.addSubview(circleNine)
  
        animateCircle(circleOne, delay: 0.1, position: 0)
        animateCircle(circleTwo, delay: 0.12, position: 0)
        animateCircle(circleThree, delay: 0.14, position: 0)
        animateCircle(circleFour, delay: 0.16, position: 0)
        animateCircle(circleFive, delay: 0.18, position: 0)
        animateCircle(circleSix, delay: 0.2, position: 0)
        animateCircle(circleSeven, delay: 0.22, position: 0)
        animateCircle(circleEight, delay: 0.24, position: 0)
        animateCircle(circleNine, delay: 0.26, position: 0)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(ClassesTableViewController.colorViewTapped(_:)))
        colorView.addGestureRecognizer(tap)
    }
    
    func colorViewTapped(tap : UITapGestureRecognizer){
        let colorView = tap.view!
        
        dismissColorView(colorView, color: PLBlue)
    }
    
    func dismissColorView(colorView : UIView, color : UIColor){
        var delay = 0.26
        //Casecade all of the buttons
        for child in colorView.subviews{
            animateCircle(child, delay: delay, position: self.view.frame.height)
            delay = delay - 0.02
        }

        
        //shrink background
        UIView.animateAndChainWithDuration(0.4, delay: 0.4, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            colorView.transform = CGAffineTransformMakeTranslation(0, self.view.frame.height)

        }){ (Bool) in
            
            //Delete background and enable the tableview
            colorView.removeFromSuperview()
            self.tableView.scrollEnabled = true
            
            let ce = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: self.tableView.numberOfRowsInSection(0)-1, inSection: 0)) as! AddObjectCell
            ce.changeColorButtonBackground(color)

        }
    }
    
    func colorButtonPressed(sender : UIButton) {
        
    
        dismissColorView(sender.superview!, color: sender.backgroundColor!)
        sender.setTitle("J", forState: UIControlState.Normal)
        
    }
    
    func animateCircle(circle : UIView, delay : Double, position : CGFloat){
        UIView.animateWithDuration(0.4, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            circle.transform = CGAffineTransformMakeTranslation(0, position)
            }, completion: nil)

    }
    
    
    func createCircle(color : UIColor, row : Int, column : Int) -> UIView {
        let width = self.view.frame.width/4
        let height = self.view.frame.height/6
        
        let circleOne = UIButton(frame: CGRect(x: 16, y: 16, width: 64, height: 64))
        
        
        circleOne.center = CGPointMake(width + width*CGFloat(column), height + height*CGFloat(row))
        circleOne.backgroundColor = color
        circleOne.layer.cornerRadius = 32.0
        circleOne.layer.masksToBounds = true
        circleOne.transform = CGAffineTransformMakeTranslation(0, self.view.frame.height)
        circleOne.addTarget(self, action: #selector(ClassesTableViewController.colorButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        circleOne.addTarget(self, action: #selector(ClassesTableViewController.shrink(_:)), forControlEvents: UIControlEvents.TouchDown)
//        circleOne.addTarget(self, action: #selector(ClassesTableViewController.expand(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//        circleOne.addTarget(self, action: #selector(ClassesTableViewController.expand(_:)), forControlEvents: UIControlEvents.TouchDragOutside)
//

        
        return circleOne
    }
    
    func shrink(sender : UIButton) {
        UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            sender.transform = CGAffineTransformMakeScale(0.3, 0.3)
            }, completion: nil)
    }
    
    func expand(sender: UIButton) {
        UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            sender.transform = CGAffineTransformMakeScale(1.0, 1.0)
            }, completion: nil)

    }
    
}
//MARK: - Empty State 
extension ClassesTableViewController {
    
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
