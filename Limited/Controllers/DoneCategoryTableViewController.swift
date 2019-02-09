//
//  DoneCategoryTableViewController.swift
//  Limited
//
//  Created by Ráchel Polachová on 13.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit
import RealmSwift

class DoneCategoryTableViewController: UITableViewController {

    let realm = try! Realm()
    var categories : Results<Category>? = nil    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = .darkGray
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        performSegue(withIdentifier: "goToDoneItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DoneItemTableViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = (categories?[indexPath.row])!
        }
    }
    
    
    func loadCategory() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }

}
