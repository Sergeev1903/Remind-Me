//
//  ViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 07.06.2023.
//

import UIKit

class MainViewController: UITableViewController {
  
  // MARK: Properties
  var items: [CheckListItem] = [item1, item2, item3,
                                item4, item5, item6,
                                item7, item8, item9]
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  // MARK: - @IBAction
  @IBAction func addItem() {
    
    guard let vc = storyboard?.instantiateViewController(
      withIdentifier: String(describing: AddItemViewController.self)) else {
      return
    }
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  //MARK: - TableView Data Source
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "MainTableViewCell") else { return UITableViewCell() }
    
    let item = items[indexPath.row]
    cell.textLabel?.text = item.text
    
    if item.isCheck {
      cell.accessoryType = .checkmark
    } else {
      cell.accessoryType = .none
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView,
                          commit editingStyle: UITableViewCell.EditingStyle,
                          forRowAt indexPath: IndexPath) {
    
    items.remove(at: indexPath.row)
    
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }
  
  // MARK: - TableView Delegate
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    
    if let cell = tableView.cellForRow(at: indexPath) {
      
      if cell.accessoryType == .none {
        cell.accessoryType = .checkmark
      } else {
        cell.accessoryType = .none
      }
      
      tableView.deselectRow(at: indexPath, animated: true)
      
    }
  }
  
}