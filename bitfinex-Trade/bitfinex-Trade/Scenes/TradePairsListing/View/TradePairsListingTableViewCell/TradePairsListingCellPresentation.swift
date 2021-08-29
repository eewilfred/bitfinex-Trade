//
//  TradePairsListingCellPresentation.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 28/08/2021.
//

import UIKit

struct TradePairsListingCellPresentation: Hashable {

    private enum Constants {
        static let dailyChangeIndex = 4
        static let lastPriceIndex = 6
    }

    var symbol: String?
    var lastPrice: NSAttributedString?
    var dailyChange: NSAttributedString?
    var dailyChangeBgColor = UIColor.green

    init(tradeInfo: TradePair) {

        let dailyChange = tradeInfo.values[safe: Constants.dailyChangeIndex]
        let lastPrice = tradeInfo.values[safe: Constants.lastPriceIndex]

        var dailyChangeForegroundColor = UIColor.black
        var lastPriceTextColor = UIColor(named: "DarkGreen") ?? .green

        if (dailyChange ?? 0.0) < 0 {
            dailyChangeBgColor = .red
            dailyChangeForegroundColor = .white
            lastPriceTextColor = .red
        }

        symbol = String(tradeInfo.name.dropFirst()) // remove "t"
        self.dailyChange = NSAttributedString(
            string: String(format: "%.3f", dailyChange ?? 0.0),
            attributes: [.foregroundColor : dailyChangeForegroundColor]
        )
        self.lastPrice = NSAttributedString(
            string: String(format: "%.3f", lastPrice ?? 0.0),
            attributes: [.foregroundColor : lastPriceTextColor]
        )
    }
}
