//
//  LoginViewController.swift
//  CityEye
//
//  Created by Gerardo Israel Monteverde on 1/22/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!

    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Actions
    
    @IBAction func login(sender: AnyObject) {
        
        let username = self.txtUsername.text
        let password = self.txtPassword.text
        
        if (username?.utf16.count < 4 || password?.utf16.count < 5)
        {
            let myAlert = UIAlertController(title: "Plop!", message: "Your username and password must be at least 5 characters.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        else
        {
            self.actInd.startAnimating()
            PFUser.logInWithUsernameInBackground(username!, password: password!, block: { (user: PFUser?, error: NSError?) -> Void in
                self.actInd.stopAnimating()
                
                if ((user) != nil)
                {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                }
                else
                {
                    let myAlert = UIAlertController(title: "Plop!", message: "Something wrong happend 😰.", preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    
                }
            })
        }
    }
 
}
