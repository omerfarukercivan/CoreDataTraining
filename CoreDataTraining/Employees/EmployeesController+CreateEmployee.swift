//
//  EmployeeController+CreateEmployee.swift
//  CoreDataTraining
//
//  Created by Ömer Faruk Ercivan on 3.07.2023.
//

import UIKit

extension EmployeesController: CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee) {
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        
        let row = allEmployees[section].count
        let insertionIndexPath = IndexPath(row: row, section: section)
        
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionIndexPath], with: .middle)
    }
}
