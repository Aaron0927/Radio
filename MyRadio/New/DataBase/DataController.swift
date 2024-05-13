//
//  DataController.swift
//  MyRadio
//
//  Created by Aaron on 2024/5/3.
//
import CoreData
import Foundation

class DataController: ObservableObject {
    static let shared = DataController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RadioModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { descriptions, error in
            if let error = error {
                fatalError("failed to load data store \(error)")
            }

        }
    }

    func save() {
        if container.viewContext.hasChanges {
              try? container.viewContext.save()
        }
    }

    func delete(obj: NSManagedObject) {
        container.viewContext.delete(obj)
    }

}
