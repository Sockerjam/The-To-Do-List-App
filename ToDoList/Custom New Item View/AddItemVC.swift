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
      static let weekDays = WeekDays.shortNames
    }
    
    private let viewModel:ToDoListModel!
    
    var yConstraints:NSLayoutConstraint?
    var yConstraintsTextEdit:NSLayoutConstraint?
    
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
        headerLabel.text = "Add New Task Item"
        headerLabel.font = UIFont(name: "Helvetica", size: 0)
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        headerLabel.textColor = Constant.textColor
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    
    let textField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Task Here"
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
        weekdayListLabel.text = "Complete Task On: "
        weekdayListLabel.textColor = Constant.textColor
        weekdayListLabel.font = UIFont(name: "Helvetive", size: 0)
        weekdayListLabel.font = UIFont.boldSystemFont(ofSize: 15)
        weekdayListLabel.translatesAutoresizingMaskIntoConstraints = false
        return weekdayListLabel
    }()
    
    private let stackView:UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.backgroundColor = .clear
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        setupSegmentedControl()
        addSubviews()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewBackground
        
    }
    
    @objc private func keyboardWillShow(notification: NSNotification){
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillChangeFrameNotification {
            
            yConstraints?.isActive = false
            yConstraintsTextEdit = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -keyboardSize.height/4)
            yConstraintsTextEdit?.isActive = true
            
        }
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func setupSegmentedControl(){
        weekdayList.translatesAutoresizingMaskIntoConstraints = false
        weekdayList.setTitleTextAttributes([NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 15)!], for: .normal)
        weekdayList.addTarget(self, action: #selector(selectedDay), for: .valueChanged)
        
    }
    
    private func addSubviews(){
        view.addSubview(stackView)
        stackView.addArrangedSubview(customView)
        customView.addSubview(headerLabel)
        customView.addSubview(textField)
        customView.addSubview(cancelButton)
        customView.addSubview(weekdayListLabel)
        customView.addSubview(weekdayList)
        customView.addSubview(addItemButton)
        
        setConstraints()
    }
    
    private func setConstraints(){
        
        yConstraints = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        yConstraints?.isActive = true
        
        NSLayoutConstraint.activate([
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 200),
            stackView.widthAnchor.constraint(equalToConstant: 300),
            textField.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            textField.centerYAnchor.constraint(equalTo: stackView.centerYAnchor, constant: -30),
            textField.widthAnchor.constraint(equalToConstant: 250),
            textField.heightAnchor.constraint(equalToConstant: 30),
            headerLabel.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: customView.topAnchor, constant: 10),
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
        stackView.removeFromSuperview()
        yConstraintsTextEdit?.isActive = false
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
            stackView.removeFromSuperview()
            yConstraintsTextEdit?.isActive = false
            dismiss(animated: true)
        }
        
    }
    
}
