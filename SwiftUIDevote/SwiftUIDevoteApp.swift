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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
