//
//  CollectionViewCell.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 18/01/2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell, Identifiable {
  
  private let label: UILabel = {
    let l = UILabel()
    l.textColor = .black
    l.font = UIFont(name: "Helvetica", size: 17)
    l.translatesAutoresizingMaskIntoConstraints = false
    return l
  }()
  
  private let checkMark: UIImageView = {
    let c = UIImageView(image: UIImage(systemName: "checkmark"))
    c.tintColor = .blue
    c.translatesAutoresizingMaskIntoConstraints = false
    return c
  }()
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = .white
    contentView.addSubview(label)
    contentView.addSubview(checkMark)
    setContraints()
  }
  
    func configure(with listModel: ListModel) {
        label.text = listModel.item
        checkMark.isHidden = !listModel.done
  }
  
  private func setContraints() {
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
      label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
        checkMark.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
      checkMark.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
      checkMark.widthAnchor.constraint(equalToConstant: 20),
      checkMark.heightAnchor.constraint(equalToConstant: 15)
    ])
  }
}
