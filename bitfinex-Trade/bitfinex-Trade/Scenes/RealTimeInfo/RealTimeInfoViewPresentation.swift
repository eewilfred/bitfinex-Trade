//
//  RealTimeInfoViewPresentation.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 30/08/2021.
//

import Foundation

struct RealTimeInfoViewPresentation {

    enum Sections: CaseIterable {

        case tickerInfo
        case tradeInfo
    }

    var tickerInfoCellPresentation: [TickerInfoViewCellPresentation]?

    mutating func updaTetradeInfoCellPresentation(state: RealTimeInfoViewState) {

        tickerInfoCellPresentation = state.tickerUpdate?.updateInfo.map({ (info) in

            TickerInfoViewCellPresentation(info: info)
        })
    }
}
