//
//  IconPickerViewController.swift
//  Remind Me
//
//  Created by Артем Сергеев on 19.06.2023.
//

import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
  func iconPicker(
    _ picker: IconPickerViewController,
    didPick iconName: String)
}


class IconPickerViewController: UITableViewController {
  
  // MARK: - Properties
  let icons = ["gift", "cart", "checklist", "folder", "airplane", "dollarsign" ]
  weak var delegate: IconPickerViewControllerDelegate?
  
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "Choose icon"
  }
  
  
  // MARK: - Table view data source
  override func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
      return icons.count
    }
  
  override func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "IconCell") else {
      
      return UITableViewCell()
    }
    
    tableView.cellForRow(at: indexPath)?.selectionStyle = .none
    tableView.separatorStyle = .none
    let iconName = icons[indexPath.row]
    cell.textLabel!.text = iconName
    cell.imageView!.image = UIImage(systemName: iconName)
    return cell
  }
  
  override func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath) {
      if let delegate = delegate {
        let iconName = icons[indexPath.row]
        delegate.iconPicker(self, didPick: iconName)
      }
    }
  
}
