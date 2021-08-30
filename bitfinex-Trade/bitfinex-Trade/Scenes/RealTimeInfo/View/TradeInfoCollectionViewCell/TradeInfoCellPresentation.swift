//
//  TradeInfoCellPresentation.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 31/08/2021.
//

import Foundation

struct TradeInfoCellPresentation: Hashable {

    var amount: String?
    var price: String?
    var time: String?
    let uuid = UUID()


    init(update: [TradePairTradesUpdate.Information]) {

        update.forEach { info in
            switch info {
                case .tradeID(_):
                    break
                case .timeStampInMilliSecond(let value):
                    let date = Date(milliseconds: value)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "h:mm a"
                    self.time = dateFormatter.string(from: date)
                case .amount(let value):
                    self.amount = String(format: "%.3f", value)
                case .price(let value):
                    self.price = String(format: "%.3f", value)
                case .unknown:
                    break
                }
        }
    }

    static func ==(lhs: TradeInfoCellPresentation, rhs: TradeInfoCellPresentation) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
