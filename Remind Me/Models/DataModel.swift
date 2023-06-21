//
//  DataModel.swift
//  Remind Me
//
//  Created by Артем Сергеев on 17.06.2023.
//

import Foundation

class DataModel {
  
  var lists: [TaskList] = []
  
  var indexOfSelectedList: Int {
    get {
      return UserDefaults.standard.integer(
        forKey: "ListItemIndex")
    }
    set {
      UserDefaults.standard.set(
        newValue,
        forKey: "ListItemIndex")
    }
  }
  
  init() {
    defaultNoteLists()
    loadLists()
    registerDefaults()
    handleFirstTime()
  }
  
  class func nextTasklistItemID() -> Int {
    let userDefaults = UserDefaults.standard
    let itemID = userDefaults.integer(forKey: "TaskItemID")
    userDefaults.set(itemID + 1, forKey: "TaskItemID")
    return itemID
  }
  
  private func defaultNoteLists() {
    let list1 = TaskList(name: "Birthdays", icon: "gift")
    let list2 = TaskList(name: "Groceries", icon: "cart")
    let list3 = TaskList(name: "To Do", icon: "checklist")
    
    lists = [list1, list2, list3]
  }
  
  private func registerDefaults() {
    let dictionary = [
      "ListItemIndex": -1,
      "FirstTime": true
    ] as [String: Any]
    UserDefaults.standard.register(defaults: dictionary)
  }
  
  private func handleFirstTime() {
    let userDefaults = UserDefaults.standard
    let firstTime = userDefaults.bool(forKey: "FirstTime")
    
    if firstTime {
      let list = TaskList(name: "New list")
      lists.append(list)
      indexOfSelectedList = 3
      userDefaults.set(false, forKey: "FirstTime")
    }
  }
  
  
  // MARK: - Data Saving
  func documentsDirectory() -> URL {
    let paths = FileManager.default.urls(
      for: .documentDirectory,
      in: .userDomainMask)
    return paths[0]
  }
  
  func dataFilePath() -> URL {
    return documentsDirectory().appendingPathComponent("Remind Me.plist")
  }
  
  func saveLists() {
    let encoder = PropertyListEncoder()
    do {
      let data = try encoder.encode(lists)
      try data.write(
        to: dataFilePath(), options: Data.WritingOptions.atomic)
    } catch {
      print("Error encoding list array: \(error.localizedDescription)")
    }
  }
  
  func loadLists() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        lists = try decoder.decode(
          [TaskList].self, from: data)
        sortLists()
      } catch {
        print("Error decoding list array: \(error.localizedDescription)")
      }
    }
  }
  
  func sortLists() {
    lists.sort { list1, list2 in
      return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
    }
  }
  
}

