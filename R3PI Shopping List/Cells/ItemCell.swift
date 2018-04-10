//
//  ItemCell.swift
//  R3PI Shopping List
//
//  Created by Vasil Nunev on 07/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    var item: Item?

    @IBOutlet var itemNameLabel: UILabel!
    @IBOutlet var itemPriceLabel: UILabel!
    @IBOutlet var quantityTextField: UITextField!
    @IBOutlet var itemImageView: UIImageView!
    
    weak var delegate: AddItemDelegate?
    
    @IBAction private func addButtonTapped(_ sender: Any) {
        guard let item = item,
            let quantity = quantityTextField.text else { return }
        delegate?.add(item, quantity: Int(quantity) ?? 0)
    }
}
