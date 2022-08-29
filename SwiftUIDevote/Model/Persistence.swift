//
//  Persistence.swift
//  SwiftUIDevote
//
//  Created by Kaori Persson on 2022-08-24.
//

import CoreData

struct PersistenceController {
    // MARK: - 1. Persistent controller
    static let shared = PersistenceController()

    // MARK: - 2. Persistent container
    // The class to handle core data function
    let container: NSPersistentContainer

    // MARK: - 3. Initialisation (Load the persistent store)
    // inMemory: Bool = true, Save the information into the memory rather than disk (SQLite -> Disk, inMemory -> memory). See the preview section, the setting inMemory: Bool = true
    // So that all the information will be cleaned up when the app ended
    // inMemory is perfect for testing
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftUIDevote")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // MARK: - 4. Preview
    // For preview, the information is saved in memory for the testing. (inMemory: Bool = true)
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<5 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.task = "Sample task No \(i)"
            newItem.completion = false
            newItem.id = UUID()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
