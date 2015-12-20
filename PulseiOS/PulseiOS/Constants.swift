//
//  Constants.swift
//  PulseiOS
//
//  Created by Varun D Patel on 11/13/15.
//  Copyright © 2015 pulse. All rights reserved.
//

import Foundation
import UIKit

struct ColorConstants {
    static let GreenCorrectColor = UIColor(red: 91.0 / 255, green: 201.0 / 255, blue: 139.0 / 255, alpha: 1.0)
    static let RedIncorrectColor = UIColor(red: 201.0 / 255, green: 91.0 / 255, blue: 104.0 / 255, alpha: 1.0)
    static let GrayNormalButtonColor = UIColor(red: 205.0 / 255, green: 205.0 / 255, blue: 205.0 / 255, alpha: 1.0)
    static let OrangeAppColor = UIColor(red: 255.0 / 255, green: 194.0 / 255, blue: 113.0 / 255, alpha: 1.0)
    static let BlueAppColor = UIColor(red: 169.0 / 255, green: 201.0 / 255, blue: 212.0 / 255, alpha: 1.0)
}

struct StoryBoards {
    static let iPadStoryBoardName = "iPadPulseApp"
    static let iPhoneStoryBoardName = "iPhonePulseApp"
}

struct AnswerTypes {
    static let MultipleChoice = "MultipleChoice"
    static let FillInTheBlank = "FillInTheBlank"
    static let Matching = "Matching"
}

struct UserRoles {
    static let Student = "Student"
    static let Teacher = "Teacher"
}

struct  Score {
    static var Increment = 500
    static var Decrement = -500
}

class ViewState {
    static var currentView : DeviceViewController?
}
