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
        
        let testButton = PLButton()
        let itemSize = self.tabBar.frame.size.width/4
        testButton.frame = CGRectMake(itemSize*2, 0, itemSize, self.tabBar.frame.size.height)
        testButton.backgroundColor = UIColor.clearColor()
        testButton.imageView?.image = UIImage(named: "tabBarImageAddDark")
        testButton.addTarget(self, action: "addPressed", forControlEvents: UIControlEvents.TouchUpInside)
        self.tabBar.addSubview(testButton)
    }
    
    
    func addPressed () {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let viewController = storyboard.instantiateViewControllerWithIdentifier("AddNav")
        let navController = self.viewControllers![0] as! PLNavigationController
        let viewCon = navController.viewControllers[0]
        
        viewCon.presentViewController(viewController, animated: true, completion: nil)
    }
    
    //Allow the tab bar to rotate for all views
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    //Depending on what view is currently selected change the supported orientations
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {

        //The settings view is portrait and will be rotated left or right
        if self.selectedIndex == 3 && UIDevice.currentDevice().orientation != UIDeviceOrientation.Portrait {
            self.tabBar.hidden = true
            return [UIInterfaceOrientationMask.Landscape ,UIInterfaceOrientationMask.Portrait]
        }
        //The view is landscape and will be rotated back to portrait
        else if self.selectedIndex == 3 {
            self.tabBar.hidden = false
            return [UIInterfaceOrientationMask.Landscape ,UIInterfaceOrientationMask.Portrait]
        }
        //If the view is not the settings view then only allow portrait orientation
        return UIInterfaceOrientationMask.Portrait
    }
    
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
//        if item.image!.isEqual(UIImage(named: "tabBarImageAddDark")){
//            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
//            let viewController = storyboard.instantiateViewControllerWithIdentifier("AddAssignment") as! AddAssignmentViewController //Uses the view created in the sotryboard so we have autolayout
//            self.presentViewController(viewController, animated: true, completion: nil)
//        }
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
