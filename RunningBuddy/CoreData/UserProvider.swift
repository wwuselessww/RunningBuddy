//
//  UserProvider.swift
//  RunningBuddy
//
//  Created by Alexander Kozharin on 08.04.26.
//

import Foundation
import CoreData

final class UserProvider {
    static let shared = UserProvider()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "WorkoutsDataModel")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                print("CANT LOAD USER STORE")
                return
            } else {
                print("user store loaded")
            }
        }
    }
    
    func fetchWeight() throws -> Int {
        let request = NSFetchRequest<User>(entityName: "User")
        do {
            let users = try persistentContainer.viewContext.fetch(request)
            guard let weight = users.first?.weight else {
                return -1
            }
            return Int(weight)
        } catch {
            print(error)
            return -2
        }
    }
    
    private func fetchUser() -> User? {
        let request = NSFetchRequest<User>(entityName: "User")
        request.fetchLimit = 1
        do {
            return try persistentContainer.viewContext.fetch(request).first
        } catch {
            print(error)
            return nil
        }
    }
    
    func saveWeight(_ weight: Int) {
        let user = fetchUser() ?? User(context: persistentContainer.viewContext)
        print("weight for saving is \(weight)")
        user.weight = Int16(weight)
        save()
    }
    
    private func save() {
        do {
            try persistentContainer.viewContext.save()
            print("saved user info")
        } catch {
            print(error)
        }
    }
    
}
