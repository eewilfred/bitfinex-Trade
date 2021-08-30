//
//  RealTimeInfoViewController.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 29/08/2021.
//

import UIKit


class RealTimeInfoViewController: UIViewController {

    var model: RealTimeInfoViewModel!
    var presentation = RealTimeInfoViewPresentation()

    enum DataItem: Hashable, Equatable {
        case ticker(TickerInfoViewCellPresentation)
        case trade(TradeInfoCellPresentation)

        static func == (lhs: Self, rhs: Self) -> Bool {
            var lhsTickerPresentation: TickerInfoViewCellPresentation?
            var lhsTradePresentation: TradeInfoCellPresentation?
            switch lhs {
            case .ticker(let presentation):
                lhsTickerPresentation = presentation
            case .trade(let presentation):
                lhsTradePresentation = presentation
            }

            switch rhs {
            case .ticker(let presentation):
                return presentation == lhsTickerPresentation
            case .trade(let presentation):
                return presentation == lhsTradePresentation
            }
        }
    }

    @IBOutlet weak var tradePairChangeButton: UIButton!
    @IBOutlet weak var infoCollectionView: UICollectionView!

    var pickerView: UIPickerView?

    var dataSource: UICollectionViewDiffableDataSource<RealTimeInfoViewPresentation.Sections, DataItem>?
    typealias Snapshot = NSDiffableDataSourceSnapshot<RealTimeInfoViewPresentation.Sections, DataItem>

    override func viewDidLoad() {

        super.viewDidLoad()
        configureCollectionView()
        model.delegate = self
        model.startListningForUpdates()
        let tradeSymbol = String(model.state.tickerSymbol.dropFirst())
        tradePairChangeButton.setTitle(tradeSymbol, for: .normal)
    }

    private func configureCollectionView() {

        infoCollectionView.register(
            TickerInfoCollectionViewCell.nib,
            forCellWithReuseIdentifier: TickerInfoCollectionViewCell.identifier
        )
        infoCollectionView.register(
            TradeInfoCollectionViewCell.nib,
            forCellWithReuseIdentifier: TradeInfoCollectionViewCell.identifier
        )

        infoCollectionView.register(
            TickerInfoSectionHeaderView.nib,
            forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TickerInfoSectionHeaderView.identifier
        )
        infoCollectionView.register(
            TradeInfoSectionHeaderView.nib,
            forSupplementaryViewOfKind:  UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TradeInfoSectionHeaderView.identifier
        )

        infoCollectionView.delegate = self

        dataSource = UICollectionViewDiffableDataSource(collectionView: infoCollectionView, cellProvider: { (collectionView, indexPath, cellPresentation) in

            switch cellPresentation {

            case .ticker(let presentation):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TickerInfoCollectionViewCell.identifier, for: indexPath) as? TickerInfoCollectionViewCell {
                    cell.presentation = presentation
                    return cell
                } else {
                    return UICollectionViewCell()
                }

            case .trade(let presentation):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TradeInfoCollectionViewCell.identifier, for: indexPath) as? TradeInfoCollectionViewCell {
                    cell.presentation = presentation
                    return cell
                } else {
                    return UICollectionViewCell()
                }

            }
        })

        // link table and source
        guard let data = dataSource else { return }

        data.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            var reuseIdentifier = TickerInfoSectionHeaderView.identifier
            if .tradeInfo == RealTimeInfoViewPresentation.Sections.init(rawValue: indexPath.section) {
                reuseIdentifier = TradeInfoSectionHeaderView.identifier
            }
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: reuseIdentifier,
                for: indexPath
            )
            return header
        }

        var snapshot = Snapshot()
        snapshot.appendSections([.tickerInfo, .tradeInfo])

        let tikerMap = presentation.tickerInfoCellPresentation?.map({ DataItem.ticker($0)}) ?? []
        snapshot.appendItems(tikerMap, toSection: .tickerInfo)

        let tradeMap = presentation.tradeInfoCellPresentation?.map({ DataItem.trade($0)}) ?? []
        snapshot.appendItems(tradeMap, toSection: .tradeInfo)
        data.apply(snapshot, animatingDifferences: true)

    }

    // MARK: Actions

    @IBAction func didTapOnBackButton() {

        model.stopListning()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapOnTradePairChangeButton() {

        pickerView = UIPickerView()
        pickerView?.delegate = self
        pickerView?.dataSource = self
        pickerView?.center = view.center
        pickerView?.backgroundColor = .systemGray4
        view.addSubview(pickerView!)
    }
}

extension RealTimeInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {

        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return model.state.pairs.count
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {

        return 40.0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return String(model.state.pairs[safe: row]?.name ?? "")
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        guard let name = model.state.pairs[safe: row]?.name else { return }
        let traidPairName = name.dropFirst()
        tradePairChangeButton.setTitle(String(traidPairName), for: .normal)

        model.stopListning()
        model.state.tickerSymbol = name
        model.startListningForUpdates(shouldResume: true)

        pickerView.removeFromSuperview()
    }
}


extension RealTimeInfoViewController: RealTimeInfoViewModelDelegate {

    func didUpdateTickerInfo() {

        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.didUpdateTickerInfo()
            }
            return
        }

        removeItemsForSection(section: .tickerInfo)
        presentation.updaTickerInfoCellPresentation(state: model.state)
        guard var snapshot = dataSource?.snapshot(),
              let tikerMap = presentation.tickerInfoCellPresentation?.map({ DataItem.ticker($0)}) else {
            return
        }
        snapshot.appendItems(tikerMap, toSection: .tickerInfo)
        dataSource?.apply(snapshot)
    }

    func didUpdateTradeInfo() {

        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.didUpdateTradeInfo()
            }
            return
        }

        removeItemsForSection(section: .tradeInfo)
        presentation.updaTradeInfoCellPresentation(state: model.state)
        guard var snapshot = dataSource?.snapshot(),
              let tradeMap = presentation.tradeInfoCellPresentation?.map({ DataItem.trade($0)}) else {
            return
        }
        snapshot.appendItems(tradeMap, toSection: .tradeInfo)
        dataSource?.apply(snapshot)
    }

    private func removeItemsForSection(section: RealTimeInfoViewPresentation.Sections) {

        guard var snapshot = dataSource?.snapshot() else {
            return
        }
        if section == .tickerInfo {
            let data = presentation.tickerInfoCellPresentation?.map({ DataItem.ticker($0)}) ?? []
            snapshot.deleteItems(data)
        } else {
            let data = presentation.tradeInfoCellPresentation?.map({ DataItem.trade($0)}) ?? []
            snapshot.deleteItems(data)
        }
        dataSource?.apply(snapshot)
    }
}

extension RealTimeInfoViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {

        return 5
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        if .tickerInfo == RealTimeInfoViewPresentation.Sections(rawValue: indexPath.section) {
            let totalWidth = collectionView.bounds.width - 50.0
            let totalHeight = collectionView.bounds.height

            let cellHeight = (totalHeight/2.0) / (CGFloat(model.state.tickerUpdate?.updateInfo.count ?? 0)/2.0)
            return CGSize(width: totalWidth/2.0, height: cellHeight)
        } else {
            return CGSize(width: collectionView.bounds.width - 20.0, height: 40)
        }

    }
}
