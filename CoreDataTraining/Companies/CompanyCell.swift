//
//  Company Cell.swift
//  CoreDataTraining
//
//  Created by Ömer Faruk Ercivan on 30.06.2023.
//

import UIKit

class CompanyCell: UITableViewCell {
    var company: Company? {
        didSet {
            nameFoundedDateLabel.text = company?.name
            
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data: imageData)
            }
            
            if let name = company?.name, let founded = company?.founded {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMMM dd, yyyy"
                
                let foundedDateString = dateFormatter.string(from: founded)
                
                let dateString = "\(name) - Founded: \(foundedDateString)"
                
                nameFoundedDateLabel.text = dateString
            } else {
                nameFoundedDateLabel.text = company?.name
            }
        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 2
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tealColor
        
        addSubview(companyImageView)
        addSubview(nameFoundedDateLabel)
        
        NSLayoutConstraint.activate([
            companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            companyImageView.heightAnchor.constraint(equalToConstant: 40),
            companyImageView.widthAnchor.constraint(equalToConstant: 40),
            companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor),
            nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8),
            nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor),
            nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
