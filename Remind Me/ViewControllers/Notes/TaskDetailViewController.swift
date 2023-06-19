//
//  AddItemViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 12.06.2023.
//

import UIKit

protocol AddItemTaskDetailViewControllerDelegate: AnyObject{
  func addItemTaskDetailViewController(
    _ controller: TaskDetailViewController,
    didFinishAdding item: TaskItem)
  func addItemTaskDetailViewControllerDidCancel(
    _ controller: TaskDetailViewController)
}

protocol EditItemTaskDetailViewControllerDelegate: AnyObject{
  func editItemTaskDetailViewController(
    _ controller: TaskDetailViewController,
    didFinishEditing item: TaskItem)
  func editItemTaskDetailViewControllerDidCancel(
    _ controller: TaskDetailViewController)
}


class TaskDetailViewController: UITableViewController {
  
  // MARK: - @IBOutlets
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  
  // MARK: - Delegates
  weak var addItemDelegate: AddItemTaskDetailViewControllerDelegate?
  weak var editItemDelegate: EditItemTaskDetailViewControllerDelegate?
  
  
  // MARK: - Properties
  var editItem: TaskItem?
  
  
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
    addItemDelegate?.addItemTaskDetailViewControllerDidCancel(self)
    editItemDelegate?.editItemTaskDetailViewControllerDidCancel(self)
  }
  
  @IBAction func doneButton() {
    guard textField.text != nil else {
      return
    }
    let listItem = TaskItem()
    listItem.text = textField.text!
    addItemDelegate?.addItemTaskDetailViewController(
      self,
      didFinishAdding: listItem)
    
    
    guard let editItem else {
      return
    }
    editItem.text = textField.text!
    editItemDelegate?.editItemTaskDetailViewController(
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
extension TaskDetailViewController:  UITextFieldDelegate {
  
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