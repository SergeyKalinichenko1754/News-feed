//
//  FavouriteButton.swift
//  SKalinichenkoTestTBC
//

import UIKit

enum ImageForFavouriteButton : String {
    case favourite = "colorStar"
    case notFavourite = "transparentStar"
}

class FavouriteButton: UIButton {
    func setFavourite(_ isFavourite: Bool) {
        let image = UIImage(named: isFavourite ? ImageForFavouriteButton.favourite.rawValue : ImageForFavouriteButton.notFavourite.rawValue)
        self.setImage(image, for: .normal)
    }
}
