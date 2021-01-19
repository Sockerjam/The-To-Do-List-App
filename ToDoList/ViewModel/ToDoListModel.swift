//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 11/01/2021.
//

import UIKit
import CoreData

class ToDoListModel {
    
    var dataSource:UICollectionViewDiffableDataSource<Section, ListModel>!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var listItems:[ListModel] = []
    
    func snapShot(_ listModel:[ListModel]){
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, ListModel>()
        snapShot.appendSections([.main])
        snapShot.appendItems(listModel)
        dataSource.apply(snapShot)
    }
    
    ///Saves Data to Persistent Container
    func saveData(){
        
        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
        ///Updates ListView
        snapShot(listItems)
    }
    
    ///Loads Data from Persistent Container
    func loadData(with request: NSFetchRequest<ListModel> = ListModel.fetchRequest()){
        do{
            listItems = try context.fetch(request)
        } catch {
            print("Error requesting data \(error)")
        }
        snapShot(listItems)
    }
    
}

//MARK: - Section Enum
extension ToDoListModel {
    enum Section {
        case main
    }
}
