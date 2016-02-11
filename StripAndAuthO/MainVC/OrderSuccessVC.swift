//
//  OrderSuccessVC.swift
//  StripAndAuthO
//
//  Created by MindLogic Solutions on 11/02/16.
//  Copyright © 2016 mls. All rights reserved.
//

import UIKit

class OrderSuccessVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""

    }
    
    @IBAction func btnLogOut(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("isLogin")
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        let nv = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        navigationController?.pushViewController(nv, animated: true)
    }
    
}
