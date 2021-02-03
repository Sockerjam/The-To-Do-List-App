//
//  AddItemVC.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 03/02/2021.
//  Copyright © 2021 Niclas Jeppsson. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController {
    
    private let customPickerView = CustomPickerView(toDoListModel: ToDoListModelImpl())
    
    
    
    private let viewBackground:UIColor = {
        let backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        return backgroundColor
    }()
    
    private let customView:UIView = {
        let customView = UIView()
        customView.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00)
        customView.layer.cornerRadius = 10
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    private let headerLabel:UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Add New To-Do Item"
        headerLabel.font = UIFont(name: "Helvetica", size: 20)
        headerLabel.textColor = .black
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    
    private let textField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add New Item"
        textField.textAlignment = .center
        textField.textColor = .black
        textField.font = UIFont(name: "Helvetica", size: 15)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let cancelButton:UIButton = {
       let cancelButton = UIButton()
        cancelButton.setAttributedTitle(.init(string: "Cancel"), for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        cancelButton.setTitleColor(.blue, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelItem), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private let addItemButton:UIButton = {
        let addItemButton = UIButton()
        addItemButton.setAttributedTitle(.init(string: "Add Item For: "),for: .normal)
        addItemButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        addItemButton.setTitleColor(.blue, for: .normal)
        addItemButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        return addItemButton
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackground
        setConstraints()
        
    }
    
    private func setConstraints(){
        
        view.addSubview(customPickerView.pickerView)
        view.addSubview(customView)
        customView.addSubview(headerLabel)
        customView.addSubview(textField)
        customView.addSubview(cancelButton)
        customView.addSubview(addItemButton)
        
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            customView.widthAnchor.constraint(equalToConstant: 300),
            customView.heightAnchor.constraint(equalToConstant: 150),
            headerLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            textField.widthAnchor.constraint(equalToConstant: 250),
            textField.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -25),
            cancelButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -10),
            addItemButton.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 25),
            addItemButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -10),
            customPickerView.pickerView.topAnchor.constraint(equalTo: customView.bottomAnchor),
            customPickerView.pickerView.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            customPickerView.pickerView.widthAnchor.constraint(equalToConstant: 250),
            customPickerView.pickerView.heightAnchor.constraint(equalToConstant: 100)
            
        ])
        
    }
    
    @objc private func cancelItem(){
        dismiss(animated: true)
        customPickerView.pickerView.isHidden = true
    }
    
    @objc private func addItem(){
        customPickerView.pickerView.isHidden = false
        
    }
    
}
