//
//  ShoppingListViewModel.swift
//  R3PI Shopping List
//
//  Created by Vasil Nunev on 07/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

import UIKit

extension ShoppingListViewController {
    
    struct ViewModel {
        
        let item: Item
        
        private var name: String {
            return item.name
        }
        private var price: String {
            return "$\(item.price)"
        }
        private var image: UIImage {
            return UIImage(named: item.imageName) ?? UIImage()
        }
        
        func configure(_ cell: ItemCell) {
            cell.item = item
            cell.itemNameLabel.text = name
            cell.itemPriceLabel.text = price
            cell.itemImageView.image = image
        }
    }
}
