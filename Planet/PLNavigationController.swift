//
//  PLNavigationController.swift
//  Planet
//
//  Created by Ty Schultz on 10/13/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit

class PLNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationBarHidden = false
        self.navigationBar.backgroundColor = UIColor.whiteColor()
        self.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationBar.opaque = true
        
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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


extension UIButton {
    
//    
//    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            self.transform = CGAffineTransformMakeScale(0.5, 0.5)
//            
//            }, completion: nil)
//
//        
//    }
//    public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            self.transform = CGAffineTransformMakeScale(1, 1)
//            
//            }, completion: nil)
//
//    }
    
}