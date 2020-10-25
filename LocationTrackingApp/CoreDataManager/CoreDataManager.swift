//
//  CoreDataManager.swift
//  LocationTrackingApp
//
//  Created by Ayush Gupta on 23/10/20.
//  Copyright © 2020 Ayush Gupta. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "LocalDBModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let err = error {
                fatalError("Failed: \(err)")
            }
        }
        return container
    }()
}
