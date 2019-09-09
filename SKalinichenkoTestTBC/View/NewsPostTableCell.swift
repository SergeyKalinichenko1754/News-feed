//
//  NewsPostTableCell.swift
//  SKalinichenkoTestTBC
//

import UIKit

protocol PresenceButtonTypeFunction {
    func tapedButtonInCell(_ newsLine: NewsLine) -> Bool
}

class NewsPostTableCell: UITableViewCell {
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellDescription: UILabel!
    @IBOutlet weak var cellFavouriteButton: FavouriteButton!
        
    var cellDelegate: PresenceButtonTypeFunction?
    var cellNewsLine: NewsLine?

    func setData(_ newsLine: NewsLine, isFavourite: Bool) {
        cellNewsLine = newsLine
        cellTitle.text = newsLine.title
        cellDescription.text = newsLine.content
        cellFavouriteButton.setFavourite(isFavourite)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.image = nil
        cellTitle.text = ""
        cellDescription.text = ""
    }
    
    @IBAction func tapedLikeButton(_ sender: FavouriteButton) {
        guard let newsLine = cellNewsLine else { return}
        cellFavouriteButton.setFavourite(cellDelegate?.tapedButtonInCell(newsLine) ?? false)
    }

}
