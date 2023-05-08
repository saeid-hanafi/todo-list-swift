//
//  Todo.swift
//  todoList
//
//  Created by Macvps on 5/6/23.
//

import Foundation
import RealmSwift

class Todo: Object {
    @Persisted (primaryKey: true) var _id: ObjectId
    @Persisted var taskText: String!
    @Persisted var isCompleted: Bool = false
    @Persisted var doneDate: Date!
    
    convenience init(task: String, isCompleted: Bool, date: Date?) {
        self.init()
        self.taskText = task
        self.isCompleted = isCompleted
        if date != nil {
            self.doneDate = date!
        }else{
            let now = Calendar.current.dateComponents(in: .current, from: Date())
            let tommorow = DateComponents(year: now.year, month: now.month, day: now.day! + 1, hour: now.hour, minute: now.minute)
            self.doneDate = Calendar.current.date(from: tommorow)
        }
    }
}
