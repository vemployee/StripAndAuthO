//
//  ProductVC.swift
//  StripAndAuthO
//
//  Created by MindLogic Solutions on 10/02/16.
//  Copyright © 2016 mls. All rights reserved.
//

import UIKit

class ProductVC: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Products"
        
        self.navigationController?.navigationBar.topItem?.title = ""

        
        navigationItem.setHidesBackButton(true, animated:true)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    // MARK: Collection View methods
    // collection view property
    
    let productPrice:[Int] = [50,100,150,200,250,300,350,400,450,500]

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productPrice.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as UICollectionViewCell
        
        let lblPrice = cell.viewWithTag(1) as! UILabel
        lblPrice.text = "\(productPrice[indexPath.row])"
        
        return cell
        
    }
    
    // MARK: CollectionView Layout Method
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let w = (collectionView.bounds.width / 2) - 20
        
        return CGSize(width: w, height: w)
    }
    
    func collectionView(collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let orederVC = storyboard?.instantiateViewControllerWithIdentifier("OrderVC") as! OrderVC
        orederVC.orderPrice = productPrice[indexPath.row]
        navigationController?.pushViewController(orederVC, animated: true)
    }
    // collection view end------------------
    
    @IBAction func btnLogout(sender: AnyObject) {
        
        NSUserDefaults.standardUserDefaults().removeObjectForKey("isLogin")
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        let nv = storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        navigationController?.pushViewController(nv, animated: true)
    }
    
    
}
