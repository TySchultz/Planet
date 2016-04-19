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
import RealmSwift

class OverheadViewController: UIViewController, PagingMenuControllerDelegate {
    
    
    var pagingMenuController    : PagingMenuController!
    var masterViewController    : MasterViewController!
    var calendarViewController  : CalendarViewController!
    var classesViewController   : ClassesTableViewController!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tabStack: UIStackView!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet var profileButton     : UIButton!
    @IBOutlet var masterButton      : UIButton!
    @IBOutlet var calendarButton    : UIButton!
    @IBOutlet var addEventButton    : UIButton!
    @IBOutlet var sortButton        : UIButton!
    @IBOutlet weak var tabBar       : UIView!
    
    
    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var emptySubTitle: UILabel!
    @IBOutlet weak var emptyTitle: UILabel!
    
    
    var currentlySorting = false
    let TABBARHEIGHT :CGFloat = 50
    let types = ["Test","Quiz","Homework","Project","Meeting", "Presentation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBarHidden = true
        
//        mainButton.setTitle("All Gyms", forState: UIControlState.Normal)
    
        
        masterViewController            = self.storyboard?.instantiateViewControllerWithIdentifier("Master") as! MasterViewController
        masterViewController.title      = ""
        calendarViewController          = self.storyboard?.instantiateViewControllerWithIdentifier("Calendar") as! CalendarViewController
        calendarViewController.title    = ""
        calendarViewController.delegate = self
        classesViewController           = self.storyboard?.instantiateViewControllerWithIdentifier("Profile") as! ClassesTableViewController
        classesViewController.delegate  = self
        classesViewController.title     = ""

        
        let viewControllers = [masterViewController, calendarViewController, classesViewController]
        
        pagingMenuController = self.childViewControllers.first as! PagingMenuController
        
        let options = PagingMenuOptions()
        options.menuHeight = 0
        options.menuDisplayMode = .Standard(widthMode: .Flexible, centerItem: true, scrollingMode: .PagingEnabled)
        pagingMenuController.setup(viewControllers: viewControllers, options: options)
        pagingMenuController.delegate = self
        
        
        tabBar.backgroundColor = UIColor.whiteColor()

        addButtonActions(masterButton,location: 0)
        addButtonActions(calendarButton,location: 1)
        addButtonActions(profileButton,location: 2)
        addButtonActions(sortButton,location: -1)

        
        for view in tabStack.arrangedSubviews {
            view.removeFromSuperview()
        }
//
        tabStack.addArrangedSubview(addEventButton)
        tabStack.addArrangedSubview(sortButton)
        tabStack.addArrangedSubview(masterButton)
        tabStack.addArrangedSubview(calendarButton)
        tabStack.addArrangedSubview(profileButton)
        
        let darkBlue                   = UIColor(red:0.16, green:0.56, blue:0.8, alpha:1)
        tabStack.backgroundColor       = darkBlue
        profileButton.backgroundColor  = PLBlue
        masterButton.backgroundColor   = PLBlue
        calendarButton.backgroundColor = PLBlue
        addEventButton.backgroundColor = PLBlue
        sortButton.backgroundColor     = PLBlue
        
        masterButton.addSubview(createSubLabel("Home"))
        calendarButton.addSubview(createSubLabel("Cal"))
        sortButton.addSubview(createSubLabel("Sort"))
        profileButton.addSubview(createSubLabel("Classes"))
        addEventButton.addSubview(createSubLabel("Add"))


        pagingMenuController.moveToMenuPage(0, animated: true)
        
        setupSort()
        // Do any additional setup after loading the view.
    }
    
    func setupSort () {
        currentTypeStackIndex = 0
        currentCourseStackIndex = 0
        
        clearOutStackView(typeStack)
        clearOutStackView(coursesStack)
        
        
        let realme = try? Realm()
        
        typeStack.tag = 1
        coursesStack.tag = 0
        
        let allCourses = realme!.objects(Course)
        for course in allCourses  {
            addButtonToStack(course.name,color:course.color, stackView: coursesStack)
        }
        
        for type in types {
            addButtonToStack(type,color:MAINTHEMECOLOR, stackView: typeStack)
        }
    }
    
    
    func createSubLabel(title : String) ->UILabel {
        let xCenter = self.view.frame.width/10

        let subLabel = UILabel(frame: CGRect(x: 0, y: 0, width: xCenter*2, height: 15))
        subLabel.text = title
        subLabel.textAlignment = NSTextAlignment.Center
        subLabel.textColor = UIColor.whiteColor()
        subLabel.font = UIFont(name: "Avenir Book", size: 11.0)
        subLabel.center = CGPointMake(xCenter,42)
        return subLabel
    }
    
    /**
     Creates the target and other properties of the tab bar buttons
     
     - parameter button:   the button to be manipulated
     - parameter location: the location on the tap bar
     */
    func addButtonActions(button : UIButton, location : Int) {

        button.tag = location
        button.addTarget(self, action: "scrollToPage:", forControlEvents: UIControlEvents.TouchUpInside)
    }
        


    

    func willMoveToMenuPage(page: Int) {
        
        switch page {
        case 0: //Home Page
            profileButton.alpha  = 1.0
            masterButton.alpha   = 0.7
            calendarButton.alpha = 1.0
            
          
            
        case 1: //Calendar page
            profileButton.alpha  = 1.0
            masterButton.alpha   = 1.0
            calendarButton.alpha = 0.7
            
            
        case 2: //Profile Page
            profileButton.alpha  = 0.7
            masterButton.alpha   = 1.0
            calendarButton.alpha = 1.0
            
            
        default:
            profileButton.alpha  = 1.0
            masterButton.alpha   = 1.0
            calendarButton.alpha = 1.0
            
            
        }

    }
    
    func didMoveToMenuPage(page: Int) {

//
//        switch page {
//        case 0: //Home Page
//            profileButton.alpha  = 1.0
//            masterButton.alpha   = 0.7
//            calendarButton.alpha = 1.0
//
//            if currentlySorting {
//                masterButton.alpha   = 1.0
//                sortButton.alpha     = 0.7
//            }
//            
//        case 1: //Calendar page
//            profileButton.alpha  = 1.0
//            masterButton.alpha   = 1.0
//            calendarButton.alpha = 0.7
//
//
//        case 2: //Profile Page
//            profileButton.alpha  = 0.7
//            masterButton.alpha   = 1.0
//            calendarButton.alpha = 1.0
//
//
//        default:
//            profileButton.alpha  = 1.0
//            masterButton.alpha   = 1.0
//            calendarButton.alpha = 1.0
//
//
//        }
    }
    
    /**
     Scroll to a certain page on the tab bar view. 
     This will make the tab bar act like the native tab bar, 
     and flash imeditely to the view
     
     - parameter sender: the tab bar button tapped
     */
    @IBAction func scrollToPage(sender: UIButton) {
       
        //Sorting Tapped
        if sender.tag == -1 {
            //Sorting tapped and it was already sorting
            if currentlySorting {
                masterButton.alpha = 0.7
                sortButton.alpha   = 1.0
                currentlySorting   = false
                hideSortView()

            }else{ //Sorting was not showing, so show
                currentlySorting   = true
                showSortView()
                masterButton.alpha = 1.0
                sortButton.alpha   = 0.7
            }
            return
        }else{ //Anything but sort tapped. Hide sorting and change colors
            hideSortView()
            currentlySorting = false
            sortButton.alpha = 1.0
            
            //Home was tapped. The page view is already on the home screen 
            //It will exit 
            if sender.tag == 0 {
                masterButton.alpha = 0.7
            }
        }
    
        
        //Current Page Selected, Dont move
        if pagingMenuController.currentPage == sender.tag || sender.tag == -1  {
            //Home tapped with sorting showing
            return
        }
     
        pagingMenuController.moveToMenuPage(sender.tag, animated: false)
    }
    
    /**
     Hides the sort view. 
     This is done by adjusting the constraint on the container view. 
     The bottom constraint will shrink down 50 only showing the tab bar.
     */
    func hideSortView() {
        //Sorting is showing
        self.bottomConstraint.constant = TABBARHEIGHT
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        masterViewController.currentEvents = masterViewController.getDays()
        masterViewController.tableView.reloadData()
        masterViewController.animateTable(0.4)

    }
    
    
    /**
     Hides the sort view. 
     This is done by adjusting the constraint on the container view. 
     The bottom constraint will grow to a size determined by the size of the stackviews 
     expandSize  = 120+coursesStack.frame.height+typeStack.frame.height)
     */
    func showSortView() {
        
        
        //Sorting not shown
        var height :CGFloat = 128
        
        if masterViewController.currentEvents.count == 0 {
            height = 500
        }
        
        if pagingMenuController.currentPage != 0 {
            pagingMenuController.moveToMenuPage(0, animated: false)
        }else{
            
        }

        self.bottomConstraint.constant = height+coursesStack.frame.height+typeStack.frame.height
        
        UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        
        
        if numberOfSelections >= 1 {
            masterViewController.reloadDays(self.filterCourses(), typeFilter: self.filterType())
        }
    }
    
    
    /**
     Add Event Tab Pressed. Modally presents the add event navigation controller
     
     - parameter sender: Add Tab Bar
     */
    @IBAction func addEventPressed(sender: UIButton) {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil) // grabs the storybaord
            let navController = storyboard.instantiateViewControllerWithIdentifier("AddNav") as! UINavigationController//Uses the view created in the sotryboard so we have autolayout as! intro
            
            //        viewController.delegate = self
            let viewController = navController.viewControllers.first as! AddEventViewController
            
        
            self.presentViewController(navController, animated: true, completion: nil)
    }
    
    
    //MARK: Stackview Methods


    var currentTypeStackIndex   = 0
    var currentCourseStackIndex = 0
    var numberOfSelections      = 0

    @IBOutlet weak var coursesStack: UIStackView!
    @IBOutlet weak var typeStack: UIStackView!


  
    
    func buttonPressed(sender : UIButton){
        
        
        //button in header is tapped and not selected
        if sender.tag == 0 {
            numberOfSelections++
            sender.alpha = 1.0
            sender.tag   = 1
        }
            //Button in header is tapped and already selected
        else if sender.tag == 1 {
            numberOfSelections--
            sender.alpha = 0.3
            sender.tag   = 0

            self.removeFromStacks(sender)
            
        }
        
        if numberOfSelections == 0 {
            masterViewController.currentEvents = masterViewController.getDays()
            masterViewController.tableView.reloadData()
//            currentEvents = getDays()
//            tableView.reloadData()
        }else{
            masterViewController.reloadDays(filterCourses(), typeFilter: filterType())
//            reloadDays()
        }
    }
    
    


    
    
    func filterCourses() -> String {
        var courseString = ""
                for item in coursesStack.arrangedSubviews {
                    if let stack = item as? UIStackView{
                        for i in stack.arrangedSubviews {
                            if let button = i as? UIButton where button.alpha == 1.0 {
                                var tmpString = ""
                                if courseString == "" {
                                    tmpString = "course.name = " + "'" + (button.titleLabel?.text)! + "'"
                                }else{
                                    tmpString = " OR course.name = " + "'" + (button.titleLabel?.text)! + "'"
                                }
                                courseString.appendContentsOf(tmpString)
                            }
                        }
                    }
                }
        
        return courseString
    }
    
    func filterType() -> String{
        var typeString = ""
        
                for item in typeStack.arrangedSubviews {
                    if let stack = item as? UIStackView{
                        for i in stack.arrangedSubviews {
                            if let button = i as? UIButton where button.alpha == 1.0 {
                                var tmpString = ""
                                if typeString == "" {
                                    tmpString = "type = " + "'" + (button.titleLabel?.text)! + "'"
                                }else{
                                    tmpString = " OR type = " + "'" + (button.titleLabel?.text)! + "'"
                                }
                                typeString.appendContentsOf(tmpString)
                            }
                        }
                    }
                }
        
        return  typeString
    }
    
    
    func removeFromStacks (sender : UIButton){
                for  stack in typeStack.arrangedSubviews as! [UIStackView] {
                    for button in stack.arrangedSubviews as! [UIButton] {
                        if button.titleLabel?.text == sender.titleLabel?.text{
                            UIView.animateWithDuration(0.2, animations: { () -> Void in
                                button.alpha = 0.3
                                button.tag = 0
                            })
                            break
                        }
                    }
                }
        
                for stack in coursesStack.arrangedSubviews as! [UIStackView] {
                    for button in stack.arrangedSubviews as! [UIButton] {
                        if button.titleLabel?.text == sender.titleLabel?.text{
                            UIView.animateWithDuration(0.2, animations: { () -> Void in
                                button.alpha = 0.3
                                button.tag = 0
                            })
                            break
                        }
                    }
                }
    }
    
    func clearOutStackView(stack : UIStackView){
        for view in stack.arrangedSubviews {
            stack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    
    
    
    func validAddToStack(stack : UIStackView, let stackNumber : Int) -> Bool {
        
        
        var currentW : CGFloat = 0.0
        let viewWidth = view.frame.size.width - 150
        for view in stack.arrangedSubviews {
            currentW += view.frame.size.width + 8
        }
        
        if currentW > viewWidth {
            if stackNumber == 0 {
                currentCourseStackIndex += 1
            }else{
                currentTypeStackIndex += 1
            }
            return false
        }
        return true
    }
    
    func addButtonToStack(type : String,color : Int, stackView : UIStackView){
        let label = createButton(type, type: stackView.tag)
        label.backgroundColor = Course().colorForType(color)
        
        var currentStackIndex = 0
        if stackView.tag == 0 {
            currentStackIndex = currentCourseStackIndex
        }else{
            currentStackIndex = currentTypeStackIndex
        }
        
        if stackView.arrangedSubviews.count == 0 {
            let newStack = UIStackView(frame: CGRectMake(0, 0, 200, 10))
            newStack.axis = .Horizontal
            newStack.alignment = .Leading
            newStack.spacing = 8.0
            stackView.addArrangedSubview(newStack)
            newStack.addArrangedSubview(label)
        }else{
            let currentStack = stackView.arrangedSubviews[currentStackIndex] as! UIStackView
            currentStack.addArrangedSubview(label)
            if !validAddToStack(currentStack,stackNumber: stackView.tag) {
                currentStack.removeArrangedSubview(label)
                let newStack = UIStackView(frame: CGRectMake(0, 0, 200, 10))
                newStack.axis = .Horizontal
                newStack.alignment = .Fill
                newStack.distribution = .EqualSpacing
                newStack.spacing = 8.0
                stackView.addArrangedSubview(newStack)
                newStack.addArrangedSubview(label)
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    newStack.addArrangedSubview(label)
                })
            }
        }
        
    }
    
    func createButton(title : String, type: Int) -> UIButton{
        let height :CGFloat = 40.0
        let button = UIButton(frame: CGRectMake(0, 0, 100, height))
        button.setTitle(title, forState: UIControlState.Normal)
        button.titleLabel?.font = UIFont(name: "Avenir Book", size: 15)
        button.backgroundColor = PLBlue
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.layer.cornerRadius = button.frame.size.height/2
        button.layer.masksToBounds = true
        button.titleLabel?.textAlignment = NSTextAlignment.Center
        button.sizeToFit()
        button.heightAnchor.constraintEqualToConstant(height).active = true
        button.widthAnchor.constraintEqualToConstant(button.frame.size.width+30).active = true
        button.alpha = 0.3
        button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    func hideEmptyState() {
        emptyImage.alpha = 0.0
        emptyTitle.alpha = 0.0
        emptySubTitle.alpha = 0.0

        masterViewController.hideEmptyTable()
        calendarViewController.hideEmptyTable()
        //Sorting not shown
        let height :CGFloat = 128
        
        
        if currentlySorting {
            self.bottomConstraint.constant = height+coursesStack.frame.height+typeStack.frame.height
            
            UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                }, completion: nil)
        }

    }
    
    func reloadControllers() {
        
        setupSort()
        
        masterViewController.currentEvents = masterViewController.getDays()
        masterViewController.setup()
        calendarViewController.currentEvents = calendarViewController.getDays()
        calendarViewController.tableView.reloadData()
        
//        if masterViewController.currentEvents.count == 0 {
//            masterViewController.showEmptyTable()
//            calendarViewController.showEmptyTable()
//        }
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