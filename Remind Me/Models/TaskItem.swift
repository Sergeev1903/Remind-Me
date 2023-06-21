//
//  CheckListItem.swift
//  Remind Me
//
//  Created by Артем Сергеев on 07.06.2023.
//

import Foundation
import UserNotifications

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
  
  deinit {
    removeNotification()
  }
  
  
  func removeNotification() {
    let center = UNUserNotificationCenter.current()
    center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
  }
  
  func scheduleNotification() {
    removeNotification()
    
    if shouldRemind && dueDate > Date() {
      
      let content = UNMutableNotificationContent()
      content.title = "Reminder:"
      content.body = text
      content.sound = UNNotificationSound.default
      
      let calendar = Calendar(identifier: .gregorian)
      let components = calendar.dateComponents(
        [.year, .month, .day, .hour, .minute],
        from: dueDate)
      
      let trigger = UNCalendarNotificationTrigger(
        dateMatching: components,
        repeats: false)
      
      let request = UNNotificationRequest(
        identifier: "\(itemID)",
        content: content,
        trigger: trigger)
      
      
      let center = UNUserNotificationCenter.current()
      center.delegate = self
      center.add(request)
    }
  }
  
  private func getCheckTaskIsDone() {
     self.isCheck = true
     self.shouldRemind = false
   }
  
}

extension TaskItem: UNUserNotificationCenterDelegate {
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    
    DispatchQueue.main.async {
      self.getCheckTaskIsDone()
    }
    
    completionHandler([.alert, .sound, .badge])
    
    print("willPresent")
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    
    DispatchQueue.main.async {
      self.getCheckTaskIsDone()
    }
    print("didReceive")
  }
}



