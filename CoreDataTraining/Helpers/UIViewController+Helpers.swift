//
//  UIViewController+Helpers.swift
//  CoreDataTraining
//
//  Created by Ömer Faruk Ercivan on 30.06.2023.
//

import UIKit

extension UIViewController {
    
    func setupLightBlueBackgroundView(height: CGFloat) -> UIView {
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        
        NSLayoutConstraint.activate([
            lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            lightBlueBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
            lightBlueBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        return lightBlueBackgroundView
    }
    
    func setupPlusButtonInNavBar(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus"), style: .plain, target: self, action: selector)
    }
    
    func setupCancelButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    func setupSaveButton(selector: Selector) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: selector)
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}
