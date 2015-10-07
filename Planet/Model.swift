//
//  Model.swift
//  Planet
//
//  Created by Ty Schultz on 10/5/15.
//  Copyright © 2015 Ty Schultz. All rights reserved.
//

import RealmSwift

class Model: Object {
    
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }

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
    dynamic var name = ""
    dynamic var date = NSDate(timeIntervalSince1970: 1)
    dynamic var course: Course!
    dynamic var serverID = ""
    
    override static func primaryKey() -> String? {
        return "serverID"
    }
}
