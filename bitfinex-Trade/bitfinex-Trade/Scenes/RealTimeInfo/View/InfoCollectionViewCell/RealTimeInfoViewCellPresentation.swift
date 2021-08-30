//
//  RealTimeInfoViewCellPresentation.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 30/08/2021.
//

import Foundation

struct RealTimeInfoViewCellPresentation: Hashable {

    var fieldTitle: String
    var value: String

    init(info: TradePairUpdates.Information) {

        switch info {
        case .bid(let value):
            fieldTitle = "Highest bid:"
            self.value = String(format: "%.3f", value)
        case .bidSize(let value):
            fieldTitle = "Bid size:"
            self.value = String(format: "%.3f", value)
        case .ask(let value):
            fieldTitle = "Lowest Ask:"
            self.value = String(format: "%.3f", value)
        case .askSize(let value):
            fieldTitle = "Ask Size:"
            self.value = String(format: "%.3f", value)
        case .dailyChange(let value):
            fieldTitle = "Price Change:"
            self.value = String(format: "%.3f", value)
        case .dailyChangeRelative(let value):
            fieldTitle = "Relative Price Change:"
            let percentage = value * 100.0
            self.value = String(format: "%.3f percent", percentage)
        case .lastPrice(let value):
            fieldTitle = "Lasr price:"
            self.value = String(format: "%.3f", value)
        case .volume(let value):
            fieldTitle = "Volume:"
            self.value = String(format: "%.3f", value)
        case .heigh(let value):
            fieldTitle = "High:"
            self.value = String(format: "%.3f", value)
        case .low(let value):
            fieldTitle = "Low:"
            self.value = String(format: "%.3f", value)
        case .unknown:
            fieldTitle = ""
            self.value = ""
        }
    }
}
