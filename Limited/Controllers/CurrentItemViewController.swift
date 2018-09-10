//
//  CurrentItemViewController.swift
//  Limited
//
//  Created by Ráchel Polachová on 9.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentItemViewController: UIViewController, SideEditItemDelegate {

    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var currentItemBarNavigator: UINavigationItem!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var importantLabel: UILabel!
    
    let realm = try! Realm()
    var selectedItem : Item? {
        didSet {
            currentItemBarNavigator.title = selectedItem?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItem()
        
    }

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goEditItem", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditCurrentItemViewController
        destinationVC.editDelegate = self
        destinationVC.isImportant = selectedItem!.isImportant
    }
    
    func itemEdited(isImportant: Bool) {
        do { try realm.write {
                selectedItem?.isImportant = isImportant
            }
        } catch {
            print("Error editing item: \(error)")
        }
        
        loadItem()
        
    }
    
    func loadItem() {
        importantLabel.text = selectedItem!.isImportant ? "Important" : "Not important"
        
        numberLabel.textColor = UIColor(hex: selectedItem!.color)
        
        if let desc = selectedItem?.itemDescription {
            descriptionLabel.text = desc
        } else {
            descriptionLabel.text = "No description."
        }
        
        if let count = selectedItem?.numberOfDone {
            numberLabel.text = String(count)
        } else {
            numberLabel.text = "0"
        }
    }
    
    
}
