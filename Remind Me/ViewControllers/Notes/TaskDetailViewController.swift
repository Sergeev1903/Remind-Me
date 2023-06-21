//
//  AddItemViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 12.06.2023.
//

import UIKit
import UserNotifications

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
  @IBOutlet weak var shouldRemindSwitch: UISwitch!
  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var datePickerCell: UITableViewCell!
  
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
    configureRemindState()
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
      textField.text = editItem?.text
    }
  }
  
  private func configureRemindState() {
    shouldRemindSwitch.isOn = false
    datePickerCell.isHidden = true

    if let item = editItem {
      datePickerCell.isHidden = item.shouldRemind ? false: true
      shouldRemindSwitch.isOn = item.shouldRemind
      datePicker.date = item.dueDate
    }
  }
  
  
  // MARK: - @IBActions
  @IBAction func cancelButton() {
    addItemDelegate?.addItemTaskDetailViewControllerDidCancel(self)
    editItemDelegate?.editItemTaskDetailViewControllerDidCancel(self)
  }
  
  @IBAction func doneButton() {
    
    guard !textField.text!.isEmpty else {
      return doneBarButton.isEnabled = false
    }
    let listItem = TaskItem()
    listItem.text = textField.text!
    listItem.shouldRemind = shouldRemindSwitch.isOn
    listItem.dueDate = datePicker.date
    listItem.scheduleNotification()
    addItemDelegate?.addItemTaskDetailViewController(
      self,
      didFinishAdding: listItem)
    
    
    guard let editItem else {
      return
    }
    editItem.text = textField.text!
    editItem.shouldRemind = shouldRemindSwitch.isOn
    editItem.dueDate = datePicker.date
    editItem.scheduleNotification()
    editItemDelegate?.editItemTaskDetailViewController(
      self,
      didFinishEditing: editItem)
  }
  
  @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
    textField.resignFirstResponder()
        
    if (switchControl.isOn != editItem?.shouldRemind && !textField.text!.isEmpty) ||
        datePicker.date != editItem?.dueDate {
      doneBarButton.isEnabled = true
    } else {
      doneBarButton.isEnabled = false
    }

    if switchControl.isOn {
      datePickerCell.isHidden = false
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options: [.alert, .sound, .badge]) {_, _ in
        print(" notification active")
      }
    } else {
      datePickerCell.isHidden = true
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
