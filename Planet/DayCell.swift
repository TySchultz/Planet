//
//  DayCell.swift
//  Planet
//
//  Created by Ty Schultz on 9/28/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {

    @IBOutlet weak var dayTitle: UILabel!
    @IBOutlet weak var dayNumber: UILabel!
    @IBOutlet weak var eventStack: UIStackView!
    @IBOutlet weak var circleStack: UIStackView!
    
    
    @IBOutlet weak var numberOfObjects: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
