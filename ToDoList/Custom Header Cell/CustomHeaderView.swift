//
//  CustomHeaderView.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 09/02/2021.
//  Copyright © 2021 Niclas Jeppsson. All rights reserved.
//

import UIKit

class CustomHeaderView: UICollectionReusableView {
    
    static let headerID = "reusableHeaderView"
    
    
    private let headerLabel:UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = UIFont(name: "Helvetica", size: 20)
        headerLabel.textColor = .black
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()
    
    private let headerView:UIView = {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 1, green: 0.70, blue: 0.42, alpha: 0.2)
        headerView.layer.cornerRadius = 10
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addSubview(headerView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(with listModel:ListModelSection){
        
        headerLabel.text = listModel.sectionName
    }
    
    private func setConstraints(){
        
        headerView.addSubview(headerLabel)
        
        // Set High Priority For HeaderView To Avoid Constraint Issue
        let constraintHeight = NSLayoutConstraint(item: headerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 30)
        constraintHeight.priority = .defaultHigh
        
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor), headerView.trailingAnchor.constraint(equalTo: trailingAnchor), headerView.topAnchor.constraint(equalTo: topAnchor), headerView.bottomAnchor.constraint(equalTo: bottomAnchor), headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15), headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -2), constraintHeight
        ])
    }
    
}
