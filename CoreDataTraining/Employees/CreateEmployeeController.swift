//
//  CreateEmployeeController.swift
//  CoreDataTraining
//
//  Created by Ömer Faruk Ercivan on 30.06.2023.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    var delegate: CreateEmployeeControllerDelegate?
    var company: Company?
    var employee: Employee?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Birthday"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        
        textField.placeholder = "MM/DD/YYYY"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let employeeTypeSegmentedControl: UISegmentedControl = {
        let types = [
            EmployeeType.Executive.rawValue,
            EmployeeType.SeniorManagement.rawValue,
            EmployeeType.Staff.rawValue
        ]
        let sc = UISegmentedControl(items: types)
        
        sc.selectedSegmentIndex = 0
        sc.translatesAutoresizingMaskIntoConstraints = false
        
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        
        setupUI()
        setupCancelButton()
        setupSaveButton(selector: #selector(handleSave))
    }
    
    private func setupUI() {
        _ = setupLightBlueBackgroundView(height: 150)
        
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(birthdayLabel)
        view.addSubview(birthdayTextField)
        view.addSubview(employeeTypeSegmentedControl)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            birthdayLabel.widthAnchor.constraint(equalToConstant: 100),
            birthdayLabel.heightAnchor.constraint(equalToConstant: 50),
            
            birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor),
            birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor),
            birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor),
            
            employeeTypeSegmentedControl.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor),
            employeeTypeSegmentedControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            employeeTypeSegmentedControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            employeeTypeSegmentedControl.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    @objc private func handleSave() {
        guard let employeeName = nameTextField.text else { return }
        guard let company = self.company else { return }
        guard let birthdayText = birthdayTextField.text else { return }
        guard let employeeType = employeeTypeSegmentedControl.titleForSegment(at: employeeTypeSegmentedControl.selectedSegmentIndex) else { return }
        
        if birthdayText.isEmpty || employeeName.isEmpty {
            showError(title: "Empty Text Field", message: "Empty fields are not allowed!")
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Bad Date", message: "Birthday date entered no valid")
            return
        }
        
        let tupple = CoreDataManager.shared.createEmployee(employeeName: employeeName, company: company, birthday: birthdayDate, employeeType: employeeType)
        
        if let error = tupple.1 {
            print(error)
        } else {
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: tupple.0!)
            }
        }
    }
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
