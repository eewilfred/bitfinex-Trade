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

    var dataSource: UITableViewDiffableDataSource<TradePairsListingPresentation.Sections, TradePairsListingCellPresentation>?

    override func viewDidLoad() {

        super.viewDidLoad()
        configureTableView()
        model.fetchTradePairs { success in
            // TODO:
        }
    }

    private func configureTableView() {

        tableView.register(
            TradePairsListingTableViewCell.nib,
            forCellReuseIdentifier: TradePairsListingTableViewCell.identifier
        )
        tableView.tableFooterView = UIView()
        // Add data source
        dataSource = UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { tableView, _, cellPresentation in

                guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: TradePairsListingTableViewCell.identifier
                ) else {
                    return UITableViewCell()
                }
                // TODO: configure cell
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

