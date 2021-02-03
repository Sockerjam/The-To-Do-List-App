//
//  CustomPickerView.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 03/02/2021.
//  Copyright © 2021 Niclas Jeppsson. All rights reserved.
//

import UIKit

class CustomPickerView: UIViewController {
    
    
    let pickerView:UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00)
        pickerView.layer.cornerRadius = 10
        pickerView.isHidden = true
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        return pickerView
    }()
    
    var selectedRowTitle:String = ""
    
    private let dayModel:ToDoListModel
    
    init(toDoListModel:ToDoListModel){
        self.dayModel = toDoListModel
        super.init(nibName: nil, bundle: nil)
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension CustomPickerView : UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRowTitle = dayModel.days[row]
    }
    
}

extension CustomPickerView : UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dayModel.days.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dayModel.days[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: dayModel.days[row], attributes: [NSAttributedString.Key.font:UIFont(name: "Helvetica", size: 15)!, NSAttributedString.Key.foregroundColor:UIColor.white])
        
        return attributedString
    }

    
    
}
