import UIKit
import Crashlytics
enum FRgetStages:Int {
    case StageRequest = 0
    case StageValidate
    case StageReset
}
class STRForgotPasswordViewController: UIViewController {
    var token: String!
    var email: String!
    
    //MARK: already Have Code SetUp
    var alreadyHaveCode: Bool?
    @IBOutlet var txtAHCheight: NSLayoutConstraint!
    @IBOutlet var vwAlreadyHaveCode: UIView!
    @IBOutlet var btnResendCode: UIButton!
    
    @IBOutlet var btnBackToLogin: UIButton!
    
    @IBOutlet var imgBottoMAlreadyCode: UIImageView!
    @IBAction func btnResend(sender: AnyObject) {
        self.forgetPasswordStage = .StageRequest
        if validate()
        {
            requestForgetPassword()
            
        }

    }
    
    
    @IBAction func btnAlreadyHaveCode(sender: AnyObject) {
        if(btnResendCode.tag == 0)
        {
            alreadyHaveCode = true
            showResendCodeTxt()
            btnResendCode.tag = 1
            self.forgetPasswordStage = .StageValidate
            btnSend.setTitle("SUBMIT", forState: UIControlState.Normal)
        }
        else{
            alreadyHaveCode = false
            hideResendCodeTxt()
            btnResendCode.tag = 0
            txtAlreadyHaveCode.text = ""
            self.forgetPasswordStage = .StageRequest
          btnSend.setTitle("SEND", forState: UIControlState.Normal)
        }
    }
    
    
    
    
    @IBOutlet var imgCheck: UIImageView!
    @IBOutlet var lblAlreadyHaveCode: UILabel!
    @IBOutlet var txtAlreadyHaveCode: UITextField!
    //MARK:--------
    
    @IBOutlet var bottomLayout: NSLayoutConstraint!
    @IBOutlet var scrlView: UIScrollView!
    @IBOutlet var btnSend: UIButton!
    @IBAction func btnSend(sender: AnyObject) {
        switch forgetPasswordStage! {
            
        case .StageRequest :
            if validate()
            {
                requestForgetPassword()
                
            }
            break
        case .StageValidate :
            if validate()
            {
                requestValidatePassword()
            }
            break
        case .StageReset :
            if(txtUserInfo.isFirstResponder())
            {
                self.txtConfirmPass.becomeFirstResponder()
                self.txtConfirmPass.returnKeyType=UIReturnKeyType.Go
                self.scrlView.setContentOffset(CGPointMake(0, 120), animated: true)
            }
            else
            {
                if validate()
                {
                    requestResetPassword()
                }
            }
            
            
            break
        }
        self.view.endEditing(true)

    }
    @IBOutlet var vwSndBtn: UIView!
    @IBAction func btnBackToLogin(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBOutlet var txtHeight: NSLayoutConstraint!
    @IBOutlet var vwHeight: NSLayoutConstraint!
    @IBOutlet var imgBottomLine: UIImageView!
    @IBOutlet var lblBackToLogin: UILabel!
    @IBOutlet var txtUserInfo: UITextField!
    @IBOutlet var lblMessage: UILabel!
    
    @IBOutlet var txtConfirmPass: UITextField!
    var forgetPasswordStage:FRgetStages?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forgetPasswordStage = .StageRequest
        alreadyHaveCode = false
         self.navigationController?.navigationBarHidden = true
        addKeyboardNotifications()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUpFont()
         setUpForInitialDisplay()
        //  UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func createAlert(alertTitle: String, alertMessage: String, alertCancelTitle: String)
    {
        let alert = UIAlertView(title: alertTitle, message: alertMessage, delegate: self, cancelButtonTitle: alertCancelTitle)
        alert.show()
    }
    func addKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(STRForgotPasswordViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(STRForgotPasswordViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil)
        
    }
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        UIView.animateWithDuration(0, animations: { () -> Void in
            self.bottomLayout.constant = keyboardFrame.size.height
        }) { (completed: Bool) -> Void in
            
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0, animations: { () -> Void in
            self.bottomLayout.constant = 0.0
        }) { (completed: Bool) -> Void in
            
        }
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
        
        
        if(forgetPasswordStage == .StageReset)
        {
                            if(textField ==  self.txtUserInfo)
                            {
                                self.txtConfirmPass.becomeFirstResponder()
                                self.txtConfirmPass.returnKeyType=UIReturnKeyType.Default
                                self.scrlView.setContentOffset(CGPointMake(0, 120), animated: true)
                                return true
                            }
            
        }
        
        if(self.alreadyHaveCode == true)
        {
            if(textField == self.txtUserInfo)
            {
                self.txtAlreadyHaveCode.becomeFirstResponder()
                return true
            }
        }
        
        
        
//            switch forgetPasswordStage! {
//                
//            case .StageRequest :
//                if validate()
//                {
//                 requestForgetPassword()
//                 textField.resignFirstResponder()
//                }
//                break
//            case .StageValidate :
//                if validate()
//                {
//                    requestValidatePassword()
//                    textField.resignFirstResponder()
//                }
//                break
//            case .StageReset :
//                if(textField ==  self.txtUserInfo)
//                {
//                    self.txtConfirmPass.becomeFirstResponder()
//                    self.txtConfirmPass.returnKeyType=UIReturnKeyType.Go
//                    self.scrlView.setContentOffset(CGPointMake(0, 120), animated: true)
//                }
//                else
//                {
//                if validate()
//                {
//                    requestResetPassword()
//                    textField.resignFirstResponder()
//                }
//                }
//
//                
//                break
//            }
        textField.resignFirstResponder()
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if(string == " ")
        {
            return false
        }
//        if(textField == self.txtUserInfo && forgetPasswordStage != .StageReset )
//        {
//            textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
//            return false
//        }

        return true
    }
    func validate()->(Bool){
        
        switch forgetPasswordStage! {
        case .StageRequest:
            if((txtUserInfo.text?.characters.count == 0) )
            {
                createAlert("", alertMessage: TextMessage.enterValues.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                return false
            }
            if(!utility.isEmail(txtUserInfo.text!))
            {
                createAlert("", alertMessage: TextMessage.emailValid.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                return false
            }
            break
        case .StageValidate:
            if(self.alreadyHaveCode == true)
            {
                if((txtUserInfo.text?.characters.count == 0) )
                {
                    createAlert("", alertMessage: TextMessage.enterValues.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                    return false
                }
                if(!utility.isEmail(txtUserInfo.text!))
                {
                    createAlert("", alertMessage: TextMessage.emailValid.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                    return false
                }
                if((txtAlreadyHaveCode.text?.characters.count == 0) )
                {
                    createAlert("", alertMessage: TextMessage.entertoken.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                    return false
                }
            }
            else
            {
                if((txtUserInfo.text?.characters.count == 0) )
                {
                    createAlert("", alertMessage: TextMessage.entertoken.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                    return false
                    }
                if(txtUserInfo.text != self.token)
                {
                    createAlert("", alertMessage: TextMessage.validtoken.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                    return false
                }
            }
            break
        case .StageReset:
            if((txtUserInfo.text?.characters.count == 0) )
            {
                createAlert("", alertMessage: TextMessage.newpassword.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                return false
            }
            if(txtUserInfo.text != self.txtConfirmPass.text)
            {
                createAlert("", alertMessage: TextMessage.confirmpassword.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                return false
            }

            break
        }
        return true
    }
    //MARK:  API methods
    func requestForgetPassword()->(){
        var loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["email":txtUserInfo.text!], serviceType: .STRApiRequestForgetPassword, success: { (response) in
               dispatch_async(dispatch_get_main_queue()) {
            if(response["status"]?.integerValue != 1)
            {
                
              MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                                   loadingNotification = nil
                self.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue)
                self.requestOTPLog(false)
                return
            }
            guard let data = response["data"] as? [String:AnyObject],readerGenerateSessionResponse = data["readerRequestForgotPasswordResponse"] as? [String:AnyObject] else{
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                self.requestOTPLog(false)

                               return
            }
            self.token = "\(readerGenerateSessionResponse["token"]!)"
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            self.createAlert("", alertMessage: TextMessage.emailsend.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                self.requestOTPLog(true)
                if(self.alreadyHaveCode == true)
                {
                    self.forgetPasswordStage = .StageValidate
                    self.email = self.txtUserInfo.text
                    self.txtAlreadyHaveCode.text = ""

                }
                else
                {
                    
                    
               self.setupForEnterToken()
                }
               
            }
           
        }) { (err) in
              dispatch_async(dispatch_get_main_queue()) {
            self.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.requestOTPLog(false)

            }
        }

    }
    func requestValidatePassword()->(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        var dict: Dictionary<String,String>?
        if(self.alreadyHaveCode == true)
        {
            dict = ["email":self.txtUserInfo.text!,"token":txtAlreadyHaveCode.text!]
        }
        else
            
        {
          dict =  ["email":email!,"token":self.token]
        }
        
        
        generalApiobj.hitApiwith(dict!, serviceType: .STRApiValidateForgetPassword, success: { (response) in
             dispatch_async(dispatch_get_main_queue()) {
            if(response["status"]?.integerValue != 1)
            {
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue)
                self.sendOTPlog(false)
                return
            }
            guard let data = response["data"] as? [String:AnyObject],_ = data["readerValidateForgotPasswordResponse"] as? [String:AnyObject] else{
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                self.sendOTPlog(false)
                return
            }
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.sendOTPlog(true)
                  self.setupUIForReset()
            }
        }) { (err) in
              dispatch_async(dispatch_get_main_queue()) {
            self.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.sendOTPlog(false)
            }
        }
    }
    func requestResetPassword()->(){
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Loading"
        let generalApiobj = GeneralAPI()
        generalApiobj.hitApiwith(["email":email!,"token":self.token,"password":txtUserInfo.text!], serviceType: .STRApiResetForgetPassword, success: { (response) in
            dispatch_async(dispatch_get_main_queue()) {
                if(response["status"]?.integerValue != 1)
                {
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.createAlert(TextMessage.alert.rawValue, alertMessage: "\(response["message"] as! String)", alertCancelTitle: TextMessage.Ok.rawValue)
                    self.resetPassword(false)
                    return
                }
                guard let data = response["data"] as? [String:AnyObject],_ = data["readerResetPasswordResponse"] as? [String:AnyObject] else{
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    self.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                    self.resetPassword(false)

                    return
                }
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.resetPassword(true)
                self.dismiss()
            }
        }) { (err) in
            dispatch_async(dispatch_get_main_queue()) {
                self.createAlert(TextMessage.alert.rawValue, alertMessage: TextMessage.tryAgain.rawValue, alertCancelTitle: TextMessage.Ok.rawValue)
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                self.resetPassword(false)
            }
        }
    }

    //MARK: UI settings and changes
    func setupForEnterToken()->(){
       // self.vwAlreadyHaveCode.hidden =  true
        lblMessage.text="Enter your code below."
        
        email=txtUserInfo.text
//        txtUserInfo.text=""
//        let attributes = [
//            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.5),
//            NSFontAttributeName : UIFont(name: "SourceSansPro-Semibold", size: 15)! // Note the !
//        ]
//        txtUserInfo.attributedPlaceholder = NSAttributedString(string: "CODE", attributes:attributes)
//        txtUserInfo.placeholder = "CODE"
        txtUserInfo.returnKeyType=UIReturnKeyType.Default
        txtAlreadyHaveCode.becomeFirstResponder()
        btnSend .setTitle("SUBMIT", forState: UIControlState.Normal)
        lblBackToLogin.text = "CANCEL"
        
        self.showResendCodeTxt()
        self.alreadyHaveCode = true
        forgetPasswordStage = .StageValidate
    }
    func setupUIForReset()->(){
        
        if(alreadyHaveCode == true)
        {
            self.vwAlreadyHaveCode.hidden = true
        }
        
        
        txtUserInfo.text=""
        let attributes = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.5),
            NSFontAttributeName : UIFont(name: "SourceSansPro-Semibold", size: 15)! // Note the !
        ]
        txtUserInfo.attributedPlaceholder = NSAttributedString(string: "ENTER PASSWORD", attributes:attributes)
        txtUserInfo.placeholder = "ENTER PASSWORD"
        txtHeight.constant = 50
        vwHeight.constant =  vwHeight.constant - 20
        imgBottomLine.hidden =  false
        txtConfirmPass.hidden = false
        txtConfirmPass.attributedPlaceholder = NSAttributedString(string: "CONFIRM PASSWORD", attributes:attributes)
        txtConfirmPass.placeholder = "CONFIRM PASSWORD"
        txtConfirmPass.secureTextEntry = true
        txtUserInfo.returnKeyType=UIReturnKeyType.Next
        txtUserInfo.becomeFirstResponder()
        txtUserInfo.secureTextEntry = true
        forgetPasswordStage = .StageReset
    }
    func setUpForInitialDisplay(){
        lblMessage.text = "Enter your email below and we'll send you code to reset your password."
        txtUserInfo.text=""
        let attributes = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.5),
            NSFontAttributeName : UIFont(name: "SourceSansPro-Semibold", size: 15)! // Note the !
        ]
        txtHeight.constant = 0
        vwHeight.constant =  vwHeight.constant - (40 + 14 + 1) + 83 //height of already have
        imgBottomLine.hidden =  true
        txtUserInfo.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes:attributes)
        txtUserInfo.placeholder = "EMAIL"
        txtConfirmPass.hidden = true
        
        
        //MARK: A H C
        self.txtAlreadyHaveCode.attributedPlaceholder =  NSAttributedString(string: "CODE", attributes:attributes)
        self.txtAlreadyHaveCode.placeholder = "CODE"
        hideResendCodeTxt()
    }
    
    
    func showResendCodeTxt()
    {
        self.txtAHCheight.constant = 40
         vwHeight.constant =  vwHeight.constant + 52
        self.imgBottoMAlreadyCode.hidden = false
        self.btnResendCode.hidden = false
        self.imgCheck.image = UIImage.init(imageLiteral: "selected")
        self.txtUserInfo.returnKeyType=UIReturnKeyType.Next
    }
    func hideResendCodeTxt()
    {
        self.txtAHCheight.constant = 0
        vwHeight.constant =  vwHeight.constant - 52
        self.btnResendCode.hidden = true
        self.imgBottoMAlreadyCode.hidden = true
        self.imgCheck.image = UIImage.init(imageLiteral: "check")
         self.txtUserInfo.returnKeyType=UIReturnKeyType.Default
    }
    
    
    func dismiss()->(){
    self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidDisappear(animated: Bool) {
        //self.navigationController?.navigationBarHidden=true
    }
    func setUpFont(){
        btnSend.titleLabel?.font = UIFont(name: "Roboto-Medium", size: 14.0);
        vwSndBtn.layer.cornerRadius=5;
        lblMessage.font = UIFont(name: "SourceSansPro-Semibold", size: 14.0);
        txtUserInfo.font =  UIFont(name: "SourceSansPro-Semibold", size: 15.0);
        txtConfirmPass.font =  UIFont(name: "SourceSansPro-Semibold", size: 15.0);
        let attributes = [
            NSForegroundColorAttributeName: UIColor.init(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 0.5),
            NSFontAttributeName : UIFont(name: "SourceSansPro-Semibold", size: 15)! // Note the !
        ]
        
        txtUserInfo.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes:attributes)
        txtUserInfo.placeholder = "EMAIL"
        txtConfirmPass.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes:attributes)
        txtConfirmPass.placeholder = "PASSWORD"
         lblBackToLogin.font = UIFont(name: "SourceSansPro-Semibold", size: 14.0);
        txtAlreadyHaveCode.font =  UIFont(name: "SourceSansPro-Semibold", size: 14.0);
        btnResendCode.titleLabel?.font = UIFont(name: "SourceSansPro-Semibold", size: 14.0)
        lblAlreadyHaveCode.font = UIFont(name: "SourceSansPro-Semibold", size: 14)
        

    }
    
    
    
    /*Fabric event loging*/
    func requestOTPLog(success:Bool){
        var good: String?
        if success{
            good = "YES"
        }
        else{
            good = "NO"
        }
        Answers.logCustomEventWithName("OTP REQUEST", customAttributes: ["email": txtUserInfo.text!,
            "Success":good!])
    }
    func sendOTPlog(success:Bool){
        var OTP: String
        if(self.alreadyHaveCode == true)
        {
            OTP = txtAlreadyHaveCode.text!
        }
        else
            
        {
            OTP =  self.token
        }
        var good: String?
        if success{
            good = "YES"
        }
        else{
            good = "NO"
        }
        Answers.logCustomEventWithName("OTP SEND", customAttributes: ["OTP": OTP,
            "Success":good!])
    }

    func resetPassword(success:Bool){
        var good: String?
        if success{
            good = "YES"
        }
        else{
            good = "NO"
        }
        Answers.logCustomEventWithName("PASSWORD RESET", customAttributes: ["Success":good!])
    }

    
      

}
