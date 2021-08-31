//
//  TradePairsListingViewModelTest.swift
//  bitfinex-TradeTests
//
//  Created by Edwin Wilson on 31/08/2021.
//

import XCTest
@testable import bitfinex_Trade

class TradePairsListingViewModelTest: XCTestCase {


    func testViewModelTestPairFetch() throws {

        let model = TradePairsListingViewModel()

        let expectation = expectation(description: "Pair Fetch")
        var isSuccess: Bool?
        model.fetchTradePairs { success in

            isSuccess = success
            expectation.fulfill()
        }

        waitForExpectations(timeout: 60.0, handler: nil)
        guard let success = isSuccess else {
            XCTFail("success was not passed")
            return
        }
        XCTAssertTrue(success, "Fetching trade pairs failed")
        XCTAssertNotNil(model.state.pairs, "Pairs did not get copied")
    }

    func testPerformanceExample() throws {

        let model = TradePairsListingViewModel()
        self.measure {

            let expectation = expectation(description: "Pair Fetch")
            model.fetchTradePairs { success in
                expectation.fulfill()
            }

            waitForExpectations(timeout: 60.0, handler: nil)
            XCTAssertNotNil(model.state.pairs, "Pairs did not get copied")
        }
    }

}
