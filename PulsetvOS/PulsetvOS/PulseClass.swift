//
//  PulseClass.swift
//  PulsetvOS
//
//  Created by Max Marze on 11/12/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import Bolts
import Parse

class PulseClass: PFObject, PFSubclassing {
    override class func initialize() {
        struct Static {
            static var onceToken : dispatch_once_t = 0;
        }
        dispatch_once(&Static.onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Class"
    }
    
    @NSManaged var name : String
    @NSManaged var students : [PFUser]
    @NSManaged var teacher : [PFUser]
}