//
//  RealTimeInfoViewPresentation.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 30/08/2021.
//

import Foundation

struct RealTimeInfoViewPresentation {

    enum Sections: Int, CaseIterable {

        case tickerInfo
        case tradeInfo
    }

    var tickerInfoCellPresentation: [TickerInfoViewCellPresentation]?
    var tradeInfoCellPresentation: [TradeInfoCellPresentation]?

    mutating func updaTickerInfoCellPresentation(state: RealTimeInfoViewState) {

        tickerInfoCellPresentation = state.tickerUpdate?.updateInfo.map({ (info) in
            TickerInfoViewCellPresentation(info: info)
        })
    }

    mutating func updaTradeInfoCellPresentation(state: RealTimeInfoViewState) {

        tradeInfoCellPresentation = state.tradeUpdate?.updateInfo.map({ (info) in
            TradeInfoCellPresentation(update: info)
        })
    }
}
