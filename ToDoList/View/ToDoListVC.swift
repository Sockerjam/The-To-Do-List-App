//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 11/01/2021.
//

import UIKit
import CoreData

class ToDoListVC: UIViewController {
    
//    let weekdaySection = WeekdaySections()
    
//    var viewModel = ToDoListModel()
    
    var listItems:[ListItems] = []
    
    var weekdays:[WeekdaySections] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var dataSource:UICollectionViewDiffableDataSource<WeekdaySections, ListItems>!
    
    var collectionView:UICollectionView = {
        
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00)
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weekdays = [
            WeekdaySections(weekday: "Monday", listItem: listItems
            ), WeekdaySections(weekday: "Tuesday", listItem: [ListItems(items: "Call Mamma"), ListItems(items: "Eat Food")]
            )]
        
        collectionView.delegate = self
        searchController.searchBar.delegate = self
        
        navBarSetup()
        
        setupView()
        
        setupList()
        
//        loadData()
        
        snapShot(weekdays)

    }
    
    func navBarSetup(){
        
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.backgroundColor = UIColor(red: 1.00, green: 0.70, blue: 0.42, alpha: 1.00)
        navBarApperance.largeTitleTextAttributes = [.foregroundColor:UIColor.white]
        navBarApperance.titleTextAttributes = [.foregroundColor:UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search To-Do's"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = UIBarStyle.black
        
        navigationItem.searchController = searchController
        
        definesPresentationContext = true
        
        let buttonImage = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButton(_:)))
        buttonImage.tintColor = .white
        navigationItem.rightBarButtonItem = buttonImage
        
    }
    
    func setupView(){
        
        view.addSubview(collectionView)
    
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        ///Layout Constraints for CollectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setupList(){
        
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, ListItems>
        { cell, indexPath, listModel in
            
            var cellConfig = cell.defaultContentConfiguration()
            cellConfig.text = listModel.items
            cellConfig.textProperties.color = .black
            cellConfig.textProperties.font = UIFont(name: "Helvetica", size: 15)!
            cell.contentConfiguration = cellConfig
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<WeekdaySections, ListItems>(collectionView: collectionView) {collectionView, indexPath, listModel in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: listModel)
            return cell
        }
        
    }
    
    func snapShot(_ listModel:[WeekdaySections]){
        
        var snapShot = NSDiffableDataSourceSnapshot<WeekdaySections, ListItems>()
        snapShot.appendSections(listModel)
        for items in listModel {
            snapShot.appendItems(items.listItem, toSection: items)
        }
       dataSource.apply(snapShot)
    }
    
    @objc func searchButtonPressed(_ sender:UIButton){
        
        searchController.isActive = true
    }
    
    @objc func addButton(_ sender:UIButton){
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { alertAction in
            
            ///Check if text field is empy
            if textField.text?.isEmpty == true{
                
                self.dismiss(animated: true)
           
            } else {
                
                self.listItems.append(ListItems(items: textField.text!))
                ///Create new NSManagedObject for DataModel
//                let newListItem = ListModel(context: self.context)
//                newListItem.item = textField.text
                
                ///Appends array with new object
//                self.viewModel.listItems.append(newListItem)
//                self.listItems.append(newListItem)
                
                ///Saves new Data through the Context
//                self.saveData()
                
                self.snapShot(self.weekdays)
            }
        }
        
        alert.addTextField {alertTextField in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true) {
            
        }
    }
    
    ///Saves Data to Persistent Container
    func saveData(){
        
        do {
            try context.save()
        } catch {
            print("Error saving \(error)")
        }
        ///Updates ListView
//        snapShot()
    }
    
    ///Loads Data from Persistent Container
    func loadData(with request: NSFetchRequest<ListModel> = ListModel.fetchRequest()){
        do{
            let item = try context.fetch(request)
        } catch {
            print("Error requesting data \(error)")
        }
//        snapShot(viewModel.listItems)
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

//MARK: - Section Enum
extension ToDoListVC {
    enum Section {
        case main
    }
}
