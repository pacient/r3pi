//
//  R3PI_Shopping_ListTests.swift
//  R3PI Shopping ListTests
//
//  Created by Vasil Nunev on 06/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

import XCTest
@testable import R3PI_Shopping_List

class R3PI_Shopping_ListTests: XCTestCase {
    
    func testEndpointIsSuccess() {
        let api = API()
        let promise = expectation(description: "isSuccess")
        api.requestCurrencies { result in
            if result.isSuccess {
                promise.fulfill()
            } else {
                XCTFail("Error: \(result.error?.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testExchangeRate() {
        let milk = Item(name: "Milk", price: 1.30, imageName: "milk")
        let cart = ["Milk": [milk,milk]]
        let currency = ["EUR": 0.80]
        let rate = currency["EUR"] ?? 1.0
        var sum: Double = 0.0
        for key in cart.keys {
            guard let items = cart[key] else { continue }
            sum += items.reduce(0, { $0 + $1.price })
        }
        let subtotal = sum * rate
        let expectedSubtotal = 2.08
        XCTAssertEqual(expectedSubtotal, subtotal)
    }
}
