//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Niclas Jeppsson on 13/01/2021.
//

import UIKit

final class ToDoListViewController: UIViewController {
  
  private enum Constants {
    static let titleColor = UIColor.white
    static let barBackgroundColor = UIColor(red: 1, green: 0.70, blue: 0.42, alpha: 1)
    static let deleteActionBackgroundColor = UIColor(red: 1.00, green: 0.27, blue: 0.27, alpha: 1.00)
    static let doneActionBackgroundColor = UIColor(red: 0.51, green: 0.66, blue: 0.36, alpha: 1.00)
    static let collectionViewBackgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00)
  }
  
  // MARK: Private properties
  
  private lazy var layout: UICollectionViewCompositionalLayout = {
    var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
    configuration.backgroundColor = UIColor(red: 0.99, green: 0.97, blue: 0.91, alpha: 1.00)
    configuration.trailingSwipeActionsConfigurationProvider = {(indexPath) in
      
      ///Delete Button Setup
      let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, completion) in
        self?.swipeActionDelete(indexPath)
        completion(true)
      }
      
      ///Done Button Setup
      let doneAction = UIContextualAction(style: .normal, title: "Done") { [weak self] (action, view, completion) in
        self?.swipeActionDone(indexPath)
        completion(true)
      }
      deleteAction.backgroundColor = Constants.deleteActionBackgroundColor
      doneAction.backgroundColor = Constants.doneActionBackgroundColor
      return UISwipeActionsConfiguration(actions: [deleteAction, doneAction])
    }
    
    return UICollectionViewCompositionalLayout.list(using: configuration)
  }()
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "reusableListCell")
    collectionView.backgroundColor = Constants.collectionViewBackgroundColor
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.delegate = self
    return collectionView
  }()
  
  private lazy var buttonItem: UIBarButtonItem = {
    let item = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapAddButton(_:)))
    item.tintColor = .white
    return item
  }()
  
  private lazy var searchController: UISearchController = {
    let searchController = UISearchController(searchResultsController: nil)
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Search To-Do's"
    searchController.searchBar.tintColor = .white
    searchController.searchBar.barStyle = UIBarStyle.black
    searchController.searchResultsUpdater = self
    return searchController
  }()
  
  private lazy var dataSource = UICollectionViewDiffableDataSource<ListModelSection, ListModel>(collectionView: collectionView) { collectionView, indexPath, listModel in
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reusableListCell", for: indexPath) as? CollectionViewCell else {
      assertionFailure("Unable to dequeue colleciton view cell")
      return nil
    }
    cell.configure(with: self.toDoListModel.itemModels[indexPath.item])
    return cell
}
  
  private let toDoListModel: ToDoListModel
    private let addItemVC: AddItemVC
  
  // MARK: Lifecycle
  
  init(viewModel: ToDoListModel) {
    self.toDoListModel = viewModel
    self.addItemVC = AddItemVC(with: viewModel)
    super.init(nibName: nil, bundle: nil)
    setConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidAppear(_ animated: Bool)  {
    super.viewDidAppear(animated)
    navBarSetup()
    toDoListModel.start(with: dataSource)
  }
  
  // MARK: Private functions
  
  private func navBarSetup(){
    let navBarApperance = UINavigationBarAppearance()
    navBarApperance.backgroundColor = Constants.barBackgroundColor
    navBarApperance.largeTitleTextAttributes = [.foregroundColor: Constants.titleColor]
    navBarApperance.titleTextAttributes = [.foregroundColor: Constants.titleColor]
    
    navigationController?.navigationBar.standardAppearance = navBarApperance
    navigationController?.navigationBar.scrollEdgeAppearance = navBarApperance
    navigationItem.searchController = searchController
    navigationItem.rightBarButtonItem = buttonItem
    definesPresentationContext = true
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  ///CollectionViewListConstraints
  private func setConstraints(){
    view.addSubview(collectionView)
    ///Layout Constraints for CollectionView
    NSLayoutConstraint.activate([
      collectionView.topAnchor.constraint(equalTo: view.topAnchor),collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor), collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  @objc private func didTapAddButton(_ sender: UIButton){
    
    // Moved this function from the global scope - alertController was only initialised once causing placeholder text do dissapear
    let alertController: UIAlertController = {
      var textField = UITextField()
      let alert = UIAlertController(title: "Add New To-Do Item", message: "", preferredStyle: .alert)
      alert.addTextField { alertTextField in
        alertTextField.placeholder = "Add New Item"
          textField = alertTextField
      }
      
      let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] alertAction in
        guard let text = textField.text,
              !text.isEmpty else {
          self?.dismiss(animated: UIView.areAnimationsEnabled)
          return
        }
        self?.toDoListModel.addNewItem(text)
      }
      
      alert.addAction(action)
      return alert
    }()
    addItemVC.modalPresentationStyle = .overCurrentContext
    addItemVC.modalTransitionStyle = .crossDissolve
    present(addItemVC, animated: true) {
    }
  }
  
  private func swipeActionDelete(_ indexPath:IndexPath){
    toDoListModel.deleteItem(at: indexPath)
  }
  
  private func swipeActionDone(_ indexPath:IndexPath){
    toDoListModel.markAsDone(at: indexPath)
  }
}

//MARK: - UICollectionView Delegate
extension ToDoListViewController: UICollectionViewDelegate {
  
  ///Highlighted cell background
  func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
    cell.backgroundColor = .systemTeal
  }
  
  ///Unhighlighted cell background
  func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
    cell.backgroundColor = .white
  }
}

//MARK: - SearchResultsUpdating
extension ToDoListViewController : UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    toDoListModel.update(fromSearchKey: searchController.searchBar.text)
  }
    
}
