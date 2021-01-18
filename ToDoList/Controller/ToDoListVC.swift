//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 11/01/2021.
//

import UIKit
import CoreData

class ToDoListVC: UIViewController {
    
    let toDoListView = ToDoListView()
    
    let viewModel = ToDoListModel()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoListView.searchController.searchResultsUpdater = self
        toDoListView.searchController.searchBar.delegate = self
        
        toDoListView.navBarSetup()
        
        toDoListView.setupSwipeAction()
        toDoListView.collectionViewSetup()
        toDoListView.collectionViewConstraints(view)
        toDoListView.collectionView.delegate = self
        setupList()
        loadData()

    }
    
    func setupList(){
        
        viewModel.dataSource = UICollectionViewDiffableDataSource<viewModel.Section, ListModel>(collectionView: toDoListView.collectionView) {collectionView, indexPath, listModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableListCell", for: indexPath) as! CollectionViewCell
            cell.label.text = listModel.item
            
            return cell
        }
        
    }
    
//    func snapShot(_ listModel:[ListModel]){
//        
//        var snapShot = NSDiffableDataSourceSnapshot<Section, ListModel>()
//        snapShot.appendSections([.main])
//        snapShot.appendItems(listModel)
//        dataSource.apply(snapShot)
//    }
    
//    @objc func addButton(_ sender:UIButton){
//        
//        var textField = UITextField()
//        
//        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
//        
//        let action = UIAlertAction(title: "Add Item", style: .default) { alertAction in
//            
//            ///Check if text field is empy
//            if textField.text?.isEmpty == true{
//                
//                self.dismiss(animated: true)
//            } else {
//                
//                ///Create new NSManagedObject for DataModel
//                let newListItem = ListModel(context: self.context)
//                newListItem.item = textField.text
//                
//                ///Appends array with new object
//                self.viewModel.listItems.append(newListItem)
//                
//                ///Saves new Data through the Context
//                self.saveData()
//            }
//        }
//        
//        alert.addTextField {alertTextField in
//            alertTextField.placeholder = "Add New Item"
//            textField = alertTextField
//        }
//        
//        alert.addAction(action)
//        
//        present(alert, animated: true) {
//            
//        }
//    }
    
//    ///Saves Data to Persistent Container
//    func saveData(){
//        
//        do {
//            try context.save()
//        } catch {
//            print("Error saving \(error)")
//        }
//        ///Updates ListView
//        snapShot(viewModel.listItems)
//    }
    
    ///Loads Data from Persistent Container
    func loadData(with request: NSFetchRequest<ListModel> = ListModel.fetchRequest()){
        do{
            viewModel.listItems = try context.fetch(request)
        } catch {
            print("Error requesting data \(error)")
        }
        snapShot(viewModel.listItems)
    }
    


}

//MARK: - UICollectionView Delegate
extension ToDoListVC : UICollectionViewDelegate {
    
    ///Highlighted cell background
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundConfiguration?.backgroundColor = .systemTeal
    }
    
    ///Unhighlighted cell background
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundConfiguration?.backgroundColor = .white
    }
    
    ///Selected Cell interaction
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
}

//MARK: - SearchResultsUpdating
extension ToDoListVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
}

//MARK: - SearchBarDelegate Methods
extension ToDoListVC : UISearchBarDelegate {
    
    ///When user taps Search on keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request:NSFetchRequest<ListModel> = ListModel.fetchRequest()
        
        request.predicate = NSPredicate(format: "item CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true)]
        
       loadData(with: request)
    }
    
    ///When user taps Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadData()
    }
    
    ///Continious update of list as user types in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadData()
            
        } else {
        
        let request:NSFetchRequest<ListModel> = ListModel.fetchRequest()

        request.predicate = NSPredicate(format: "item CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true)]

        loadData(with: request)
    }
    
}
    
}
