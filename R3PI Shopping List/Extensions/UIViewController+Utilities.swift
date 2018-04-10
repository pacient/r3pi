//
//  UIViewController+Utilities.swift
//  R3PI Shopping List
//
//  Created by Vasil Nunev on 07/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /// Dismisses the keyboard without caring who the first responder is
    @IBAction func dismissKeyboard() {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
}
