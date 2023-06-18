//
//  DataModel.swift
//  Remind Me
//
//  Created by Артем Сергеев on 17.06.2023.
//

import Foundation

class DataModel {
  var lists: [ListItem] = []
  
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
    loadChecklists()
    registerDefaults()
    handleFirstTime()
  }
  
  private func defaultNoteLists() {
    let list1 = ListItem(name: "Birthdays", icon: "gift")
    let list2 = ListItem(name: "Groceries", icon: "cart")
    let list3 = ListItem(name: "To Do", icon: "checklist")
    
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
      let list = ListItem(name: "New list")
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
  
  // this method is now called saveChecklists()
  func saveChecklists() {
    let encoder = PropertyListEncoder()
    do {
      // You encode lists instead of "items"
      let data = try encoder.encode(lists)
      try data.write(
        to: dataFilePath(),
        options: Data.WritingOptions.atomic)
    } catch {
      print("Error encoding list array: \(error.localizedDescription)")
    }
  }
  
  // this method is now called loadChecklists()
  func loadChecklists() {
    let path = dataFilePath()
    if let data = try? Data(contentsOf: path) {
      let decoder = PropertyListDecoder()
      do {
        // You decode to an object of [Checklist] type to lists
        lists = try decoder.decode(
          [ListItem].self,
          from: data)
      } catch {
        print("Error decoding list array: \(error.localizedDescription)")
      }
    }
  }
  
}

