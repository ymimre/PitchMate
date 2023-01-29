//
//  HourTableViewCell.swift
//  PitchMate
//
//  Created by Yusuf Mert İmre on 31.12.2022.
//

import UIKit

class HourTableViewCell: UITableViewCell {

    @IBOutlet weak var hourLabel: UILabel!
    
    @IBOutlet weak var availabilityView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
