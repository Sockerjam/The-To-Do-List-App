import Foundation
import UIKit

protocol ToDoListModel {
  var itemModels: [ListModel] { get }
  func start(with dataSource: UICollectionViewDiffableDataSource<ListModelSection, ListModel>)
  func update(fromSearchKey searchKey: String?)
  func addNewItem(_ item: String)
  func deleteItem(at indexPath: IndexPath)
  func markAsDone(at indexPath: IndexPath)
}

extension ToDoListModel {
  
  func update(fromSearchKey searchKey: String? = nil) {
    update(fromSearchKey: searchKey)
  }
}
