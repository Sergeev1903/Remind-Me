//
//  ListDetailViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 17.06.2023.
//

import UIKit

protocol AddItemListDetailViewControllerDelegate: AnyObject{
  func addItemListDetailViewController(
    _ controller: ListDetailViewController,
    didFinishAdding item: ListItem)
  func addItemListDetailViewControllerDidCancel(
    _ controller: ListDetailViewController)
}

protocol EditItemListDetailViewControllerDelegate: AnyObject{
  func editItemListDetailViewController(
    _ controller: ListDetailViewController,
    didFinishEditing item: ListItem)
  func editItemListDetailViewControllerDidCancel(
    _ controller: ListDetailViewController)
}


class ListDetailViewController: UITableViewController {
  
  // MARK: - @IBOutlets
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  
  // MARK: - Delegates
  weak var addItemDelegate: AddItemListDetailViewControllerDelegate?
  weak var editItemDelegate: EditItemListDetailViewControllerDelegate?
  
  
  // MARK: - Properties
  var editItem: ListItem?
  
  
  // MARK: - Lifecycle
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
      textField.text = editItem?.name
    }
  }
  
  
  // MARK: - @IBActions
  @IBAction func cancelButton() {
    addItemDelegate?.addItemListDetailViewControllerDidCancel(self)
    editItemDelegate?.editItemListDetailViewControllerDidCancel(self)
  }
  
  @IBAction func doneButton() {
    guard textField.text != nil else {
      return
    }
    let listItem = ListItem(name: "")
    listItem.name = textField.text!
    addItemDelegate?.addItemListDetailViewController(
      self,
      didFinishAdding: listItem)
    
    
    guard let editItem else {
      return
    }
    editItem.name = textField.text!
    editItemDelegate?.editItemListDetailViewController(
      self,
      didFinishEditing: editItem)
  }
  
  
  // MARK: - Table view data source
  override func tableView(
    _ tableView: UITableView,
    titleForHeaderInSection section: Int) -> String? {
      return self.title
    }
  
  
  // MARK: - Table view delegate
  override func tableView(
    _ tableView: UITableView,
    willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      return nil
    }
  
}


// MARK: - UITextFieldDelegate
extension ListDetailViewController:  UITextFieldDelegate {
  
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
