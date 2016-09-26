//
//  VigilanteTableViewCell.swift
//  Vigilante
//
//  Created by Gerardo Israel Monteverde on 12/7/15.
//  Copyright © 2015 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import Bolts

class VigilanteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var categoryImageView: UIImageView!
   
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
