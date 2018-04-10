//  Adapted from https://github.com/antitypical/Result
//  Copyright (c) 2015 Rob Rix. All rights reserved.
//
//  ResultProtocol.swift
//  R3PI Shopping List

protocol ResultProtocol {
    associatedtype Value
    
    /// Constructs a successful result wrapping a `value`.
    init(value: Value)
    
    /// Constructs a failed result wrapping an `error`.
    init(error: Error)
    
    /// Case analysis for ResultProtocol.
    ///
    /// Returns the value produced by appliying `ifFailure` to the error if self represents a failure, or `ifSuccess` to the result value if self represents a success.
    func analysis<U>(ifSuccess: (Value) -> U, ifFailure: (Error) -> U) -> U
    
    /// Returns the value if self represents a success, `nil` otherwise.
    ///
    /// A default implementation is provided by a protocol extension. Conforming types may specialize it.
    var value: Value? { get }
    
    /// Returns the error if self represents a failure, `nil` otherwise.
    ///
    /// A default implementation is provided by a protocol extension. Conforming types may specialize it.
    var error: Error? { get }
}

extension ResultProtocol {
    
    /// Returns true if self represents a success, false otherwise.
    var isSuccess: Bool {
        return analysis(ifSuccess: { _ in true }, ifFailure: { _ in false })
    }
    
    /// Returns false if self represents a success, true otherwise.
    var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the value if self represents a success, `nil` otherwise.
    var value: Value? {
        return analysis(ifSuccess: { $0 }, ifFailure: { _ in nil })
    }
    
    /// Returns the error if self represents a failure, `nil` otherwise.
    var error: Error? {
        return analysis(ifSuccess: { _ in nil }, ifFailure: { $0 })
    }
}
