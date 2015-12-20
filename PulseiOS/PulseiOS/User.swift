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
    var reloadiPhoneScoresTable = false
    
    var points : Int {
        get {
            return user![UserKey.Score] as! Int
        }
    }
    
    var currentRank = 1
    
    private init(){ }
}

struct UserKey{
    static let Role = "role"
    static let Score = "score"
    static let QuestionsCorrect = "questionsCorrect"
    static let QuestionsIncorrect = "questionsIncorrect"
}