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
    
    @IBOutlet weak var deleteWidth: NSLayoutConstraint!
    @IBOutlet weak var colorSquareWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        deleteButton.layer.cornerRadius = 4.0
        deleteButton.backgroundColor = PLRed
        colorSquare.layer.cornerRadius = 4.0
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
