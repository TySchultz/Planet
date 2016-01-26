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
        self.navigationBar.barTintColor = UIColor(red:0.27, green:0.73, blue:0.98, alpha:1)
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
