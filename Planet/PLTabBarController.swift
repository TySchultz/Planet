//
//  PLTabBarController.swift
//  Planet
//
//  Created by Ty Schultz on 10/13/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit

class PLTabBarController: UITabBarController {



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLoad() {
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        
        // Sets the default color of the background of the UITabBar
        UITabBar.appearance().barTintColor = UIColor.blackColor()
        
 
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
