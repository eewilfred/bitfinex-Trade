//
//  TradePairsListingTableViewCell.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 28/08/2021.
//

import UIKit

class TradePairsListingTableViewCell: UITableViewCell {

    @IBOutlet private weak var symbolLabel: UILabel!
    @IBOutlet private weak var lastPriceLabel: UILabel!
    @IBOutlet private weak var dailyChange: UILabel!

    var presentation: TradePairsListingCellPresentation? {
        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        dailyChange.layer.borderColor = UIColor.black.cgColor
        dailyChange.layer.borderWidth = 1.0
        dailyChange.layer.cornerRadius = 5.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}

    private func updateUI() {

        guard let presentation = presentation else {
            return
        }

        symbolLabel.text = presentation.symbol
        lastPriceLabel.text = presentation.lastPrice
        dailyChange.attributedText = presentation.dailyChange
        dailyChange.backgroundColor = presentation.dailyChangeBgColor
    }
}
