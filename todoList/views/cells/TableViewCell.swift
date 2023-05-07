//
//  TableViewCell.swift
//  todoList
//
//  Created by Macvps on 5/7/23.
//

import UIKit

class TableViewCell: UITableViewCell {
    static let ID: String = "tasksTable"
    
    @IBOutlet var checkLbl: UILabel!
    
    @IBOutlet var taskLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }

}
