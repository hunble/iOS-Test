//
//  LocationTableViewCell.swift
//  LocationManagerTest
//
//  Created by Ahmar Ijaz on 7/26/18.
//  Copyright © 2018 Arrivy. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    // MARK:- Outlets
    @IBOutlet weak var lblLocationDetails: UILabel!

    
    // MAKR:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
