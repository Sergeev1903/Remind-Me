//
//  ViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 07.06.2023.
//

import UIKit

class NotesViewController: UITableViewController {
  
  // MARK: Properties
  var items: [NoteListItem] = []
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    
    loadNotelistItems()
    // Add the following
    print("Documents folder is \(documentsDirectory())")
    print("Data file path is \(dataFilePath())")
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
  
  private func edit(_ item: NoteListItem) {
    guard let vc = storyboard?.instantiateViewController(
      withIdentifier: String(describing: NoteDetailViewController.self))
            as? NoteDetailViewController else {
      return
    }
    vc.editItemDelegate = self
    vc.title = "Edit Note"
    vc.editItem = item
    navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - Save data to infoplist
  private func saveNotelistItems() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(items)
      try data.write(
        to: dataFilePath(),
        options: Data.WritingOptions.atomic)
    } catch {
      print("Error encoding item array: \(error.localizedDescription)")
    }
  }
  
  // MARK: - Load data from infoplist
  private func loadNotelistItems() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        items = try decoder.decode(
          [NoteListItem].self,
          from: data)
      } catch {
        print("Error decoding item array: \(error.localizedDescription)")
      }
    }
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
      
      saveNotelistItems()
    }
  
  
  // MARK: - TableView Delegate
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
      
      if let cell = tableView.cellForRow(at: indexPath) {
        let item = items[indexPath.row]
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
      saveNotelistItems()
    }
  
  
  override func tableView(
    _ tableView: UITableView,
    accessoryButtonTappedForRowWith indexPath: IndexPath) {
      let item = items[indexPath.row]
      edit(item)
    }
}


// MARK: - AddItemViewControllerDelegate
extension NotesViewController: AddItemNoteDetailViewControllerDelegate {
  
  func addItemNoteDetailViewControllerDidCancel(
    _ controller: NoteDetailViewController) {
      navigationController?.popViewController(animated: true)
    }
  
  func addItemNoteDetailViewController(
    _ controller: NoteDetailViewController,
    didFinishAdding item: NoteListItem) {
      
      let newRowIndex = items.count
      items.append(item)
      let indexPath = IndexPath(row: newRowIndex, section: 0)
      let indexPaths = [indexPath]
      tableView.insertRows(at: indexPaths, with: .automatic)
      navigationController?.popViewController(animated:true)
      
      saveNotelistItems()
    }
  
}

// MARK: - EditItemViewControllerDelegate
extension NotesViewController: EditItemNoteDetailViewControllerDelegate {
  
  func editItemNoteDetailViewControllerDidCancel(
    _ controller: NoteDetailViewController) {
      navigationController?.popViewController(animated: true)
    }
  
  func editItemNoteDetailViewController(
    _ controller: NoteDetailViewController,
    didFinishEditing item: NoteListItem) {
      
      // get indexPath for current item
      if let index = items.firstIndex(of: item) {
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) {
          configureText(for: cell, with: item)
        }
      }
      navigationController?.popViewController(animated:true)
      saveNotelistItems()
    }
  
}


// MARK: -
extension NotesViewController {
  
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask)
    return paths[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Remind Me.plist")
  }
  
}
