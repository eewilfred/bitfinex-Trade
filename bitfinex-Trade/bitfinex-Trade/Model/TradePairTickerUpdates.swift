//
//  TradePairUpdates.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 30/08/2021.
//

import Foundation

struct TradePairTickerUpdates: Decodable  {

    private var values = [Float]()
    var channelId: Int = 0

    var updateInfo = [Information]()

    enum Information {

        case bid(Float)
        case bidSize(Float)
        case ask(Float)
        case askSize(Float)
        case dailyChange(Float)
        case dailyChangeRelative(Float)
        case lastPrice(Float)
        case volume(Float)
        case heigh(Float)
        case low(Float)
        case unknown

        init(arg: (Int, Float)) {

            switch arg.0 {
            case 0:
                self = .bid(arg.1)
            case 1:
                self = .bidSize(arg.1)
            case 2:
                self = .ask(arg.1)
            case 3:
                self = .askSize(arg.1)
            case 4:
                self = .dailyChange(arg.1)
            case 5:
                self = .dailyChangeRelative(arg.1)
            case 6:
                self = .lastPrice(arg.1)
            case 7:
                self = .volume(arg.1)
            case 8:
                self = .heigh(arg.1)
            case 9:
                self = .low(arg.1)
            default:
                self = .unknown
            }
        }
    }

    init(from decoder: Decoder) throws {

        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            if let _ = try? container.decode([[Float]].self) {
                throw SocketDataError.unExpectedData
            } else if let _ = try? container.decode(String.self) {
                throw SocketDataError.unExpectedData
            } else if let channelId = try? container.decode(Int.self) {
                self.channelId = channelId
            } else if let item = try? container.decode([Float].self) {
                values = item
            } else if let _ = try? container.decodeNil() {
                values.append(0.0)
            } else {
                throw SocketDataError.unExpectedData
            }
        }
        for i in values.enumerated() {
            updateInfo.append(Information(arg: i))
        }
    }
}
