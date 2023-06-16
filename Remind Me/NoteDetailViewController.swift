//
//  AddItemViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 12.06.2023.
//

import UIKit

protocol AddItemNoteDetailViewControllerDelegate: AnyObject{
  func addItemNoteDetailViewController(
    _ controller: NoteDetailViewController,
    didFinishAdding item: NoteListItem)
  func addItemNoteDetailViewControllerDidCancel(
    _ controller: NoteDetailViewController)
}

protocol EditItemNoteDetailViewControllerDelegate: AnyObject{
  func editItemNoteDetailViewController(
    _ controller: NoteDetailViewController,
    didFinishEditing item: NoteListItem)
  func editItemNoteDetailViewControllerDidCancel(
    _ controller: NoteDetailViewController)
}


class NoteDetailViewController: UITableViewController {
  
  // MARK: - @IBOutlets
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  // MARK: - Delegates
  weak var addItemDelegate: AddItemNoteDetailViewControllerDelegate?
  weak var editItemDelegate: EditItemNoteDetailViewControllerDelegate?
  
  // MARK: - Properties
  var editItem: NoteListItem?
//  var editItemIndexPath: IndexPath?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureTableView()
    configureTextField()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }
  
  
  // MARK: - Private methods
  private func configureNavigationBar() {
    doneBarButton.isEnabled = false
    navigationItem.largeTitleDisplayMode = .never
  }
  
  private func configureTableView() {
    tableView.separatorStyle = .none
  }
  
  private func configureTextField() {
    textField.delegate = self
    textField.borderStyle = .roundedRect
    textField.layer.cornerRadius = 10
    textField.layer.borderColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
    textField.layer.borderWidth = 1
    textField.placeholder = "start typing..."
    textField.returnKeyType = .done
    textField.enablesReturnKeyAutomatically = true
    
    if editItem != nil {
      textField.text = editItem?.text
    }
  }
  
  
  // MARK: - @IBActions
  @IBAction func cancelButton() {
    addItemDelegate?.addItemNoteDetailViewControllerDidCancel(self)
    editItemDelegate?.editItemNoteDetailViewControllerDidCancel(self)
  }
  
  @IBAction func doneButton() {
    guard let itemText = textField.text else {
      return
    }
    let listItem = NoteListItem()
    listItem.text = textField.text!
    addItemDelegate?.addItemNoteDetailViewController(
      self,
      didFinishAdding: listItem)
    
    
    guard var editItem else {
      return
    }
    editItem.text = textField.text!
    editItemDelegate?.editItemNoteDetailViewController(
      self,
      didFinishEditing: editItem)
  }
  
  
  // MARK: - Table Data Source
  override func tableView(
    _ tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
      return self.title
    }
  
  // MARK: - Table View Delegates
  override func tableView(
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return nil
    }
  
  override func tableView(
    _ tableView: UITableView,
    heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 50
    }
}


// MARK: - UITextFieldDelegate
extension NoteDetailViewController:  UITextFieldDelegate {
  
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String) -> Bool {
      
      let oldText = textField.text!
      let stringRange = Range(range, in: oldText)!
      let newText = oldText.replacingCharacters(in: stringRange,
                                                with: string)
      doneBarButton.isEnabled = !newText.isEmpty
      return true
    }
  
  func textFieldShouldClear(
    _ textField: UITextField) -> Bool {
      doneBarButton.isEnabled = false
      return true
    }
  
}
