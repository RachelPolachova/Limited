//
//  Category.swift
//  Limited
//
//  Created by Ráchel Polachová on 7.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = "3F3F3F"
    
    let items = List<Item>()
    
}
