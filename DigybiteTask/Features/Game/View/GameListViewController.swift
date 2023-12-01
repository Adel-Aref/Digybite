//
//  GameListViewController.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import UIKit
import RxSwift

enum FavroteTabStatus {
    case active
    case disActive
}

class GameListViewController: BaseController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!

    private var viewModel = GameViewModel()
    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    lazy var dataSrc: GamesTableDataSrc = {
        let dataSrc = GamesTableDataSrc(viewModel: self.viewModel, favroteTabStatus: favroteTabStatus)
        dataSrc.onGameSelect = { [weak self] game in
            guard let self = self,
                  let viewController = GameViewController.instantiateFromNib() else { return }
            viewController.gameID = game.id
            self.present(viewController, animated: true)
        }
        dataSrc.onWillDisplay = { [weak self] row in
            guard let self = self else { return }
            guard row == self.viewModel.gameListCount - 1 else {
                return
            }
            self.viewModel.getGamesList()
        }
        return dataSrc
    }()
    
    private var favroteTabStatus: FavroteTabStatus = .disActive {
        didSet {
            dataSrc.favroteTabStatus = favroteTabStatus
            UIView.animate(withDuration: 0.4) { [weak self] in
                self?.tableView.reloadData()
                self?.view.setNeedsLayout()
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupBinding()
        viewModel.getGamesList()
    }
    
    private func setupTableView() {
        tableView.register(cell: GameTableViewCell.self)
        tableView.delegate = dataSrc
        tableView.dataSource = dataSrc
        tableView.separatorColor = .clear
        tableView.rowHeight = 122
    }
    
    private func setupBinding() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(self.rx.isAnimating)
            .disposed(by: disposeBag)
        viewModel
            .isError
            .observe(on: MainScheduler.instance)
            .subscribe(self.rx.isError)
            .disposed(by: disposeBag)
        
        viewModel
            .isSuccess
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (_) in
                guard let self = self else { return }
                self.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    func setupUI() {
        searchBar.delegate = self
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch favroteTabStatus {
        case .disActive:
            searchBar.isHidden = true
            favroteTabStatus = .active
        default:
            searchBar.isHidden = false
            favroteTabStatus = .disActive
        }
    }
}

extension GameListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard searchText.count >= 3 else {
            return
        }
        viewModel.getGamesList(text: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}
