//
//  TradePairsFetchingCases.swift
//  bitfinex-TradeTests
//
//  Created by Edwin Wilson on 28/08/2021.
//

import XCTest
@testable import bitfinex_Trade

class TradePairsFetchingCases: XCTestCase {

    func testTradePairsAPICreation() throws {

        _ = try XCTUnwrap(NetworkManager.shared.URLForApi(path:TradePairs.tradePairsAPI))
    }

    func testTradePairsFetch() {

        guard let url =  NetworkManager.shared.URLForApi(path:TradePairs.tradePairsAPI) else {
            XCTFail("URL Creation Failed")
            return
        }

        NetworkManager.shared.start(request: url) { (response: Response<TradePairs>) in
            XCTAssertFalse(response.result?.pairs.isEmpty ?? false,  "TradePairs Parsing failed")
        }
    }

}
