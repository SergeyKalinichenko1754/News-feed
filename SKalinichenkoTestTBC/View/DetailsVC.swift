//
//  DetailsVC.swift
//  SKalinichenkoTestTBC
//

import UIKit

class DetailsVC: UIViewController {
    @IBOutlet weak var detailsImageView: UIImageView!
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var detailsDescription: UITextView!
    @IBOutlet weak var detailsFavouriteButton: FavouriteButton!
    
    var article: NewsLine?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.8127068877, green: 0.1394361556, blue: 0.4335622787, alpha: 1)
        navigationController?.navigationBar.topItem?.title = "Back"
        navigationItem.title = ""
        setLikeButton()
    }
    
    func setScreen() {
        detailsTitle.text = article?.title
        detailsDescription.text = article?.content
        if let url = article?.urlToImage {
            ImageForNews.loadImage(urlString: url, indexPath: IndexPath(row: 0, section: 0), completion: {(imageIndexPath, image) in
                guard let image = image  else { return }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return}
                    self.detailsImageView.image = image
                }
            })
        }
    }
    
    func setLikeButton() {
        guard let article = article else {
            assertionFailure("News cannot be nil at this point")
            return
        }
        let newIsFavorite = FavoriteStore.shared.isFavorite(article)
        detailsFavouriteButton.setFavourite(newIsFavorite)
    }
    
    @IBAction func tapedFavouriteButton(_ sender: UIButton) {
        guard let article = article else {
            assertionFailure("News cannot be nil at this point")
            return
        }
        let newIsFavorite = FavoriteStore.shared.isFavorite(article)
        detailsFavouriteButton.setFavourite(!newIsFavorite)
        if newIsFavorite {
            FavoriteStore.shared.delete(article)
        } else {
            FavoriteStore.shared.add(article)
        }
    }
}
