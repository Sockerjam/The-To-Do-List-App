//
//  AddItemVC.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 03/02/2021.
//  Copyright © 2021 Niclas Jeppsson. All rights reserved.
//

import UIKit

class AddItemVC: UIViewController {
    
    private enum Constant {
        static let textColor = UIColor.white
        static let backgroundColor = UIColor(red: 1, green: 0.70, blue: 0.42, alpha: 1)
        static let weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri"]
    }
    
    private let viewModel:ToDoListModel!
    
    var centerYConstraints:NSLayoutConstraint?
    var centerYConstraintsTextEdit:NSLayoutConstraint?
    
   var weekdayList:UISegmentedControl!
    
    private let viewBackground:UIColor = {
        let backgroundColor = UIColor.systemGray.withAlphaComponent(0.3)
        return backgroundColor
    }()
    
    private let customView:UIView = {
        let customView = UIView()
        customView.backgroundColor = Constant.backgroundColor
        customView.layer.cornerRadius = 10
        customView.translatesAutoresizingMaskIntoConstraints = false
        return customView
    }()
    
    private let headerLabel:UILabel = {
        let headerLabel = UILabel()
        headerLabel.text = "Add New To-Do Item"
        headerLabel.font = UIFont(name: "Helvetica", size: 0)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        headerLabel.textColor = Constant.textColor
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    
    let textField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Item Here"
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
        cancelButton.setTitleColor(Constant.textColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelItem), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()
    
    private let addItemButton:UIButton = {
        let addItemButton = UIButton()
        addItemButton.setAttributedTitle(.init(string: "Done"), for: .normal)
        addItemButton.titleLabel?.font = UIFont(name: "Helvetica", size: 15)
        addItemButton.setTitleColor(Constant.textColor, for: .normal)
        addItemButton.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
         return addItemButton
    }()
    
    private let weekdayListLabel:UILabel = {
        let weekdayListLabel = UILabel()
        weekdayListLabel.text = "Add Item For: "
        weekdayListLabel.textColor = Constant.textColor
        weekdayListLabel.font = UIFont(name: "Helvetive", size: 0)
        weekdayListLabel.font = UIFont.boldSystemFont(ofSize: 15)
        weekdayListLabel.translatesAutoresizingMaskIntoConstraints = false
        return weekdayListLabel
    }()
  
    
    init(with viewModel:ToDoListModel){
        self.viewModel = viewModel
        self.weekdayList = UISegmentedControl(items: Constant.weekDays)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackground
        textField.delegate = self
        setupSegmentedControl()
        setConstraints()
        changeConstraints(y: 0, condition: false)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        print("keyboard deinit")
    }
    
    private func changeConstraints(y:CGFloat, condition:Bool){
        
        if !condition {
            centerYConstraintsTextEdit?.isActive = false
            centerYConstraints = customView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            centerYConstraints?.isActive = true
        } else {
            centerYConstraints?.isActive = false
            centerYConstraintsTextEdit = customView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -y)
            centerYConstraintsTextEdit?.isActive = true
        }

    }
    
    @objc func keyboardWillShow(notification: NSNotification){
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            changeConstraints(y: keyboardSize.height/4, condition: true)
        }
        
        
    }
    
    private func setupSegmentedControl(){
        weekdayList.translatesAutoresizingMaskIntoConstraints = false
        weekdayList.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 15)!], for: .normal)
        weekdayList.addTarget(self, action: #selector(selectedDay), for: .valueChanged)
        
    }
    
    private func setConstraints(){
        
        view.addSubview(customView)
        
        customView.addSubview(headerLabel)
        customView.addSubview(textField)
        customView.addSubview(cancelButton)
        customView.addSubview(weekdayListLabel)
        customView.addSubview(weekdayList)
        customView.addSubview(addItemButton)
        
        NSLayoutConstraint.activate([
            customView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            customView.widthAnchor.constraint(equalToConstant: 300),
            customView.heightAnchor.constraint(equalToConstant: 200),
            headerLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10),
            textField.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: customView.centerYAnchor, constant: -30),
            textField.widthAnchor.constraint(equalToConstant: 250),
            textField.heightAnchor.constraint(equalToConstant: 30),
            cancelButton.trailingAnchor.constraint(equalTo: customView.trailingAnchor, constant: -25),
            cancelButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -2),
            weekdayListLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            weekdayListLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 15),
            weekdayList.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            weekdayList.topAnchor.constraint(equalTo: weekdayListLabel.bottomAnchor, constant: 15),
            weekdayList.widthAnchor.constraint(equalTo: customView.widthAnchor),
            addItemButton.leadingAnchor.constraint(equalTo: customView.leadingAnchor, constant: 25),
            addItemButton.bottomAnchor.constraint(equalTo: customView.bottomAnchor, constant: -2)
            
        ])
        
    }
    
    @objc private func selectedDay() {
    }
    
    @objc private func cancelItem(){
        dismiss(animated: true)
    }
    
    @objc private func addItem(){
        if weekdayList.selectedSegmentIndex >= 0 {
            
            let weekdayIndex = weekdayList.selectedSegmentIndex
            
            
            guard let text = textField.text,
                  !text.isEmpty else {
              dismiss(animated: UIView.areAnimationsEnabled)
              return
            }
            
            // Added parameter to addNewItem function
            viewModel.addNewItem(text, Constant.weekDays[weekdayIndex])
            dismiss(animated: true)
        }
        
    }
    
}

extension AddItemVC : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
}
