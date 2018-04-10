//
//  Item.swift
//  R3PI Shopping List
//
//  Created by Vasil Nunev on 06/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

import UIKit

struct Item: Codable, Equatable {
    
    let name: String
    let price: Double
    let imageName: String
    
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.name == rhs.name && lhs.price == rhs.price
    }
}
