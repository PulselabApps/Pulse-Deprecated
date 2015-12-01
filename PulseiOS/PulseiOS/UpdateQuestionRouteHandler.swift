//
//  UpdateQuestionRouteHandler.swift
//  PulseiOS
//
//  Created by Max Marze on 11/30/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import Foundation
import DeepLinkKit

public class UpdateQuestionRouteHandler : DPLRouteHandler {
    
    public override func shouldHandleDeepLink(deepLink: DPLDeepLink!) -> Bool {
        if let currentVC = ViewState.currentView {
            currentVC.checkForQuestionChange()
            return true
        }
        return false
    }
}
