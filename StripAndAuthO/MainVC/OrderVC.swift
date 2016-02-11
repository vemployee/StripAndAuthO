//
//  OrderVC.swift
//  StripAndAuthO
//
//  Created by MindLogic Solutions on 10/02/16.
//  Copyright © 2016 mls. All rights reserved.
//

import UIKit

class OrderVC: UIViewController,UITextFieldDelegate {

   
    @IBOutlet weak var txtFname: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtCVVNumber: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtExpiratinMonth: UITextField!
    @IBOutlet weak var txtExpirationYear: UITextField!
    
    
    var orderPrice:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Order price \(orderPrice)"
        self.navigationController?.navigationBar.topItem?.title = ""
        
        txtFname.delegate = self
        txtLastName.delegate = self
        txtCardNumber.delegate = self
        txtCVVNumber.delegate = self
   //     txtExpirationDate.delegate = self
        txtAddress.delegate = self
        txtExpiratinMonth.delegate = self
        txtExpirationYear.delegate = self
        
    }
    
    
    // MARK: Textfield return key delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // textfild keybord enble return key
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func btnPay(sender: AnyObject) {
        
        if txtFname.text != "" && txtLastName.text != "" && txtCardNumber.text != "" && txtCVVNumber.text != "" && txtAddress.text != "" && txtExpiratinMonth.text != "" && txtExpirationYear.text != ""
        {
            _ = MBProgressHUD.showHUDAddedTo(self.view, animated: true)

            let creditCard = STPCard() //creating a stripe card object
            creditCard.number = txtCardNumber.text!//"4000056655665556"
            creditCard.cvc = txtCVVNumber.text!//"216"
            
            creditCard.expMonth = UInt(txtExpiratinMonth.text!)!//8
            creditCard.expYear = UInt(txtExpirationYear.text!)!//18
            
            
            do {
                try creditCard.validateCardReturningError()
                
                //  var stripeError: NSError!
                Stripe.createTokenWithCard(creditCard, completion: { (token, stripeError) -> Void in
                    if (stripeError != nil){
                        print("there is error");
                    }
                    else{
                        
                        print(token!.tokenId)
                        
                        let alert = UIAlertView(title: "Your stripe token is: " + token!.tokenId, message: "", delegate: nil, cancelButtonTitle: "OK")
                      //  alert.show()
                        
                        self.postStripeToken("\(token!.tokenId)")
                    }
                })
                
            } catch {
                
                MBProgressHUD.hideHUDForView(self.view, animated: true)

                print("There was an error.")
                let alert = UIAlertView(title: "", message: "Please enter valid card details", delegate: nil, cancelButtonTitle: "OK")
                alert.show()
            }
        }
        else
        {
            let alert = UIAlertView(title: "", message: "Please enter all value", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    func postStripeToken(token: String) {
        
        let URL = "http://www.mindlogicsolutions.com/donate/payment.php"
        let params = ["stripeToken": token,//token.tokenId,
            "amount": orderPrice,
            "currency": "usd",
            "description": "hello@gmail.com"]
        
        let manager = AFHTTPRequestOperationManager()
        manager.POST(URL, parameters: params, success: { (operation, responseObject) -> Void in
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            self.txtFname.text = ""
            self.txtLastName.text = ""
            self.txtCardNumber.text = ""
            self.txtCVVNumber.text = ""
            self.txtAddress.text = ""
            self.txtExpirationYear.text = ""
            self.txtExpiratinMonth.text = ""
            
            
            if let response = responseObject as? [String: String] {
//              UIAlertView(title: response["status"],
//                    message: response["message"],
//                    delegate: nil,
//                    cancelButtonTitle: "OK").show()
    
                let nv = self.storyboard?.instantiateViewControllerWithIdentifier("OrderSuccessVC") as! OrderSuccessVC
                self.navigationController?.pushViewController(nv, animated: true)
                
            }
            
            }) { (operation, error) -> Void in
                print(error)
                MBProgressHUD.hideHUDForView(self.view, animated: true)

        }
    }

}
