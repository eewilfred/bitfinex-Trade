//
//  SocketConnectionManager.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 30/08/2021.
//

import Foundation

enum SocketDataError: Error {

    case unExpectedData
}

// MARK: - SocketConnectionDelegate

protocol SocketConnectionDelegate: AnyObject {
    func didDisconnected()
    func onMessage(text: String)
    func onError(error: Error?)
}

// MARK: - SocketConnectionManager

class SocketConnectionManager: NSObject {

    weak var delegate: SocketConnectionDelegate?

    private var webSocketTask: URLSessionWebSocketTask!
    private var urlSession: URLSession!
    private let delegateQueue = OperationQueue()

    // MARK: Public interfaces

    init(url: URL) {

        super.init()
        urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: delegateQueue)
        webSocketTask = urlSession.webSocketTask(with: url)
        connect()
    }

    func disconnect() {

        webSocketTask.cancel(with: .goingAway, reason: nil)
    }

    func send(text: String) {

        webSocketTask.send(URLSessionWebSocketTask.Message.string(text)) { error in
            if let error = error {
                self.delegate?.onError(error: error)
            }
        }
    }

    // MARK: private support functions
    private func connect() {
        webSocketTask.resume()
        listen()
    }

    private func listen()  {
        webSocketTask.receive { [weak self] result in

            guard let self = self else { return }
            switch result {
            case .failure(let error): // Will not be handling error
                self.disconnect()
                self.delegate?.onError(error: error)
            case .success(let message):
                switch message {
                case .string(let text):
                    self.delegate?.onMessage(text: text)
                case .data(_):
                    break
                @unknown default:
                    self.delegate?.onError(error: nil)
                }

                self.listen()
            }
        }
    }
}

extension SocketConnectionManager: URLSessionWebSocketDelegate {

    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {

        self.delegate?.didDisconnected()
    }
}
