//
//  CustomHeaderView.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 09/02/2021.
//  Copyright © 2021 Niclas Jeppsson. All rights reserved.
//

import UIKit

class CustomHeaderView: UICollectionReusableView {
    
    private let headerLabel:UILabel = {
        let headerLabel = UILabel()
        headerLabel.font = UIFont(name: "Helvetica", size: 30)
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

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(headerView)
        headerView.addSubview(headerLabel)
        setConstraints()
    }
    
    func configureHeader(with listModel:ListModelSection){
        headerLabel.text = listModel.sectionName
    }
    
    private func setConstraints(){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([headerView.leadingAnchor.constraint(equalTo: leadingAnchor), headerView.trailingAnchor.constraint(equalTo: trailingAnchor), headerView.topAnchor.constraint(equalTo: topAnchor), headerView.bottomAnchor.constraint(equalTo: bottomAnchor), headerView.heightAnchor.constraint(equalToConstant: 30), headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 15)])
    }
    
}
