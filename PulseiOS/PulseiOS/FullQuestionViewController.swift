//
//  FullQuestionViewController.swift
//  PulseiOS
//
//  Created by Michael Ross on 11/8/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit

class FullQuestionViewController: UIViewController {

    var fullQuestion : String?
    
    @IBOutlet weak var fullQuestionText: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fullQuestionText.text = fullQuestion!

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}