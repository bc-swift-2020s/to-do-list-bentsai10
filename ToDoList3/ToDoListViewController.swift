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

