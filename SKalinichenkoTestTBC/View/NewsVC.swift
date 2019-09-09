//
//  NewsVC.swift
//  SKalinichenkoTestTBC
//

import UIKit

class NewsVC: TemplateVC, TemplateProtocol {
    
    var loadedPage = 0
    var errorInLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenName = ScreenName.news
        newsStore.articles = []
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lines = newsStore.articles?.count ?? 0
        if indexPath.row == (lines - 1) && lines < FavoriteStore.shared.newsQuantity && !errorInLoading {
            getData()
        }
    }
    
    func getData() {
        startIndicator()
        NewsProvider.getNews(at: loadedPage, lines: 10) { [weak self] (news, error) in
            guard let self = self else { return }
            if let error = error  {
                if !self.errorInLoading {
                    self.errorInLoading = true
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else { return }
                        self.stopIndicator()
                    }
                    self.showAlert(title: "Attention", msg: error)
                }
            } else {
                guard let news = news else { return }
                self.newsStore.articles! += news.articles ?? []
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.loadedPage += 1
                    self.tableView.reloadData()
                    self.stopIndicator()
                }
            }
        }
    }
}
