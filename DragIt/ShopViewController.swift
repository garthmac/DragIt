//
//  ShopViewController.swift
//  DragIt
//
//  Created by iMac21.5 on 10/20/15.
//  Copyright (c) 2015 Garth MacKenzie. All rights reserved.
//

import UIKit
import AVFoundation

class ShopViewController: UIViewController, AVAudioPlayerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var backdropImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightTrophyImageView: UIImageView!
    @IBOutlet weak var userPickerView: UIPickerView!
    @IBOutlet weak var helpPickerView: UIPickerView!
    @IBOutlet weak var creditsPickerView: UIPickerView!
    @IBOutlet weak var buyCreditsButton: UIButton!
    @IBOutlet weak var newsLine: UIButton!
    
    @IBAction func showHelpAction(sender: UIButton) {
        if helpPickerView.hidden {
            creditsPickerView.hidden = true
            newsLine.hidden = true
            buyCreditsButton.hidden = true
            helpPickerView.hidden = false
        } else {
            showBuyCreditsAction(sender)
        }
    }
    @IBAction func showBuyCreditsAction(sender: UIButton) {
        if creditsPickerView.hidden {
            helpPickerView.hidden = true
            creditsPickerView.hidden = false
            newsLine.hidden = false
            buyCreditsButton.hidden = false
            creditsPickerView.selectRow(0, inComponent: 0, animated: true)
            pickerView(creditsPickerView, didSelectRow: 0, inComponent: 0)
        }
    }
    //MARK: - UIPickerViewDataSource
    let model = UIDevice.currentDevice().model
    var pickerDataSourceHelp: [UIButton] { // a computed property instead of func
        get {
            return (0..<self.hints.count).map {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.backdropImageView.bounds.width, height: 40))
                button.titleLabel!.font = UIFont(name: "ComicSansMS-Bold", size: 15)
                button.titleLabel!.lineBreakMode = .ByWordWrapping
                button.setTitle("(\($0 + 1)).   " + self.hints[$0], forState: .Normal)
                button.setTitleColor(UIColor.purpleColor(), forState: .Normal)
                return button
            }
        }
        set { self.pickerDataSourceHelp = newValue }
    }
    var pickerDataSourceCredits: [UIButton] { // a computed property instead of func
        get {
            return (0..<self.creditOptions.count).map {
                let button = UIButton(frame: CGRect(x: 0, y: 0, width: self.backdropImageView.bounds.width, height: 40))
                button.setTitle(self.creditOptions[$0], forState: .Normal)
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                return button
            }
        }
        set { self.pickerDataSourceCredits = newValue }
    }
    var ballImages: [UIImage]?
    private var pickerDataSource: [UIImage] { // a computed property instead of func
        get { return ballImages! }
        set { self.pickerDataSource = newValue }
    }
    private var pickerDataSource1: [UIImage] { // a computed property instead of func
        get {
            return (0..<Settings().mySkins.count).map {
                UIImage(named: Settings().mySkins[$0])!
            }
        }
        set { self.pickerDataSource1 = newValue }
    }
    private var pickerDataSource2: [UIImage] { // a computed property instead of func
        get {
            return (0..<self.audios.count).map {
                UIImage(named: self.audios[$0])!
            }
        }
        set { self.pickerDataSource2 = newValue }
    }
//    private var pickerDataSource3: [UIImage] { // a computed property instead of func
//        get {
//            return (0..<self.paddles.count).map {
//                UIImage(named: self.paddles[$0])!
//            }
//        }
//        set { self.pickerDataSource3 = newValue }
//    }
//    private var pickerDataSource4: [UIImage] { // a computed property instead of func
//        get {
//            if model.hasPrefix("iPad") {
//                return (0..<self.iPadPaddleWidths.count).map {
//                    UIImage(named: self.iPadPaddleWidths[$0])!
//                }
//            }
//            return (0..<self.paddleWidths.count).map {
//                UIImage(named: self.paddleWidths[$0])!
//            }
//        }
//        set { self.pickerDataSource4 = newValue }
//    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 { return 1 }
        if pickerView.tag == 2 { return 1 }
        return 5 } //number of wheels in the picker
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 { return pickerDataSourceHelp.count }
        if pickerView.tag == 2 { return pickerDataSourceCredits.count }
        if component == 0 {
            if doneLoad {
                return pickerDataSource.count
            } else { return 0 }
        }
        if component == 1 {
            return pickerDataSource1.count
        }
        if component == 2 {
            return pickerDataSource2.count
        }
//        if component == 3 {
//            return pickerDataSource3.count
//        }
        return pickerDataSource.count
    }
    //MARK: - UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        if pickerView.tag > 0 {
            return 45.0
        }
        return 70.0
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView.tag == 1 { return backdropImageView.bounds.width }
        if pickerView.tag == 2 { return backdropImageView.bounds.width }
        return backdropImageView.bounds.width / 5.25
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView { //expensive
        if pickerView.tag == 1 { return pickerDataSourceHelp[row] }
        if pickerView.tag == 2 { return pickerDataSourceCredits[row] }
        var iv: UIImageView
        if component == 0 {
            iv = UIImageView(image: pickerDataSource[row])
            iv.bounds = CGRect(x: 0, y: 0, width: 65, height: 65)
            return iv
        }
        if component == 1 {
            iv = UIImageView(image: pickerDataSource1[row])
            iv.bounds = CGRect(x: 0, y: 0, width: 65, height: 65)
            return iv
        }
        if component == 2 {
            iv = UIImageView(image: pickerDataSource2[row])
            iv.bounds = CGRect(x: 0, y: 0, width: 65, height: 65)
            return iv
        }
//        if component == 3 {
//            iv = UIImageView(image: pickerDataSource3[row])
//            iv.bounds = CGRect(x: 0, y: 0, width: 65, height: 30)
//            return iv
//        }
//        if component == 4 {
//            iv = UIImageView(image: pickerDataSource4[row])
//            iv.bounds = CGRect(x: 0, y: 0, width: 65, height: 65)
//            return iv
//        }
        return UIView()
    }
    var selectedHintIndex = Settings().lastHint
    var selectedCreditIndex = 0
    var selectedBallSkin: UIImage?
    var selectedLogin: String?
    var selectedBallSkin1: UIImage?
    var selectedLogin1: String?
    var selectedAudio2: UIImage?
    var selectedLogin2: String?
    var selectedPaddle3: UIImage?
    var selectedLogin3: String?
    var selectedPaddleWidth4: UIImage?
    var selectedLogin4: String?
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            selectedHintIndex = row
            return Settings().lastHint = selectedHintIndex
        }
        if pickerView.tag == 2 {
            return selectedCreditIndex = row
        }
        if component == 0 {
            selectedBallSkin = pickerDataSource[row]
            return selectedLogin = ballSkins[row]
        }
        if component == 1 {
            selectedBallSkin1 = pickerDataSource1[row]
            return selectedLogin1 = Settings().mySkins[row]
        }
        if component == 2 {
            selectedAudio2 = pickerDataSource2[row]
            return selectedLogin2 = audios[row]
        }
//        if component == 3 {
//            selectedPaddle3 = pickerDataSource3[row]
//            return selectedLogin3 = paddles[row]
//        }
//        if component == 4 {
//            selectedPaddleWidth4 = pickerDataSource4[row]
//            if model.hasPrefix("iPad") {
//                selectedLogin4 = iPadPaddleWidths[row]
//            } else {
//                selectedLogin4 = paddleWidths[row]
//            }
//        }
    }
//    var tbvcArray: [UIViewController]?
//    func prepareTabBar() {
//        tbvcArray = tabBarController!.viewControllers
//        let cvc = tbvcArray![4]    //CREDITS
//        for view in cvc.view.subviews {
//            if let animatedImageView = view as? UIImageView {
//                if animatedImageView.tag == 111 {
//                    let images = (0...8).map {
//                        UIImage(named: "peanuts-anim\($0).png")!
//                    }
//                    animatedImageView.animationImages = images
//                    animatedImageView.animationDuration = 7.0
//                    animatedImageView.startAnimating()
//                }
//                if animatedImageView.tag == 333 {
//                    let images = (0...6).map {
//                        UIImage(named: "typing-computer\($0).png")!
//                    }
//                    animatedImageView.animationImages = images
//                    animatedImageView.animationDuration = 1.0
//                    animatedImageView.startAnimating()
//                }
//            }
//        }
//    }
    private var availableCredits: Int { // a computed property instead of func
        get { return Settings().availableCredits }
        set {
            Settings().availableCredits = newValue
            updateShopTab()
        }
    }
    let helper = IAPHelper()
    var url: NSURL?
    @IBAction func home(sender: UIButton) {
        //print(url)
        if url != nil {
            UIApplication.sharedApplication().openURL(url!)
        }
    }
    var doneLoad = false
    //MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        url = NSURL(string: "https://redblockblog.wordpress.com/marketing/")!
        if #available(iOS 8.0, *) {  //let qualityOfServiceClass = QOS_CLASS_USER...
            let qualityOfServiceClass = QOS_CLASS_USER_INITIATED
            let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
            dispatch_async(backgroundQueue, { [weak self] in
                print("This is run on the background queue")
                self!.ballImages = (0..<self!.ballSkins.count).map {
                    UIImage(named: self!.ballSkins[$0])!
                }
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    print("This is run on the main queue, after backgroundQueue code in outer closure")
                    self!.doneLoad = true
                    self!.userPickerView.reloadComponent(0)
                    self!.userPickerView.selectRow(2, inComponent: 0, animated: true)
                    self!.pickerView(self!.userPickerView, didSelectRow: 2, inComponent: 0)
                })
            })
        } else {
            // Fallback for versions less than 8 for iOS 4.3 thru 7
            UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: [], animations: {
                self.ballImages = (0..<self.ballSkins.count).map {
                    UIImage(named: self.ballSkins[$0])! }
                }, completion: { [weak self] (success) -> Void in
                    self!.doneLoad = true
                    self!.userPickerView.reloadComponent(0)
                    self!.userPickerView.selectRow(2, inComponent: 0, animated: true)
                    self!.pickerView(self!.userPickerView, didSelectRow: 2, inComponent: 0)
            })
        }
        userPickerView.delegate = self
        userPickerView.dataSource = self
        helpPickerView.delegate = self
        helpPickerView.dataSource = self
        creditsPickerView.delegate = self
        creditsPickerView.dataSource = self
        //prepareTabBar()
        for aView in view.subviews {
            if let button = aView as? UIButton {
                if (0...7).contains(button.tag) {
                    button.layer.cornerRadius = 15.0
                    button.layer.borderWidth = 1.0
                    button.layer.borderColor = UIColor.blueColor().CGColor
                    button.superview!.bringSubviewToFront(button)
                }
            }
        }
    }
    func updateMySkins(withSkin: String) {
        if Settings().mySkins.count > 1 {
            if let index = ballSkins.indexOf(withSkin) {
                self.selectedLogin1 = ballSkins[index]
                if let index1 = Settings().mySkins.indexOf((self.selectedLogin1!)) {
                    userPickerView.selectRow(index1, inComponent: 1, animated: true)
                    pickerView(userPickerView, didSelectRow: index1, inComponent: 1)
                }
            }
        } else {
            userPickerView.selectRow(0, inComponent: 1, animated: true)
            pickerView(userPickerView, didSelectRow: 0, inComponent: 1)
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        helpPickerView.selectRow(Settings().lastHint, inComponent: 0, animated: true)
        updateMySkins(Settings().purchasedUid!)
        userPickerView.selectRow(Settings().soundChoice, inComponent: 2, animated: true)
        pickerView(userPickerView, didSelectRow: Settings().soundChoice, inComponent: 2)
        showBuyCreditsAction(UIButton()) 
//        if let index = paddles.indexOf((Settings().myPaddles.last!)) {
//            userPickerView.selectRow(index, inComponent: 3, animated: true)
//        }
//        userPickerView.selectRow(Settings().paddleWidthMultiplier, inComponent: 4, animated: true)
    }
    func updateShopTab() {
//        self.tabBarController?.tabBar.hidden = false
//        let shopTabBarItem = tabBarController!.tabBar.items![0]
//        shopTabBarItem.badgeValue = "\(availableCredits)"   //everything costs 10 credits or $1
    }
    func warnIfCreditsLow() {
        if availableCredits < 10 {
            alert("You have \(availableCredits) Credits!", message: "Play to earn at least 10 Credits or \n\n ...Buy Credits")        }
    }
    private func removePartialCurlTap() {
        if let gestures = self.view.gestureRecognizers {
            for gesture in gestures {
                if gesture.isKindOfClass(UITapGestureRecognizer) {
                    self.view.removeGestureRecognizer(gesture)
                }
            }
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        removePartialCurlTap()
        if helper.list.isEmpty && !helper.hasFailed {
            warnIfCreditsLow()
        }
        helper.setIAPs()
        updateShopTab()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.audioPlayer?.pause()
    }
    //MARK: - Action buySelection
    @IBAction func buySelection(sender: UIButton) {
        switch sender.tag {
        case 0: //println(sender.tag)
            checkout("Deduct 10 coins for selected Ball skin?", sender: sender)
        case 1: //println(sender.tag)
            //let paddleBallTabBarItem = tabBarController!.tabBar.items![1]
            if let login = self.selectedLogin1 { //can only happen if the wheel is spun
                let loggedInUser = User.login(login, password: "foo") //SWAP ball out to other owned ball
                print(loggedInUser)
                //paddleBallTabBarItem.badgeValue = login
            } else {
                //paddleBallTabBarItem.badgeValue = "tennis"
            }
//            self.tabBarController!.selectedIndex = 0
        case 2: //println(sender.tag)
            checkout("Deduct 10 coins for selected Audio?", sender: sender)
//        case 3: //println(sender.tag)
//            checkout("Deduct 10 coins for selected Paddle skin?", sender: sender)
//        case 4: //println(sender.tag)
//            let cost = minimumPWCredits()
//            let msg = "Deduct " + String(cost) + " coins for selected Paddle Width Multipler?"
//            let msg2 = " \n \n...Settings will be UNLOCKED for future (PdWd) adjustments"
//            if model.hasPrefix("iPad") {
//                if cost == 100 {
//                    return checkout(msg + msg2, sender: sender)
//                }
//            } else {
//                if cost == 50 {
//                    return checkout(msg + msg2, sender: sender)
//                }
//            }
//            checkout(msg, sender: sender)
        case 5: //println(sender.tag)
            checkout("Add \(chosenNumberOfCredits()) game Credits?", sender: sender)
        default: break
        }
    }
    private var audioPlayer: AVAudioPlayer!
    private var path: String! = ""
    private var soundTrack = 0
    func prepareAudios() {
        switch soundTrack {
        case 0: path = NSBundle.mainBundle().pathForResource("jazzloop2_70", ofType: "mp3")
        case 1: path = NSBundle.mainBundle().pathForResource("CYMATICS- Science Vs. Music - Nigel Stanford-2", ofType: "mp3")
        case 2: path = NSBundle.mainBundle().pathForResource("Phil Wickham-Carry My Soul(Live at RELEVANT)", ofType: "mp3")
        case 3: path = NSBundle.mainBundle().pathForResource("Hudson - Chained", ofType: "mp3")
        case 4: path = NSBundle.mainBundle().pathForResource("Forrest Gump Soundtrack", ofType: "mp3")
        case 5: path = NSBundle.mainBundle().pathForResource("Titanic Soundtrack - Rose", ofType: "mp3")
        case 6: path = NSBundle.mainBundle().pathForResource("Phil Wickham - This Is Amazing Grace", ofType: "mp3")
        case 7: path = NSBundle.mainBundle().pathForResource("Hillsong United - No Other Name - Oceans (Where Feet May Fail)", ofType: "mp3")
        case 8: path = NSBundle.mainBundle().pathForResource("Phil Wickham - At Your Name (Yahweh, Yahweh)", ofType: "mp3")
        case 9: path = NSBundle.mainBundle().pathForResource("Yusuf Islam - Peace Train - OUTSTANDING!-2", ofType: "mp3")
        case 10: path = NSBundle.mainBundle().pathForResource("Titans Spirit(Remember The Titans)-Trevor Rabin", ofType: "mp3")
        default: path = NSBundle.mainBundle().pathForResource("jazzloop2_70", ofType: "mp3")
        }
        let url = NSURL.fileURLWithPath(path!)
        audioPlayer = try? AVAudioPlayer(contentsOfURL: url)
        audioPlayer.delegate = self
        audioPlayer.numberOfLoops = 0 //0 means play once
        audioPlayer.prepareToPlay()
    }
    func fireAutoStart(timer: NSTimer) {
        if audioPlayer?.playing == true {audioPlayer?.stop()}
    }
    func checkout(message: String, sender: UIButton) {
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: "Checkout", message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Pay now!", style: UIAlertActionStyle.Default, handler: { (action) in
                self.buy(sender)  //this is the main use
            }))
            if sender.tag == 2 {
                for i in 0..<audios.count {
                    if audios[i] == self.selectedLogin2! {
                        soundTrack = i
                        let autoStartTimer =  NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: "fireAutoStart:", userInfo: nil, repeats: false)
                        autoStartTimer
                    }
                }
                alertController.addAction(UIAlertAction(title: "Sample 1st ...", style: UIAlertActionStyle.Cancel, handler: { (action) in
                    self.audioPlayer?.pause()
                    self.prepareAudios()
                    if Settings().soundOn {
                        self.audioPlayer.play()
                    } else {
                   self.audioPlayer?.pause()
                    }
                }))
            } else {
                alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) in
            }))
            }
            presentViewController(alertController, animated: true, completion: nil)
        } else { //iOS 7
            self.buy(sender)
        }
    }
    func buy(sender: UIButton) {
        switch sender.tag {
        case 0: //add selected ball skin to game
            if availableCredits > 9 {
                availableCredits -= 10
                let loggedInUser = User.login(self.selectedLogin!, password: "foo") //new ball
                print(loggedInUser)
                //let paddleBallTabBarItem = tabBarController!.tabBar.items![1]
                //paddleBallTabBarItem.badgeValue = self.selectedLogin!
                let results = Settings().mySkins.filter { el in el == self.selectedLogin! }
                if results.isEmpty {
                    Settings().mySkins.append(self.selectedLogin!)
                }
                userPickerView.reloadAllComponents()  //refresh pickerDataSource1
                updateMySkins(self.selectedLogin!)
            } else {
                warnIfCreditsLow()
            }
        case 1: print(sender.tag)
        case 2: //add selected sound track to game
            if availableCredits > 9 {
                availableCredits -= 10
                let loggedInUser = User.login(self.selectedLogin2!, password: "foo") //new audio
                print(loggedInUser)
                //let settingsTabBarItem = tabBarController!.tabBar.items![2]
                //settingsTabBarItem.badgeValue = self.selectedLogin2!
                for i in 0..<audios.count {
                    if audios[i] == self.selectedLogin2! {
                        Settings().soundChoice = i
                        let results = Settings().myAudios.filter { el in el == self.selectedLogin2! }
                        if results.isEmpty {
                            Settings().myAudios.append(self.selectedLogin2!)
                        }
                    }
                }
            } else {
                warnIfCreditsLow()
            }
//        case 3: //add selected paddle to game
//            if availableCredits > 9 {
//                availableCredits -= 10
//                if self.selectedLogin3 == nil {
//                    pickerView(userPickerView, didSelectRow: 1, inComponent: 3)  //dizzy2
//                }
//                let loggedInUser = User.login(self.selectedLogin3!, password: "foo") //new Paddle
//                print(loggedInUser)
//                let settingsTabBarItem = tabBarController!.tabBar.items![2] 
//                settingsTabBarItem.badgeValue = self.selectedLogin3!
//                for i in 0..<paddles.count {
//                    if paddles[i] == self.selectedLogin3! {
//                        Settings().myPaddles.append(self.selectedLogin3!)
//                    }
//                }
//            } else {
//                warnIfCreditsLow()
//            }
//        case 4: //adjust paddle to selected paddleWidth
//            let minPWC = self.minimumPWCredits()
//            if availableCredits >= minPWC {
//                availableCredits -= minPWC
//                let loggedInUser = User.login(self.selectedLogin4!, password: "foo") //new PaddleWidth
//                print(loggedInUser)
//                let settingsTabBarItem = tabBarController!.tabBar.items![2]
//                settingsTabBarItem.badgeValue = self.selectedLogin4!
//                for i in 0..<iPadPaddleWidths.count {
//                    if iPadPaddleWidths[i] == self.selectedLogin4! {
//                        Settings().paddleWidthMultiplier = max(1, i)
//                        Settings().purchasedPWM = Settings().paddleWidthMultiplier
//                    }
//                }
//                if model.hasPrefix("iPad") {
//                    if Settings().paddleWidthMultiplier == 10 { //enable once u purchace max paddle width
//                        Settings().paddleWidthUnlockStepper = true
//                    }
//                } else {
//                    if Settings().paddleWidthMultiplier == 5 {
//                        Settings().paddleWidthUnlockStepper = true
//                    }
//                }
//            } else {
//                if availableCredits < minPWC {
//                    alert("You have \(availableCredits) Credits!", message: "(you need \(self.minimumPWCredits()))...before buying...")
//                }
//            }
        case 5: //add selected credits to game
            purchase()
        default: break
        }
    }
//    func minimumPWCredits() -> Int {
//        if self.selectedLogin4 == nil {
//            pickerView(userPickerView, didSelectRow: Settings().paddleWidthMultiplier, inComponent: 4) //no zero width allowed- use 1 as minimum
//        }
//        var minimumCredits = 10
//        for i in 0..<iPadPaddleWidths.count {
//            if iPadPaddleWidths[i] == self.selectedLogin4! {
//                minimumCredits = i * 10
//                return minimumCredits
//            }
//        }
//        return 10
//    }
    func alert(title: String, message: String) {
        if #available(iOS 8.0, *) {
            let myAlert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            myAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(myAlert, animated: true, completion: nil)
        } else { // iOS 7
            let alert: UIAlertView = UIAlertView()
            alert.delegate = self
            alert.title = title
            alert.message = message
            alert.addButtonWithTitle("OK")
            alert.show()
        }
    }
    func chosenNumberOfCredits() -> Int {
        if self.selectedCreditIndex == 0 {
            pickerView(creditsPickerView, didSelectRow: 0, inComponent: 0)
        }
        var paidCredits = 10
        let credits = [10, 40, 70, 150, 350, 1000, 2500]
        for i in 0..<creditOptions.count {
            if i == self.selectedCreditIndex {
                paidCredits = credits[i]
            }
        }
        return paidCredits
    }
    func purchase() {
        var amount = 0.00
        if buyCreditsButton.hidden == false {
            let credits = chosenNumberOfCredits()
            let cost = [10: 0.99, 40: 2.99, 70: 4.99, 150: 9.99, 350: 19.99, 1000: 49.99, 2500: 99.99]
            amount = cost[credits]!
            print(amount)
            helper.pay4Credits(credits)
        }
    }
    let audios = ["audio77",
        "audio66",
        "audio90",
        "audio96",
        "audio125",
        "audio190",
        "audio209",
        "audio223",
        "audio3",
        "audio7",
        "audio78"]
    let ballSkins = ["globe40",
        "tennis40",
        "vectorA40",
        "vectorB40",
        "wheelOf40",
//        "8ball",
//        "asian",
//        "art160",
//        "asian33",
//        "baseball",
//        "basketball",
//        "bicycle160",
//        "blue160",
//        "bully72",
//        "burning160",
//        "c14",
//        "cd114",
//        "cd115",
//        "citroen160",
//        "cool160",
//        "cool275",
//        "cufi100",
//        "cvision160",
//        "dizzy2",
//        "dizzy34",
//        "edd2160",
//        "FFWD160",
//        "gold160",
//        "happy160",
//        "orangeW160",
//        "pickle178",
//        "pickle180",
//        "pickle190",
//        "pink130",
//        "prowheel160",
//        "radios160",
//        "r21",
//        "ring",
//        "ship160",
//        "skateW160",
//        "soccer",
//        "soccer206",
        "starDavid",
//        "star18",
        "star57",
        "steer160",
        "sun56",
        "sun94"]
//        "tennis80",
//        "toyota160",
//        "u157",
//        "u158",
//        "u191",
//        "u193",
//        "u194",
//        "u195",
//        "u196",
//        "u197",
//        "u199",
//        "u200",
//        "u201",
//        "u202",
//        "u203",
//        "u204",
//        "u207",
//        "vector160",
//        "vector300",
//        "wheel160",
//        "wheelOf160"]
    let creditOptions = ["  $0.99  ⇢    10 Credits",
        "  $2.99  ⇢   40 Credits",
        "  $4.99  ⇢   70 Credits",
        "  $9.99  ⇢  150 Credits",
        " $19.99  ⇢  350 Credits",
        " $49.99  ⇢ 1000 Credits",
        " $99.99  ⇢ 2500 Credits"]
    let hints = ["Tap [Ball] on Menu screen to pick a Video to launch",
        "Drag RedBlock into center circle to play selected video!",
        "Tap [Demo] on Menu page to view website/link to demo video",
        "Tap [Back] to return to Menu page",
        "Tap [SHOP] to go to Shop for Ball skins, background images",
        "Tap Continuous in <Settings> to autoStart random video...",
        "...Tap [Back] to autoStart new random video",
        "Turn off Continuous in <Settings> to stop autoStart"]
}