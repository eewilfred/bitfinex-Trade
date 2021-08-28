//
//  TradePairs.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 26/08/2021.
//

import Foundation

// MARK: - TradePairs

struct TradePairs: BaseResult {

    static let tradePairsAPI = "/tickers?symbols=ALL"
    var pairs = [TradePair]()

    init(from decoder: Decoder) throws {

        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            if let pair = try? container.decode(TradePair.self) {
                if pair.name.first == "t" { //to add only  trading pairs
                    pairs.append(pair)
                }
            }
        }
    }
}

// MARK: - TradePair

struct TradePair: BaseResult {

    var values = [Float]()
    var name: String = ""

    init(from decoder: Decoder) throws {

        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            if let name = try? container.decode(String.self) {
                self.name = name
                if name.first == "f" { //not to parse details of funding currencies
                    break
                }
            } else if let item = try? container.decode(Float.self) {
                values.append(item)
            } else if let _ = try? container.decodeNil() {
                values.append(0.0)
            }
        }
    }
}
