//
//  TradePairTradesUpdate.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 30/08/2021.
//

import Foundation

struct TradePairTradesUpdate: Decodable {

    private var values = [[Float]]()
    var channelId: Int = 0
    var updateInfo = [[Information]]()

    enum Information {

        case tradeID(Int)
        case timeStampInMilliSecond(Int)
        case amount(Float)
        case price(Float)
        case unknown

        init(arg: (Int, Float)) {

            switch arg.0 {
            case 0:
                self = .tradeID(Int(arg.1))
            case 1:
                self = .timeStampInMilliSecond(Int(arg.1))
            case 2:
                self = .amount(arg.1)
            case 3:
                self = .price(arg.1)
            default:
                self = .unknown
            }
        }
    }

    init(from decoder: Decoder) throws {

        var container = try decoder.unkeyedContainer()
        while !container.isAtEnd {
            if let result = try? container.decode([[Float]].self) {
                self.values = result
            } else if let _ = try? container.decode(String.self) {
                throw SocketDataError.unExpectedData
            } else if let channelId = try? container.decode(Int.self) {
                self.channelId = channelId
            } else if let _ = try? container.decodeNil() {
                throw SocketDataError.unExpectedData
            } else {
                throw SocketDataError.unExpectedData
            }
        }
        for readings in values {
            var information = [Information]()
            for tradeInfo in readings.enumerated() {
                information.append(Information(arg: tradeInfo))
            }
            updateInfo.append(information)
        }
    }
}
