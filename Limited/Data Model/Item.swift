//
//  File.swift
//  Limited
//
//  Created by Ráchel Polachová on 8.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var numberOfDone : Int = 0
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
