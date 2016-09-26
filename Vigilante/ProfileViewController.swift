//
//  ProfileViewController.swift
//  Vigilante
//
//  Created by Gerardo Israel Monteverde on 12/11/15.
//  Copyright © 2015 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit
import Parse


class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellido: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var profileView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.layer.cornerRadius = profileView.frame.size.height/2
        
        if (PFUser.currentUser() != nil)
        {
            self.title = PFUser.currentUser()?.objectForKey("nombre") as? String
        }
        
        let nombre = PFUser.currentUser()?.objectForKey("nombre") as? String
        let apellido = PFUser.currentUser()?.objectForKey("apellido") as? String
        let email = PFUser.currentUser()?.objectForKey("email") as? String
        txtNombre.text = nombre
        txtApellido.text = apellido
        txtEmail.text = email
        
        if (PFUser.currentUser()?.objectForKey("image") != nil)
        {
            let userImageFile:PFFile = PFUser.currentUser()?.objectForKey("image") as! PFFile
            userImageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                if imageData != nil
                {
                    self.profileView.image = UIImage(data: imageData!)
                }
            })
        }
        else{
            self.profileView.image = UIImage(named: "login_as_user_filled100.png")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveChanges(sender: AnyObject) {
        
        do
        {
            try PFUser.currentUser()!.fetch()
        }
        catch
        {
            
        }
        
        let myUser:PFUser = PFUser.currentUser()!

        let userNombre = txtNombre.text
        let userApellido = txtApellido.text
        
        myUser.setObject(userNombre!, forKey: "nombre")
        myUser.setObject(userApellido!, forKey: "apellido")
        
        //Save data
        myUser.saveInBackgroundWithBlock
        {
            (success: Bool, error: NSError?) -> Void in
            
            if (error != nil)
            {
                let myAlert = UIAlertController(title: "Plop!", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated: true, completion: nil)
                return
            }
            
            if (success)
            {
                let userMessage = "All data was updated 😎"
                let myAlert = UIAlertController(title: "¡Woohoo!", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: {
                    (action:UIAlertAction!) -> Void in
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        //self.opener.loadUserDetails()
                    })
                })
                myAlert.addAction(okAction)
                self.presentViewController(myAlert, animated: true, completion: nil)
                return
            }
        }
    }
    
}
