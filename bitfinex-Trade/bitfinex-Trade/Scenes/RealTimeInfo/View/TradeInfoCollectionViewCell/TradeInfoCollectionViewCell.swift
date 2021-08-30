//
//  TradeInfoCollectionViewCell.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 30/08/2021.
//

import UIKit

class TradeInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    var presentation: TradeInfoCellPresentation? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    private func updateUI() {

        guard let presentation = presentation else { return }
        amountLabel.text = presentation.amount
        priceLabel.text = presentation.price
        timeLabel.text = presentation.time
    }
}
