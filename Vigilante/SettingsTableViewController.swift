//
//  SettingsTableViewController.swift
//  CityEye
//
//  Created by Gerardo Israel Monteverde on 19/01/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UINavigationControllerDelegate {
    
    
    //MARK: - Properties
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var username: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(animated: Bool) {
    
        let nombre = PFUser.currentUser()?.objectForKey("nombre") as? String
        let apellido = PFUser.currentUser()?.objectForKey("apellido") as? String
        let nombreCompleto = "\(nombre!) \(apellido!)"
        
        self.fullName.text = nombreCompleto
        self.username.text = PFUser.currentUser()?.username
        
        if (PFUser.currentUser()?.objectForKey("image") != nil)
        {
            let userImageFile:PFFile = PFUser.currentUser()?.objectForKey("image") as! PFFile
            userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if imageData != nil
                {
                    self.profileImage.image = UIImage(data: imageData!)
                }
            })
        }
        else{
            self.profileImage.image = UIImage(named: "login_as_user_filled100.png")
        }
        
        if (PFUser.currentUser() != nil)
        {
            self.title = PFUser.currentUser()?.objectForKey("nombre") as? String
        }
    }
    
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("loogedOutSegue", sender: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
