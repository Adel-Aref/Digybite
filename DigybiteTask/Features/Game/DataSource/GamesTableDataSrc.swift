//
//  GamesTableDataSrc.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//


import UIKit

class GamesTableDataSrc: NSObject {
    var viewModel: GameViewModel
    var favroteTabStatus: FavroteTabStatus
    var onGameSelect: ((GameModel)->())?
    var onWillDisplay: ((Int)->())?
    
    init(viewModel: GameViewModel, favroteTabStatus: FavroteTabStatus) {
        self.viewModel = viewModel
        self.favroteTabStatus = favroteTabStatus
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension GamesTableDataSrc: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch favroteTabStatus {
        case .active:
            return viewModel.favoritedList?.count ?? 0
        default:
            return viewModel.gameListCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue() as GameTableViewCell
        
        switch favroteTabStatus {
        case .disActive:
            let game = viewModel.getGameByIndex(at: indexPath.row)
            cell.game = game

        default:
            let item = viewModel.favoritedList?[indexPath.row]
            guard let item = item else { return UITableViewCell() }
            let game = GameModel(id: Int(item.id) ?? 0,
                                 name: item.name,
                                 backgroundImage: item.backgroundImage,
                                 description: item.gameDescription,
                                 website: item.website,
                                 redditUrl: item.redditUrl,
                                 genres: item.genres)
            cell.game = game
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = viewModel.getGameByIndex(at: indexPath.row)
        onGameSelect?(game)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        onWillDisplay?(indexPath.row)
    }
}
