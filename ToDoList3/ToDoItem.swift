//
//  ToDoItem.swift
//  ToDoList3
//
//  Created by Ben Tsai on 2/9/20.
//  Copyright © 2020 Ben Tsai. All rights reserved.
//

import Foundation
struct ToDoItem: Codable{
    var name:String
    var date: Date
    var notes: String
    var reminderSet: Bool
}
