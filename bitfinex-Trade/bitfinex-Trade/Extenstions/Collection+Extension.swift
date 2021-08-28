//
//  Collection+Extension.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 28/08/2021.
//

import Foundation

extension Collection {

    /// Safe subscript, returns the element if index within bounds, nil otherwise
    ///
    /// - Parameter index: Index of the desired element
    subscript(safe index: Index) -> Element? {

        return indices.contains(index) ? self[index] : nil
    }
}
