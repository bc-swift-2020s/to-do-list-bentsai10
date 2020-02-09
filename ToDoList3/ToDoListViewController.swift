//
//  ViewController.swift
//  ToDoList3
//
//  Created by Ben Tsai on 2/9/20.
//  Copyright © 2020 Ben Tsai. All rights reserved.
//

import UIKit

class ToDoListViewController: UIViewController {

    @IBOutlet weak var toDoTableView: UITableView!
    var toDoArray = ["Graduate", "Get a Job", "Get Married", "Have Kids"]
    override func viewDidLoad() {
        super.viewDidLoad()
        toDoTableView.delegate = self as UITableViewDelegate
        toDoTableView.dataSource = self as UITableViewDataSource
        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail"{
            let destination = segue.destination as! ToDoDetailTableViewController
            let selectedIndexPath = toDoTableView.indexPathForSelectedRow!
            destination.toDoItem = toDoArray[selectedIndexPath.row]
        }else{
            if let selectedIndexPath = toDoTableView.indexPathForSelectedRow {
                toDoTableView.deselectRow(at: selectedIndexPath, animated: true )
            }
        }
    }
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue){
        let source = segue.source as! ToDoDetailTableViewController
        if let selectedIndexPath = toDoTableView.indexPathForSelectedRow{
            toDoArray[selectedIndexPath.row] = source.toDoItem
            toDoTableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        }else{
            let newIndexPath = IndexPath(row: toDoArray.count, section: 0)
            toDoArray.append(source.toDoItem)
            toDoTableView.insertRows(at: [newIndexPath], with: .bottom)
            toDoTableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
    }
}
extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numberofRowsInSection was just called. Returning\(toDoArray.count) ")
        return toDoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cellforRowAt was just called for indexPath.row = \(indexPath.row) which is the cell containing \(toDoArray[indexPath.row])")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = toDoArray[indexPath.row]
        return cell
    }
    
    
}

