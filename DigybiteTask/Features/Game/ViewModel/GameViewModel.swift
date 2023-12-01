//
//  GameListViewModel.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import Foundation
import RxSwift

class GameViewModel: BaseViewModel {
    var isLoading: PublishSubject<Bool> = PublishSubject()
    let isSuccess: PublishSubject<[GameModel]> = PublishSubject()
    let game: PublishSubject<GameModel> = PublishSubject()
    var isError: PublishSubject<ErrorMessage> = PublishSubject()
    var isRemoved: PublishSubject<Bool> = PublishSubject()

    var disposeBag: DisposeBag = DisposeBag()
    let repository: Repository
    let storage: LocalStorageProtocol = LocalStorage()

    var favoritedList: [GameRealmModel]?
    var games = [GameModel]()
    var gameListCount: Int {
        return games.count
    }
    
    func getGameByIndex(at index: Int) -> GameModel {
        return games[index]
    }
    
    func getFavoritedList() {
        favoritedList = self.storage.objects()
    }
    
    var isLoad = false
    var page = 1
    
    public init (_ repo: Repository = GameRepo()) {
        repository = repo
        isSuccess.disposed(by: disposeBag)
        configureDisposeBag()
        getFavoritedList()
    }

    func getGamesList(text: String = "") {
        guard !isLoad else {
            return
        }
        self.isLoading.onNext(true)
        self.isLoad = true
        (repository as? GameRepo)?.getGameList(page: page, searchText: text, completion: { [weak self]  result in
            guard let self = self else {
                return
            }
            self.isLoading.onNext(false)
            self.isLoad = false
            switch result {
            case .success(let data):
                if let data = data as? DigybiteResponse<[GameModel]> {
                    if data.next != nil {
                        self.page += 1
                    }
                    self.games.append(contentsOf: data.results ?? [])
                    self.isSuccess.onNext(self.games)

                }
            case .failure(let error):
                let error = ErrorMessage(title: "Error", message: error.localizedDescription, action: nil)
                self.isError.onNext(error)
            }
        })
    }
    
    func getGameByGameID(id: Int) {
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
    
   
//    func removeUser() {
//        if let user = defaults.user {
//            let results = realm.getObjects(model: UserModel.self).filter { $0.phone == user.phone }
//            if let first = results.first {
//                realm.delete(first)
//                defaults.isLoggedIn = false
//                isRemoved.onNext(true)
//            }
//        }
//    }
}
