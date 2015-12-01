//
//  RankAndPointsTableViewCell.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/30/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit

class RankAndPointsTableViewCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
