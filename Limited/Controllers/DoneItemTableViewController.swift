//
//  DoneItemTableViewController.swift
//  Limited
//
//  Created by Ráchel Polachová on 13.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit
import RealmSwift

class DoneItemTableViewController: UITableViewController {

    var doneToDoItems : Results<Item>? = nil
    let realm = try! Realm()
    var doneArray = [Item]()
    
    var selectedCategory = Category()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItem()
    }

    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doneArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell")
        
        let item = doneArray[indexPath.row]
        cell?.textLabel?.text = item.name
        
        return cell!
    }
    
    func loadItem() {
        doneToDoItems = selectedCategory.items.sorted(byKeyPath: "name")
        
        for i in 0..<selectedCategory.items.count {
            if selectedCategory.items[i].isDone == true {
                doneArray.append(selectedCategory.items[i])
            }
        }
        
    }

}
