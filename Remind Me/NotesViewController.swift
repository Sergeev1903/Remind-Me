//
//  ViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 07.06.2023.
//

import UIKit

class NotesViewController: UITableViewController {
  
  // MARK: Properties
  var items: [NoteListItem] = [item1, item2, item3,
                               item4, item5, item6,
                               item7, item8, item9]
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
  }
  
  
  // MARK: - Private methods
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
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
  
  private func configureText(for cell: UITableViewCell, with item: NoteListItem) {
    cell.textLabel?.text = item.text
  }
  
  private func edit(_ item: NoteListItem, indexPath: IndexPath) {
    guard let vc = storyboard?.instantiateViewController(
      withIdentifier: String(describing: NoteDetailViewController.self))
            as? NoteDetailViewController else {
      return
    }
    vc.editItemDelegate = self
    vc.title = "Edit Note"
    vc.editItem = item
    vc.editItemIndexPath = indexPath
    navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - @IBAction
  @IBAction func addItem() {
    guard let vc = storyboard?.instantiateViewController(
      withIdentifier: String(describing: NoteDetailViewController.self))
            as? NoteDetailViewController else {
      return
    }
    vc.addItemDelegate = self
    vc.title = "Add Note"
    navigationController?.pushViewController(vc, animated: true)
  }
  
  
  //MARK: - TableView Data Source
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return items.count
    }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      guard let cell = tableView.dequeueReusableCell(
        withIdentifier: "MainTableViewCell") else {
        return UITableViewCell()
      }
      
      let item = items[indexPath.row]
      cell.textLabel?.text = item.text
      cell.textLabel?.numberOfLines = 3
      
      
      if item.isCheck {
        cell.imageView?.isHidden = false
        cell.textLabel?.attributedText = crossedOut(isCheck: item.isCheck,
                                                    text: (cell.textLabel?.text)!)
      } else {
        cell.imageView?.isHidden = true
      }
      return cell
    }
  
  override func tableView(
    _ tableView: UITableView,
    commit editingStyle: UITableViewCell.EditingStyle,
    forRowAt indexPath: IndexPath) {
      
      items.remove(at: indexPath.row)
      let indexPaths = [indexPath]
      tableView.deleteRows(at: indexPaths, with: .automatic)
    }
  
  
  // MARK: - TableView Delegate
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
      
      if let cell = tableView.cellForRow(at: indexPath) {
        
        switch cell.imageView?.isHidden {
        case .some(true):
          cell.imageView?.isHidden = false
          cell.textLabel?.attributedText = crossedOut(isCheck: true,
                                                      text: (cell.textLabel?.text)!)
        default:
          cell.imageView?.isHidden = true
          cell.textLabel?.attributedText = crossedOut(isCheck: false,
                                                      text: (cell.textLabel?.text)!)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
      }
      
    }
  
  override func tableView(
    _ tableView: UITableView,
    accessoryButtonTappedForRowWith indexPath: IndexPath) {
      let item = items[indexPath.row]
      edit(item, indexPath: indexPath)
    }
}


// MARK: - AddItemViewControllerDelegate
extension NotesViewController: AddItemViewControllerDelegate {
  
  func addItemViewControllerDidCancel(
    _ controller: NoteDetailViewController) {
      navigationController?.popViewController(animated: true)
    }
  
  func addItemViewController(
    _ controller: NoteDetailViewController,
    didFinishAdding item: NoteListItem) {
      
      let newRowIndex = items.count
      items.append(item)
      let indexPath = IndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)
      navigationController?.popViewController(animated:true)
    }
  
}

// MARK: - EditItemViewControllerDelegate
extension NotesViewController: EditItemViewControllerDelegate {
  
  func editItemViewControllerDidCancel(
    _ controller: NoteDetailViewController) {
      navigationController?.popViewController(animated: true)
    }
  
  func editItemViewController(
    _ controller: NoteDetailViewController,
    didFinishEditing item: NoteListItem, with indexPath: IndexPath) {
      
      items.remove(at: indexPath.row)
      items.insert(item, at: indexPath.row)
      tableView.reloadRows(at: [indexPath], with: .automatic)
      navigationController?.popViewController(animated:true)
    }
}
