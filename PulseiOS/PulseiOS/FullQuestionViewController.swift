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
    }
}
