//
//  RealTimeInfoViewController.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 29/08/2021.
//

import UIKit

class RealTimeInfoViewController: UIViewController {

    var model: RealTimeInfoViewModel!

    override func viewDidLoad() {

        super.viewDidLoad()
        model.startListningTickerUpdates()
    }


    // MARK: Actions

    @IBAction func didTapOnBackButton() {

        model.stopListning()
        self.dismiss(animated: true, completion: nil)
    }
}
