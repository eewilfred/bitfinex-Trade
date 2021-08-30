//
//  RealTimeInfoViewCellPresentation.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 30/08/2021.
//

import UIKit

struct TickerInfoViewCellPresentation: Hashable {

    var fieldTitle: String
    var value: NSAttributedString

    init(info: TradePairTickerUpdates.Information) {

        switch info {
        case .bid(let value):
            fieldTitle = "Highest bid:"
            self.value = NSAttributedString(string: String(format: "%.3f", value))
        case .bidSize(let value):
            fieldTitle = "Bid size:"
            self.value = NSAttributedString(string: String(format: "%.3f", value))
        case .ask(let value):
            fieldTitle = "Lowest Ask:"
            self.value = NSAttributedString(string: String(format: "%.3f", value))
        case .askSize(let value):
            fieldTitle = "Ask Size:"
            self.value = NSAttributedString(string: String(format: "%.3f", value))
        case .dailyChange(let value):
            fieldTitle = "Price Change:"
            var textColor = UIColor(named: "DarkGreen") ?? .green
            if value < 0.0 {
                textColor = .red
            }
            self.value = NSAttributedString(
                string: String(format: "%.3f", value),
                attributes: [.foregroundColor : textColor]
            )
        case .dailyChangeRelative(let value):
            fieldTitle = "Relative Price Change:"
            let percentage = value * 100.0
            var textColor = UIColor(named: "DarkGreen") ?? .green
            if value < 0.0 {
                textColor = .red
            }
            self.value = NSAttributedString(
                string: String(format: "%.3f", percentage),
                attributes: [.foregroundColor : textColor]
            )
        case .lastPrice(let value):
            fieldTitle = "Lasr price:"
            self.value = NSAttributedString(string: String(format: "%.3f", value))
        case .volume(let value):
            fieldTitle = "Volume:"
            self.value = NSAttributedString(string: String(format: "%.3f", value))
        case .heigh(let value):
            fieldTitle = "High:"
            self.value = NSAttributedString(string: String(format: "%.3f", value))
        case .low(let value):
            fieldTitle = "Low:"
            self.value = NSAttributedString(string: String(format: "%.3f", value))
        case .unknown:
            fieldTitle = ""
            self.value = NSAttributedString()
        }
    }
}
