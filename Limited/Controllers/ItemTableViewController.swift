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


    
    var toDoItems : Results<Item>? = nil
    let realm = try! Realm()
    @IBOutlet weak var barNavigation: UINavigationItem!
    
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
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! ItemTableViewCell
        
        if let item = toDoItems?[indexPath.row] {
            cell.setItem(item: item)
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
        action.image = #imageLiteral(resourceName: "wastebin24.png")
        
        return action
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let todo = toDoItems![indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, completetion) in
            view.backgroundColor = .red
            
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
        
        action.image = #imageLiteral(resourceName: "done24.png")
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
                destinationVC.selectedItem = toDoItems?[indexPath.row]
            }
        default:
            break
        }
        
    }
    
    
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "name")
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
