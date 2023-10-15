//
//  TestProject_CoreData_App.swift
//  TestProject<CoreData>
//
//  Created by Anonymous on 14/10/2023.
//

import SwiftUI

@main
struct TestProject_CoreData_App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
