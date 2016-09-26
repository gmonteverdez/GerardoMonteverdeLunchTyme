//
//  SignUpViewController.swift
//  CityEye
//
//  Created by Gerardo Israel Monteverde on 1/22/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit
import Parse

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    // MARK: Properties
    var imagePicker = UIImagePickerController()
    let following = []
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0,0,150,150)) as UIActivityIndicatorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    // MARK: Actions
    @IBAction func selectProfilePicture(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .Camera
            presentViewController(imagePicker, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func selectImageFromGallery(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum)
        {
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = .PhotoLibrary
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    //MARK: - ImagePicker
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        profileImage.image = image
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    @IBAction func signUp(sender: AnyObject) {
        
        let username = self.txtUsername.text
        let password = self.txtPassword.text
        let email = self.txtEmail.text
        
        if (username?.utf16.count < 4 || password?.utf16.count < 5)
        {
            let myAlert = UIAlertController(title: "Plop!", message: "El nombre de usuario debe ser mayor a 4 caracteres y la contraseña mayor a 5.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
            
        }
        else if (email?.utf16.count < 8)
        {
            let myAlert = UIAlertController(title: "¡Espera!", message: "Escribe un email válido", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction)
            self.presentViewController(myAlert, animated: true, completion: nil)
        }
        else
        {
            self.actInd.startAnimating()
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            newUser["following"] = self.following
            newUser["nombre"] = " "
            newUser["apellido"] = " "
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                self.actInd.stopAnimating()
                
                if ((error) != nil)
                {
                    let myAlert = UIAlertController(title: "Plop!", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil)
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                }
                else
                {
                    let userMessage = "Lunch Tyme team is very happy to have you here 😃"
                    let myAlert = UIAlertController(title: "Welcome!", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: {
                        (action:UIAlertAction!) -> Void in
                        self.dismissViewControllerAnimated(true, completion: { () -> Void in
                            //self.opener.loadUserDetails()
                        })
                    })
                    myAlert.addAction(okAction)
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    self.tabBarController?.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        }
    }

}
