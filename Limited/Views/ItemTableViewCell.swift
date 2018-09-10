//
//  ItemTableViewCell.swift
//  Limited
//
//  Created by Ráchel Polachová on 10.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    
    @IBOutlet weak var nameOfItemLabel: UILabel!
    @IBOutlet weak var numberOfDone: UILabel!
    
    func setItem(item: Item) {
        nameOfItemLabel.text = item.name
        numberOfDone.text = "//  " + String(item.numberOfDone)
        
        if item.isImportant {
            nameOfItemLabel.textColor = .white
            numberOfDone.textColor = .white
            backgroundColor = UIColor(hex: item.color)?.withAlphaComponent(0.8)
        }
    }
}
