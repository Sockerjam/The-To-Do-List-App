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
  
  private enum Constants {
    static let workableWeekDays = 1...5
  }
  
  private lazy var weekDays: [String] = {
    Constants.workableWeekDays.map {
      weekdayNameFrom(weekdayNumber: $0)
    }
  }()
    
    // MARK: Private
    
    ///Loads Data from Persistent Container
  private func loadData(with request: NSFetchRequest<ListModel> = ListModel.fetchRequest()){
    do{
      listItems = try context.fetch(request)
    } catch {
      print("Error requesting data \(error)")
    }
    snapShot(groupAndSort(items: listItems))
  }
  
    // dict = ["Mon": [ListModel, ListModel], "Tue":[ListModel, ListModel], etc]
  private func groupAndSort(items: [ListModel]) -> [ListModelSection] {
   let dict = Dictionary(grouping:items) { $0.onDay }
    print(dict)
    
    for (day, item) in dict {
        if !sectionObjects.contains(ListModelSection(sectionName: day ?? "0", items: item)) {
            sectionObjects.append(ListModelSection(sectionName: day ?? "0", items: item))
        }
        }
    
    
//    return weekDays.map {
//    if let items = dict[$0] {
//        return ListModelSection(sectionName: $0, items: items)
//    }
//  }
    
    return sectionObjects
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
      toDo.onDay = weekday
      ///Saves new Data through the Context
      saveData()
      loadData()
    }
    
    /// Initlialises the sectionObject property with the aim of having no duplicate weekdays - it's required to not have duplicate header section names
  // I believe this can go as we took care of avoiding day repetition when adding the item to core data already; We should have our datasource (local or network) as the single source of truth and always and only refer to that to check what exists or not.
  
//    func sectionObjectInitialiser(_ weekday: String, _ item: ListModel){
//
//        var index:Int?
//
//        for object in 0..<sectionObjects.count {
//
//            if sectionObjects[object].sectionName == weekday {
//                index = object
//                break
//            }
//        }
//
//        if let indexMatch = index {
//            sectionObjects[indexMatch].items.append(item)
//        } else {
//            sectionObjects.append(ListModelSection(sectionName: weekday, items: [item]))
//        }
//    }
    
    func deleteItem(at indexPath: IndexPath) {
        context.delete(listItems[indexPath.item])
        listItems.remove(at: indexPath.item)
        saveData()
        loadData()
    }
    
    func markAsDone(at indexPath: IndexPath) {
        listItems[indexPath.item].done.toggle()
        saveData()
        loadData()
    }
}

extension ToDoListModelImpl {
  
   private func weekdayNameFrom(weekdayNumber: Int) -> String {
      let calendar = Calendar.current
      let dayIndex = ((weekdayNumber - 1) + (calendar.firstWeekday - 1)) % 7
      return calendar.shortWeekdaySymbols[dayIndex]
  }
}
