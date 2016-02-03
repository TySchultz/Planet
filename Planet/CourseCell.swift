//
//  CourseCell.swift
//  Planet
//
//  Created by Ty Schultz on 2/2/16.
//  Copyright © 2016 Ty Schultz. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {

    @IBOutlet weak var classTitle: UILabel!
    @IBOutlet weak var upcomingEvents: UILabel!
    @IBOutlet weak var colorSquare: UIView!
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        colorSquare.layer.cornerRadius = 4.0
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
