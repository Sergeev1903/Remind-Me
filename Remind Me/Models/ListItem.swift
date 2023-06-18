//
//  NoteList.swift
//  Remind Me
//
//  Created by Артем Сергеев on 16.06.2023.
//

import Foundation

class ListItem: NSCoder, Codable {
  var name: String
  var icon: String
  var items: [NoteItem] = []

  init(name: String, icon: String = "folder") {
    self.name = name
    self.icon = icon
  }
  
  func countUncheckedItems() -> Int {
    var count = 0
    for item in items where !item.isCheck {
      count += 1
    }
    return count
  }
}

  
