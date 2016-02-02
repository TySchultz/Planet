//
//  OverheadViewController.swift
//  Planet
//
//  Created by Ty Schultz on 1/26/16.
//  Copyright © 2016 Ty Schultz. All rights reserved.
//

import UIKit
import PagingMenuController
import SwiftDate

class OverheadViewController: UIViewController, PagingMenuControllerDelegate {
    
    
//    @IBOutlet weak var sortButton: UIButton!
//    @IBOutlet weak var mainButton: UIButton!
    var pagingMenuController : PagingMenuController!
    
    var masterViewController : MasterViewController!
    var calendarViewController : CalendarViewController!
    var classesViewController : ClassesTableViewController!
    
    
    var profileButton : PLButton!
    var masterButton : PLButton!
    var calendarButton : PLButton!

    @IBOutlet weak var tabBar: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBarHidden = true
        
//        mainButton.setTitle("All Gyms", forState: UIControlState.Normal)
        
        
        masterViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Master") as! MasterViewController
        masterViewController.title = ""
        masterViewController.delegate = self
        calendarViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Calendar") as! CalendarViewController
        calendarViewController.title = ""
        calendarViewController.delegate = self

        classesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Profile") as! ClassesTableViewController
        classesViewController.title = ""

        
        let viewControllers = [classesViewController,masterViewController,calendarViewController]
        
        pagingMenuController = self.childViewControllers.first as! PagingMenuController
        
        let options = PagingMenuOptions()
        options.menuHeight = 0
        options.menuDisplayMode = .Standard(widthMode: .Flexible, centerItem: true, scrollingMode: .PagingEnabled)
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
        
        pagingMenuController.delegate = self
        
        
//        let v = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width-60, height: 40))
//        v.backgroundColor = UIColor.clearColor()
//        self.navigationController?.navigationBar.addSubview(v)
//        
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
//        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Avenir Book", size: 24)!], forState: UIControlState.Normal)
        
   
        

        profileButton  = createNavButton("Classes", location: 0, width: tabBar.frame.width/3)
        masterButton   = createNavButton("Today", location: 1, width: tabBar.frame.width/3)
        calendarButton = createNavButton("Calendar", location: 2, width: tabBar.frame.width/3)
        tabBar.addSubview(profileButton)
        tabBar.addSubview(masterButton)
        tabBar.addSubview(calendarButton)

        pagingMenuController.moveToMenuPage(1, animated: true)
        
        
        tabBar.backgroundColor = PLBlue
        
        // Do any additional setup after loading the view.
    }
    
    
    func createNavButton(title : String, location : Int, width : CGFloat) -> PLButton {
        let button = PLButton()
        button.frame = CGRectMake(CGFloat(location)*width, 0, width, 40)
        button.setTitle(title, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "Avenir Regular", size: 15.0)
        button.titleLabel?.textColor = UIColor.whiteColor()
        if location == 1 {
            button.alpha = 1.0
        }else{
            button.alpha = 0.5
        }
        button.tag = location
        button.addTarget(self, action: "scrollToPage:", forControlEvents: UIControlEvents.TouchUpInside)

        return button
    }
        
        
    @IBAction func addEvent(sender: UIBarButtonItem) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
        let viewController = storyboard.instantiateViewControllerWithIdentifier("AddNav")
        
        self.presentViewController(viewController, animated: true, completion: nil)

    }
    
 //
//    func shouldMoveToMain(type : FilterType ) {
//        pagingMenuController.moveToMenuPage(0, animated: true)
//        
//        mainView.changeFilterAndReload(type)
//        
//        switch type {
//        case .ALL:
//            mainButton.setTitle("All Gyms", forState: UIControlState.Normal)
//        case .UP:
//            mainButton.setTitle("Upper Gym", forState: UIControlState.Normal)
//        case .DOWN:
//            mainButton.setTitle("Lower Gym", forState: UIControlState.Normal)
//        default:
//            mainButton.setTitle("All Gyms", forState: UIControlState.Normal)
//        }
//        
//        
//        var titleRect = mainButton.frame
//        titleRect.origin.x =  view.frame.size.width/2 - titleRect.width/2
//        mainButton.frame = titleRect
//        
//        var rightRect = sortButton.frame
//        rightRect.origin.x = view.frame.size.width - rightRect.width/2
//        sortButton.frame = rightRect
//    }
//    
    func willMoveToMenuPage(page: Int) {
        
    }
    
    func didMoveToMenuPage(page: Int) {
        
        let selectedAlpha :CGFloat = 1.0
        let deselectedAlpha :CGFloat = 0.5
        switch page {
        case 0:
            profileButton.alpha     = selectedAlpha
            masterButton.alpha      = deselectedAlpha
            calendarButton.alpha    = deselectedAlpha
        case 1:
            profileButton.alpha     = deselectedAlpha
            masterButton.alpha      = selectedAlpha
            calendarButton.alpha    = deselectedAlpha
        case 2:
            profileButton.alpha     = deselectedAlpha
            masterButton.alpha      = deselectedAlpha
            calendarButton.alpha    = selectedAlpha
        default:
            profileButton.alpha     = deselectedAlpha
            masterButton.alpha      = selectedAlpha
            calendarButton.alpha    = deselectedAlpha
        }
    }
    
    func scrollToPage(sender: UIButton) {
        pagingMenuController.moveToMenuPage(sender.tag, animated: true)
    
    }
    
    func scrollViewDidScroll(xPosition : CGFloat) {
        
        print(xPosition)
        

        
//        let leftAlpha = (383.0 - xPosition/2)/383
//        mainButton.alpha = leftAlpha
//        
//        let rightAlpha = (xPosition+191)/383
//        sortButton.alpha = rightAlpha
//        
//        
        var titleRect = masterButton.frame
        titleRect.origin.x = -xPosition/2 + view.frame.size.width/2 - titleRect.width/2
        masterButton.frame = titleRect
//
//        var rightRect = sortButton.frame
//        rightRect.origin.x = -xPosition/2 + view.frame.size.width - rightRect.width/2
//        sortButton.frame = rightRect
    }
}
//
//class MyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    var hidingNavBarManager: HidingNavigationBarManager?
//    @IBOutlet weak var tableView: UITableView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
//    }
//    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        hidingNavBarManager?.viewWillAppear(animated)
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        
//        hidingNavBarManager?.viewDidLayoutSubviews()
//    }
//    
//    override func viewWillDisappear(animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        hidingNavBarManager?.viewWillDisappear(animated)
//    }
//    
//    //// TableView datasoure and delegate
//    
//    func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool {
//        hidingNavBarManager?.shouldScrollToTop()
//        
//        return true
//    }
//    
//    ...
//}
