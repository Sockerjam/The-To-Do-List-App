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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoListView.view = self
        toDoListView.toDoListModel = viewModel
        
        toDoListView.searchController.searchResultsUpdater = self
        toDoListView.searchController.searchBar.delegate = self
        
        toDoListView.navBarSetup()
        
        toDoListView.setupSwipeAction()
        toDoListView.collectionViewSetup()
        toDoListView.collectionViewConstraints(view)
        toDoListView.collectionView.delegate = self
        setupList()
        viewModel.loadData()

    }
    
    func setupList(){
        
        viewModel.dataSource = UICollectionViewDiffableDataSource<Section, ListModel>(collectionView: toDoListView.collectionView) {collectionView, indexPath, listModel in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableListCell", for: indexPath) as! CollectionViewCell
            cell.label.text = listModel.item
            
            return cell
        }
        
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
        
        viewModel.loadData(with: request)
    }
    
    ///When user taps Cancel
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.loadData()
    }
    
    ///Continious update of list as user types in search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            viewModel.loadData()
            
        } else {
        
        let request:NSFetchRequest<ListModel> = ListModel.fetchRequest()

        request.predicate = NSPredicate(format: "item CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true)]

            viewModel.loadData(with: request)
    }
    
}
    
}

//MARK: - Section Enum
extension ToDoListVC {
    enum Section {
        case main
    }
}
