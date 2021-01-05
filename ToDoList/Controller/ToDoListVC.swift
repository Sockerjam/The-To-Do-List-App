//
//  ViewController.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 04/01/2021.
//

import UIKit

class ToDoListVC: UIViewController {
    
    var listItems:[ListViewModel] = []
    
    var userDefaults = UserDefaults()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    
    var dataSource:UICollectionViewDiffableDataSource<Section, ListViewModel>!
    
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
        
        collectionView.delegate = self
        
        navBarSetup()
        
        setupView()
    }
    
    func setupList(){
        
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, ListViewModel>
        { cell, indexPath, listViewModel in
            
            var cellConfig = cell.defaultContentConfiguration()
            cellConfig.text = listViewModel.toDoList
            cellConfig.textProperties.color = .black
            cellConfig.textProperties.font = UIFont(name: "Helvetica", size: 15)!
            cell.contentConfiguration = cellConfig
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, ListViewModel>(collectionView: collectionView) {collectionView, indexPath, listViewModel in
            let cell = collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: listViewModel)
            return cell
        }
        
        snapShot(listItems)
    }
    
    func snapShot(_ listViewModel:[ListViewModel]){
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, ListViewModel>()
        snapShot.appendSections([.main])
        snapShot.appendItems(listViewModel)
        dataSource.apply(snapShot)
    }
    
    func navBarSetup(){
        
        let navBarApperance = UINavigationBarAppearance()
        navBarApperance.backgroundColor = UIColor(red: 1.00, green: 0.70, blue: 0.42, alpha: 1.00)
        navBarApperance.largeTitleTextAttributes = [.foregroundColor:UIColor.white]
        navBarApperance.titleTextAttributes = [.foregroundColor:UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let buttonImage = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addButton(_:)))
        buttonImage.tintColor = .white
        navigationItem.rightBarButtonItem = buttonImage
    }
    
    @objc func addButton(_ sender:UIButton){
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { alertAction in
            
            self.listItems.append(ListViewModel(toDoList: textField.text))
            
            self.setupList()
            
            self.saveData()
            
        }
        
        alert.addTextField {alertTextField in
            alertTextField.placeholder = "Add New Item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true) {
            
        }
    }
    
    func setupView(){
        
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func saveData(){
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.listItems)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error handling encoding \(error)")
        }
    }
    
}

extension ToDoListVC : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundConfiguration?.backgroundColor = .systemTeal
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.backgroundConfiguration?.backgroundColor = .white
    }
    
}

extension ToDoListVC {
    
    enum Section {
        case main
    }
}
