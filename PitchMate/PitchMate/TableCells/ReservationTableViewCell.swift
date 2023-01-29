//
//  ReservationTableViewCell.swift
//  PitchMate
//
//  Created by Yusuf Mert İmre on 6.01.2023.
//

import UIKit

class ReservationTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var hourLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
