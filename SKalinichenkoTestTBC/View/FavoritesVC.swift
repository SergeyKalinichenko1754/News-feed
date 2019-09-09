//
//  FavoritesVC.swift
//  SKalinichenkoTestTBC
//

import UIKit

class FavoritesVC: TemplateVC, TemplateProtocol {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenName = ScreenName.favorites
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    func getData() {
        startIndicator()
        newsStore.articles = []
        tableView.reloadData()
        DispatchQueue.global().async {
            let articles = FavoriteStore.shared.loadAllFavouritesNews()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.newsStore.articles = articles
                self.tableView.reloadData()
                self.stopIndicator()
            }
        }
    }
    
}
