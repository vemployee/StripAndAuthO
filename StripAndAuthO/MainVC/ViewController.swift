//
//  ViewController.swift
//  StripAndAuthO
//
//  Created by MindLogic Solutions on 10/02/16.
//  Copyright © 2016 mls. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = ""

    }

    override func viewWillAppear(animated: Bool) {
        navigationController?.navigationBarHidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.navigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func btnSignUp(sender: AnyObject) {
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("isLogin") != nil)
        {
            let nv = storyboard?.instantiateViewControllerWithIdentifier("ProductVC") as! ProductVC
            navigationController?.pushViewController(nv, animated: true)
        }
        else
        {
            let nv = storyboard?.instantiateViewControllerWithIdentifier("SignUpVC") as! SignUpVC
            navigationController?.pushViewController(nv, animated: true)
        }
    }
    
    @IBAction func btnLogIn(sender: AnyObject) {
        
        if (NSUserDefaults.standardUserDefaults().valueForKey("isLogin") != nil)
        {
            let nv = storyboard?.instantiateViewControllerWithIdentifier("ProductVC") as! ProductVC
            navigationController?.pushViewController(nv, animated: true)
        }
        else
        {
            let nv = storyboard?.instantiateViewControllerWithIdentifier("LogInVC") as! LogInVC
            navigationController?.pushViewController(nv, animated: true)
        }
    }

}

