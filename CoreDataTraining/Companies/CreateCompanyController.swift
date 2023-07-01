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

class CreateCompanyController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: CreateCompanyControllerDelegate?
    
    var company: Company? {
        didSet {
            guard let founded = company?.founded else { return }
            
            nameTextField.text = company?.name
            datePicker.date = founded
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
                setupCircularImageStyle()
            }
        }
    }
    
    private func setupCircularImageStyle() {
        companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        companyImageView.clipsToBounds = true
        companyImageView.layer.borderColor = UIColor.darkBlue.cgColor
        companyImageView.layer.borderWidth = 2
    }
    
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
        imageView.contentMode = .scaleAspectFill
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
        setupCancelButton()
        setupSaveButton(selector: #selector(handleSave))
    }
    
    private func setupUI() {
        let lightBlueBackgroundView = setupLightBlueBackgroundView(height: 350)
        
        view.addSubview(companyImageView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
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
            datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor)
        ])
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
        
        setupCircularImageStyle()
        dismiss(animated: true, completion: nil)
    }
    
    private func saveCompanyChanges() {
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company?.name = nameTextField.text
        company?.founded = datePicker.date
        
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 1)
            company?.imageData = imageData
        }
        
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
                
        if let companyImage = companyImageView.image {
            let imageData = companyImage.jpegData(compressionQuality: 1)
            company.setValue(imageData, forKey: "imageData")
        }
        
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
