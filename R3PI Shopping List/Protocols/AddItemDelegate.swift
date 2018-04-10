//
//  AddItemDelegate.swift
//  R3PI Shopping List
//
//  Created by Vasil Nunev on 07/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

import Foundation

protocol AddItemDelegate: class {
    func add(_ item: Item, quantity: Int)
}
