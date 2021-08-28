//
//  TradePairsListingPresentation.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 28/08/2021.
//

import Foundation

struct TradePairsListingPresentation {

    enum Sections: CaseIterable {

        case pairs
    }

    var tradePairsCellPresentations = [TradePairsListingCellPresentation]()

    mutating func update(state: TradePairsListingState) {

        tradePairsCellPresentations = state.pairs?.map { pairInfo -> TradePairsListingCellPresentation in

            let dailyChange = pairInfo.values[4]
            let lastPrice = pairInfo.values[6]

            return TradePairsListingCellPresentation(
                symbol: pairInfo.name,
                lastPrice: lastPrice,
                dailyChange: dailyChange
            )
        } ?? []
    }
}
