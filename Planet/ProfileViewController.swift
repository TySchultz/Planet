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

    
    
    var hidden = true
    
    var index = 0
    
    
    var currentCourses : Results<Course>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        

        // Do any additional setup after loading the view.
    }
    
    func setup(){
        
        index = 0
        
        
        let realme = try? Realm()
        
        currentCourses = realme!.objects(Course)
        
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
    }

    
    //MARK: - Table View
  
    
    //TODO: Delete all events connected to that course when deleting course
//    func deleteButtonPressed(sender : UIButton) {
//        let realme = try! Realm()
//
//        var tmpIndex = 0
//        
//        print("count: \(currentCourses.count)"   )
//
//        for course in currentCourses  {
//            if tmpIndex == sender.tag{
//                
//                try! realme.write {
//                    realme.delete(course)
//                }
//                break
//            }else{
//                tmpIndex++
//            }
//        }
//    }

//    @IBAction func addClassPressed(sender: UIButton) {
//        
//        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
//        let viewController = storyboard.instantiateViewControllerWithIdentifier("IntroAddClass") //Uses the view created in the sotryboard so we have autolayout
//        
//        
//        
//        self.presentViewController(viewController, animated: true) { () -> Void in
//            
//        }
//        
//    }
    
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
