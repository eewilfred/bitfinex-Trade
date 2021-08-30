//
//  RealTimeInfoViewModel.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 29/08/2021.
//

import Foundation

protocol RealTimeInfoViewModelDelegate: AnyObject {

    func didUpdateTickerInfo()
    func didUpdateTradeInfo()
}

// MARK: - RealTimeInfoViewState

struct RealTimeInfoViewState {

    var tickerSymbol: String
    var pairs: [TradePair]
    var tickerUpdate: TradePairTickerUpdates?
    var tradeUpdate: TradePairTradesUpdate?
}

// MARK: - RealTimeInfoViewModel

class RealTimeInfoViewModel  {

    private enum Constants {

        static let updateUrlString = "wss://api-pub.bitfinex.com/ws/2"
    }

    var tickerUpdateManager: SocketConnectionManager?
    var state: RealTimeInfoViewState

    weak var delegate: RealTimeInfoViewModelDelegate?

    init(tradePairSymbol: String, pairs: [TradePair]) {

        state = RealTimeInfoViewState(tickerSymbol: tradePairSymbol, pairs: pairs)
        configureTickerUpdateManager()
    }

    func startListningForUpdates(shouldResume: Bool = false) {

        if shouldResume {
            tickerUpdateManager?.connect()
        }
        tickerUpdateManager?.send(
            text: tickerConnectionMessageForSymbol(symbol: state.tickerSymbol)
        )
        tickerUpdateManager?.send(
            text: tradeConnectionMessageForSymbol(symbol: state.tickerSymbol)
        )
    }

    func stopListning() {

        tickerUpdateManager?.disconnect()
    }

    // MARK: support

    private func configureTickerUpdateManager() {

        if let url = URL(string: Constants.updateUrlString) {
            tickerUpdateManager = SocketConnectionManager(url: url)
            tickerUpdateManager?.delegate = self
        }
    }

    private func tickerConnectionMessageForSymbol(symbol: String) -> String {

        return """
                {"event": "subscribe", "channel": "ticker", "symbol": "\(symbol)"}
                """
    }

    private func tradeConnectionMessageForSymbol(symbol: String) -> String {

        return """
                {"event": "subscribe", "channel": "trades", "symbol": "\(symbol)"}
                """
    }
}

// MARK: - SocketConnectionDelegate

extension RealTimeInfoViewModel: SocketConnectionDelegate {

    func didDisconnected() {

//        configureTickerUpdateManager()
    }

    func onMessage(text: String) {

        #if DEBUG
//        print("message received:: \(text)")
        #endif

        if let jsonData = text.data(using: .utf8) {
            if let tradeUpdate = try? JSONDecoder().decode(TradePairTradesUpdate.self, from: jsonData) {
                #if DEBUG
                print("trade update received")
                #endif
                state.tradeUpdate = tradeUpdate
                delegate?.didUpdateTradeInfo()
            } else if let tradePairUpdate = try? JSONDecoder().decode(
                TradePairTickerUpdates.self,
                from: jsonData
            ) {
                state.tickerUpdate = tradePairUpdate
                delegate?.didUpdateTickerInfo()

                #if DEBUG
                print("ticket recived")
                #endif
            }
        }
    }

    func onError(error: Error?) {

        #if DEBUG
        print(error?.localizedDescription ?? "")
        #endif
    }
}
