//
//  AddItemViewController.swift
//  Limited
//
//  Created by Ráchel Polachová on 9.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit

protocol SideAddItemDelegate {
    func itemAdded(name: String, description: String)
}

class AddItemViewController: UIViewController {

    var addDelegate : SideAddItemDelegate!
    var categoryColor : String!
    
    @IBOutlet weak var nameOfItem: UITextField!
    @IBOutlet weak var descriptionOfItem: UITextView!
    @IBOutlet weak var addButton: UIButton!
    
    
    var originalHeightAddButton : CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        self.hideKeyboardWhenTappedAround()
        
    }
    
    
    // MARK : - UI
    
    func setUI() {
        originalHeightAddButton = addButton.frame.origin.y
        addButton.setTitleColor(UIColor(hex: categoryColor), for: .normal)
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        if let nameItem = nameOfItem.text, let descriptionItem = descriptionOfItem.text {
            addDelegate.itemAdded(name: nameItem, description: descriptionItem)
            _ = navigationController?.popViewController(animated: true)
        } else {
            
            let alert = UIAlertController(title: "Name your item", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (alert) in }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
}
