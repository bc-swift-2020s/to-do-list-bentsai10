//
//  ListTableViewCell.swift
//  ToDoList3
//
//  Created by Ben Tsai on 3/6/20.
//  Copyright © 2020 Ben Tsai. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate: class {
    func checkboxToggle(sender: ListTableViewCell )
}

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: ListTableViewCellDelegate?
    
    var toDoItem: ToDoItem!{
        didSet{
            nameLabel.text = toDoItem.name
            checkBoxButton.isSelected = toDoItem.completed
        }
    }
    
    
    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkboxToggle(sender: self)
    }
    
}
