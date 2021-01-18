//
//  CollectionViewCell.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 18/01/2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    let label = UILabel()
    let checkMark = UIView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelDesign()
        checkMarkDesign()
        
        labelConstraints()
        checkMarkConstraints()
        
        
    }
    
    func labelDesign(){
        
        label.textColor = .black
        label.font = UIFont(name: "Helvetica", size: 17)
        
        
    }
    
    func checkMarkDesign(){
        
        checkMark.largeContentImage = UIImage(systemName: "checkmark")
                
        
    }
    
    func labelConstraints(){
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15), label.topAnchor.constraint(equalTo: topAnchor, constant: 15)])
        
    }
    
    func checkMarkConstraints(){
        
        addSubview(checkMark)
        
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([checkMark.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15),checkMark.topAnchor.constraint(equalTo: topAnchor, constant: 15), checkMark.widthAnchor.constraint(equalToConstant: 20), checkMark.heightAnchor.constraint(equalToConstant: 20)])
        
    }

}
