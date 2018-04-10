//
//  ShoppingListViewController.swift
//  R3PI Shopping List
//
//  Created by Vasil Nunev on 06/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController {

    private lazy var items: [Item] = {
       return [
            Item(name: "Peas", price: 0.95, imageName: "peas"),
            Item(name: "Eggs", price: 0.175, imageName: "eggs"), // A dozen eggs is $2.10, each egg costs $0.175
            Item(name: "Milk", price: 1.30, imageName: "milk"),
            Item(name: "Beans", price: 0.73, imageName: "beans"),
        ]
    }()
    
    // MARK: - IBActions
    
    @IBAction private func cartTapped(_ sender: Any) {
        guard let vc = UIStoryboard(name: "ShoppingCart", bundle: nil).instantiateInitialViewController() as? ShoppingCartViewController else { return }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ShoppingListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemCell else { return UITableViewCell() }
        let model = ViewModel(item: items[indexPath.row])
        model.configure(cell)
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ShoppingListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

// MARK: - AddItemDelegate

extension ShoppingListViewController: AddItemDelegate {
    
    func add(_ item: Item, quantity: Int) {
        // TODO: It would be great to restrict to like a 1000 items in the basket for perfomance
        guard quantity > 0 else { return }
        let ud = UserDefaults.standard
        let cartIdentifier = "cart"
        let decoder = JSONDecoder()
        var items = [Item]()
        if let decoded = ud.data(forKey: cartIdentifier)  {
            do {
                items = try decoder.decode([Item].self, from: decoded)
                for _ in 1...quantity {
                    items.append(item)
                }
            } catch {
                print(error)
            }
        } else {
            for _ in 1...quantity {
                items.append(item)
            }
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            ud.set(encoded, forKey: cartIdentifier)
            showAddedAlert(for: item, quantity: quantity)
        }
    }
    
    private func showAddedAlert(for item: Item, quantity: Int) {
        let alert = UIAlertController(title: "Added", message: "\(item.name) x\(quantity) has been added to your cart", preferredStyle: .alert)
        present(alert, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.dismiss(animated: true)
                self.view.endEditing(true)
            })
        }
    }
}
