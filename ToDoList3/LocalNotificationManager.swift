//
//  LocalNotificationManager.swift
//  ToDoList3
//
//  Created by Ben Tsai on 3/8/20.
//  Copyright © 2020 Ben Tsai. All rights reserved.
//

import Foundation
import UserNotifications

struct LocalNotificationManager {
    static func authorizeLocalNotifications(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            guard error == nil else{
                print("error")
                return
            }
            if granted {
                print("granted")
            }else{
                print("denied")
                //TODO: Put an alert here
            }
        }
    }
    static func setCalendarNotification(title:String,subtitle: String, body:String, badgeNumber: NSNumber?, sound: UNNotificationSound, date: Date) -> String{
        //create content
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle
        content.body = body
        content.sound = sound
        content.badge = badgeNumber
        //create trigger
        var dateComponents =  Calendar.current.dateComponents([.year,.month, .day, .hour, .minute], from: date)
        dateComponents.second = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        //create request
        let notificationID = UUID().uuidString
        let request = UNNotificationRequest(identifier: notificationID, content: content, trigger: trigger)
        
        //register request with the notification center
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print ("Error")
            }else{
                
            }
        }
        return notificationID
    }
}
