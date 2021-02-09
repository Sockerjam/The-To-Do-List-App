//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 11/01/2021.
//

import UIKit
import CoreData

final class ToDoListModelImpl {
    
    private var dataSource: UICollectionViewDiffableDataSource<Sections, ListModel>?
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var listItems = [ListModel]()
    
    private var sectionObjects = [ListModelSection]()
    
    // MARK: Private
    
    ///Loads Data from Persistent Container
    private func loadData(with request: NSFetchRequest<ListModel> = ListModel.fetchRequest()){
        do{
            listItems = try context.fetch(request)
        } catch {
            print("Error requesting data \(error)")
        }
        snapShot(listItems)
    }
    
    // And although this could well be part of the function above, I think it ads clarity if we encapsualte the logic like this
    private func makeRequest(text: String) -> NSFetchRequest<ListModel>  {
        let request: NSFetchRequest<ListModel> = ListModel.fetchRequest()
        request.predicate = NSPredicate(format: "item CONTAINS[cd] %@", text)
        request.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true)]
        return request
    }
    
    ///Saves Data to Persistent Container
    private func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
    }
    
    private func snapShot(_ listModel: [ListModel]) {
        var snapShot = NSDiffableDataSourceSnapshot<Sections, ListModel>()
        
        snapShot.appendSections([.Monday])
        
        snapShot.appendItems(listModel)
        dataSource?.apply(snapShot, animatingDifferences: false)
    }
}


//MARK: - ToDoListModel
extension ToDoListModelImpl: ToDoListModel {    
    
    var itemModels: [ListModel] {
        listItems
    }
    
    func start(with dataSource: UICollectionViewDiffableDataSource<Sections, ListModel>) {
        self.dataSource = dataSource
        loadData()
    }
    
    // This new func + refactoring allows to avoid code repetition. The optionality + guard eliminates the need of force unwrapping the searchBar.text in the VC class - Force unwrapping is a huge cause of crashes and def. someting to avoid in most csses
    
    func update(fromSearchKey searchKey: String? = nil) {
        guard let text = searchKey,
              !text.isEmpty else {
            loadData()
            return
        }
        loadData(with: makeRequest(text: text))
    }
    
    func addNewItem(_ item: String, _ weekday: String) {
        //Create new NSManagedObject for DataModel
        let newListItem = ListModel(context: context)
        newListItem.item = item
        newListItem.weekday = weekday
        ///Appends array with new object
        listItems.append(newListItem)
        ///Saves new Data through the Context
        saveData()
        loadData()
    }
    
    func deleteItem(at indexPath: IndexPath) {
        context.delete(listItems[indexPath.item])
        saveData()
        loadData()
    }
    
    func markAsDone(at indexPath: IndexPath) {
        listItems[indexPath.item].done.toggle()
        saveData()
        loadData()
    }
}
