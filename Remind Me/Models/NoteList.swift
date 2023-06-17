//
//  NoteList.swift
//  Remind Me
//
//  Created by Артем Сергеев on 16.06.2023.
//

import Foundation

class NoteList: NSCoder {
  var name: String
  var icon: String = "folder"

  init(name: String, icon: String = "folder") {
    self.name = name
    self.icon = icon
  }
}


// MARK: - Mock data
var list1 = NoteList(name: "Birthdays", icon: "gift")
var list2 = NoteList(name: "Groceries", icon: "cart")
var list3 = NoteList(name: "Cool Apps", icon: "app")
var list4 = NoteList(name: "To Do", icon: "checklist")
  
