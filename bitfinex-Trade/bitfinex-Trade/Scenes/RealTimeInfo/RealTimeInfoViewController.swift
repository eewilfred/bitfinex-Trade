//
//  RealTimeInfoViewController.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 29/08/2021.
//

import UIKit

struct RealTimeInfoViewPresentation {

    enum Sections: CaseIterable {

        case info
    }

    var tradeInfoCellPresentation: [RealTimeInfoViewCellPresentation]?

    mutating func updaTetradeInfoCellPresentation(state: RealTimeInfoViewState) {

        tradeInfoCellPresentation = state.tickerUpdate?.updateInfo.map({ (info) in

            RealTimeInfoViewCellPresentation(info: info)
        })
    }
}

class RealTimeInfoViewController: UIViewController {

    var model: RealTimeInfoViewModel!
    var presentation = RealTimeInfoViewPresentation()

    @IBOutlet weak var tradePairChangeButton: UIButton!
    @IBOutlet weak var infoCollectionView: UICollectionView!

    var dataSource: UICollectionViewDiffableDataSource<RealTimeInfoViewPresentation.Sections, RealTimeInfoViewCellPresentation>?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        configureCollectionView()
        model.delegate = self
        model.startListningForUpdates()
    }

    private func configureCollectionView() {

        infoCollectionView.register(
            RealTimeInfoCollectionViewCell.nib,
            forCellWithReuseIdentifier: RealTimeInfoCollectionViewCell.identifier
        )
        infoCollectionView.delegate = self

        dataSource = UICollectionViewDiffableDataSource(collectionView: infoCollectionView, cellProvider: { (collectionView, path, cellPresentation) in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RealTimeInfoCollectionViewCell.identifier, for: path) as? RealTimeInfoCollectionViewCell else {

                return UICollectionViewCell()
            }

            cell.presentation = cellPresentation
            return cell
        })

        // link table and source
        guard let data = dataSource else {
            return
        }

        var snapshot = NSDiffableDataSourceSnapshot<RealTimeInfoViewPresentation.Sections, RealTimeInfoViewCellPresentation>()
        snapshot.appendSections(RealTimeInfoViewPresentation.Sections.allCases)
        snapshot.appendItems([])
        data.apply(snapshot, animatingDifferences: false, completion: nil)
    }

    private func UpdateCollectionView() {

        guard var snapshot = dataSource?.snapshot() else {
            return
        }

        snapshot.appendItems(presentation.tradeInfoCellPresentation ?? [])
        dataSource?.apply(snapshot)
    }


    // MARK: Actions

    @IBAction func didTapOnBackButton() {

        model.stopListning()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapOnTradePairChangeButton() {

        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.center = view.center
        view.addSubview(pickerView)
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

        let name = model.state.pairs[safe: row]?.name
        let traidPairName = name?.dropFirst()
        tradePairChangeButton.setTitle(String(traidPairName ?? ""), for: .normal)
    }
}


extension RealTimeInfoViewController: RealTimeInfoViewModelDelegate {

    func didUpdateTradePairInfo() {

        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.didUpdateTradePairInfo()
            }
            return
        }

        guard var snapshot = dataSource?.snapshot() else {
            return
        }

        snapshot.deleteItems(presentation.tradeInfoCellPresentation ?? [])
        dataSource?.apply(snapshot)
        presentation.updaTetradeInfoCellPresentation(state: model.state)
        UpdateCollectionView()
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

        let totalWidth = collectionView.bounds.width - 50.0
        let totalHeight = collectionView.bounds.height

        let cellHeight = (totalHeight/2.0) / (CGFloat(model.state.tickerUpdate?.updateInfo.count ?? 0)/2.0)
        return CGSize(width: totalWidth/2.0, height: cellHeight)
    }
}
