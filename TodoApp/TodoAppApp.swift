//
//  TodoAppApp.swift
//  TodoApp
//
//  Created by Yasuhiro Yoshida on 2022/02/08.
//

import SwiftUI

@main
struct TodoAppApp: App {
  
  let persistentContainer = CoreDataManager.shared.persistentContainer
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistentContainer.viewContext)
    }
  }
}
