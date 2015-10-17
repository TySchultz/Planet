//
//  ProfileViewController.swift
//  Planet
//
//  Created by Ty Schultz on 10/13/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift

class ProfileViewController: UIViewController {

    @IBOutlet weak var deleteStack: UIStackView!
    @IBOutlet weak var colorStack: UIStackView!
    @IBOutlet weak var coursesStack: UIStackView!
    
    
    var hidden = true
    
    var index = 0
    
    
    var currentCourses : Results<Course>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setup()
        
        deleteStack.hidden = true

        // Do any additional setup after loading the view.
    }
    
    func setup(){
        
        index = 0
        
        clearOutStackView(deleteStack)
        clearOutStackView(colorStack)
        clearOutStackView(coursesStack)
        
        let realme = try? Realm()
        
        currentCourses = realme!.objects(Course)
        for course in currentCourses  {
            addCourses(course)
        }
    }
    
    func clearOutStackView(stack : UIStackView){
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        setup()
    }
    
    override func viewDidDisappear(animated: Bool) {
            deleteStack.hidden = true
    }
    
    
    func addCourses(c : Course){
        let label = UILabel(frame: CGRectMake(0, 0, 100, 30))
        label.text = c.name
        label.font = UIFont(name: "Avenir Book", size: 16.0)
        label.heightAnchor.constraintEqualToConstant(20).active = true
        label.tag = index
        coursesStack.addArrangedSubview(label)
        
        
        let size :CGFloat = 20
        let circle = UIView(frame: CGRectMake(0, 0, size, size))
        circle.layer.cornerRadius = size/2
        circle.backgroundColor = PLBlue
        circle.layer.masksToBounds = true
        circle.heightAnchor.constraintEqualToConstant(size).active = true
        circle.widthAnchor.constraintEqualToConstant(size).active = true
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
       
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            if self.deleteStack.hidden == true{
               self.deleteStack.hidden = false
            }else{
                self.deleteStack.hidden = true
            }
    
        })
    }
    
    func deleteButtonPressed(sender : UIButton) {
        let realme = try! Realm()

        var tmpIndex = 0
        
        print("count: \(currentCourses.count)"   )

        for course in currentCourses  {
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

       //Creates a like swoop effect. Also it wasnt working before so i did it this way haha
        UIView.animateWithDuration(0.1, delay: 0.00, options: [], animations: { () -> Void in
            circle.hidden = true
            }) { (Bool) -> Void in
        }
        
        UIView.animateWithDuration(0.1, delay: 0.02, options: [], animations: { () -> Void in
            label.hidden = true
            }) { (Bool) -> Void in
        }
        
        UIView.animateWithDuration(0.1, delay: 0.04, options: [], animations: { () -> Void in
            sender.hidden = true
            }) { (Bool) -> Void in
        }
    }

    @IBAction func addClassPressed(sender: UIButton) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let viewController = storyboard.instantiateViewControllerWithIdentifier("IntroAddClass") //Uses the view created in the sotryboard so we have autolayout
        
        
        
        self.presentViewController(viewController, animated: true) { () -> Void in
            
        }
        
    }
    @IBOutlet weak var addClass: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
