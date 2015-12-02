//
//  iPhoneScoresViewController.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/30/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit
import Charts
import Parse

class iPhoneScoresViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    let userData = User.sharedInstance
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if(userData.reloadiPhoneScoresTable) {
            self.tableView.reloadData()
            userData.reloadiPhoneScoresTable = false
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("SessionSummaryCell") as! PieChartSessionSummaryCellTableViewCell
            /** PIE CHART SETUP : ************************************/
            cell.progressPieChart.legend.enabled = false
            cell.progressPieChart.usePercentValuesEnabled = true
            cell.progressPieChart.holeColor = ColorConstants.BlueAppColor
            cell.progressPieChart.sizeToFit()
            cell.progressPieChart.centerTextRadiusPercent = 75.0
            cell.progressPieChart.descriptionText = ""
            /*********************************************************/
            let correctAnswers = userData.user!["questionsCorrect"] as! Double
            let incorrectAnswers = userData.user!["questionsIncorrect"] as! Double
            DeviceViewHelper.drawPieChart(correctAnswers, incorrect: incorrectAnswers, isInitialLoad: true, progressPieChart: cell.progressPieChart)
            return cell
        } else {
            tableView.dequeueReusableCellWithIdentifier("RankAndPointsCell") as! RankAndPointsTableViewCell
            let cell = tableView.dequeueReusableCellWithIdentifier("RankAndPointsCell") as! RankAndPointsTableViewCell
            cell.pointsLabel.text = "Points\t: "  + String(userData.points)
            DeviceViewHelper.setRankLabel(cell.rankLabel, offset: "Rank\t: ")
            cell.rankLabel.text = "Rank\t: "  + String(userData.currentRank)
            return cell
        }
    }
    
}
