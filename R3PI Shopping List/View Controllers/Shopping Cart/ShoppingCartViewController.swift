//
//  ShoppingCartViewController.swift
//  R3PI Shopping List
//
//  Created by Vasil Nunev on 07/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

import UIKit

class ShoppingCartViewController: UIViewController {

    @IBOutlet private var subtotalLabel: UILabel!
    @IBOutlet private var currencyLabel: UILabel!
    @IBOutlet private var emptyView: UIView!
    @IBOutlet private var tableView: UITableView!
    private lazy var currencyPickerView: UIPickerView = {
        let picker = UIPickerView(frame: CGRect(x: 0, y: view.bounds.height - 250, width: view.bounds.width, height: 250))
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true
        picker.backgroundColor = .lightGray
        picker.showsSelectionIndicator = true

        view.addSubview(picker)
        return picker
    }()
    private var currencies: [String: Double] = [:]
    private let cartIdentifier = "cart"
    private let api = API()
    private var selectedCurrency: String = "USD" {
        didSet {
            currencyDidChange()
        }
    }
    private var cartItems: [String: [Item]] {
        let items: [Item] = getCartItems() ?? []
        currencyDidChange()
        return Dictionary(grouping: items, by: { $0.name })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCurrencies()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePickerIfNeeded))
        view.addGestureRecognizer(tapGesture)
        navigationItem.title = "Cart"
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func hidePickerIfNeeded() {
        if !currencyPickerView.isHidden {
            currencyPickerView.isHidden = true
        }
    }
    
    private func currencyDidChange() {
        guard let items = getCartItems() else { return }
        let rate = currencies[selectedCurrency] ?? 1.0
        let sum = items.reduce(0, { $0 + $1.price }) * rate
        let title = selectedCurrency.replacingOccurrences(of: "USD", with: "")
        currencyLabel.text = title == "" ? "USD" : title
        subtotalLabel.text = "\(Double(round(100*sum)/100))"
    }
    
    private func getCurrencies() {
        api.requestCurrencies { [weak self] result in
            guard let response = result.value else {
                print(result.error.debugDescription)
                return
            }
            self?.currencies = response.quotes
        }
    }
    
    private func getCartItems() -> [Item]? {
        let decoder = JSONDecoder()
        let ud = UserDefaults.standard
        if let decoded = ud.data(forKey: cartIdentifier) {
            do {
                let items = try decoder.decode([Item].self, from: decoded)
                emptyView.isHidden = items.count != 0
                return items
            } catch {
                print(error)
                emptyView.isHidden = false
                return nil
            }
        }
        emptyView.isHidden = false
        return nil
    }
    
    private func storeItems(_ items: [Item]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(items) {
            UserDefaults.standard.set(encoded, forKey: cartIdentifier)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction private func currencyTapped(_ sender: Any) {
        getCurrencies()
        guard currencies.keys.count > 0 else {
            print("no currencies have been downloaded")
            return
        }
        currencyPickerView.isHidden = !currencyPickerView.isHidden
    }
}

// MARK: - UITableViewDelegate

extension ShoppingCartViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
}

// MARK: - UITableViewDataSource

extension ShoppingCartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = Array(cartItems.keys)[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell") as? CartCell,
            let item = cartItems[key]?.first,
            let quantity = cartItems[key]?.count else { return UITableViewCell() }
        
        let model = ViewModel(item: item, quantity: quantity)
        model.configure(cell)
        cell.delegate = self
        return cell
    }
}

// MARK: - UIPickerViewDataSource

extension ShoppingCartViewController: UIPickerViewDataSource {

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

// MARK: - UIPickerViewDelegate

extension ShoppingCartViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let keys = currencies.keys.compactMap {$0}
        var title = keys[row].replacingOccurrences(of: "USD", with: "")
        if title == "" {
            title = "USD"
        }
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let keys = currencies.keys.compactMap {$0}
        selectedCurrency = keys[row]
    }
}

// MARK: - ItemDelegate

extension ShoppingCartViewController: RemoveItemDelegate {
    
    func remove(_ item: Item) {
        let alert = UIAlertController(title: "Are you sure?", message: "Are you sure you want to remove \(item.name) from your shopping list?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let removeAction = UIAlertAction(title: "Remove", style: .default) { [weak self] _ in
            guard let items = self?.getCartItems() else { return }
            let restItems = items.filter { $0 != item }
            self?.storeItems(restItems)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(removeAction)
        present(alert, animated: true)
    }
}
