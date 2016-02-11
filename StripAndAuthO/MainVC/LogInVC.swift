//
//  LogInVC.swift
//  StripAndAuthO
//
//  Created by MindLogic Solutions on 10/02/16.
//  Copyright © 2016 mls. All rights reserved.
//

import UIKit

class LogInVC: UIViewController,FBSDKLoginButtonDelegate,UITextFieldDelegate {

   // @IBOutlet weak var btnSignFB: UIButton!
    
    @IBOutlet weak var btnFBLogin: UIButton!

    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        navigationController?.navigationBar.tintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.topItem?.title = ""
                
        var titleLable: UILabel
        titleLable =  UILabel(frame: CGRectMake(0,0,150,40))
        titleLable.text = "Sign in"
        titleLable.textAlignment = .Center
        self.navigationItem.titleView = titleLable
        
        
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        btnFBLogin.layer.cornerRadius = 20
        btnFBLogin.layer.borderWidth = 1
        btnFBLogin.layer.borderColor = UIColor.blueColor().CGColor
    }
    
    @IBAction func btnLogIn(sender: AnyObject) {
        
        if txtEmail.text != "" && txtPassword.text != ""
        {
            print("Log in")
            CheckIsLogin(txtEmail.text!, passWord: txtPassword.text!)
        }
        else
        {
            let alert = UIAlertView(title: "", message: "Please enter all value", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
        
    }
    
    @IBAction func loginFacebookAction(sender: AnyObject) {
        // GAnalytics.registerClick("Login Facebook", screen: self.className)
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logInWithReadPermissions(["public_profile","email"], fromViewController: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    //  self.getFBUserData()
                }
                self.returnUserData()
            }
        }
    }
    
    // Facebook Delegate Methods
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        returnUserData()

        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            print(result)
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
              //  print("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                let userEmail : NSString = result.valueForKey("email") as! NSString
                print("User Email is: \(userEmail)")
                
                NSUserDefaults.standardUserDefaults().setObject("logInSuccess", forKey: "isLogin")
                
                let nv = self.storyboard?.instantiateViewControllerWithIdentifier("ProductVC") as! ProductVC
                self.navigationController?.pushViewController(nv, animated: true)
            }
        })
    }
    
    
    // MARK: Textfield return key delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // textfild keybord enble return key
        self.view.endEditing(true)
        return false
    }
    
    func CheckIsLogin(uEmail:String,passWord:String)
    {
        _ = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let manager = AFHTTPRequestOperationManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
       // let param = ["email":"\(uEmail)","password":"\(passWord)"]
        manager.GET("http://mindlogicsolutions.com/demoregister/login.php?email=\(uEmail)&&password=\(passWord)",
            parameters: nil,
            success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                
                var json :AnyObject!
                
                json = (try! NSJSONSerialization.JSONObjectWithData(responseObject as! NSData, options: NSJSONReadingOptions.MutableContainers)) as! Dictionary<String, AnyObject>
                
                
          //  print(json)
                
                if json["success"] != nil
                {
                    if json["success"] as! Int == 1
                    {
                        NSUserDefaults.standardUserDefaults().setObject("logInSuccess", forKey: "isLogin")
                        
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        let nv = self.storyboard?.instantiateViewControllerWithIdentifier("ProductVC") as! ProductVC
                        self.navigationController?.pushViewController(nv, animated: true)
                        
                        
                    }
                    else
                    {
                        MBProgressHUD.hideHUDForView(self.view, animated: true)
                        let alert = UIAlertView(title: "", message: "\(json["message"] as! String)", delegate: nil, cancelButtonTitle: "OK")
                        alert.show()
                    }
                }
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            },
            failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                print("Error: " + error.localizedDescription)
                MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    
}
