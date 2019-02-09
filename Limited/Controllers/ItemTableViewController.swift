//
//  ItemTableViewController.swift
//  Limited
//
//  Created by Ráchel Polachová on 8.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit
import RealmSwift

class ItemTableViewController: UITableViewController, SideAddItemDelegate {
    
    @IBOutlet weak var barNavigation: UINavigationItem!
    
    var toDoItems : Results<Item>? = nil
    var plannedItems = [Item]()
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet {
            barNavigation.title = selectedCategory?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor(hex: selectedCategory!.color)
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    
    // MARK: - TableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plannedItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        if plannedItems.count != 0 {
            let item = plannedItems[indexPath.row]
            cell.setItem(item: item)
        } else {
            cell.textLabel?.text = "No items."
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
                    self.realm.delete(self.plannedItems[indexPath.row])
                    self.loadItems()
                }
            } catch {
                print("Error deleting item: \(error)")
            }
        }
        
        action.backgroundColor = .red
        action.image = #imageLiteral(resourceName: "trash")
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let todo = plannedItems[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, completetion) in
            view.backgroundColor = .red
            
            do {
                try self.realm.write {
                    todo.isDone = true
                    self.loadItems()
                }
                self.tableView.reloadData()
            } catch {
                print("Error adding done to item: \(error)")
            }
            completetion(true)
        }
        action.image = #imageLiteral(resourceName: "checkmark")
        action.backgroundColor = UIColor(hex: "45bc2d")
        return action
    }
    
    
    // MARK : - Current Item delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToCurrentItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goToAddItem":
            
            let destinationVC = segue.destination as! AddItemViewController
            destinationVC.addDelegate = self
            destinationVC.categoryColor = selectedCategory?.color
            
        case "goToCurrentItem":
            let destinationVC = segue.destination as! CurrentItemViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedItem = plannedItems[indexPath.row]
            }
        default:
            break
        }
        
    }
    
    
    //    MARK: - Realm methods
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "name")
        
        plannedItems = [Item]()
        
        for i in 0..<selectedCategory!.items.count {
            if selectedCategory?.items[i].isDone == false {
                plannedItems.append(selectedCategory!.items[i])
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToAddItem", sender: self)
        
        
    }
    
    func itemAdded(name: String, description: String) {
        let newItem = Item()
        newItem.name = name
        newItem.itemDescription = description
        newItem.color = selectedCategory!.color
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
    
}
