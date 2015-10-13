//
//  AddAssignmentViewController.swift
//  Planet
//
//  Created by Nick Armold on 10/7/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit
import RealmSwift

class AddAssignmentViewController: UIViewController {
    
    
    @IBOutlet weak var classStack: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//    addButtonsToStack()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
//    
//    func addButtonsToStack(){
//        
//        
//        let realme = try? Realm()
//        
//        let allCourses = realme!.objects(Course)
//
//        for singleCourse in allCourses {
//            let button = UIButton(frame: CGRectMake(0, 0, 250, 250))
//            button.backgroundColor = PLBlue
//            button.setTitle(singleCourse.name, forState: UIControlState.Normal)
//            button.layer.cornerRadius = 18
//            button.addTarget(self, action: "classButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
//            classStack.addArrangedSubview(button)
//        }
//    }

    @IBAction func closeButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil) //hide the viewController
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
