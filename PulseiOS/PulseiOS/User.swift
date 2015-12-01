//
//  User.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/14/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import Foundation
import Parse

class User {
    static let sharedInstance = User()
    
    let user = PFUser.currentUser()
    
    var points : Int {
        get {
            return user!["score"] as! Int
        }
    }
    
    private init(){ }
}