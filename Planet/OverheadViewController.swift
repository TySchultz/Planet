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
    
    @IBOutlet weak var tabStack: UIStackView!
    
    @IBOutlet var profileButton : UIButton!
    @IBOutlet var masterButton : UIButton!
    @IBOutlet var calendarButton : UIButton!
    @IBOutlet var addEventButton : UIButton!

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

        
        let viewControllers = [masterViewController, calendarViewController, classesViewController]
        
        pagingMenuController = self.childViewControllers.first as! PagingMenuController
        
        let options = PagingMenuOptions()
        options.menuHeight = 0
        options.menuDisplayMode = .Standard(widthMode: .Flexible, centerItem: true, scrollingMode: .PagingEnabled)
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
        pagingMenuController.delegate = self
        
        
        let darkBlue = UIColor(red:0.16, green:0.56, blue:0.8, alpha:1)
        tabBar.backgroundColor = darkBlue

        addButtonActions(profileButton,location: 2)
        
        addButtonActions(masterButton,location: 0)

        addButtonActions(calendarButton,location: 1)

        addEventButton.addTarget(self, action: "addEvent:", forControlEvents: UIControlEvents.TouchUpInside)
   
        
        for view in tabStack.arrangedSubviews {
            view.removeFromSuperview()
        }
        tabStack.addArrangedSubview(masterButton)
        tabStack.addArrangedSubview(calendarButton)
        tabStack.addArrangedSubview(profileButton)
        tabStack.addArrangedSubview(addEventButton)
        
        
        
        profileButton.backgroundColor   = PLBlue
        masterButton.backgroundColor    = PLBlue
        calendarButton.backgroundColor  = PLBlue
        addEventButton.backgroundColor  = PLBlue

        pagingMenuController.moveToMenuPage(0, animated: true)
        
   
        
        // Do any additional setup after loading the view.
    }
    
    
    func addButtonActions(button : UIButton, location : Int) {

        button.tag = location
        button.addTarget(self, action: "scrollToPage:", forControlEvents: UIControlEvents.TouchUpInside)
    }
        
        

    

    func willMoveToMenuPage(page: Int) {
        
    }
    
    func didMoveToMenuPage(page: Int) {

        switch page {
        case 0:
            profileButton.alpha   = 1.0
            masterButton.alpha    = 0.7
            calendarButton.alpha  = 1.0
            

        case 1:
            profileButton.alpha   = 1.0
            masterButton.alpha    = 1.0
            calendarButton.alpha  = 0.7
            

        case 2:
            profileButton.alpha   = 0.7
            masterButton.alpha    = 1.0
            calendarButton.alpha  = 1.0
            

        default:
            profileButton.alpha   = 1.0
            masterButton.alpha    = 1.0
            calendarButton.alpha  = 1.0
            

        }
    }
    
    @IBAction func scrollToPage(sender: UIButton) {
            pagingMenuController.moveToMenuPage(sender.tag, animated: false)
    }
    
    
    @IBAction func addEventPressed(sender: UIButton) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
            let viewController = storyboard.instantiateViewControllerWithIdentifier("AddNav")
            
            self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    
    func scrollViewDidScroll(xPosition : CGFloat) {
        
        print(xPosition)
    }
}


extension UIButton {
    
    //    This method sets an image and title for a UIButton and
    //    repositions the titlePosition with respect to the button image.
    //    Add additionalSpacing between the button image & title as required
    //    For titlePosition, the function only respects UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft and UIViewContentModeRight
    //    All other titlePositions are ignored
    @objc func set(image anImage: UIImage?, title: String!, titlePosition: UIViewContentMode, additionalSpacing: CGFloat, state: UIControlState){
        self.imageView?.contentMode = .Center
        self.setImage(anImage, forState: state)
        
        positionLabelRespectToImage(title!, position: titlePosition, spacing: additionalSpacing)
        
        self.titleLabel?.contentMode = .Center
        self.setTitle(title, forState: state)
        self.titleLabel?.font = UIFont(name: "Avenir Light", size: 11.0)
        self.titleLabel?.layer.masksToBounds = false
    }
    
    private func positionLabelRespectToImage(title: NSString, position: UIViewContentMode, spacing: CGFloat) {
        let imageSize = self.imageRectForContentRect(self.frame)
        let titleFont = UIFont(name: "Avenir Light", size: 11.0)
        let titleSize = title.sizeWithAttributes([NSFontAttributeName: titleFont!])
        
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position){
        case .Top:
            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .Bottom:
            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing), left: -(imageSize.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .Left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .Right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        self.titleEdgeInsets = titleInsets
        self.imageEdgeInsets = imageInsets
    }
}