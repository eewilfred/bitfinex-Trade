//
//  TradePairsListingCellPresentation.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 28/08/2021.
//

import Foundation

struct TradePairsListingCellPresentation: Hashable {

    var symbol: String?
    var lastPrice: Float?
    var dailyChange: Float?
}
