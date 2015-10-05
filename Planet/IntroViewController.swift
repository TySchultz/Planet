//
//  IntroViewController.swift
//  Planet
//
//  Created by Ty Schultz on 9/28/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {

    
    
    @IBOutlet weak var circlesStack: UIStackView!
    @IBOutlet weak var classesStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacing :CGFloat = 16.0
        classesStack.spacing = spacing
        circlesStack.spacing = spacing

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddClassPressed(sender: UIButton) {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let viewController = storyboard.instantiateViewControllerWithIdentifier("IntroAddClass") as! IntroAddClassViewController //Uses the view created in the sotryboard so we have autolayout
        viewController.parent = self
        
        self.presentViewController(viewController, animated: true) { () -> Void in
            
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
    }
    
    @IBAction func addClass( classToAdd : NSString , color :UIColor){
        let size :CGFloat = 16.0
        
        let label = UILabel(frame: CGRectMake(0, 0, 50, 50)) //This CGRectMake doesnt actually matter. stackview collapses everything
        label.font = UIFont(name: "Avenir Heavy", size: 18.0)
        label.text = classToAdd as String
        label.heightAnchor.constraintEqualToConstant(size).active = true //Makes the height be at least 16.0 tall
        label.backgroundColor = UIColor.whiteColor()
        label.hidden = true
        self.classesStack.addArrangedSubview(label)
        
        
        let circle = UIView(frame: CGRectMake(0, 0, size, size))
        circle.layer.cornerRadius = size/2
        circle.backgroundColor = color
        circle.layer.masksToBounds = true //This is like the photoshop thing. if we dont have it the corner radius wont show up
        circle.heightAnchor.constraintEqualToConstant(size).active = true
        circle.widthAnchor.constraintEqualToConstant(size).active = true
        circle.hidden = true
        self.circlesStack.addArrangedSubview(circle)
        
        
     
    }
    
    @IBAction func doneButton(sender: UIButton) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let viewController = storyboard.instantiateViewControllerWithIdentifier("Master") //Uses the view created in the sotryboard so we have autolayout

        let navControl = UINavigationController(rootViewController: viewController)
        
        navControl.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
//        navControl.modalPresentationStyle = UIModalPresentationStyle.CurrentContext

        self.presentViewController(navControl, animated: true) { () -> Void in
            
        }
        


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
