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
    
    @IBOutlet weak var colorStack: UIStackView!
    @IBOutlet weak var coursesStack: UIStackView!
    @IBOutlet weak var deleteStack: UIStackView!

    @IBOutlet weak var numberOfClasses: UILabel!
    
    var hidden = true
    
    var index = 0
    
    var currentCourses : Results<Course>?
    
  

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup(){
        
        index = 0
        
        clearOutStackView(colorStack)
        clearOutStackView(coursesStack)
        
        let realme = try? Realm()
        
        currentCourses = realme!.objects(Course)
        for course in currentCourses!  {
            
            addCourses(course)
        }
        
        self.numberOfClasses.text = "\(currentCourses!.count)"
        
        header.frame = CGRectMake(0, 0, view.frame.size.width, 600)
        self.tableView.tableFooterView = UIView()

    }
    
 
    
    func clearOutStackView(stack : UIStackView){
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    
    func addCourses(c : Course){
        
        let label = UILabel(frame: CGRectMake(0, 0, 100, 30))
        label.text = c.name
        label.font = UIFont(name: "Avenir Book", size: 16.0)
        label.heightAnchor.constraintEqualToConstant(20).active = true
        label.tag = index
        coursesStack.addArrangedSubview(label)
        
        
        let size :CGFloat = 20
        let circle = UIView(frame: CGRectMake(0, 0, 8, size))
        circle.layer.cornerRadius = 4
        circle.backgroundColor = c.colorForType(ColorType(rawValue: c.color)!)
        circle.layer.masksToBounds = true
        circle.heightAnchor.constraintEqualToConstant(size).active = true
        circle.widthAnchor.constraintEqualToConstant(8).active = true
        circle.hidden = false
        circle.alpha = 1.0;
        circle.tag = index
        colorStack.addArrangedSubview(circle)
        
        let delete = UIButton(frame: CGRectMake(0, 0, size, size))
        delete.layer.cornerRadius = size/2
        delete.backgroundColor = UIColor.redColor()
        delete.setTitle("x", forState: UIControlState.Normal)
        delete.titleLabel?.font = UIFont(name: "Avenir Book", size: 14.0)
        delete.layer.masksToBounds = true
        delete.heightAnchor.constraintEqualToConstant(size).active = true
        delete.widthAnchor.constraintEqualToConstant(size*2).active = true
        delete.alpha = 1.0;
        delete.tag = index
        delete.addTarget(self, action: "deleteButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        deleteStack.addArrangedSubview(delete)
        
        
        index++
    }
    @IBAction func editButtonPressed(sender: UIButton) {
       
    
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
        
        let label = coursesStack.arrangedSubviews[sender.tag]
        let circle = colorStack.arrangedSubviews[sender.tag]
        
        circle.hidden = true
        label.hidden  = true
        sender.hidden = true
    }
    
    @IBAction func addClassPressed(sender: UIButton) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let viewController = storyboard.instantiateViewControllerWithIdentifier("IntroAddClass") //Uses the view created in the sotryboard so we have autolayout
        
        
        
        self.presentViewController(viewController, animated: true) { () -> Void in
            
        }
        
    }
    
   
}
