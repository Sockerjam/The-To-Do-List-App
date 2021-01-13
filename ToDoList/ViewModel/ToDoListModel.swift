//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 11/01/2021.
//

import UIKit

struct ToDoListModel : Hashable {
    
    var listItems:[ListModel] = []
    
}

struct WeekdaySections : Hashable {
    
    var weekday:String
    var listItem:[ListItems]
    
}
