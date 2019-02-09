//
//  File.swift
//  Limited
//
//  Created by Ráchel Polachová on 8.9.18.
//  Copyright © 2018 Rachel Polachova. All rights reserved.
//

import Foundation
 import RealmSwift
import UIKit

class Item: Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var itemDescription: String = ""
    @objc dynamic var color : String = "3F3F3F"
    @objc dynamic var numberOfDone : Int = 0
    @objc dynamic var isImportant : Bool = false
    @objc dynamic var isDone : Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
