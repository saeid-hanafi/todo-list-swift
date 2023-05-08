//
//  ViewController.swift
//  todoList
//
//  Created by Macvps on 5/6/23.
//

import UIKit

class ViewController: UIViewController {
    
    private var todoModel: TodoModel!
    private var todos = [Todo]()
    
    @IBOutlet var taskInput: UITextField!
    @IBOutlet var taskTableView: UITableView!
    @IBOutlet var addTaskBtn: UIButton!
    @IBOutlet var taskDateInput: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoModel = TodoModel(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.todoModel.getTasks()
    }
    
    @IBAction func inputValChanged(_ sender: Any) {
        let task = self.taskInput.text!
        if task != "" {
            self.todoModel.searchTasks(task: self.taskInput.text!)
        }else{
            self.todoModel.getTasks()
        }
    }
    
    @IBAction func addTaskBtnAction(_ sender: Any) {
        var date: Date? = self.taskDateInput.date
        if date!.timeIntervalSince1970 < Date().timeIntervalSince1970 {
            date = nil
        }
        
        self.todoModel.setTask(task: self.taskInput.text!, date: date)
    }
    
}

extension ViewController: TodoAppDelegate, UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.taskTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.taskTableView.dequeueReusableCell(withIdentifier: TableViewCell.ID) as! TableViewCell
        
        if self.todos.count > 0 {
            switch self.todos[indexPath.row].isCompleted {
                case true:
                    cell.checkLbl.text = "✅"
                    break
                default:
                    cell.checkLbl.text = "☑️"
            }
            cell.taskLbl.text = self.todos[indexPath.row].taskText
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var doneAction: UIContextualAction!
        
        if self.todos[indexPath.row].isCompleted {
            doneAction = UIContextualAction(style: .normal, title: "Again") { act, vi, completion in
                self.todoModel.updateTask(id: self.todos[indexPath.row]._id, task: self.todos[indexPath.row].taskText, isCompleted: false)
            }
            doneAction.backgroundColor = .red
        }else{
            doneAction = UIContextualAction(style: .normal, title: "Done") { act, vi, completion in
                self.todoModel.updateTask(id: self.todos[indexPath.row]._id, task: self.todos[indexPath.row].taskText, isCompleted: true)
            }
            doneAction.backgroundColor = .green
        }
        
        return UISwipeActionsConfiguration(actions: [doneAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { act, vi, completion in
            self.todoModel.deleteTask(id: self.todos[indexPath.row]._id)
        }
        action.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func deleteTask(data: Bool) {
        print("Deleted Todo is : \(data)")
    }
    
    func setTask(data: Todo) {
        print("Todo is : \(data)")
        self.taskInput.text = ""
    }
    
    func getTasks(data: [Todo]) {
        self.todos = data
        self.taskTableView.reloadData()
    }
    
    func updateTask(data: Todo) {
        print("New Todo is : \(data)")
    }
    
    func failedTask(error: String) {
        print("Error is : \(error)")
    }
}

