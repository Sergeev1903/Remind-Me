//
//  NoteList.swift
//  Remind Me
//
//  Created by Артем Сергеев on 16.06.2023.
//

import Foundation

class TaskList: NSCoder, Codable {
  
  var name: String = ""
  var icon: String = "folder"
  var items: [TaskItem] = []
  
  init(name: String, icon: String = "folder") {
    self.name = name
    self.icon = icon
    super.init()
  }
  
  func countUncheckedItems() -> Int {
    var count = 0
    for item in items where !item.isCheck {
      count += 1
    }
    return count
  }
  
}

