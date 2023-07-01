//
//  EmployeesController.swift
//  CoreDataTraining
//
//  Created by Ömer Faruk Ercivan on 30.06.2023.
//

import UIKit
import CoreData

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    let cellID = "cellid"
    
    var company: Company?
    var employees = [Employee]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkBlue
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        
        fetchEmployees()
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
    }
    
    func didAddEmployee(employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let employee = employees[indexPath.row]
        
//        cell.textLabel?.text = employee.name
        
        if let name = employee.name, let birtday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM dd, yyyy"
            
            cell.textLabel?.text = "\(name)     \(dateFormatter.string(from: birtday))"
        }
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        return cell
    }
    
    private func fetchEmployees() {
        guard let companyEmployee = company?.employees?.allObjects as? [Employee] else { return }
        
        self.employees = companyEmployee
        
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let request = NSFetchRequest<Employee>(entityName: "Employee")
//        
//        do {
//            let employees = try context.fetch(request)
//            self.employees = employees
//            
//        } catch let error {
//            print("Failed to fetch employees: ", error)
//        }
    }
    
    @objc private func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        
        present(navController, animated: true, completion: nil)
    }
}
