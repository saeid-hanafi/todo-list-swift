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
    
    convenience init(task: String, isCompleted: Bool) {
        self.init()
        self.taskText = task
        self.isCompleted = isCompleted
    }
}
