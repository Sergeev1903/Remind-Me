//
//  CheckListItem.swift
//  Remind Me
//
//  Created by Артем Сергеев on 07.06.2023.
//

import Foundation

class TaskItem: NSCoder, Codable {
  var text: String = ""
  var isCheck: Bool = false
  
  var dueDate = Date()
  var shouldRemind = false
  var itemID = -1
  
  override init() {
    super.init()
    itemID = DataModel.nextTasklistItemID()
  }
  
}





