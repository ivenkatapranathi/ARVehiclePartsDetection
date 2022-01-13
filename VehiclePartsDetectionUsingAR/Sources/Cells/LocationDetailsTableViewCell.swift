//
//  LocationDetailsTableViewCell.swift
//  VehiclePartsDetectionUsingAR
//
//  Created by Venkata Pranathi Immaneni on 3/15/21.
//

import UIKit

class LocationDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var title: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
