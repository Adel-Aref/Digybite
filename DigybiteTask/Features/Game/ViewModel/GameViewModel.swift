//
//  GameListViewModel.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import Foundation
import RxSwift
import CoreData

class GameViewModel: BaseViewModel {
    var isLoading: PublishSubject<Bool> = PublishSubject()
    let isSuccess: PublishSubject<Bool> = PublishSubject()
    let game: PublishSubject<GameModel> = PublishSubject()
    var isError: PublishSubject<ErrorMessage> = PublishSubject()
    var isRemoved: PublishSubject<Bool> = PublishSubject()
    
    var disposeBag: DisposeBag = DisposeBag()
    let repository: Repository
    
    var games = [GameModel]()
    var gameListCount: Int {
        return games.count
    }
        
    public init (_ repo: Repository = GameRepo()) {
        repository = repo
        isSuccess.disposed(by: disposeBag)
        configureDisposeBag()
        getCachedList()
    }
    
    func getGameByIndex(at index: Int) -> GameModel {
        return games[index]
    }
    
    func getCachedList() {
        CoreDataHelper.shared.fetchGames { games in
            self.games = games
            self.isSuccess.onNext(true)
            self.getGamesList()
        }
    }
    
    func getFavoritedList() {
        CoreDataHelper.shared.fetchGames { games in
            self.games = games.filter({ game in
                return game.isFavorite == true
            })
            self.isSuccess.onNext(true)
        }
    }
    
    func getGamesList(text: String = "") {
        self.isLoading.onNext(true)
        (repository as? GameRepo)?.getGameList(searchText: text, completion: { [weak self]  result in
            guard let self = self else {
                return
            }
            self.isLoading.onNext(false)
            switch result {
            case .success(let data):
                if let data = data as? DigybiteResponse<[GameModel]> {
                    self.games = data.results ?? []
                    CoreDataHelper.shared.createNewGameEntity(games)
                    self.isSuccess.onNext(true)
                }
            case .failure(let error):
                let error = ErrorMessage(title: "Error", message: error.localizedDescription, action: nil)
                self.isError.onNext(error)
            }
        })
    }
    
    func getGameByGameID(id: Int32) {
        self.isLoading.onNext(true)
        (repository as? GameRepo)?.getGameByGameID(id: id, completion: { [weak self]  result in
            guard let self = self else {
                return
            }
            self.isLoading.onNext(false)
            switch result {
            case .success(let data):
                if let data = data as? GameModel {
                    self.game.onNext(data)
                }
            case .failure(let error):
                let error = ErrorMessage(title: "Error", message: error.localizedDescription, action: nil)
                self.isError.onNext(error)
            }
        })
    }
}
