//
//  GamesTableDataSrc.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//


import UIKit

class GamesTableDataSrc: NSObject {
    var viewModel: GameViewModel
    var onGameSelect: ((GameModel)->())?
    
    init(viewModel: GameViewModel, favroteTabStatus: FavroteTabStatus) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GamesTableDataSrc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.gameListCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as GameTableViewCell
        let game = viewModel.getGameByIndex(at: indexPath.row)
        cell.game = game
        cell.backgroundColor = (game.isRead ?? false) ? .gray : .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = viewModel.getGameByIndex(at: indexPath.row)
        onGameSelect?(game)
    }
}
