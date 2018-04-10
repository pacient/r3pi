//
//  Result.swift
//  R3PI Shopping List
//
//  Created by Vasil Nunev on 10/04/2018.
//  Copyright © 2018 Vasil Nunev. All rights reserved.
//

enum Result<T>: ResultProtocol, CustomDebugStringConvertible, CustomStringConvertible {
    
    case success(T)
    case failure(Error)
    
    // MARK: - Constructors
    
    /// Constructs a success wrapping a `value`.
    init(value: T) {
        self = .success(value)
    }
    
    /// Constructs a failure wrapping an `error`.
    init(error: Error) {
        self = .failure(error)
    }
    
    /// Case analysis for Result.
    ///
    /// Returns the value produced by applying `ifFailure` to `failure` Results, or `ifSuccess` to `success` Results.
    func analysis<Result>(ifSuccess: (T) -> Result, ifFailure: (Error) -> Result) -> Result {
        switch self {
        case let .success(value):
            return ifSuccess(value)
        case let .failure(value):
            return ifFailure(value)
        }
    }
    
    // MARK: CustomStringConvertible
    
    var description: String {
        return analysis(
            ifSuccess: { ".success(\($0))" },
            ifFailure: { ".failure(\($0))" })
    }
    
    // MARK: CustomDebugStringConvertible
    
    var debugDescription: String {
        return description
    }
}
