//
//  TodoModel.swift
//  todoList
//
//  Created by Macvps on 5/6/23.
//

import Foundation
import RealmSwift

protocol TodoAppDelegate: AnyObject {
    func setTask(data: Todo)
    func getTasks(data: [Todo])
    func updateTask(data: Todo)
    func deleteTask(data: Bool)
    func failedTask(error: String)
}

class TodoModel {
    private let delegate: TodoAppDelegate!
    private let realmConnection = try! Realm()
    private let notificationManager = NotificationManager()
    
    init(delegate: TodoAppDelegate!) {
        self.delegate = delegate
    }
    
    func setTask(task: String, date: Date?) {
        if task != "" {
            let newTask = Todo(task: task, isCompleted: false, date: date)
            try! realmConnection.write {
                realmConnection.add(newTask)
            }
            
            self.setNotification(data: newTask)
            delegate?.setTask(data: newTask)
            self.getTasks()
        }else{
            delegate?.failedTask(error: "Task is empty!")
        }
    }
    
    func getTasks() {
        let tasks = realmConnection.objects(Todo.self)
        if tasks.count > 0 {
            var result = [Todo]()
            for task in tasks {
                result.append(task)
            }
            delegate?.getTasks(data: result)
        }else{
            delegate?.failedTask(error: "Nothing Found!")
        }
    }
    
    func updateTask(id: ObjectId, task: String, isCompleted: Bool) {
        if task != "" {
            let oldTask = realmConnection.objects(Todo.self).where {
                $0._id == id
            }
            if oldTask.count == 1 {
                let newTask = oldTask.first
                try! realmConnection.write {
                    newTask?.taskText = task
                    newTask?.isCompleted = isCompleted
                }
                
                if isCompleted {
                    notificationManager.removeNotification(identifier: (newTask?._id.stringValue)!)
                }else{
                    self.setNotification(data: newTask!)
                }
                
                delegate?.updateTask(data: newTask!)
                self.getTasks()
            }else{
                delegate?.failedTask(error: "Task is not found!!")
            }
        }else{
            delegate?.failedTask(error: "Task is empty!!")
        }
    }
    
    func deleteTask(id: ObjectId) {
        let oldTask = realmConnection.objects(Todo.self).where {
            $0._id == id
        }
        if oldTask.count == 1 {
            try! realmConnection.write {
                realmConnection.delete(oldTask.first!)
            }
            
            notificationManager.removeNotification(identifier: id.stringValue)
            delegate?.deleteTask(data: true)
            self.getTasks()
        }else{
            delegate?.failedTask(error: "Task is not found!!")
        }
    }
    
    func searchTasks(task: String) {
        if task != "" {
            let tasks = realmConnection.objects(Todo.self).where {
                $0.taskText.contains(task)
            }
            
            var newTasks = [Todo]()
            for val in tasks {
                newTasks.append(val)
            }
            
            delegate?.getTasks(data: newTasks)
        }else{
            delegate?.failedTask(error: "Input is empty!")
        }
    }
    
    private func setNotification(data: Todo) {
        var notifications = [NotificationData]()
        var notification = NotificationData(id: data._id.stringValue, title: data.taskText, subTitle: "Let's do it!", dateTime: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: data.doneDate))
        notifications.append(notification)
        notificationManager.notifications = notifications
        notificationManager.schedules()
    }
}
