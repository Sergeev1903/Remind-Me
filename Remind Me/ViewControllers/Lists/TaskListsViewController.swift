//
//  AllListsViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 16.06.2023.
//

import UIKit

class TaskListsViewController: UITableViewController {
  
  // MARK: - Properties
  var dataModel: DataModel!
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "All Task Lists"
    configureNavigationBar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    // load last screen
    navigationController?.delegate = self
    
    let index = dataModel.indexOfSelectedList
    if index >= 0 && index < dataModel.lists.count {
      let list = dataModel.lists[index]
      
      guard let vc = storyboard?.instantiateViewController(
        withIdentifier: String(describing: TasksViewController.self))
              as? TasksViewController else {
        return
      }
      vc.title = list.name
      vc.taskList = list
      navigationController?.pushViewController( vc, animated: true)
    }
  }
  
  
  // MARK: - Private methods
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    
    let titleImage = UIImageView()
    titleImage.image = #imageLiteral(resourceName: "icons8-tick-tick-96()")
    titleImage.contentMode = .scaleAspectFill
    let logoNavigationBar = UIBarButtonItem(customView: titleImage)
    navigationItem.leftBarButtonItem = logoNavigationBar
  }
  
  private func edit(_ item: TaskList) {
    guard let vc = storyboard?.instantiateViewController(
      withIdentifier: String(describing: TaskListDetailViewController.self))
            as? TaskListDetailViewController else {
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
      withIdentifier: String(describing: TaskListDetailViewController.self))
            as? TaskListDetailViewController else {
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
      return dataModel.lists.count
    }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AllListsCell")
      
      let item = dataModel.lists[indexPath.row]
      cell.textLabel?.text = item.name
      cell.imageView?.image = UIImage(systemName: item.icon)
      
      let notDoneItems = item.countUncheckedItems()
      if item.items.count == 0 {
        cell.detailTextLabel?.text = "empty list"
      } else {
        cell.detailTextLabel?.text = notDoneItems == 0 ? "all done": "\(notDoneItems) not done"
      }
      
      cell.accessoryType = .detailDisclosureButton
      return cell
    }
  
  // MARK: - Table view dalegate
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
      
      dataModel.indexOfSelectedList = indexPath.row
      
      guard let vc = storyboard?.instantiateViewController(
        withIdentifier: String(describing: TasksViewController.self))
              as? TasksViewController else {
        return
      }
      let item = dataModel.lists[indexPath.row]
      vc.title = item.name
      vc.taskList = item
      navigationController?.pushViewController(vc, animated: true)
    }
  
  override func tableView(
    _ tableView: UITableView,
    accessoryButtonTappedForRowWith indexPath: IndexPath) {
      let item = dataModel.lists[indexPath.row]
      edit(item)
    }
  
  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath) {
      
      dataModel.lists.remove(at: indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
  
  override func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 60
    }
  
}


// MARK: - AddItemListDetailViewControllerDelegate
extension TaskListsViewController: AddItemTaskListDetailViewControllerDelegate {
  
  func addItemTaskListDetailViewController(
    _ controller: TaskListDetailViewController,
    didFinishAdding item: TaskList) {
      dataModel.lists.append(item)
      dataModel.sortLists()
      tableView.reloadData()
      navigationController?.popViewController(animated:true)
    }
  
  func addItemTaskListDetailViewControllerDidCancel(
    _ controller: TaskListDetailViewController) {
      dataModel.sortLists()
      tableView.reloadData()
      navigationController?.popViewController(animated: true)
    }
  
}


// MARK: - EditItemListDetailViewControllerDelegate
extension TaskListsViewController: EditItemTaskListDetailViewControllerDelegate {
  
  func editItemTaskListDetailViewController(
    _ controller: TaskListDetailViewController,
    didFinishEditing item: TaskList) {
      // get indexPath for current edit item
      if let index = dataModel.lists.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          cell.textLabel?.text = item.name
        }
      }
      navigationController?.popViewController(animated:true)
    }
  
  func editItemTaskListDetailViewControllerDidCancel(
    _ controller: TaskListDetailViewController) {
      navigationController?.popViewController(animated: true)
    }
  
}


// MARK: - UINavigationControllerDelegate
extension TaskListsViewController: UINavigationControllerDelegate {
  
  func navigationController(
    _ navigationController: UINavigationController,
    willShow viewController: UIViewController, animated: Bool) {
      if viewController === self {
        dataModel.indexOfSelectedList = -1
      }
    }
  
}
