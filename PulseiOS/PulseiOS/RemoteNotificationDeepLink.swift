//
//  RemoteNotificationDeepLink.swift
//  PulseiOS
//
//  Created by Max Marze on 11/28/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import Foundation

let RemoteNotificationDeepLinkAppSectionKey : String = "article"

class RemoteNotificationDeepLink : NSObject {
    
    var article : String = ""
    
    class func create(userInfo : [NSObject : AnyObject]) -> RemoteNotificationDeepLink? {
        let info = userInfo as NSDictionary
        
        let articleID = info.objectForKey(RemoteNotificationDeepLinkAppSectionKey) as! String
        
        var ret : RemoteNotificationDeepLink? = nil
        if !articleID.isEmpty
        {
            ret = RemoteNotificationDeepLinkArticle(articleStr: articleID)
        }
        return ret
    }
    
    private override init() {
        self.article = ""
        super.init()
    }
    
    private init(articleStr : String) {
        self.article = articleStr
        super.init()
    }
    
    final func trigger() {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.triggerImp({ (passedData) -> (Void) in
                
            })
        }
    }
    
    private func triggerImp(completition : ((AnyObject?)->(Void))) {
        completition(nil)
    }
}

class RemoteNotificationDeepLinkArticle : RemoteNotificationDeepLink {
    
    var articleID : String!
    
    override init(articleStr: String) {
        self.articleID = articleStr
        super.init(articleStr: articleStr)
    }
    
    private override func triggerImp(completition: ((AnyObject?) -> (Void))) {
        super.triggerImp { (passedData) -> (Void) in
            
            print("We did it sort of!!!")
        }
    }
}