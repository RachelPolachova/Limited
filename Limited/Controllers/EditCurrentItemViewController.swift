//
//  EditCurrentItemViewController.swift
//  Limited
//
//  Created by Ráchel Polachová on 9.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit

protocol SideEditItemDelegate {
    func itemEdited(isImportant: Bool)
}

class EditCurrentItemViewController: UIViewController {

    var editDelegate : SideEditItemDelegate!
    var isImportant : Bool = false
    
    
    @IBOutlet weak var importantSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isImportant == true {
            importantSwitch.isOn = true
        } else {
            importantSwitch.isOn = false
        }
        
    }
    
    @IBAction func isImportantSwitched(_ sender: UISwitch) {
        if (sender.isOn == true) {
            isImportant = true
        } else {
            isImportant = false
        }
    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        editDelegate.itemEdited(isImportant: isImportant)
        _ = navigationController?.popViewController(animated: true)
    }
    
}

