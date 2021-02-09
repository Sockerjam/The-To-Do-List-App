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
        headerLabel.font = UIFont(name: "Helvetica", size: 15)
        headerLabel.textColor = .black
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        return headerLabel
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .white
        addSubview(headerLabel)
    }
    
    func configureHeader(with listModel:ListModel){
        headerLabel.text = listModel.weekday
    }
    
    private func setConstraints(){
        
        NSLayoutConstraint.activate([headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)])
    }
    
}
