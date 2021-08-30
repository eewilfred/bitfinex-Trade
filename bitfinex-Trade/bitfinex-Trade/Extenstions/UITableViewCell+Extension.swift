//
//  UITableViewCell+Extension.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 28/08/2021.
//

import UIKit

extension UITableViewCell {

    /// Class name as cell identifier string
    class var identifier: String { return String(describing: self) }

    /// Initialize xib using Class name
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}

extension UICollectionReusableView {

    /// Class name as cell identifier string
    class var identifier: String { return String(describing: self) }

    /// Initialize xib using Class name
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
}
