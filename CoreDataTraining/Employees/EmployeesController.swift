//
//  EmployeesController.swift
//  CoreDataTraining
//
//  Created by Ömer Faruk Ercivan on 30.06.2023.
//

import UIKit
import CoreData

class IndentedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = rect.inset(by: insets)
        
        super.drawText(in: customRect)
    }
}

class EmployeesController: UITableViewController {
    let cellID = "cellid"
    
    var company: Company?
    var allEmployees = [[Employee]]()
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
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
    
    private func fetchEmployees() {
        guard let companyEmployee = company?.employees?.allObjects as? [Employee] else { return }
        allEmployees = []
        
        employeeTypes.forEach { employeeType in
            allEmployees.append(companyEmployee.filter { $0.type == employeeType })
        }
    }
    
    @objc private func handleAdd() {
        let createEmployeeController = CreateEmployeeController()
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        
        present(navController, animated: true, completion: nil)
    }
}
