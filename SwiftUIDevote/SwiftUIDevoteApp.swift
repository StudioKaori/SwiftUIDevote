//
//  SwiftUIDevoteApp.swift
//  SwiftUIDevote
//
//  Created by Kaori Persson on 2022-08-24.
//

import SwiftUI

@main
struct SwiftUIDevoteApp: App {
    let persistenceController = PersistenceController.shared
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var body: some Scene {
        WindowGroup {
            // NSManagedObjectContext
            // The class handles CRUD of database
            // All object created for core data will be under the control of the class
            // To place managedobjectcontext here, it'll be injected to the all views and subviews
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
