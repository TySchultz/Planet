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
    dynamic var color = ""
    let events = List<Event>()
    dynamic var serverID  = ""
    
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
//    
//    func stringForType(type :EventType) -> String{
//        
//        switch type{
//            case .TEST:
//                return "Test"
//            case .QUIZ:
//                return "Quiz"
//            case .HW:
//                return "HW"
//            case .PROJECT:
//                return "Project"
//            case .PRESENTATION:
//                return "Presentation"
//            case .MEETING:
//                return "Meeting"
//        }
//    }
//    
//    func typeForString(type :String) -> EventType{
//        
//        switch type{
//        case "Test":
//            return .TEST
//        case "Quiz":
//            return .QUIZ
//        case "HW":
//            return .HW
//        case "Project":
//            return .PROJECT
//        case "Presentation":
//            return .PRESENTATION
//        case "Meeting":
//            return .MEETING
//        default:
//            return .TEST
//        }
//    }
}
