//
//  RestaurantDetail.swift
//  CityEye
//
//  Created by Gerardo Israel Monteverde on 9/26/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import Foundation
import MapKit
import UIKit


class RestaurantDetail: UIViewController, MKMapViewDelegate  {
    
    var selectedRestaurantesData = NSDictionary()
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var categoryTypeLabel: UILabel!
    @IBOutlet weak var formattedAddressLabel: UILabel!
    @IBOutlet weak var formattedPhoneLabel: UILabel!
    @IBOutlet weak var twitterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        
        self.title = "Lunch Tyme"
        
        self.restaurantNameLabel.text = (self.selectedRestaurantesData["name"] as? String)!
        self.categoryTypeLabel.text = (self.selectedRestaurantesData["category"] as? String)!
        
        if let locationData = self.selectedRestaurantesData["location"]
        {
            
            let latitude = locationData.objectForKey("lat") as? Double
            let longitude = locationData.objectForKey("lng") as? Double
            let address = locationData.objectForKey("address") as? String
            let postalCode = locationData.objectForKey("postalCode") as? String
            let city = locationData.objectForKey("city") as? String
            let state = locationData.objectForKey("state") as? String
            
            self.formattedAddressLabel.text = "\(address!), \(city!), \(state!) \(postalCode!)"
            
            let coordinate = MKCoordinateRegionMake(CLLocationCoordinate2DMake(latitude!, longitude!), MKCoordinateSpanMake(0.17, 0.15))
            map.setRegion(coordinate, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.title = self.restaurantNameLabel.text
            annotation.subtitle = self.categoryTypeLabel.text
            annotation.coordinate.latitude = latitude!
            annotation.coordinate.longitude = longitude!
            map.addAnnotation(annotation)
            
            cameraSetup()
        }
        
        if let locationData = self.selectedRestaurantesData["contact"]
        {
            self.formattedPhoneLabel.text = locationData.objectForKey("formattedPhone") as? String
            self.twitterLabel.text = "@\((locationData.objectForKey("twitter") as? String)!)"
        }
        
    }
    
    private func cameraSetup(){
        map.camera.altitude = 1400
        map.camera.pitch =  50
        map.camera.heading = 180
    }

}
