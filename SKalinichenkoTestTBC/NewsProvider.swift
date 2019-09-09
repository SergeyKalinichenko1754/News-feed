//
//  NewsProvider.swift
//  SKalinichenkoTestTBC
//

import UIKit

class NewsProvider {
    static func getNews(at page: Int, lines: Int, completion: @escaping (_ news: News?, _ error: String?) -> Void) {
        if (page * lines) - FavoriteStore.shared.newsQuantity > lines {
            completion(nil, nil)
            return
        }
        guard let my_url = getUrl(pageNumber: page + 1, linesOnPage: lines) else {
            completion(nil, nil)
            return
        }
        let task = URLSession.shared.dataTask(with: my_url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, nil)
                return
            }
            do {
                let news = try JSONDecoder().decode(News.self, from: data)
                if page == 0 {
                    FavoriteStore.shared.newsQuantity = news.totalResults ?? 0
                }
                if (news.totalResults ?? 0) == 0 {
                    let err = try JSONDecoder().decode(RequestError.self, from: data)
                    if err.status == "error" {
                        completion(nil, err.message)
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(news, nil)
                }
            } catch let error {
                completion(nil, error.localizedDescription)
            }
        }
        task.resume()
    }
}
