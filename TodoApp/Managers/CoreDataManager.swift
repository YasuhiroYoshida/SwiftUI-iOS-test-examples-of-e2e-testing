//
//  CoreDataManager.swift
//  TodoApp
//
//  Created by Yasuhiro Yoshida on 2022/02/08.
//

import CoreData

class CoreDataManager {

  let persistentContainer: NSPersistentContainer
  static let shared: CoreDataManager = CoreDataManager()

  private init() {
    persistentContainer = NSPersistentContainer(name: "TodoAppModel")
    persistentContainer.loadPersistentStores { description, error in
      if let error = error {
        fatalError("Unable to initialize Core Data \(error)")
      }
    }
  }
}
