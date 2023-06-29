//
//  CreateCompanyController.swift
//  CoreDataTraining
//
//  Created by Ömer Faruk Ercivan on 26.06.2023.
//

import UIKit
import CoreData

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var delegate: CreateCompanyControllerDelegate?
    var company: Company? {
        didSet {
            guard let founded = company?.founded else { return }
            
            nameTextField.text = company?.name
            datePicker.date = founded
        }
    }
    
    let lightBlueBackgroundView: UIView = {
        let bg = UIView()
        
        bg.backgroundColor = .lightBlue
        bg.translatesAutoresizingMaskIntoConstraints = false
        
        return bg
    }()
    
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        
        dp.datePickerMode = .date
        dp.preferredDatePickerStyle = .wheels
        dp.translatesAutoresizingMaskIntoConstraints = false
        
        return dp
    }()
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectorPhoto)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company == nil ? "Create Company" : "Edit Company"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkBlue
        
        setupUI()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    private func setupUI() {
        view.addSubview(lightBlueBackgroundView)
        view.addSubview(companyImageView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 350),
            
            companyImageView.topAnchor.constraint(equalTo: view.topAnchor),
            companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            companyImageView.heightAnchor.constraint(equalToConstant: 100),
            companyImageView.widthAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            datePicker.leftAnchor.constraint(equalTo: view.leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: view.rightAnchor),
            //            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor)
        ])
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        if company == nil {
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    @objc private func handleSelectorPhoto() {
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func saveCompanyChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let saveError {
            print("Failed to save company changes:", saveError)
        }
    }
    
    private func createCompany() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        company.setValue(nameTextField.text, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        
        do {
            try context.save()
            
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }
        } catch let saveError {
            print("Failed to save company: ", saveError)
        }
    }
}
