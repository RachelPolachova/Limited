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

        print(isImportant)
        
        // Do any additional setup after loading the view.
        
        if isImportant == true {
            importantSwitch.isOn = true
        } else {
            importantSwitch.isOn = false
        }
        
    }
    
    @IBAction func isImportantSwitched(_ sender: UISwitch) {
        if (sender.isOn == true) {
            print("on")
            isImportant = true
        } else {
            print("off")
            isImportant = false
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        editDelegate.itemEdited(isImportant: isImportant)
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
}

