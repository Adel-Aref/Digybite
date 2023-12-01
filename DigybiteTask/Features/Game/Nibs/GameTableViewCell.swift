//
//  GameTableViewCell.swift
//  DigybiteTask
//
//  Created by Adel Aref on 30/11/2023.
//

import UIKit
import SDWebImage

class GameTableViewCell: UITableViewCell {
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var genresLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        gameImageView.clipsToBounds = true
        gameImageView.layer.cornerRadius = 8
    }
    
    var game: GameModel? {
        didSet {
            nameLbl.text = game?.name
            let genres = game?.genres?.map({ genre in
                return genre.name
            }).reduce("") { $0 + ($1 ?? "") + ", " }
            genresLbl.text = (game?.genres?.count == 1) ? game?.genres?.first?.name : genres
            gameImageView.setImage(strUrl: game?.backgroundImage,
                                   name: "placeHolder")
        }
    }
}
