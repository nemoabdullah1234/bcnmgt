import UIKit
import AirshipKit
import Crashlytics
class STRLoginViewController: UIViewController ,UITextFieldDelegate,UIDocumentInteractionControllerDelegate{
    @IBAction func btnSendDiagnostic(sender: AnyObject) {
        sendMail()
    }
    @IBOutlet var btnSendDiagnostic: UIButton!

    @IBOutlet var botmLayout: NSLayoutConstraint!
    @IBOutlet var btnShow: UIButton!
    var activityVC: UIActivityViewController?
    @IBAction func btnShow(sender: UIButton) {
        if(sender.titleLabel?.text == "SHOW")
        {
            self.txtPassword.secureTextEntry = false
            sender.setTitle("HIDE", forState: UIControlState.Normal)
        }
        else{
            self.txtPassword.secureTextEntry = true
            sender.setTitle("SHOW", forState: UIControlState.Normal)
        }
        
    }
    
    @IBOutlet var txtUserName: B68UIFloatLabelTextField!
    @IBOutlet var txtPassword: B68UIFloatLabelTextField!
    
    @IBOutlet var vwBtnLogin: UIView!
    
    @IBOutlet var lblForgetSomething: UILabel!
    
    @IBOutlet var lblResetYourPassword: UILabel!
    
    @IBOutlet var lblBuild: UILabel!
    
    @IBOutlet var btnLogin: UIButton!
    
    @IBOutlet var scrlView: UIScrollView!
    
    var localTimeZoneAbbreviation: String { return NSTimeZone.localTimeZone().name ?? "UTC" }
    var dataArrayObj : NSDictionary?
    var defaultView : String?
    var defaultSortedby : String?
    var defaultSortedorder : String?
    var currentTextFeild: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
         self.addKeyboardNotifications()
        //  self.btnShow.hidden = true
        // Do any additional setup after loading the view.
//        var buildType:String!
//        
//        
//        if(Kbase_url.containsString("ossclients"))
//        {
//            buildType = "0.1Q"
//        }
//        else{
//            buildType = "0.1P"
//        }
//        let aStr = String(format: "%@",buildType)
        let nsObject: AnyObject? = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]
        //Then just cast the object as a String, but be careful, you may want to double check for nil
        let version = nsObject as! String
        // Do any additional setup after loading the view.
        var buildType = "P"
        if(Kbase_url.containsString("ossclients"))
        {
            buildType = "Q"
        }
        
        lblBuild.text = "V" + version + buildType

        //lblBuild.text = aStr
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         self.navigationController?.navigationBarHidden = true
    
          setUpFont()
        
        
        //  UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }
    
//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    override func viewDidDisappear(animated: Bool) {
         // UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
    }
    func addKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(STRLoginViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(STRLoginViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(string == " ")
        {
        return false
        }
//        if(textField == self.txtUserName)
//        {
//            textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
//            return false
//
//        }
        
        return true
    }
    func createAlert(alertTitle: String, alertMessage: String, alertCancelTitle: String)
    {
        
        let alert = UIAlertView(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: alertCancelTitle)
        alert.show()
        
        
        

    }

    //MARK: textField delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        return true
    }
    func textFieldDidEndEditing(textField: UITextField) {
        
    
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func validate()->(Bool){
        if((txtPassword.text?.characters.count == 0) && (txtUserName.text?.characters.count == 0))
        {
            createAlert("", alertMessage: TextMessage.enterValues.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
            return false
        }
        if(txtUserName.text?.characters.count == 0)
        {
               createAlert("", alertMessage: TextMessage.enterUserName.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
            return false
        }
        if(txtPassword.text?.characters.count == 0)
        {
             createAlert("", alertMessage: TextMessage.enterPassword.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
            return false
        }
        if(!utility.isEmail(txtUserName.text!))
        {
             createAlert("", alertMessage: TextMessage.emailValid.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
            return false
        }
        
        return true
    }
    
    @IBAction func btnLogin(sender: AnyObject) {
        if validate(){
            //"sujoy@osscube.com"
            //"sujoy@123"
            print(txtUserName.text!)
            print(txtPassword.text!)
            utility.setUserEmail(txtUserName.text!)
            let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            loadingNotification.mode = MBProgressHUDMode.Indeterminate
            loadingNotification.labelText = "Loading"
            let generalApiobj = GeneralAPI()
            
            let someDict:[String:String] = ["email":txtUserName.text!, "password":txtPassword.text!,"channelId":utility.getChannelId()! , "os" : typeofOS ] //utility.getChannelId()!
            generalApiobj.hitApiwith(someDict, serviceType: .STRApiLogin, success: { (response) in
                
                
                print(response)
                  dispatch_async(dispatch_get_main_queue()) {
                guard let data = response["data"] as? [String:AnyObject],let readerSignInResponse = data["readerSignInResponse"] as? [String:AnyObject] else{
                      MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                      self.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue)
                    self.loginSuccess(false)

                    return
                }
                    let msg  = "\(response["message"] as! String)"
                    if(msg.characters.count > 0)
                    {
                    utility.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue ,view: self)
                    }
                print(readerSignInResponse["token"] as? String)
                utility.setPermToken((readerSignInResponse["token"] as? String)!)
                utility.setCountryDialCode((readerSignInResponse["readerGetProfileResponse"]!["countryDialCode"] as? String)!)
                utility.setCountryCode((readerSignInResponse["readerGetProfileResponse"]!["countryCode"] as? String)!)
              //  utility .setUserRole("salesrep")
               
                
                    
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.getSession()
                }
            }) { (err) in
                  dispatch_async(dispatch_get_main_queue()) {
                  MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                //self.dismissSelf()
                    self.loginSuccess(false)
                NSLog(" %@", err)
                }
            }

        }
    }
    
    func getSession()->(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(Dictionary<String,String>(), serviceType: .STRApiSession, success: { (response) in
              dispatch_async(dispatch_get_main_queue()) {
            print(response)
            guard let data = response["data"] as? [String:AnyObject],let readerGenerateSessionResponse = data["readerGenerateSessionResponse"] as? [String:AnyObject] else{
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                self.loginSuccess(false)
                return
            }
            utility.setUserToken((readerGenerateSessionResponse["token"] as? String)!)
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.dataFeeding()
                self.updateTimeZone()
 
            }
        }) { (err) in
                  dispatch_async(dispatch_get_main_queue()) {
          self.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
           MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.loginSuccess(false)
            }
        }
        
    }
    
    func dataFeeding()  {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        
        generalApiobj.hitApiwith([:], serviceType: .STRApiGetSettingDetails, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                
                print(response["data"])
                
                let dataDictionary = response["data"] as? [String : AnyObject]
                if dataDictionary?.count <= 0 {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    return
                }
                let dictResult = dataDictionary as! NSDictionary
                self.dataArrayObj = dictResult["readerGetSettingsResponse"]  as? NSDictionary
                self.setValueInDefaults(self.dataArrayObj!)
                
               self.dismissSelf()
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                
                NSLog(" %@", err)
                 self.loginSuccess(false)
            }
        }
    }
    
    func setValueInDefaults(infoDictionary : NSDictionary) {
        loginSuccess(true)
        self.defaultView = self.dataArrayObj!["dashboardDefaultView"] as? String
        
        if self.defaultView == "All" {
            utility.setselectedIndexDashBoard("0")
        }else if self.defaultView == "Watched" {
            utility.setselectedIndexDashBoard("1")
        }else if self.defaultView == "Exceptions" {
            utility.setselectedIndexDashBoard("2")
        }
        
        
        self.defaultSortedby = self.dataArrayObj!["dashboardSortBy"] as? String
        self.defaultSortedorder = self.dataArrayObj!["dashboardSortOrder"] as? String
        
        
        utility.setselectedSortBy(self.defaultSortedby!)
        utility.setselectedSortOrder(self.defaultSortedorder!)
        utility.setNotification((self.dataArrayObj!["notifications"] as? String)!)
        utility.setSilentFrom((self.dataArrayObj!["silentHrsFrom"] as? String)!)
        utility.setSilentTo((self.dataArrayObj!["silentHrsTo"] as? String)!)
        utility.setNotificationAlert((self.dataArrayObj!["sound"] as? String)!)
        utility.setNotificationVibration((self.dataArrayObj!["vibration"] as? String)!)
        utility.setNotificationBadge((self.dataArrayObj!["led"] as? String)!)
        utility.setBeaconServices((self.dataArrayObj!["beaconServiceStatus"] as? String)!)
    }
    // MARK:- Notification
    func keyboardWillShow(notification: NSNotification) {
        // self.scrlView.setContentOffset(CGPointMake(0, 120), animated: true)
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.botmLayout.constant = keyboardFrame.size.height - 100
        }) { (completed: Bool) -> Void in
            
        }

        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
      self.scrlView.setContentOffset(CGPointMake(0, 0), animated: true)
        
    }

    
    @IBAction func btnForgotPassword(sender: AnyObject) {
        let forgot=STRForgotPasswordViewController(nibName: "STRForgotPasswordViewController", bundle: nil)
        self.navigationController?.pushViewController(forgot, animated: true)
        
    }
    
    func backToDashbaord() {
        //  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        //  appDelegate.initSideBarMenuFromLogin()
        
        self.dismissSelf()
    }
    
    func dismissSelf() -> () {
        
        
        if (utility.getUserRole() ==  "warehouse") {
            applicationEnvironment.ApplicationCurrentType = applicationType.warehouseOwner
        }else{
             applicationEnvironment.ApplicationCurrentType = applicationType.salesRep
        }
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.initSideBarMenuFromLogin()
        
        
        //backToDashbaord()
        self.dismissViewControllerAnimated(true) { 
            
        }
    }

    
    func setUpFont(){
        btnLogin.titleLabel?.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0);
        vwBtnLogin.layer.cornerRadius=5;
        lblForgetSomething.font = UIFont(name: "SourceSansPro-Regular", size: 14.0);
        lblResetYourPassword.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0);
        btnSendDiagnostic.titleLabel?.font = UIFont(name: "SourceSansPro-Semibold", size: 16.0)
        txtUserName.font =  UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        txtPassword.font =  UIFont(name: "SourceSansPro-Semibold", size: 18.0);
        let attributes = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.5),
            NSFontAttributeName : UIFont(name: "SourceSansPro-Regular", size: 14.0)! // Note the !
        ]
        
        txtPassword.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes:attributes)
        txtPassword.placeHolderTextSize = "14"
        txtUserName.placeHolderTextSize = "14"
        txtPassword.inactiveTextColorfloatingLabel = colorWithHexString("8c8c8c")
        txtUserName.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes:attributes)
        btnShow.titleLabel?.font = UIFont(name: "SourceSansPro-Regular", size: 12.0)
    }
    
    /*Fabric event loging*/
    func loginSuccess(success:Bool){
        var didSuceed:String?
        var userName: String? = txtUserName.text
        if userName == nil{
            userName = ""
        }
        if success{
         didSuceed = "YES"
        }
        else{
              didSuceed = "NO"
        }
        Answers.logCustomEventWithName("Login", customAttributes: [
            "user name " : userName!,
            "success"    : didSuceed!
            ])
    }
    func sendMail()->(){
        //        let emailViewController = configuredMailComposeViewController()
        //        if MFMailComposeViewController.canSendMail() {
        //            self.presentViewController(emailViewController, animated: true, completion: nil)
        //        }
        //    let mailData = STRLogFileGenerator()
        // mailData.createCSV()
        
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0].stringByAppendingString("/"+role+"_log.csv")
        
        
        let fileData = NSURL(fileURLWithPath: documentsPath)
        
        let objectsToShare = [fileData]
        
        self.activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        
        
        let model = UIDevice.currentDevice().model
        print("device type=\(model)")
        if model == "iPad" {
            
            print("device type inside ipad =\(model)")
            
            if let wPPC = activityVC!.popoverPresentationController {
                wPPC.sourceView = activityVC!.view
            }
            presentViewController( activityVC!, animated: true, completion: nil)
            
        }else{
            
            
            self.presentViewController(activityVC!, animated: true, completion: nil)
        }
        
    }
    
    func updateTimeZone(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["timezone":localTimeZoneAbbreviation], serviceType: .STRUpdateTimeZone, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                print(response)
                guard let data = response["data"] as? [String:AnyObject],let _ = data["readerGenerateSessionResponse"] as? [String:AnyObject] else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    return
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                self.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
        }

    }
    

}

extension UIViewController {
    public override static func initialize() {
        
        // make sure this isn't a subclass
        if self != UIViewController.self {
            return
        }
        
        let _: () = {
            let originalSelector = #selector(UIViewController.viewWillAppear(_:))
            let swizzledSelector = #selector(UIViewController.newViewWillAppear(_:))
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
            } else {
                method_exchangeImplementations(originalMethod, swizzledMethod);
            }
        }()
    }
    
    // MARK: - Method Swizzling
    
    func newViewWillAppear(animated: Bool) {
        self.newViewWillAppear(animated)
        var name = NSStringFromClass(self.classForCoder)
        if(self.isKindOfClass(UINavigationController))
        {
            return
        }
        if name.containsString(".")
        {
            let arr = name.componentsSeparatedByString(".")
            name = arr[arr.count-1]
        }
        if  (name != "") {
            print("viewWillAppear: \(name)")
            Answers.logCustomEventWithName("VIEW APPEAR", customAttributes: ["VIEW NAME": name])
        } else {
            print("viewWillAppear: \(self)")
        }
    }
    
    
}

