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
    
    //var toDoItems:[ToDoItem] = []
    var toDoItems = ToDoItems()

    @IBOutlet weak var toDoTableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
//    var toDoArray = ["Graduate", "Get a Job", "Get Married", "Have Kids"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoTableView.delegate = self as UITableViewDelegate
        toDoTableView.dataSource = self as UITableViewDataSource
        toDoItems.loadData {
            self.toDoTableView.reloadData()
        }
        
        LocalNotificationManager.authorizeLocalNotifications()
        // Do any additional setup after loading the view.
    }
    
    func saveData(){
        toDoItems.saveData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = toDoTableView.indexPathForSelectedRow!
            destination.toDoItem = toDoItems.itemsArray[selectedIndexPath.row]
        }else{
            if let selectedIndexPath = toDoTableView.indexPathForSelectedRow {
                toDoTableView.deselectRow(at: selectedIndexPath, animated: true )
            }
        }
    }
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue){
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = toDoTableView.indexPathForSelectedRow{
            toDoItems.itemsArray[selectedIndexPath.row] = source.toDoItem
            toDoTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }else{
            let newIndexPath = IndexPath(row: toDoItems.itemsArray.count, section: 0)
            toDoItems.itemsArray.append(source.toDoItem)
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
            toDoItems.itemsArray[selectedIndexPath.row].completed = !toDoItems.itemsArray[selectedIndexPath.row].completed
            toDoTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        cell.delegate = self
        cell.toDoItem = toDoItems.itemsArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            toDoItems.itemsArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = toDoItems.itemsArray[sourceIndexPath.row]
        toDoItems.itemsArray.remove(at: sourceIndexPath.row)
        toDoItems.itemsArray.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
    
}

