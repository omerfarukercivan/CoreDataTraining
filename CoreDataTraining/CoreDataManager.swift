//
//  CoreDataManager.swift
//  CoreDataTraining
//
//  Created by Ömer Faruk Ercivan on 27.06.2023.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataTrainingModels")
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Loading of store: \(error)")
            }
        }
        return container
    }()
    
    func fetchCompanies() -> [Company] {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
        
        do {
            let companies = try context.fetch(fetchRequest)
            return compani es
            
        } catch let fetchError {
            print("Failed to fetch companies:", fetchError)
            return []
        }
    }
}
