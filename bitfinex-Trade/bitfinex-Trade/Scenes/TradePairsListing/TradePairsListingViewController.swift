//
//  ViewController.swift
//  bitfinex-Trade
//
//  Created by Edwin Wilson on 26/08/2021.
//

import UIKit

class TradePairsListingViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!

    var model = TradePairsListingViewModel()
    var presentation = TradePairsListingPresentation()

    var dataSource: UITableViewDiffableDataSource<TradePairsListingPresentation.Sections, TradePairsListingCellPresentation>?

    override func viewDidLoad() {

        super.viewDidLoad()
        configureTableView()
        hideLoader(false)
        // using unowned instead of weak as this has to comeback for any other user interaction / this is root view
        model.fetchTradePairs { [unowned self] success in
            self.handleTradePairsUpdate()
        }
    }

    // MARK: Support

    private func handleTradePairsUpdate() {

        if !Thread.isMainThread {
            DispatchQueue.main.async {
                self.handleTradePairsUpdate()
            }
            return
        }
        presentation.update(state: self.model.state)
        updateDataSource()
        hideLoader(true)
    }

    fileprivate func hideLoader(_ isHidden: Bool) {

        activityIndicatorView.isHidden = isHidden
        if isHidden {
            activityIndicatorView.stopAnimating()
        } else {
            activityIndicatorView.startAnimating()
        }
    }
}

// MARK: - TableView related

extension TradePairsListingViewController {

    private func configureTableView() {

        tableView.register(
            TradePairsListingTableViewCell.nib,
            forCellReuseIdentifier: TradePairsListingTableViewCell.identifier
        )
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        // Add data source
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, _, cellPresentation in

                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: TradePairsListingTableViewCell.identifier
                ) as? TradePairsListingTableViewCell else {
                    return UITableViewCell()
                }
                cell.presentation = cellPresentation
                return cell
            }
        )

        // link table and source
        guard let data = dataSource else {
            return
        }

        var source = NSDiffableDataSourceSnapshot<TradePairsListingPresentation.Sections, TradePairsListingCellPresentation>()
        source.appendSections(TradePairsListingPresentation.Sections.allCases)
        source.appendItems(presentation.tradePairsCellPresentations)
        data.apply(source, animatingDifferences: false, completion: nil)
    }

    private func updateDataSource() {

        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.appendItems(presentation.tradePairsCellPresentations)
        dataSource?.apply(snapshot)
    }
}

extension TradePairsListingViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "RealTimeInfoViewController") as? RealTimeInfoViewController,
              let symbol = model.state.pairs?[safe: indexPath.row]?.name,
              let pairs = model.state.pairs else {
            return
        }
        vc.modalPresentationStyle = .fullScreen
        vc.model = RealTimeInfoViewModel(tradePairSymbol: symbol, pairs: pairs)
        self.present(vc, animated: true)
    }
}
