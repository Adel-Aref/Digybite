//
//  GameViewController.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import UIKit
import RxSwift

class GameViewController: UIViewController {
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var redditLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var widthValueConstraint: NSLayoutConstraint!
    
    var reloadFavroiteList: (()->())?
    var gameID: Int32?
    private var game: GameModel?
    private let defaultValueLabelHeight: CGFloat = 70
    private var viewModel = GameViewModel()
    private var favoriteStatus: FavoriteStatus = .favorite {
        didSet {
            switch favoriteStatus {
            case .favorite:
                favoriteButton.setTitle("Favorite", for: .normal)
            default:
                favoriteButton.setTitle("Favorited", for: .normal)
            }
        }
    }
    lazy var disposeBag: DisposeBag = {
        return DisposeBag()
    }()
    
    enum FavoriteStatus {
        case favorite
        case favorited
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupSafairTap()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let gameID = gameID else {return}
        viewModel.getGameByGameID(id: gameID)
    }
    
    private func setupSafairTap() {
        websiteLabel.isUserInteractionEnabled = true
        redditLabel.isUserInteractionEnabled = true
        let websiteTap = UITapGestureRecognizer(target: self, action: #selector(openWebsiteSafari))
        let riddetTap = UITapGestureRecognizer(target: self, action: #selector(openRedditSafari))
        websiteLabel.addGestureRecognizer(websiteTap)
        redditLabel.addGestureRecognizer(riddetTap)
    }
    
    @objc func openWebsiteSafari() {
        game?.website?.openInSafari()
    }
    
    @objc func openRedditSafari() {
        game?.redditUrl?.openInSafari()
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
            .game
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] (game) in
                guard let self = self else { return }
                self.game = game
                self.setUI(game)
            }).disposed(by: disposeBag)
    }
    
    private func setUI(_ game: GameModel) {
        gameNameLabel.text = game.name
        gameDescriptionLabel.text = game.description?.htmlToString
        gameImageView.setImage(strUrl: game.backgroundImage, name: "placeHolder")
        CoreDataHelper.shared.fetchGames { [weak self] games in
            let gameModel = games.filter { $0.id == game.id }.first
            guard  gameModel?.isFavorite ?? false else {
                self?.favoriteStatus = .favorite
                return
            }
            self?.favoriteStatus = .favorited
        }
    }
    
    @IBAction func closeAction(sender: UIButton) {
        dismiss(animated: true) { [weak self] in
            self?.reloadFavroiteList?()
        }
    }
    
    @IBAction func seeMoreAction(sender: UIButton) {
        switch sender.tag {
        case 0:
            setOpenState(isFull: true)
            sender.tag = 1
        default:
            setOpenState(isFull: false)
            sender.tag = 0
        }
    }
    
    @IBAction func favoriteAction(sender: UIButton) {
        switch favoriteStatus {
        case .favorited:
            guard let game = game else {return}
            CoreDataHelper.shared.updateGameFavorite(isFavorite: false, id: game.id)
            favoriteStatus = .favorite
        default:
            guard let game = game else {return}
            favoriteStatus = .favorited
            CoreDataHelper.shared.updateGameFavorite(isFavorite: true, id: game.id)
        }
    }
    
    func setOpenState(isFull: Bool) {
        var fullHeight = defaultValueLabelHeight
        if isFull {
            fullHeight = gameDescriptionLabel.sizeThatFits(CGSize(width: gameDescriptionLabel.bounds.width, height: 10000)).height
        }
        widthValueConstraint.constant = fullHeight
        seeMoreButton.setImage(isFull ? UIImage(named: "arrowDown") : UIImage(named: "arrowUp"), for: .normal)
    }
}
