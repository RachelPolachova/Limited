//
//  CategoryTableViewController.swift
//  Limited
//
//  Created by Ráchel Polachová on 7.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController, SideAddDelegate {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.configuration.fileURL?.deletingLastPathComponent().path ?? "no path")
        loadCategory()

    }

    
    
    // MARK: - TableView Delegate Methods
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories yet."
        
        let categoryColor = categories?[indexPath.row].color
        
        cell.textLabel?.textColor = UIColor(hex: categoryColor!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "goToAddCategory":
            let destinationVC = segue.destination as! AddCategoryViewController
            destinationVC.addDelegate = self
            
        case "goToItems":
            let destinationVC = segue.destination as! ItemTableViewController
            
            if let indexPath = tableView.indexPathForSelectedRow {
                destinationVC.selectedCategory = categories?[indexPath.row]
            }
        default:
            break
        }
        
        
        
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            
            do {
                
                try self.realm.write {
                    
                    for _ in 0..<self.categories![indexPath.row].items.count {
                        
                        self.realm.delete(self.categories![indexPath.row].items[0])
                        
                    }
                    
                    self.realm.delete(self.categories![indexPath.row])
                    
                }
                self.loadCategory()
                
            } catch {
                
                print("Error deleting data: \(error)")
                
            }
        }
        
        action.backgroundColor = .red
        action.image = #imageLiteral(resourceName: "garbage")
        
        return action
    }
    
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToAddCategory", sender: self)
    }
    
    
    // MARK: - REALM categories functions
    
    func saveCategory(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
    }
    
    func loadCategory() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    func categoryAdded(name: String, color: UIColor) {
        let newCategory = Category()
        newCategory.name = name
        newCategory.color = color.toHex!
        self.saveCategory(category: newCategory)
        self.tableView.reloadData()
    }
    
}



