//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 13/01/2021.
//

import UIKit

class ToDoListView {
    
    var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    var swipeAction1 = UIContextualAction()
    var collectionView:UICollectionView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var toDoListModel:ToDoListModel!
    var view:UIViewController!
    
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
    
    func setupSwipeAction(){
        
        swipeAction1 = UIContextualAction(style: .normal, title: "Done", handler: { action, view, completion in
            completion(true)
        })
    }
    
    func collectionViewSetup() {
        
        configuration.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00)
        configuration.trailingSwipeActionsConfigurationProvider = {(indexPath) in
            self.swipeAction1.backgroundColor = .systemGreen
            return UISwipeActionsConfiguration(actions: [self.swipeAction1])
        }
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "reusableListCell")
        collectionView.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00)
        
    }
    
    func collectionViewConstraints(_ view:UIView){
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        ///Layout Constraints for CollectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
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
    
    func swipeActionHandler(){
        
        
    }
    
    
    
}
