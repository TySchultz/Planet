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

class Course: Object {
  
    dynamic var name = ""
    dynamic var time = NSDate(timeIntervalSince1970: 1)
    dynamic var color = 0
    let events = List<Event>()
    dynamic var serverID  = ""
  
    
    /**
     Returns the UIColor corresponding to the colorType

     - parameter type: the type of color ColorType

     - returns: the UIColor
     */
    func colorForType(type : Int) -> UIColor {
        switch type{
        case 0:
            return PLOrange
        case 1:
            return PLLightGreen
        case 2:
            return PLGray
        case 3:
            return PLRed
        case 4:
            return PLLightBlue
        case 5:
            return PLBlue
        case 6:
            return PLGreen
        case 7:
            return PLPurple
        default:
            return PLBlue
        }
    }

    

    override static func primaryKey() -> String? {
        return "serverID"
    }
}

// Person model
class Event: Object {
    dynamic var date :NSDate = NSDate(timeIntervalSince1970: 1)
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
