//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 11/01/2021.
//

import UIKit

class ToDoListModel {
    
    var listItems:[ListModel] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataSource:UICollectionViewDiffableDataSource<ToDoListVC.Section, ListModel>!
    
}

class weekdaySections {
    
    var weekday:String?
    var listItem:[ToDoListModel]
    
    init(weekday:String, listItem:[ToDoListModel]){
        self.weekday = weekday
        self.listItem = listItem
    }
}
