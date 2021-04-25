//
//  PersistanceController.swift
//  todos
//
//  Created by Chrystian Guth on 11/04/2021.
//
import Foundation
import CoreData

struct PersistenceController {
    // A singleton for our entire app to use
    static let shared = PersistenceController()

    // Storage for Core Data
    let container: NSPersistentContainer

    // A test configuration for SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        let todo1 = Note(context: controller.container.viewContext)
        todo1.theId = UUID()
        todo1.content = "some content"
        todo1.date = Date()
        
        let todo2 = Note(context: controller.container.viewContext)
        todo2.theId = UUID()
        todo2.content = "asdasd"
        todo1.date = Date()
        
        let todo3 = Note(context: controller.container.viewContext)
        todo3.theId = UUID()
        todo3.content = "another note"
        todo1.date = Date()
        
        let fosterHome = FosterHome(context: controller.container.viewContext)
        fosterHome.theId = UUID()
        fosterHome.name = "Lt da Leona"
        fosterHome.notes = [todo1, todo2, todo3]

        return controller
    }()
    
    static var preview2: PersistenceController = {
        let controller = PersistenceController(inMemory: true)

        return controller
    }()

    // An initializer to load Core Data, optionally able
    // to use an in-memory store.
    init(inMemory: Bool = false) {
        // If you didn't name your model Main you'll need
        // to change this name below.
        container = NSPersistentContainer(name: "FosterTheKitten")

        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func save() {
        let context = container.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Show some error here
            }
        }
    }

}
