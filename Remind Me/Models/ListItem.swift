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
}


// MARK: - Mock data
var list1 = ListItem(name: "Birthdays", icon: "gift")
var list2 = ListItem(name: "Groceries", icon: "cart")
var list3 = ListItem(name: "Cool Apps", icon: "app")
var list4 = ListItem(name: "To Do", icon: "checklist")
  
