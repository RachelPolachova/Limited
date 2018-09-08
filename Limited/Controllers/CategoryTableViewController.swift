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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(realm.configuration.fileURL?.deletingLastPathComponent().path)
        
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
       
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            do {
                try realm.write {
                    realm.delete(categories![indexPath.row])
                    tableView.reloadData()
                }
            } catch {
                print("Error deleting category: \(error)")
            }
            
        }
    }
    
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        let selectionVC = storyboard?.instantiateViewController(withIdentifier: "addCategory") as! AddCategoryViewController
        selectionVC.addDelegate = self
        present(selectionVC, animated: true, completion: nil)
        
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

extension UIColor {
    
    // MARK: - Initialization
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt32 = 0
        
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        
        let length = hexSanitized.characters.count
        
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
            
        } else {
            return nil
        }
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - Computed Properties
    
    var toHex: String? {
        return toHex()
    }
    
    // MARK: - From UIColor to String
    
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
}
}
