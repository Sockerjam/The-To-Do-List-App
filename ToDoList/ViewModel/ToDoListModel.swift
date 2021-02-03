import Foundation
import UIKit

protocol ToDoListModel {
  var itemModels: [ListModel] { get }
  func start(with dataSource: UICollectionViewDiffableDataSource<ListModelSection, ListModel>)
  func update(fromSearchKey searchKey: String?)
  func addNewItem(_ item: String)
  func deleteItem(at indexPath: IndexPath)
  func markAsDone(at indexPath: IndexPath)
    
    var days:[String] {get}
}

extension ToDoListModel {
  
  func update(fromSearchKey searchKey: String? = nil) {
    update(fromSearchKey: searchKey)
  }
}

extension ToDoListModel {
    
    var days:[String] {
       ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
    }
}
