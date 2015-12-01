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
    private var scores = [Int]()
    
    var userRank : Int {
        get {
            setScores()
            var rank = 1
            scores.sortInPlace({ $0 > $1 })
            for score in scores {
                if score == self.user!["score"] as? Int {
                    break
                }
                rank++
            }
            return rank
            
        }
    }
    
    var points : Int {
        get {
            return user!["score"] as! Int
        }
    }
    
    private func setScores() {
        let query = PFQuery(className: "Class")
        query.whereKey("name", equalTo: "Math")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                let currentClass = objects![0]
                let relationalQuery : PFQuery? = currentClass.relationForKey("students").query()
                relationalQuery?.whereKeyExists("score")
                relationalQuery?.findObjectsInBackgroundWithBlock({ (object: [PFObject]?, errors: NSError?) -> Void in
                    if errors == nil {
                        self.scores.removeAll()
                        for obj in object!{
                            let student = obj
                            let score = student.valueForKey("score") as? Int
                            self.scores.append(score!)
                        }
                    }
                })
            }
        }
    }
    
    private init(){ }
}