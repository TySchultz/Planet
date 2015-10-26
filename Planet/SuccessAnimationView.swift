//
//  SuccessAnimationView.swift
//  Planet
//
//  Created by Ty Schultz on 10/25/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit

class SuccessAnimationView: UIView {

    let BACKGROUNDCOLOR = PLDARKBLUE
    let ANIMATIONTIME = 0.2
    let ALPHA :CGFloat = 0.9
    
    
    var box : UIView?
    var label : UILabel?

    var leftBorderLine : UIView?
    var rightBorderLine : UIView?
    var topBorderLine : UIView?
    var bottomBorderLine : UIView?
    
    let drawn = false
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.initialize()
    }
    
    convenience init() {
        self.init(frame: CGRectZero)
        
        self.initialize()
    }
    
    func closeView(){
        self.removeFromSuperview()
    }
    
    func initialize() {
        NSLog("common init")
        
       let tapRecognizer = UITapGestureRecognizer(target: self, action: "closeView")
        addGestureRecognizer(tapRecognizer)
        
        backgroundColor = UIColor.clearColor()
        
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: self.frame.size.height))
        backgroundView.backgroundColor = BACKGROUNDCOLOR
        backgroundView.alpha = ALPHA
        
        addSubview(backgroundView)
        
        createBox()
        createLines()
        createLabel()
        animateLines()

        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
            backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

            }) { (Bool) -> Void in
                
        }

//        UIView.animateWithDuration(ANIMATIONTIME) { () -> Void in
//            backgroundView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
//        }
    }
    
    func createBox() {
        let width = self.frame.size.width-128
        let height :CGFloat = 100
        box = UIView(frame: CGRect(x: 64, y: self.frame.midY-50, width: width, height: height))
        box?.backgroundColor = UIColor.clearColor()
        addSubview(box!)
    }
    
    func createLabel() {
        let width = self.frame.size.width-128
        let height :CGFloat = 100

        label = UILabel(frame: CGRect(x: 64, y: self.frame.midY-50, width: width, height: height))
        label?.text = "SUCCESS"
        label?.font = UIFont(name: "Avenir Medium", size: 40.0)
        label?.textColor = UIColor.whiteColor()
        label?.textAlignment = NSTextAlignment.Center
        label?.alpha = 0.0
        addSubview(label!)
    }
    
    func createLines () {
        let LINECOLOR = PLLIGHTBLUE
        let STARTSIZE : CGFloat = 1.0
        let RIGHTX : CGFloat = box!.frame.size.width
        let BOTTOMY : CGFloat = box!.frame.size.height
        
        
        leftBorderLine = UIView(frame: CGRect(x: 0, y: BOTTOMY, width: STARTSIZE, height: STARTSIZE))
        leftBorderLine?.backgroundColor = LINECOLOR
        box!.addSubview(leftBorderLine!)
        
        rightBorderLine = UIView(frame: CGRect(x: RIGHTX, y: 0, width: STARTSIZE, height: STARTSIZE))
        rightBorderLine?.backgroundColor = LINECOLOR
        box!.addSubview(rightBorderLine!)
        
        topBorderLine = UIView(frame: CGRect(x: 0, y: 0, width: STARTSIZE, height: STARTSIZE))
        topBorderLine?.backgroundColor = LINECOLOR
        box!.addSubview(topBorderLine!)
        
        bottomBorderLine = UIView(frame: CGRect(x: RIGHTX, y: BOTTOMY, width: STARTSIZE, height: STARTSIZE))
        bottomBorderLine?.backgroundColor = LINECOLOR
        box!.addSubview(bottomBorderLine!)
        
    }
    
    
    func animateLines() {
        let LINEWIDTH :CGFloat = 1.0
        let HEIGHT :CGFloat = 100
        let WIDTH :CGFloat = box!.frame.size.width
        let RIGHTX : CGFloat = box!.frame.size.width
        let BOTTOMY : CGFloat = box!.frame.size.height
        
        
        UIView.animateWithDuration(0.05, animations: { () -> Void in
            self.label?.alpha = 1.0
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.05, animations: { () -> Void in
                    self.label?.alpha = 0.0
                    }) { (Bool) -> Void in
                        UIView.animateWithDuration(0.05, animations: { () -> Void in
                            self.label?.alpha = 1.0
                            }) { (Bool) -> Void in
                                UIView.animateWithDuration(0.05, animations: { () -> Void in
                                    self.label?.alpha = 0.0
                                    }) { (Bool) -> Void in
                                        UIView.animateWithDuration(0.05, animations: { () -> Void in
                                            self.label?.alpha = 1.0
                                            }) { (Bool) -> Void in
                                                UIView.animateWithDuration(0.1, animations: { () -> Void in
                                                    self.label?.alpha = 0.0
                                                    }) { (Bool) -> Void in
                                                        UIView.animateWithDuration(0.1, animations: { () -> Void in
                                                            self.label?.alpha = 1.0
                                                            }) { (Bool) -> Void in
                                                                
                                                        }
                                                }
                                        }
                                }
                        }
                }
        }
        
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.leftBorderLine!.frame = CGRectMake(0, 0, LINEWIDTH, HEIGHT)
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.1, animations: { () -> Void in
                    self.topBorderLine?.frame = CGRectMake(0, 0, WIDTH, LINEWIDTH)
                    }) { (Bool) -> Void in
                        UIView.animateWithDuration(0.1, animations: { () -> Void in
                            self.rightBorderLine!.frame = CGRectMake(RIGHTX, 0, LINEWIDTH, HEIGHT)
                            }) { (Bool) -> Void in
                                UIView.animateWithDuration(0.1, animations: { () -> Void in
                                    self.bottomBorderLine?.frame = CGRectMake(0, BOTTOMY, WIDTH, LINEWIDTH)
                                    }) { (Bool) -> Void in
                                        self.animateBars()
                                }
                        }
                }
        }
    }
    
    func animateBars(){
        let BARCOLOR = PLLIGHTBLUE
        let HEIGHT :CGFloat = 100
        let WIDTH :CGFloat = box!.frame.size.width
        let RIGHTX : CGFloat = box!.frame.size.width
        let BOTTOMY : CGFloat = box!.frame.size.height
        
        
        let secondBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: HEIGHT))
        secondBar.backgroundColor = BARCOLOR
        secondBar.alpha = 0.8
        box!.addSubview(secondBar)
        box!.sendSubviewToBack(secondBar)
        
        let firstBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: HEIGHT))
        firstBar.backgroundColor = BARCOLOR
        firstBar.alpha = 0.4
        box!.addSubview(firstBar)
        box!.sendSubviewToBack(firstBar)
        
        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            firstBar.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                    secondBar.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
                    }) { (Bool) -> Void in
                        
                        self.leftBorderLine?.alpha  = 0.0
                        //Shrink
                        UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                            secondBar.frame = CGRect(x: RIGHTX, y: 0, width: 0, height: HEIGHT)
                            self.topBorderLine?.frame = CGRect(x: RIGHTX, y: 0, width: 0, height: 0)
                            }) { (Bool) -> Void in

                        }
                        
                        UIView.animateWithDuration(0.3, delay: 0.15, options: .CurveEaseInOut, animations: { () -> Void in
                            self.bottomBorderLine?.frame = CGRect(x: RIGHTX, y: BOTTOMY, width: 0, height: 0)
                            self.rightBorderLine?.frame = CGRect(x: RIGHTX, y: BOTTOMY, width: 0, height: 0)

                            }) { (Bool) -> Void in
                                UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
                                    self.alpha = 0.0
                                    
                                    }) { (Bool) -> Void in
                                        
                                        self.closeView()
                                        
    
                                }
                        }
                        
                        UIView.animateWithDuration(0.3, delay: 0.1, options: .CurveEaseInOut, animations: { () -> Void in
                            firstBar.frame = CGRect(x: RIGHTX, y: 0, width: 0, height: HEIGHT)
                            self.label?.alpha = 0.0

                            }) { (Bool) -> Void in
                              
                                
                                
                        }
                }
        }
        
        
//        UIView.animateWithDuration(0.3, delay: 0.3, options: .CurveEaseInOut, animations: { () -> Void in
//            secondBar.frame = CGRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)
//            }) { (Bool) -> Void in
//                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
//                    secondBar.frame = CGRect(x: RIGHTX, y: 0, width: 0, height: HEIGHT)
//                    }) { (Bool) -> Void in
//                        self.closeView()
//                }
//        }
        
    }
//    -(void)drawFirstPage{
//    
//    if(!_drawn){
//    _drawn = YES;
//    
//    [UIView animateWithDuration:.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//    [_leftBorderBar     setFrame:CGRectMake(0, 0, 1, self.frame.size.height)];
//    [_rightBorderBar    setFrame:CGRectMake(self.frame.size.width, 0, 1, self.frame.size.height)];
//    [_topBorderBar      setFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
//    [_bottomBorderBar   setFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 1)];
//    
//    }completion:^(BOOL finished){
//    [_leftVoteBar setAlpha:1.0];
//    
//    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//    [_leftVoteBar   setFrame:CGRectMake(5, 5, (self.frame.size.width/2)-5, self.frame.size.height-10)];
//    }completion:^(BOOL finished){
//    [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//    [_tapRight setAlpha:1.0];
//    }completion:^(BOOL finished){
//    }];
//    }];
//    }];
//    }
//    }
//    
//    -(void)setInitails{
//    
//    [_leftBorderBar     setFrame:CGRectMake(0, self.frame.size.height, 1, 1)];
//    [_rightBorderBar    setFrame:CGRectMake(self.frame.size.width, 0, 1, 1)];
//    [_topBorderBar      setFrame:CGRectMake(0, 0, 1, 1)];
//    [_bottomBorderBar   setFrame:CGRectMake(self.frame.size.width, self.frame.size.height, 1, 1)];
//    [_rightVoteBar      setFrame:CGRectMake(self.frame.size.width/2, 5, (self.frame.size.width/2)-5, self.frame.size.height-10)];
//    [_leftVoteBar       setFrame:CGRectMake(5, self.frame.size.height-5, (self.frame.size.width/2)-5, 1)];
//    [_leftVoteBar       setAlpha:0.0];
//    [_rightVoteBar      setAlpha:0.0];
//    
//    [_tapLeft           setAlpha:0.0];
//    [_tapRight          setAlpha:0.0];
//    
//    _drawn = NO;
//    
//    }

}
