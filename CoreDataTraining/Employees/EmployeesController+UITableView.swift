//
//  EmployeeController+UITableView.swift
//  CoreDataTraining
//
//  Created by Ömer Faruk Ercivan on 3.07.2023.
//

import UIKit

extension EmployeesController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
        
        label.text = employeeTypes[section]
        label.backgroundColor = .lightBlue
        label.textColor = .darkBlue
        label.font = UIFont.systemFont(ofSize: 16)
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        if let name = employee.name, let birtday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM dd, yyyy"
            
            cell.textLabel?.text = "\(name) - \(dateFormatter.string(from: birtday))"
        }
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        
        return cell
    }
}
