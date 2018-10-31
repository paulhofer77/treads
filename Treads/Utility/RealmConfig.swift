//
//  RealmConfig.swift
//  Treads
//
//  Created by Paul Hofer on 31.10.18.
//  Copyright © 2018 Hopeli. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    
    static var runDataConfig: Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        let config = Realm.Configuration(
            fileURL: realmPath,
            schemaVersion: 0,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 0) {
//                    Nothing to do here
//                    Realm will automatically eteact new Properties and Remove Properties
//                    here you put code for more complex Data Migrations
                }
        })
        return config
    }
    
}
