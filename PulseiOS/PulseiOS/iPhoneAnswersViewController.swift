//
//  iPhoneAnswersViewController.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/14/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import UIKit

class iPhoneAnswersViewController: DeviceViewController , UIScrollViewDelegate{
    
    @IBOutlet weak var iPhoneAnswersScrollView: UIScrollView!
    var y = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        iPhoneAnswersScrollView.delegate = self
    }
    
    func configureScrollView(){
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
}
