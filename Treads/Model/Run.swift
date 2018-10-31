//
//  Run.swift
//  Treads
//
//  Created by Paul Hofer on 31.10.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import Foundation
import RealmSwift


class Run: Object {
    
    @objc dynamic public private(set) var id: String = ""
    @objc dynamic public private(set) var date = NSDate()
    @objc dynamic public private(set) var pace: Int = 0
    @objc dynamic public private(set) var distance: Double = 0.0
    @objc dynamic public private(set) var duration: Int = 0
    
//    we need a primary key which is unique
    override class func primaryKey () -> String {
        return "id"
    }
    
    override class func indexedProperties() -> [String] {
        return ["pace", "date", "duration"]
    }
    
    convenience init(pace: Int, distance: Double, duration: Int) {
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.duration = duration
    }
    
    static func addRunToRealm(pace: Int, distance: Double, duration: Int) {
        REALM_QUEUE.sync {
            let newRun = Run.init(pace: pace, distance: distance, duration: duration)
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(newRun)
                    try realm.commitWrite()
                }
            }catch {
                debugPrint("Error adding Run to Realm")
            }
        }
    }
    
    
    static func getAllRuns() -> Results<Run>? {
        
        do {
            let realm = try Realm()
            var runs = realm.objects(Run.self)
            runs = runs.sorted(byKeyPath: "date", ascending: false)
            return runs
        }catch {
            return nil
        }
    }
    
    
    
    
    
    
}



