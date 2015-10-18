//
//  DragItViewController.swift
//  DragIt
//
//  Created by iMac 27 on 2015-10-15.
//  Copyright © 2015 iMac 27. All rights reserved.
//

import UIKit

func degreesToRadians(degrees: Double) -> CGFloat {
    return CGFloat(degrees * M_PI / 180.0)
}
func radiansToDegrees(radians: Double) -> CGFloat {
    return CGFloat(radians / M_PI * 180.0)
}

class DragItViewController: UIViewController {

    @IBOutlet weak var dragAreaView: UIView!
    @IBOutlet weak var ringView: UIView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var dragHereLabel: UILabel!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var dragViewXLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var dragViewYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowCenterYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    
    var circleViewDict = [String:CircleView]()
    let videoTags = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
    let degrees: [Double] = [270, 310, 350, 30, 70, 110, 150, 190, 230]
    
    func pointOnCircleEdge(radius: CGFloat, angleInDegrees: Double) -> CGPoint {
        let center = CGPoint(x: CGRectGetMidX(view!.bounds), y: CGRectGetMidY(view!.bounds) )
        let x = center.x + (radius * cos(degreesToRadians(angleInDegrees)))
        let y = center.y + (radius * sin(degreesToRadians(angleInDegrees)))
        return CGPoint(x: x, y: y)
    }
    
    func addCircleView(index: Int) {
        let circleWidth = CGFloat(40)   //(25 + (arc4random() % 50))
        let circleHeight = circleWidth
        //start at bottom = 270 degrees
        let centerPoint = pointOnCircleEdge(ringView.bounds.width/2, angleInDegrees: degrees[index])
        // Create a new CircleView
        let circleView = CircleView(frame: CGRectMake(centerPoint.x - circleWidth/2, centerPoint.y - circleWidth/2, circleWidth, circleHeight))
        circleViewDict[videoTags[index]] = circleView
        view.addSubview(circleView)
        for (key,circle) in circleViewDict {
            if let videoTag = NSUserDefaults.standardUserDefaults().stringForKey(BouncerViewController.Constants.FavVideo) {
                // Animate the drawing of the circle over the course of x seconds
                if key == videoTag {
                    self.videoTag = videoTag  //needed for animateClear...in touchesBegan(
                    circle.animateCircle(2.0)
                }
            }
        }
    }

    var initialDragViewY: CGFloat = 30.0
    var isGoalReached: Bool {
        get { let distanceFromGoal: CGFloat = sqrt(pow(self.dragView.center.x - self.goalView.center.x, 2) +
                pow(self.dragView.center.y - self.goalView.center.y, 2))
            return distanceFromGoal < self.dragView.bounds.size.width / 2
        }
    }
    let dragAreaPadding = 5
    var lastBounds = CGRectZero
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lastBounds = self.view.bounds
        self.ringView.layer.borderColor = UIColor.greenColor().CGColor                  //new
        self.ringView.layer.cornerRadius = self.ringView.bounds.size.height / 2         //new
        self.ringView.layer.borderWidth = 4                                             //new
        self.dragView.layer.cornerRadius = 10    //self.dragView.bounds.size.height / 2
        self.goalView.layer.cornerRadius = self.goalView.bounds.size.height / 2
        self.goalView.layer.borderWidth = 4
        self.initialDragViewY = self.dragViewYLayoutConstraint.constant
        self.updateGoalView()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        for idx in 0..<9 {
            addCircleView(idx)
        }
        print(circleViewDict)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !CGRectEqualToRect(self.view.bounds, self.lastBounds) {
            self.boundsChanged()
            self.lastBounds = self.view.bounds
        }
    }
    func boundsChanged() {
        self.returnToStartLocationAnimated(false)
        self.dragAreaView.bringSubviewToFront(self.dragView)
        self.dragAreaView.bringSubviewToFront(self.goalView)
        self.view.layoutIfNeeded()
        self.arrowCenterYLayoutConstraint.constant = 0
    }
    // MARK: Actions
    @IBAction func panAction() {
        if self.panGesture.state == .Changed {
            self.moveObject()
        }
        else if self.panGesture.state == .Ended {
            if self.isGoalReached {
                self.returnToStartLocationAnimated(false)
                self.moveObject()
                performSegueWithIdentifier("Bouncer View", sender: nil)
            } else {
                self.returnToStartLocationAnimated(true)
            }
        }
    }
    var videoTag = "E"
    // checks for taps on circles
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // tapping a circle toggles its isAlive state...set dragView
        for touch in touches {
            if let _ = touch.view as? CircleView {
                let point = touch.locationInView(dragAreaView)
                for (key,circle) in circleViewDict {
                    if circle.frame.contains(point) {
                        if videoTag != key {
                            circleViewDict[videoTag]!.animateEraseCircle(2.0)
                            videoTag = key
                            NSUserDefaults.standardUserDefaults().setObject(videoTag, forKey: BouncerViewController.Constants.FavVideo)
                            //dragView.center = circle.center
                            circle.animateCircle(2.0)
                        }
                    }
                }
            }
        }
    }
    // MARK: UI Updates
    func moveObject() {
        let minX = CGFloat(self.dragAreaPadding)
        let maxX = self.dragAreaView.bounds.size.width - self.dragView.bounds.size.width - minX
        let minY = CGFloat(self.dragAreaPadding)
        let maxY = self.dragAreaView.bounds.size.height - self.dragView.bounds.size.height - minY
        var translation =  self.panGesture.translationInView(self.dragAreaView)
        var dragViewX = self.dragViewXLayoutConstraint.constant + translation.x
        var dragViewY = self.dragViewYLayoutConstraint.constant + translation.y
        if abs(dragViewX) > maxX {
            dragViewX = maxX
            translation.x += self.dragViewXLayoutConstraint.constant - maxX
        }
        else {
            translation.x = 0
        }
        if dragViewY < minY {
            dragViewY = minY
            translation.y += self.dragViewYLayoutConstraint.constant - minY
        }
        else if dragViewY > maxY {
            dragViewY = maxY
            translation.y += self.dragViewYLayoutConstraint.constant - maxY
        }
        else {
            translation.y = 0
        }
        self.dragViewXLayoutConstraint.constant = dragViewX
        self.dragViewYLayoutConstraint.constant = dragViewY
        self.panGesture.setTranslation(translation, inView: self.dragAreaView)
        UIView.animateWithDuration(0.05, delay: 0.0, options: .BeginFromCurrentState,
            animations: { () -> Void in
                self.view.layoutIfNeeded()
            },
            completion: nil)
        self.updateGoalView()
    }
    func updateGoalView() {
        let goalColor = self.isGoalReached ? UIColor.whiteColor() : UIColor(red: 174/255.0, green: 0, blue: 0, alpha: 1)
        self.goalView.layer.borderColor = goalColor.CGColor
        self.dragHereLabel.textColor = goalColor
        self.dragHereLabel.text = self.isGoalReached ? "Drop!" : "Drag here!"
    }
    func returnToStartLocationAnimated(animated: Bool) {
        self.dragViewXLayoutConstraint.constant = self.dragView.bounds.size.width
        self.dragViewYLayoutConstraint.constant = self.initialDragViewY
        if animated {
            UIView.animateWithDuration(0.3, delay: 0, options: .BeginFromCurrentState,
                animations: { () -> Void in
                    self.view.layoutIfNeeded()
                },
                completion: nil)
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
