//
//  ItemTableViewController.swift
//  Limited
//
//  Created by Ráchel Polachová on 8.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit
import RealmSwift

class ItemTableViewController: UITableViewController {


    
    var toDoItems : Results<Item>? = nil
    let realm = try! Realm()
    @IBOutlet weak var barNavigation: UINavigationItem!
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barNavigation.title = selectedCategory?.name

    }
    
    
    // MARK: - TableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        if let item = toDoItems?[indexPath.row] {
            cell.textLabel?.text = item.name + " " + String(item.numberOfDone)
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            do {
                try self.realm.write {
                    self.realm.delete(self.toDoItems![indexPath.row])
                    self.loadItems()
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
        
        action.backgroundColor = .red
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let todo = toDoItems![indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, completetion) in
            print("Done \(todo.name)")
            do {
                try self.realm.write {
                    todo.numberOfDone += 1
                }
                self.tableView.reloadData()
            } catch {
                print("Error adding done to item: \(error)")
            }
            completetion(true)
        }
        
        action.backgroundColor = .green
        return action
    }
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "name")
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var nameTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new item.", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (alert) in }
        let addAction = UIAlertAction(title: "Add", style: .default) { (alert) in
            let newItem = Item()
            newItem.name = nameTextField.text!
            
            do {
                try self.realm.write {
                    self.realm.add(newItem)
                    self.selectedCategory?.items.append(newItem)
                    self.loadItems()
                }
            } catch {
                print("Error adding new item: \(error)")
            }
        }
        
        alert.addTextField { (textField) in
            nameTextField = textField
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        self.tableView.reloadData()
    }
    
}
