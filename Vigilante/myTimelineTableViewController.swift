//
//  myTimelineTableViewController.swift
//  Vigilante
//
//  Created by Gerardo Israel Monteverde on 1/10/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class myTimelineTableViewController: UITableViewController {
    
    var TimelineData:NSMutableArray = NSMutableArray()
    var following = [AnyObject]()
    var restaurantesData = [NSDictionary]()
    let imageCache = NSCache()
    var restaurantFollowing: [String] = []
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 150, 150)) as UIActivityIndicatorView

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        let currentInstallation: PFInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject("Colonias", forKey: "channels")
        currentInstallation.saveInBackground()

        navigationItem.title = "Lunch Tyme"
        
        self.actInd.center = self.view.center
        self.actInd.hidesWhenStopped = true
        self.actInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(self.actInd)
        
        self.loadDataFromURL()
        self.tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if((PFUser.currentUser()) == nil)
        {
            self.performSegueWithIdentifier("LoginSegue", sender: self)
        }
    }
    
    
//    //MARK: - Load data
    func loadDataFromURL(){
        // Asynchronous Http call to your api url, using NSURLSession:
        NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: "http://sandbox.bottlerocketapps.com/BR_iOS_CodingExam_2015_Server/restaurants.json")! as NSURL, completionHandler: { (data, response, error) -> Void in
            // Check if data was received successfully
            if error == nil && data != nil
            {
                do {
                    // Convert NSData to Dictionary where keys are of type String, and values are of any type
                    //let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String:AnyObject]
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! [String:AnyObject]
                    for dictionary in [json] as [[String: AnyObject]]
                    {
                        if let nestedDictionary = dictionary["restaurants"]
                        {
                            
                            for restaurant in nestedDictionary as! [NSDictionary]
                            {
                                self.restaurantesData.append(restaurant)
                
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
                catch
                {
                    // Something went wrong
                }
            }
        }).resume()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return restaurantesData.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:VigilanteTableViewCell = tableView.dequeueReusableCellWithIdentifier("timelineCell", forIndexPath: indexPath) as! VigilanteTableViewCell

        let restaurant = self.restaurantesData[indexPath.row]
    
        let name = restaurant.objectForKey("name") as? String
        let category = restaurant.objectForKey("category") as? String
        let backgroundImageURL = restaurant.objectForKey("backgroundImageURL") as? NSString
        
        cell.nameLabel.text = name
        cell.categoryLabel.text = category

        cell.restaurantImageView.image = nil
        cell.activityIndicator.hidden = false
        cell.activityIndicator.startAnimating()
        if let cacheImage = self.imageCache.objectForKey(backgroundImageURL!) as? UIImage{
            cell.restaurantImageView.image = cacheImage
        }
        
        let url = NSURL(string: backgroundImageURL! as String)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, resposn, error) in
            if error != nil
            {
                print(error)
                return
            }
            
            dispatch_async(dispatch_get_main_queue(),
            {
                if let downloadImage:UIImage = UIImage(data: data!)
                {
                    self.imageCache.setObject(downloadImage, forKey: backgroundImageURL!)
                    cell.restaurantImageView.image = downloadImage
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.hidden = true
                }
            })
            
        }).resume()
        
        return cell
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "RestaurantDetailSegue"
        {
            let nextScene =  segue.destinationViewController as! RestaurantDetail
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                let selectedVehicle = self.restaurantesData[indexPath.row]
                print(selectedVehicle)
                nextScene.selectedRestaurantesData = selectedVehicle
            }
        }
        
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let addAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Call" , handler: { (action:UITableViewRowAction!, indexPath:NSIndexPath!) -> Void in
            
            let sheet = UIAlertController(title: "Call", message: "You can make a phonecall", preferredStyle: .ActionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:
            { (alert: UIAlertAction) in
                self.dismissViewControllerAnimated(true, completion: nil)
            });
            sheet.addAction(cancelAction)
            
            let currentRestaurant = UIAlertAction(title: "Call", style: UIAlertActionStyle.Default, handler:
            { (alert: UIAlertAction) in
                
                let restaurant = self.restaurantesData[indexPath.row]
                
                if let locationData = restaurant["contact"]
                {
                    let phone = locationData.objectForKey("phone") as? String
                    UIApplication.sharedApplication().openURL(NSURL(string: "tel://\(phone!)")!)
                }
                
            });
            sheet.addAction(currentRestaurant)
            
            self.presentViewController(sheet, animated: true, completion: nil)
            
        })
        
        return [addAction]
        
    }
   
}
