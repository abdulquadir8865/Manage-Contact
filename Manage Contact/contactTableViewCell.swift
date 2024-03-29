//
//  contactTableViewCell.swift
//  Manage Contact
//
//  Created by droadmin on 20/10/23.
//

import UIKit

class contactTableViewCell: UITableViewCell {

    
    
    
    
    @IBOutlet weak var imgview: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblBirth: UILabel!
    
    @IBOutlet weak var lblGender: UILabel!
    
    @IBOutlet weak var lblDiscription: UILabel!
    
    @IBOutlet weak var editBtn: UIButton!
    
    @IBOutlet weak var deleteBtn: UIButton!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
