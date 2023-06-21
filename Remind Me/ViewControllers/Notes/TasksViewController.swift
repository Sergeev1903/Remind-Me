//
//  ViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 07.06.2023.
//

import UIKit

class TasksViewController: UITableViewController {
  
  // MARK: - Properties
  var taskList: TaskList!
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  
  // MARK: - Private methods
  private func crossedOut(isCheck: Bool, text: String) -> NSAttributedString {
    if isCheck {
      let attributedString = NSMutableAttributedString(string: (text))
      let attributes: [NSAttributedString.Key: Any] = [
        .strikethroughStyle: NSUnderlineStyle.single.rawValue,
        .strikethroughColor: UIColor.red]
      attributedString.addAttributes(attributes, range: NSRange(location: 0, length: attributedString.length))
      return attributedString
    }
    return NSMutableAttributedString(string: (text))
    
  }
  
  private func configureText(
    for cell: UITableViewCell,
    with item: TaskItem) {
      cell.textLabel?.text = item.text
    }
  
  private func edit(_ item: TaskItem) {
    guard let vc = storyboard?.instantiateViewController(
      withIdentifier: String(describing: TaskDetailViewController.self))
            as? TaskDetailViewController else {
      return
    }
    vc.editItemDelegate = self
    vc.title = "Edit Task"
    vc.editItem = item
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  // MARK: - @IBActions
  @IBAction func addItem() {
    guard let vc = storyboard?.instantiateViewController(
      withIdentifier: String(describing: TaskDetailViewController.self))
            as? TaskDetailViewController else {
      return
    }
    vc.addItemDelegate = self
    vc.title = "Add Task"
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  //MARK: - TableView data source
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return taskList.items.count
    }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: "NotesCell") else {
        return UITableViewCell()
      }
      
      let item = taskList.items[indexPath.row]
      configureText(for: cell, with: item)
      cell.textLabel?.numberOfLines = 3
      
      if item.isCheck {
        cell.imageView?.isHidden = false
        cell.textLabel?.attributedText = crossedOut(
          isCheck: item.isCheck, text: (cell.textLabel?.text)!)
      } else {
        cell.imageView?.isHidden = true
      }
      
      return cell
    }
  
  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath) {
      
      taskList.items.remove(at: indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
  
  
  // MARK: - Table view delegate
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
      
      if let cell = tableView.cellForRow(at: indexPath) {
        let item = taskList.items[indexPath.row]
        item.isCheck.toggle()
        
        switch cell.imageView?.isHidden {
        case .some(true):
          cell.imageView?.isHidden = false
          cell.textLabel?.attributedText = crossedOut(
            isCheck: item.isCheck, text: (cell.textLabel?.text)!)
        default:
          cell.imageView?.isHidden = true
          cell.textLabel?.attributedText = crossedOut(
            isCheck: item.isCheck, text: (cell.textLabel?.text)!)
        }
        tableView.deselectRow(at: indexPath, animated: true)
      }
    }
  
  
  override func tableView(
    _ tableView: UITableView,
    accessoryButtonTappedForRowWith indexPath: IndexPath) {
      let item = taskList.items[indexPath.row]
      edit(item)
    }
  
  override func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 60
    }
  
}


// MARK: - AddItemViewControllerDelegate
extension TasksViewController: AddItemTaskDetailViewControllerDelegate {
  
  func addItemTaskDetailViewControllerDidCancel(
    _ controller: TaskDetailViewController) {
      navigationController?.popViewController(animated: true)
    }
  
  func addItemTaskDetailViewController(
    _ controller: TaskDetailViewController,
    didFinishAdding item: TaskItem) {
      
      let newRowIndex = taskList.items.count
      taskList.items.append(item)
      let indexPath = IndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)
      navigationController?.popViewController(animated:true)
    }
  
}


// MARK: - EditItemViewControllerDelegate
extension TasksViewController: EditItemTaskDetailViewControllerDelegate {
  
  func editItemTaskDetailViewControllerDidCancel(
    _ controller: TaskDetailViewController) {
      navigationController?.popViewController(animated: true)
    }
  
  func editItemTaskDetailViewController(
    _ controller: TaskDetailViewController,
    didFinishEditing item: TaskItem) {
      // get indexPath for current edit item
      if let index = taskList.items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
      navigationController?.popViewController(animated:true)
    }
  
}

