//
//  DataController.swift
//  Ultimedia
//
//  Created by William Alexander on 5/3/22.
//

import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Sources")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}


// Question this...
