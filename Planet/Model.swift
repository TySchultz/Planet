//
//  Model.swift
//  Planet
//
//  Created by Ty Schultz on 10/5/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import RealmSwift


enum EventType : String {
    case TEST = "Test"
    case QUIZ = "Quiz"
    case HW = "HW"
    case PROJECT = "Project"
    case PRESENTATION = "Presentation"
    case MEETING = "Meeting"
}


enum ColorType : String {
    case PLCOLOR_BLUE = "PLBLUE"
    case PLCOLOR_GREEN = "PLGREEN"
    case PLCOLOR_PURPLE = "PLPURPLE"
    case PLCOLOR_GRAY = "PLGRAY"
    case PLCOLOR_BLACK = "PLBLACK"
    case PLCOLOR_ORANGE = "PLORANGE"
}


class Course: Object {
  
    dynamic var name = ""
    dynamic var time = NSDate(timeIntervalSince1970: 1)
    dynamic var color = ""
    let events = List<Event>()
    dynamic var serverID  = ""
    var colorEnum: ColorType {
        get {
            return ColorType(rawValue: self.color)!
        }
        set {
            self.color = newValue.rawValue
        }
    }
    
    
    
    func colorForType(type : ColorType) -> UIColor {
        switch type{
        case .PLCOLOR_BLUE:
            return PLBlue
        case .PLCOLOR_GREEN:
            return PLGreen
        case .PLCOLOR_PURPLE:
            return PLPurple
        case .PLCOLOR_GRAY:
            return PLGray
        case .PLCOLOR_BLACK:
            return PLBlack
        case .PLCOLOR_ORANGE:
            return PLOrange
        }
    }
    

    override static func primaryKey() -> String? {
        return "serverID"
    }
}

// Person model
class Event: Object {
    dynamic var date = NSDate(timeIntervalSince1970: 1)
    dynamic var course: Course!
    dynamic var serverID = ""
    dynamic var type = "Test"
    var typeEnum: EventType {
        get {
            return EventType(rawValue: self.type)!
        }
        set {
            self.type = newValue.rawValue
        }
    }
    override static func primaryKey() -> String? {
        return "serverID"
    }

}
