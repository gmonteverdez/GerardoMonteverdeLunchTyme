//
//  profileCellTableViewCell.swift
//  CityEye
//
//  Created by Gerardo Israel Monteverde on 1/18/16.
//  Copyright © 2016 Gerardo Israel Monteverde. All rights reserved.
//

import UIKit

class profileCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var profileCellUsername: UILabel!
    @IBOutlet weak var profileCellTituloIcon: UIImageView!
    @IBOutlet weak var profileCellColonia: UILabel!
    @IBOutlet weak var profileCellProfileImage: UIImageView!
    @IBOutlet weak var profileCellPost: UITextView!
    @IBOutlet weak var profileCellFecha: UILabel!
    @IBOutlet weak var profileCellPostImage: UIImageView!
    
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
