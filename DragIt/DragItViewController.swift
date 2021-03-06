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

    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var dragAreaView: UIView!
    @IBOutlet weak var goalView: UIView!
    @IBOutlet weak var dragHereLabel: UILabel!
    @IBOutlet weak var dragView: UIView!
    @IBOutlet weak var dragViewXLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var dragViewYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowCenterYLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet weak var demoButton: UIButton!
    @IBOutlet weak var shopButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    var circleViewDict = [String:CircleView]()
    let videoTags = ["A", "B", "C", "D", "E", "F", "G", "H", "I"]
    let degrees: [Double] = [270, 310, 350, 30, 70, 110, 150, 190, 230]  //start at top clockwise
    var url: NSURL?
    var creditsURL: NSURL?
    var youTubeURL: NSURL?
    @IBAction func demo(sender: UIButton?) {
        if url != nil {
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    func demo3(sender: UIButton?) {
        if creditsURL != nil {
            UIApplication.sharedApplication().openURL(creditsURL!)
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case BouncerViewController.Constants.ShopSegue:
                if let svc = segue.destinationViewController as? ShopViewController {
                    svc.backDrops = backDrops
                    svc.backDropImages = backDropImages
                    svc.ballSkins = ballSkins
                    svc.ballImages = ballImages
                    svc.doneLoad = doneLoad
                }
            case BouncerViewController.Constants.VideoSegue:
                _ = segue.destinationViewController as! BouncerViewController
            default:
                break
            }
        }
    }
    @IBAction func shop(sender: UIButton) {
        spinner?.startAnimating()
        performSegueWithIdentifier(BouncerViewController.Constants.ShopSegue, sender: nil)
    }
    @IBAction func unwindFromModalViewController(segue: UIStoryboardSegue) {
        //drag from back button to viewController exit button
        spinner?.stopAnimating()
    }
    @IBAction func unwindFromModalCREDITSViewController(segue: UIStoryboardSegue) {
        //drag from back button to viewController exit button
        demo3(nil)
    }
    func rotateView(view: UIView, degrees: CGFloat) {
        let delay = 2.0 * Double(NSEC_PER_SEC)
        if degrees <= 180 {
            let deg1 = degrees
            UIView.animateWithDuration(2.0, animations: {
                view.transform = CGAffineTransformMakeRotation((deg1 * CGFloat(M_PI)) / 180.0)
            })
        } else {
            let deg2 = 360.0 - degrees
            UIView.animateWithDuration(2.0, animations: {
                view.transform = CGAffineTransformMakeRotation((180.0 * CGFloat(M_PI)) / 180.0)
            })
            UIView.animateWithDuration(2.0, animations: {
                view.transform = CGAffineTransformMakeRotation((deg2 * CGFloat(M_PI)) / 180.0)
            })
        }
        Settings().availableCredits += 1
        let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) { [weak self] (success) -> Void in
            self!.performSegueWithIdentifier(BouncerViewController.Constants.VideoSegue, sender: nil)
        }
    }
    func pointOnCircleEdge(radius: CGFloat, angleInDegrees: Double) -> CGPoint {
        let center = CGPoint(x: CGRectGetMidX(view!.bounds), y: CGRectGetMidY(view!.bounds) )
        let x = center.x + (radius * cos(degreesToRadians(angleInDegrees)))
        let y = center.y + (radius * sin(degreesToRadians(angleInDegrees)))
        return CGPoint(x: x, y: y)
    }
    func addCircleView(index: Int) {
        let circleWidth = CGFloat(40)   //(25 + (arc4random() % 50))
        let circleHeight = circleWidth
        //start at top clockwise = 270 degrees
        let centerPoint = pointOnCircleEdge(ringView!.bounds.width/2, angleInDegrees: degrees[index])
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
    var ringView: UIView?
    var backDropImages: [UIImage]?
    var ballImages: [UIImage]?
    var doneLoad = false
    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        url = NSURL(string: BouncerViewController.Constants.DragItDemoURL)
        creditsURL = NSURL(string: BouncerViewController.Constants.Demo3URL)
        lastBounds = self.view.bounds
        let diameter = min(view.frame.maxX, view.frame.maxY) - 50.0
        ringView = UIView(frame: CGRect(origin: goalView.center, size: CGSize(width: diameter, height: diameter)))
        ringView!.layer.borderColor = UIColor.greenColor().CGColor       //change to green to see
        ringView!.layer.cornerRadius = ringView!.bounds.size.width / 2   //new
        ringView!.layer.borderWidth = 4                                  //new
        dragView.layer.cornerRadius = 10
        goalView.layer.cornerRadius = self.goalView.bounds.size.width / 2
        goalView.layer.borderWidth = 4
        initialDragViewY = self.dragViewYLayoutConstraint.constant
        updateGoalView()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        earnCoin()  //show available credits
        if Settings().mybackDrops.count > 1 {
            for i in 0..<backDrops.count {
                if backDrops[i] == Settings().mybackDrops.last {
                    backDropImageView.image = UIImage(named: self.backDrops[i])
                }
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addBalls()
        if ballImages == nil {
            let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
            dispatch_async(backgroundQueue, { [weak self] in
                print("This is run on the background queue")
                self!.ballImages = (0..<self!.ballSkins.count).map {
                    UIImage(named: self!.ballSkins[$0])!
                }
                self!.backDropImages = (0..<self!.backDrops.count).map {
                    UIImage(named: self!.backDrops[$0])!
                }
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    print("This is run on the main queue, after backgroundQueue code in outer closure...doneLoad = true")
                    self!.doneLoad = true
                    })
                })
        }
        autoStart()
    }
    private var auto: Bool { // a computed property instead of func
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey(BouncerViewController.Constants.AutoStart)
        }
    }
    func autoStart() {
        if auto {  //if enabled, will pick random video (otherwise previous played selection)
            //Note: if back button pressed while watching a repeat enabled video, repeat will shut off...via unwind below
            performSegueWithIdentifier(BouncerViewController.Constants.VideoSegue, sender: nil)
        }
    }
    func addBalls() {
        for idx in 0..<9 {
            addCircleView(idx)
        }
        //print(circleViewDict)
    }
    func removeBalls() {
        for circle in circleViewDict.values {
            circle.removeFromSuperview()
        }
        for letter in videoTags {
            circleViewDict[letter] = nil
        }
        //print(circleViewDict)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        removeBalls()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !CGRectEqualToRect(self.view.bounds, self.lastBounds) {
            boundsChanged()
            lastBounds = self.view.bounds
        }
    }
    func boundsChanged() {
        returnToStartLocationAnimated(false)
        dragAreaView.bringSubviewToFront(dragView)
        dragAreaView.bringSubviewToFront(goalView)
        removeBalls()
        addBalls()
        view.layoutIfNeeded()
        arrowCenterYLayoutConstraint.constant = 0
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
                rotateView(goalView, degrees: 360.0)  //performSegue
            } else {
                self.returnToStartLocationAnimated(true)
            }
        }
    }
    var videoTag = "Z"
    // checks for taps on circles
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // tapping a circle toggles its state...set dragView
        for touch in touches {
            if let _ = touch.view as? CircleView {
                //print("touch green")
                let point = touch.locationInView(view)
                for (key,circle) in circleViewDict {
                    if circle.frame.contains(point) {
                        if videoTag != key {
                            if videoTag != "Z" {
                                circleViewDict[videoTag]!.animateEraseCircle(2.0)
                                //erase old selection title
                                let idx = videoTags.indexOf(videoTag)
                                let title = videoNames[idx!]
                                for v in view.subviews {
                                    if let old = v as? UIButton {
                                        if old.titleLabel?.text == title {
                                            old.removeFromSuperview()
                                        }
                                    }
                                }
                            }
                            videoTag = key
                            NSUserDefaults.standardUserDefaults().setObject(videoTag, forKey: BouncerViewController.Constants.FavVideo)
                            circle.animateCircle(2.0)
                            //add title
                            let idx = videoTags.indexOf(key)
                            let title = videoNames[idx!]
                            let button = UIButton(frame: CGRect(origin: circle.center, size: CGSize(width: title.characters.count * 10, height: 30)))
                            button.tag = idx!
                            button.setTitle(title, forState: .Normal)
                            if Settings().mybackDrops.last == "Black_hole2048.jpg" {
                                button.setTitleColor(UIColor.crayons_aquaColor(), forState: .Normal)
                            } else {
                                button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                            }
                            button.titleLabel?.font = UIFont.systemFontOfSize(15, weight: UIFontWeightBold)
                            button.addTarget(self, action: "gotoYouTube:", forControlEvents: .TouchUpInside)
                            view.addSubview(button)
                        }
                    }
                }
            }
        }
    }
    func gotoYouTube(sender: UIButton?) {
        if let idx = sender?.tag {
            if let url = NSURL(string: externalURLs[idx]) {
                UIApplication.sharedApplication().openURL(url)
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
        let goalColor = self.isGoalReached ? UIColor.whiteColor() : UIColor.redColor()     //(red: 174/255.0, green: 0, blue: 0, alpha: 1)
        self.goalView.layer.borderColor = goalColor.CGColor
        self.dragHereLabel.textColor = goalColor
        self.dragHereLabel.text = self.isGoalReached ? "Drop!" : "Drag here!"
        let arrowImage = self.isGoalReached ? nil : UIImage(named: "arrow_down.png")
        self.arrowImageView.image = arrowImage
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
    let backDrops = ["aurora-6-iss-150318.jpg",
        "Black_hole2048.jpg",
        "bluePlanet.jpg",
        "Clouds_outer_space_planets_earth.jpg",
        "digital_art_1024x1024.jpg",
        "glory.jpg",
        "heavensDeclare.jpg",
        "IMG_3562.jpg",
        "Outer_space_planets_earth_men_fantasy.jpg",
        "space_3d_art_planet_earth_apocalyptic.jpg",
        "sunrise_glory-wide.jpg"]
    let ballSkins = ["arrow40",
        "asian40",
        "balloonRing40",
        "bluePlanet40",
        "burning40",
        "cufi40",
        "edd40",
        "globe40",
        "vectorA40",
        "vectorB40"]
    let videoNames = ["You're Beautiful",
        "  CYMATICS",
        "Cornerstone",
        "Greater than All",
        "Get to Mars",
        " Matthew 24",
        "This Is Amazing Grace",
        "Hillsong Oceans",
        "My Chains are Gone"]
    let externalURLs = ["https://www.youtube.com/user/PhilWickhamVEVO",
        "https://www.youtube.com/watch?v=WJ29WAglfWA",
        "https://www.youtube.com/user/hillsonglive",
        "https://www.youtube.com/watch?v=MBdkb8qk-As",
        "https://www.youtube.com/watch?v=0xwzItqYmII&index=4&list=RDm1Be0qJw9ZE",
        "https://www.youtube.com/watch?v=qOkImV2cJDg&list=RDm1Be0qJw9ZE&index=29",
        "https://www.youtube.com/user/philwickham",
        "https://www.youtube.com/watch?v=Ah0uydqMYhE",
        "https://www.youtube.com/watch?v=qOkImV2cJDg&list=RDm1Be0qJw9ZE&index=29"]
    // MARK: - get coins!
    lazy var coins: UIImageView = {
        let size = CGSize(width: 42.0, height: 20.0)
        let coins = UIImageView(frame: CGRect(origin: CGPoint(x: -1 , y: -1), size: size))
        self.view.addSubview(coins)
        return coins
    }()
    private var coinCount = 0
    lazy var coinCountLabel: UILabel = { let coinCountLabel = UILabel(frame: CGRect(origin: CGPoint(x: -1 , y: -1), size: CGSize(width: 80.0, height: 20.0)))
        coinCountLabel.font = UIFont(name: "ComicSansMS-Bold", size: 18.0)
        coinCountLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(coinCountLabel)
        return coinCountLabel
    }()
    lazy var largeCoin: UIImageView = {
        let size = CGSize(width: 100.0, height: 100.0)
        let coin = UIImageView(frame: CGRect(origin: CGPoint(x: -1 , y: -1), size: size))
        self.view.addSubview(coin)
        return coin
    }()
    func resetCoins() {
        let midx = view.bounds.midX
        coins.center = CGPoint(x: (midx - 60.0), y: (view.bounds.minY + 12.0))
        coinCountLabel.center = CGPoint(x: (midx + 60.0), y: (view.bounds.minY + 10.0))
        largeCoin.center = CGPoint(x: midx, y: view.bounds.midY)
    }
    func earnCoin() {  //show available credits
        self.coinCount += Settings().availableCredits  //move first because of annimation delay
        //prepare for annimation
        largeCoin.image = UIImage(named: "1000CreditsSWars1.png")
        resetCoins()
        largeCoin.alpha = 1
        largeCoin.center.y = view.bounds.minY //move off screen but alpha = 1
        UIView.animateWithDuration(3.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
            self.largeCoin.alpha = 0
            }, completion: nil)
        //prepare for annimation
        coinCountLabel.alpha = 0
        coinCountLabel.center.y = view.bounds.maxY //move off screen
        if let image = UIImage(named: "1000Credits2-20.png") {
            coins.image = image
            coins.alpha = 0
            coins.center.y = view.bounds.maxY //move off screen
            UIView.animateWithDuration(4.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                self.coinCountLabel.text = "\(Settings().availableCredits)"
                self.resetCoins()
                self.coins.alpha = 1
                self.coinCountLabel.alpha = 1
                }, completion: nil)
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
