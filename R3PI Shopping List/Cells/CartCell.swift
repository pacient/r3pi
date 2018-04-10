//
//  CartCell.swift
//  R3PI Shopping List
//
//  Created by Vasil Nunev on 07/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    var item: Item?
    
    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemPriceLabel: UILabel!
    @IBOutlet var itemQuantityLabel: UILabel!
    @IBOutlet var itemImageView: UIImageView!
    
    weak var delegate: RemoveItemDelegate?
    
    @IBAction private func removeTapped(_ sender: Any) {
        guard let item = item else { return }
        delegate?.remove(item)
    }
}
