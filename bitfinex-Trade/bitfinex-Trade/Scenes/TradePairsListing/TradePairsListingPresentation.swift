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

        tradePairsCellPresentations = state.pairs?.map{
            TradePairsListingCellPresentation(tradeInfo: $0)
        } ?? []
    }
}
