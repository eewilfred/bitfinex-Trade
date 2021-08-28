//
//  TradePairsListingViewModel.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 28/08/2021.
//

import Foundation

struct TradePairsListingState {

    var pairs: [TradePair]?
}

class TradePairsListingViewModel {

    var state = TradePairsListingState()

    func fetchTradePairs( completionHandler: @escaping (Bool) -> Void) {

        guard let url = NetworkManager.shared.URLForApi(path: TradePairs.tradePairsAPI) else {
            completionHandler(false)
            return
        }
        NetworkManager.shared.start(request: url) { [unowned self] (response: Response<TradePairs>) in

            guard response.error == nil,
                  let pairs = response.result?.pairs else {
                completionHandler(false)
                return
            }
            state.pairs = pairs
            completionHandler(true)
        }
    }
}
