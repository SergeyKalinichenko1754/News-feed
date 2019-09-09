//
//  Model.swift
//  SKalinichenkoTestTBC
//

import UIKit

enum ScreenName: String {
    case news = "News"
    case favorites = "Favorites"
}

struct News: Decodable {
    var totalResults: Int?
    var articles: [NewsLine]?    
}

struct NewsLine: Codable {
    var url: String
    var title: String?
    var content: String?
    var urlToImage: String?
}

struct RequestError: Decodable {
    var status: String?
    var code: String?
    var message: String?
}

class FavoriteStore {
    
    static let shared = FavoriteStore()
    var favourites: [String] = []
    var newsQuantity = 0
    
    init() {
        load()
    }
    
    func isFavorite(_ newsLine: NewsLine) -> Bool {
        return favourites.contains(newsLine.url)
    }
        
    func add(_ article: NewsLine) {
        favourites.append(article.url)
        save()
        guard let json = try? JSONEncoder().encode(article) else {
            assertionFailure("Unable to save article")
            return
        }
        UserDefaults.standard.set(json, forKey: article.url)
    }
    
    func delete(_ article: NewsLine) {
        guard let index = favourites.firstIndex(of: article.url) else {
            assertionFailure("Favourite news not found and not deleted. But had to be!")
            return}
        favourites.remove(at: index)
        UserDefaults.standard.set(nil, forKey: article.url)
        save()
    }
    
    func loadAllFavouritesNews() -> [NewsLine] {
        var articles = [NewsLine]()
        for url in favourites {
            guard let jsonData = UserDefaults.standard.value(forKey: url) as? Data else {
                assertionFailure("Favourtie news line data is not available. But expected at this point")
                continue
            }
            guard let newArticle = try? JSONDecoder().decode(NewsLine.self, from: jsonData) else {
                assertionFailure("Unable to decode favourite news line data")
                continue
            }
            articles.append(newArticle)
        }
        return articles
    }
    
    private func save() {
        UserDefaults.standard.set(favourites, forKey: "FavoriteStore")
    }
    
    private func load() {
        if let array = UserDefaults.standard.object(forKey: "FavoriteStore") as? [String] {
            favourites = array
        } else {
            favourites = []
        }
    }
}
