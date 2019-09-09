//
//  TemplateVC.swift
//  SKalinichenkoTestTBC
//

import UIKit

protocol TemplateProtocol {
    func getData()
}

class TemplateVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PresenceButtonTypeFunction {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var activityIndicator = UIActivityIndicatorView()
    var screenName: ScreenName?
    var newsStore = News()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset.right = 15
        tableView.isEmptyRowsHidden = true
        newsStore.articles = []
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = screenName?.rawValue
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: "NewsPostTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "NewsPostTableCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsStore.articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsPostTableCell", for: indexPath) as? NewsPostTableCell else { return UITableViewCell()}
        guard let new = newsStore.articles?[indexPath.row] else { return UITableViewCell()}
        cell.cellDelegate = self
        
        let newIsFavorite = FavoriteStore.shared.isFavorite(new)
        
        cell.setData(new, isFavourite: newIsFavorite)
        if let url = new.urlToImage {
            ImageForNews.loadImage(urlString: url, indexPath: indexPath, completion: {(imageIndexPath, image) in
                guard let image = image  else { return }
                DispatchQueue.main.async {
                    if let thisCell = tableView.cellForRow(at: indexPath) as? NewsPostTableCell {
                        thisCell.cellImage.image = image
                    }
                }
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showDetailsForArticle(at: indexPath)
    }
    
    func showDetailsForArticle(at indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
        let detailsVC = storyboard.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
        detailsVC.article = newsStore.articles?[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    func startIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        activityIndicator.color = #colorLiteral(red: 0.8127068877, green: 0.1394361556, blue: 0.4335622787, alpha: 1)
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopIndicator() {
        activityIndicator.stopAnimating()
    }
        
    func tapedButtonInCell(_ newsLine: NewsLine) -> Bool {
        let newIsFavorite = FavoriteStore.shared.isFavorite(newsLine)
        if newIsFavorite {
            FavoriteStore.shared.delete(newsLine)
        } else {
            FavoriteStore.shared.add(newsLine)
        }
        return !newIsFavorite
    }
        
}
