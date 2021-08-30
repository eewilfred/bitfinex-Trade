//
//  RealTimeInfoCollectionViewCell.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 30/08/2021.
//

import UIKit

class RealTimeInfoCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!

    var presentation: RealTimeInfoViewCellPresentation? {

        didSet {
            updateUI()
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()
        layer.cornerRadius = 7.0
        valueLabel.textColor = .darkGray
    }

    private func updateUI() {

        guard let presentation = presentation else { return }
        titleLabel.text = presentation.fieldTitle
        valueLabel.text = presentation.value
    }
}
