//
//  ClassSession_Beta.swift
//  PulsetvOS
//
//  Created by Max Marze on 11/12/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import Bolts
import Parse

class ClassSession_Beta: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "ClassSession_Beta"
    }
    
    @NSManaged var classIn : PFRelation
    @NSManaged var questions : PFRelation
    @NSManaged var answerDisplayed : Bool
    @NSManaged var currentQuestion : Int
}
