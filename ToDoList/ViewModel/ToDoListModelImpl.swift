//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 11/01/2021.
//

import UIKit
import CoreData

final class ToDoListModelImpl {
  
  private var dataSource: UICollectionViewDiffableDataSource<ListModelSection, ListModel>?
  
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  private var listItems = [ListModel]()
  
  private var sectionObjects = [ListModelSection]()
  
  private func loadData(with request: NSFetchRequest<ListModel> = ListModel.fetchRequest()){
    do{
      listItems = try context.fetch(request)
    } catch {
      print("Error requesting data \(error)")
    }
    snapShot(groupAndSort(items: listItems))
  }
  
  private func groupAndSort(items: [ListModel]) -> [ListModelSection] {
    
    let dict = Dictionary(grouping: items) { $0.onDay }
      .mapValues { items -> ListModelSection in
        let onDayIndex = WeekDays.longNames.firstIndex(of: items.first?.onDay ?? "") ?? 0
        return ListModelSection(sectionName: WeekDays.longNames[onDayIndex], items: items)
      }
    
    return dict.values.sorted {
      WeekDays.longNames.firstIndex(of: $0.sectionName) ?? 0 < WeekDays.longNames.firstIndex(of: $1.sectionName) ?? 0
    }
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
  
  private func snapShot(_ listModel: [ListModelSection]) {
    var snapShot = NSDiffableDataSourceSnapshot<ListModelSection, ListModel>()
    
    snapShot.appendSections(listModel)
    for item in listModel {
      snapShot.appendItems(item.items, toSection: item)
    }
    
    dataSource?.apply(snapShot, animatingDifferences: false)
  }
}


//MARK: - ToDoListModel
extension ToDoListModelImpl: ToDoListModel {
  var itemModels: [ListModelSection] {
    sectionObjects
  }
  
  var items:[ListModel] {
    listItems
  }
  
  
  func start(with dataSource: UICollectionViewDiffableDataSource<ListModelSection, ListModel>) {
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
    let toDo = ListModel(context: context)
    toDo.item = item
    switch weekday {
    case "Mon":
        toDo.onDay = "Monday"
    case "Tue":
        toDo.onDay = "Tuesday"
    case "Wed":
        toDo.onDay = "Wednesday"
    case "Thu":
        toDo.onDay = "Thursday"
    case "Fri":
        toDo.onDay = "Friday"
    default:
        return
    }
    ///Saves new Data through the Context
    saveData()
    loadData()
  }
  
  func deleteItem(at indexPath: IndexPath) {
    context.delete(deleteAndToggle(indexPath))
    saveData()
    loadData()
  }
  
  func markAsDone(at indexPath: IndexPath) {
    deleteAndToggle(indexPath).done.toggle()
    saveData()
    loadData()
  }
  
  // Finds correct item to delete and toggle by finding correct Section and correct Item in that Section
  private func deleteAndToggle (_ indexPath:IndexPath) -> ListModel {
    
    
    var itemArray = [ListModel]()
    
    for item in listItems {
      if item.onDay == dataSource?.snapshot().sectionIdentifiers[indexPath.section].sectionName {
        itemArray.append(item)
      }
    }
    
    let returnItem = itemFinder(with: itemArray[indexPath.item])
    
    return returnItem
  }
  
  private func itemFinder(with selectedItem: ListModel) -> ListModel {
    
    var returnItem:ListModel?
    
    for item in listItems {
      if item == selectedItem {
        returnItem = item
      }
    }
    
    guard let item = returnItem else {return ListModel()}
    
    return item
  }
  
}
