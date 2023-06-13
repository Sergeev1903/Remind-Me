//
//  AddItemViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 12.06.2023.
//

import UIKit

class AddItemViewController: UITableViewController {
  
  
  // MARK: - @IBOutlets
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  
  
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
  }

  
  // MARK: - @IBActions
  @IBAction func cancelButton() {
    navigationController?.popViewController(animated: true)
  }
  
  @IBAction func doneButton() {
    print(textField.text!)
    navigationController?.popViewController(animated: true)
  }
  
  
  // MARK: - Table View Delegates
  override func tableView(_ tableView: UITableView,
                          willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }
  
}


// MARK: - UITextFieldDelegate
extension AddItemViewController:  UITextFieldDelegate {
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(in: stringRange,
                                              with: string)
    doneBarButton.isEnabled = !newText.isEmpty
    return true
  }
  
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneBarButton.isEnabled = false
    return true
  }
}
