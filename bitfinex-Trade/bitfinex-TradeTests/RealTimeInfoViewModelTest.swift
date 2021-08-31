//
//  RealTimeInfoViewModelTest.swift
//  bitfinex-TradeTests
//
//  Created by Edwin Wilson on 31/08/2021.
//

import XCTest
@testable import bitfinex_Trade

class RealTimeInfoViewModelTest: XCTestCase, RealTimeInfoViewModelDelegate {

    var listingModel = TradePairsListingViewModel()

    var listningExptectation: XCTestExpectation?

    enum TestingError: Error {

        case tradePairDownLoadFailed
    }

    override func setUpWithError() throws {

        let expt = expectation(description: "fetchTradePairs")
        listingModel.fetchTradePairs { success in
            expt.fulfill()
        }
        waitForExpectations(timeout: 2.0, handler: nil)
        if listingModel.state.pairs?.isEmpty ?? true {
            throw TestingError.tradePairDownLoadFailed
        }
    }

    func testRealTimeInfoViewModelIntilization() {

        guard let pairs = listingModel.state.pairs,
              let symbol = pairs.first?.name else {
            XCTFail("can not retrive symbol or pair")
            return
        }
        let model = RealTimeInfoViewModel(tradePairSymbol: symbol, pairs: pairs)
        XCTAssertTrue(!model.state.pairs.isEmpty, "pairs not intilized properly")
        XCTAssertNil(model.state.tickerUpdate)
        XCTAssertNil(model.state.tradeUpdate)
    }

    // Check Socket listinign and restart flow
    func testSocketListining() {

        guard let pairs = listingModel.state.pairs,
              let symbol = pairs.first?.name else {
            XCTFail("can not retrive symbol or pair")
            return
        }
        let model = RealTimeInfoViewModel(tradePairSymbol: symbol, pairs: pairs)
        model.delegate = self
        listningExptectation = expectation(description: "startListningForUpdates")
        listningExptectation?.expectedFulfillmentCount = 2
        model.startListningForUpdates()
        waitForExpectations(timeout: 20.0, handler: nil)
        XCTAssertNotNil(model.state.tickerUpdate, "Ticker did not update")
        XCTAssertNotNil(model.state.tradeUpdate, "Trade did not update")
        model.stopListning()
        listningExptectation = expectation(description: "startListningForUpdates")
        listningExptectation?.expectedFulfillmentCount = 2
        model.startListningForUpdates(shouldResume: true)
        waitForExpectations(timeout: 20.0, handler: nil)
        XCTAssertNotNil(model.state.tickerUpdate, "Ticker did not update on restart")
        XCTAssertNotNil(model.state.tradeUpdate, "Trade did not update on restart")
        model.stopListning()
    }

    func didUpdateTickerInfo() {

        listningExptectation?.fulfill()
    }

    func didUpdateTradeInfo() {

        listningExptectation?.fulfill()
    }
}
