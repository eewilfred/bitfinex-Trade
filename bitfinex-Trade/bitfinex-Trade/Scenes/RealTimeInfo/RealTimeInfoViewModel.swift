//
//  RealTimeInfoViewModel.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 29/08/2021.
//

import Foundation

protocol RealTimeInfoViewModelDelegate: AnyObject {

    func didUpdateTradePairInfo()
}

// MARK: - RealTimeInfoViewState

struct RealTimeInfoViewState {

    var tickerSymbol: String
    var pairs: [TradePair]
    var update: TradePairUpdates?
}

// MARK: - RealTimeInfoViewModel

class RealTimeInfoViewModel  {

    private enum Constants {

        static let tickerUpdateUrlString = "wss://api-pub.bitfinex.com/ws/2"
    }

    var tickerUpdateManager: SocketConnectionManager?
    var state: RealTimeInfoViewState

    weak var delegate: RealTimeInfoViewModelDelegate?

    init(tradePairSymbol: String, pairs: [TradePair]) {

        state = RealTimeInfoViewState(tickerSymbol: tradePairSymbol, pairs: pairs)
        configureTickerUpdateManager()
    }

    func startListningTickerUpdates(symbol: String? = nil) {

        tickerUpdateManager?.send(
            text: tickerConnectionMessageForSymbol(symbol: symbol ?? state.tickerSymbol)
        )
    }

    func stopListning() {

        tickerUpdateManager?.disconnect()
        tickerUpdateManager?.delegate = nil
    }

    // MARK: support

    private func configureTickerUpdateManager() {

        if let url = URL(string: Constants.tickerUpdateUrlString) {
            tickerUpdateManager = SocketConnectionManager(url: url)
            tickerUpdateManager?.delegate = self
        }
    }

    private func tickerConnectionMessageForSymbol(symbol: String) -> String {

        return """
                {"event": "subscribe", "channel": "ticker", "symbol": "\(symbol)"}
                """
    }
}

// MARK: - SocketConnectionDelegate

extension RealTimeInfoViewModel: SocketConnectionDelegate {

    func didDisconnected() {

        configureTickerUpdateManager()
    }

    func onMessage(text: String) {

        if let jsonData = text.data(using: .utf8),
           let tradePairUpdate = try? JSONDecoder().decode(
            TradePairUpdates.self,
            from: jsonData
           ) {
            state.update = tradePairUpdate
            delegate?.didUpdateTradePairInfo()

            #if DEBUG
            print(state.update)
            #endif
        }
    }

    func onError(error: Error?) {}
}


