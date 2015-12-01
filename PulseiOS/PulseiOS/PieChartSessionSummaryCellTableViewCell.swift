//
//  PieChartSessionSummaryCellTableViewCell.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/30/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Charts

class PieChartSessionSummaryCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var progressPieChart: PieChartView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
