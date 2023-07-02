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
            return companies
            
        } catch let fetchError {
            print("Failed to fetch companies:", fetchError)
            return []
        }
    }
    
    func createEmployee(employeeName: String, company: Company, birthday: Date, employeeType: String) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        employee.company = company
        employee.employeeInformation = employeeInformation
        
        employee.setValue(employeeName, forKey: "name")
        employeeInformation.birthday = birthday
        employee.type = employeeType
        
        do {
            try context.save()
            return (employee, nil)
            
        } catch let error {
            return (nil, error)
        }
    }
}
