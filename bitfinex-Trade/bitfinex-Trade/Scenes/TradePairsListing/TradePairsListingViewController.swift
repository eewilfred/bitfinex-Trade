//
//  ViewController.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 26/08/2021.
//

import UIKit

class TradePairsListingViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!

    var model = TradePairsListingViewModel()
    var presentation = TradePairsListingPresentation()

    override func viewDidLoad() {

        super.viewDidLoad()
        model.fetchTradePairs { success in
            // TODO:
        }
    }
}

