//
//  PushRouteHandler.swift
//  PulseiOS
//
//  Created by Max Marze on 11/30/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import Foundation
import DeepLinkKit

public class PushRouteHandler: DPLRouteHandler {
    public override func shouldHandleDeepLink(deepLink: DPLDeepLink!) -> Bool {
        if let title = deepLink.routeParameters["title"] as? String,
            message = deepLink.routeParameters["message"] as? String {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
                let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    
                })
                alert.addAction(okayAction)
                if let rootVC = UIApplication.sharedApplication().keyWindow?.rootViewController {
                    rootVC.presentViewController(alert, animated: true, completion: nil)
                }
//                UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
        }
        return false
    }
}
