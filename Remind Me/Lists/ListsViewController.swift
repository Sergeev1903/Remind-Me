//
//  AllListsViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 16.06.2023.
//

import UIKit

class ListsViewController: UITableViewController {
  
  // MARK: - Properties
  var noteList: [NoteList] = [list1, list2, list3, list4]
  let cellID = "AllListsCell"
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "All Lists"
    
    configureNavigationBar()
    configureTableView()
  }
  
  
  // MARK: - Private methods
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  private func configureTableView() {
    tableView.register(UITableViewCell.self,
                       forCellReuseIdentifier: cellID)
  }
  
  private func edit(_ item: NoteList) {
    guard let vc = storyboard?.instantiateViewController(
      withIdentifier: String(describing: ListDetailViewController.self))
            as? ListDetailViewController else {
      return
    }
    vc.editItemDelegate = self
    vc.title = "Edit List"
    vc.editItem = item
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  // MARK: - @IBActions
  @IBAction func addItem() {
    guard let vc = storyboard?.instantiateViewController(
      withIdentifier: String(describing: ListDetailViewController.self))
            as? ListDetailViewController else {
      return
    }
    vc.addItemDelegate = self
    vc.title = "Add List"
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  // MARK: - Table view data source
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return noteList.count
    }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(
        withIdentifier: cellID, for: indexPath)
      let item = noteList[indexPath.row]
      cell.textLabel?.text = item.name
      cell.imageView?.image = UIImage(systemName: item.icon)
      cell.accessoryType = .detailDisclosureButton
      return cell
    }
  
 
  // MARK: - Table view dalegate
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
    
      guard let vc = storyboard?.instantiateViewController(
        withIdentifier: String(describing: NotesViewController.self))
              as? NotesViewController else {
        return
      }
      let itemName = noteList[indexPath.row].name
      vc.title = itemName
      navigationController?.pushViewController(vc, animated: true)
  }
  
  override func tableView(
    _ tableView: UITableView,
    accessoryButtonTappedForRowWith indexPath: IndexPath) {
      let item = noteList[indexPath.row]
      edit(item)
    }
  
  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath) {
      
      noteList.remove(at: indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
  
}


// MARK: - AddItemListDetailViewControllerDelegate
extension ListsViewController: AddItemListDetailViewControllerDelegate {
  
  func addItemListDetailViewController(
    _ controller: ListDetailViewController,
    didFinishAdding item: NoteList) {
    
    let newRowIndex = noteList.count
    noteList.append(item)
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    navigationController?.popViewController(animated:true)
  }
  
  func addItemListDetailViewControllerDidCancel(
    _ controller: ListDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
}


// MARK: - EditItemListDetailViewControllerDelegate
extension ListsViewController: EditItemListDetailViewControllerDelegate {
  
  func editItemListDetailViewController(
    _ controller: ListDetailViewController,
    didFinishEditing item: NoteList) {
      
      // get indexPath for current edit item
      if let index = noteList.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          cell.textLabel?.text = item.name
        }
      }
      navigationController?.popViewController(animated:true)
  }
  
  func editItemListDetailViewControllerDidCancel(
    _ controller: ListDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
}

