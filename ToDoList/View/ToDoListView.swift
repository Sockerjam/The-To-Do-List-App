//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 13/01/2021.
//

import UIKit
import CoreData

class ToDoListView {
    
    private var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    var collectionView:UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var toDoListModel:ToDoListModel!
    var view:UIViewController!
    
    ///NavigationBar Setup
    func navBarSetup(){
    
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.backgroundColor = UIColor(red: 1.00, green: 0.70, blue: 0.42, alpha: 1.00)
        navBarApperance.largeTitleTextAttributes = [.foregroundColor:UIColor.white]
        navBarApperance.titleTextAttributes = [.foregroundColor:UIColor.white]
        
        view.navigationController?.navigationBar.standardAppearance = navBarApperance
        view.navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        view.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search To-Do's"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = UIBarStyle.black
        
        view.navigationItem.searchController = searchController
        
        view.definesPresentationContext = true
        
        let buttonImage = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButton(_:)))
        buttonImage.tintColor = .white
        view.navigationItem.rightBarButtonItem = buttonImage
        
    }

    
    ///CollectionViewList Design
    func collectionViewSetup() {
        
        configuration.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00)
        configuration.trailingSwipeActionsConfigurationProvider = {(indexPath) in
            
            ///Delete Button Setup
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
                self.swipeActionDelete(indexPath)
                completion(true)
            }
            
            ///Done Button Setup
            let doneAction = UIContextualAction(style: .normal, title: "Done") { (action, view, completion) in
                self.swipeActionDone(indexPath)
                completion(true)
            }
            deleteAction.backgroundColor = .red
            doneAction.backgroundColor = .green
            return UISwipeActionsConfiguration(actions: [deleteAction, doneAction])
            
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "reusableListCell")
        collectionView.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00)
        
    }
    
    ///CollectionViewListConstraints
    func collectionViewConstraints(_ view:UIView){
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        ///Layout Constraints for CollectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    ///Button Action From NavigationController
    @objc func addButton(_ sender:UIButton){
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { alertAction in
            
            ///Check if text field is empy
            if textField.text?.isEmpty == true{
                
                self.view.dismiss(animated: true)
            } else {
                
                ///Create new NSManagedObject for DataModel
                let newListItem = ListModel(context: self.toDoListModel.context)
                newListItem.item = textField.text

                ///Appends array with new object
                self.toDoListModel.listItems.append(newListItem)

                ///Saves new Data through the Context
                self.toDoListModel.saveData()
            }
        }
        
        alert.addTextField {alertTextField in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        view.present(alert, animated: true) {
            
        }
    }
    
    ///Deletes cell when user clicks Delete
    func swipeActionDelete(_ indexPath:IndexPath){

        ///Deletes selected item from the context
        toDoListModel.context.delete(toDoListModel.listItems[indexPath.item])
        
        ///Deletes selected item from listItem Array
        toDoListModel.listItems.remove(at: indexPath.item)
        
        ///Saves data to the persistent container
        toDoListModel.saveData()

    }
    
    ///Adds checkmark to completed items
    func swipeActionDone(_ indexPath:IndexPath){
        
        toDoListModel.listItems[indexPath.item].done = !toDoListModel.listItems[indexPath.item].done
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        
        if toDoListModel.listItems[indexPath.item].done {
            cell.checkMark.image = UIImage(systemName: "checkmark")
        } else {
            cell.checkMark.image = .none
        }
        
        toDoListModel.saveData()
        
    }
    
}
