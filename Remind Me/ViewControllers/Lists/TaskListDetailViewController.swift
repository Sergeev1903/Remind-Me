//
//  ListDetailViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 17.06.2023.
//

import UIKit

protocol AddItemTaskListDetailViewControllerDelegate: AnyObject{
  func addItemTaskListDetailViewController(
    _ controller: TaskListDetailViewController,
    didFinishAdding item: TaskList)
  func addItemTaskListDetailViewControllerDidCancel(
    _ controller: TaskListDetailViewController)
}

protocol EditItemTaskListDetailViewControllerDelegate: AnyObject{
  func editItemTaskListDetailViewController(
    _ controller: TaskListDetailViewController,
    didFinishEditing item: TaskList)
  func editItemTaskListDetailViewControllerDidCancel(
    _ controller: TaskListDetailViewController)
}


class TaskListDetailViewController: UITableViewController {
  
  // MARK: - @IBOutlets
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var iconImage: UIImageView!

  
  // MARK: - Delegates
  weak var addItemDelegate: AddItemTaskListDetailViewControllerDelegate?
  weak var editItemDelegate: EditItemTaskListDetailViewControllerDelegate?
  var iconName = "folder"
  
  
  // MARK: - Properties
  var editItem: TaskList?
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationBar()
    configureTableView()
    configureTextField()
    configureiconImage()
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
    textField.layer.borderColor = UIColor.separator.cgColor
    textField.layer.borderWidth = 1
    textField.layer.masksToBounds = true
    textField.placeholder = "start typing..."
    textField.returnKeyType = .done
    textField.enablesReturnKeyAutomatically = true
    
    if editItem != nil {
      textField.text = editItem?.name
    }
  }
  
  private func configureiconImage() {
    if let item = editItem {
      iconName = item.icon
    }
    iconImage.image = UIImage(systemName: iconName)
  }
  
  
  // MARK: - @IBActions
  @IBAction func cancelButton() {
    addItemDelegate?.addItemTaskListDetailViewControllerDidCancel(self)
    editItemDelegate?.editItemTaskListDetailViewControllerDidCancel(self)
  }
  
  @IBAction func doneButton() {
    if let list = editItem {
      list.name = textField.text!
      list.icon = iconName
      editItemDelegate?.editItemTaskListDetailViewController(
        self,
        didFinishEditing: list)
    } else {
      let list = TaskList(name: textField.text!)
      list.icon = iconName
      addItemDelegate?.addItemTaskListDetailViewController(
        self,
        didFinishAdding: list)
    }
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
      return indexPath
    }
  
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
      
      tableView.cellForRow(at: indexPath)?.selectionStyle = .none
      
      if indexPath.row == 1 {
        guard let vc = storyboard?.instantiateViewController(
          withIdentifier: String(
            describing: IconPickerViewController.self))
                as? IconPickerViewController else {
          return
        }
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
      }
    }
  
}


// MARK: - UITextFieldDelegate
extension TaskListDetailViewController:  UITextFieldDelegate {
  
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

// MARK: - IconPickerViewControllerDelegate
extension TaskListDetailViewController: IconPickerViewControllerDelegate {
  
  func iconPicker(
    _ picker: IconPickerViewController,
    didPick iconName: String) {
      self.iconName = iconName
      iconImage.image = UIImage(systemName: iconName)
      doneBarButton.isEnabled = !iconName.isEmpty
      navigationController?.popViewController(animated: true)
    }
  
}
