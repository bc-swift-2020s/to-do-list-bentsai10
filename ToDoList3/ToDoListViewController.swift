//
//  ViewController.swift
//  ToDoList3
//
//  Created by Ben Tsai on 2/9/20.
//  Copyright © 2020 Ben Tsai. All rights reserved.
//

import UIKit
import UserNotifications

class ToDoListViewController: UIViewController {
    
    var toDoItems:[ToDoItem] = []

    @IBOutlet weak var toDoTableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
//    var toDoArray = ["Graduate", "Get a Job", "Get Married", "Have Kids"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoTableView.delegate = self as UITableViewDelegate
        toDoTableView.dataSource = self as UITableViewDataSource
        loadData()
        authorizeLocalNotifications()
        // Do any additional setup after loading the view.
    }
    
    func authorizeLocalNotifications(){
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
    
    func setNotifications(){
        guard toDoItems.count>0 else{
            return
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        for index in 0..<toDoItems.count {
            if toDoItems[index].reminderSet{
                let toDoItem = toDoItems[index]
                toDoItems[index].notificationID = setCalendarNotification(title: toDoItem.name, subtitle: "", body: toDoItem.notes, badgeNumber: nil, sound: .default, date: toDoItem.date)
            }
        }
    }
    
    func setCalendarNotification(title:String,subtitle: String, body:String, badgeNumber: NSNumber?, sound: UNNotificationSound, date: Date) -> String{
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
    
    func loadData(){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        guard let data = try?Data(contentsOf: documentURL)else{return}
        let jsonDecoder = JSONDecoder()
        do{
            toDoItems = try jsonDecoder.decode(Array<ToDoItem>.self, from: data)
            toDoTableView.reloadData()
        }catch{
            print("Error!")
        }
    }
    func saveData(){
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("todos").appendingPathExtension("json")
        let jsonEncoder = JSONEncoder()
        let data = try?jsonEncoder.encode(toDoItems )
        do{
            try data?.write(to: documentURL, options: .noFileProtection)
        }catch{
            print("Error!")
        }
        setNotifications()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = toDoTableView.indexPathForSelectedRow!
            destination.toDoItem = toDoItems[selectedIndexPath.row]
        }else{
            if let selectedIndexPath = toDoTableView.indexPathForSelectedRow {
                toDoTableView.deselectRow(at: selectedIndexPath, animated: true )
            }
        }
    }
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue){
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = toDoTableView.indexPathForSelectedRow{
            toDoItems[selectedIndexPath.row] = source.toDoItem
            toDoTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }else{
            let newIndexPath = IndexPath(row: toDoItems.count, section: 0)
            toDoItems.append(source.toDoItem)
            toDoTableView.insertRows(at: [newIndexPath], with: .bottom)
            toDoTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveData()
    }
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if toDoTableView.isEditing{
            toDoTableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
            
        }else{
            toDoTableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
}
extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate{
    func checkboxToggle(sender: ListTableViewCell) {
        if let selectedIndexPath = toDoTableView.indexPath(for: sender){
            toDoItems[selectedIndexPath.row].completed = !toDoItems[selectedIndexPath.row].completed
            toDoTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self
        cell.nameLabel.text = toDoItems[indexPath.row].name
        cell.checkBoxButton.isSelected = toDoItems[indexPath.row].completed
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            toDoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoItems[sourceIndexPath.row]
        toDoItems.remove(at: sourceIndexPath.row)
        toDoItems.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
    
}

