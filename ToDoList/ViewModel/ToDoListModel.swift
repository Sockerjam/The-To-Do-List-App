import Foundation
import UIKit

protocol ToDoListModel {
    var itemModels: [ListModelSection] { get }
    func start(with dataSource: UICollectionViewDiffableDataSource<ListModelSection, ListModel>)
    func update(fromSearchKey searchKey: String?)
    func addNewItem(_ item: String, _ weekday: String)
    func deleteItem(at indexPath: IndexPath)
    func markAsDone(at indexPath: IndexPath)
    
// We don't use these anymore but even if we would, these are internal to the class and don't need to be exposed.
//  func sectionObjectInitialiser(_ weekday: String, _ item: ListModel)
//    var days:[String] {get}
}

extension ToDoListModel {
    
    func update(fromSearchKey searchKey: String? = nil) {
        update(fromSearchKey: searchKey)
    }
}
