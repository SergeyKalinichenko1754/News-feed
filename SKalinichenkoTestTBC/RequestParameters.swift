//
//  RequestParameter.swift
//  SKalinichenkoTestTBC
//

import Foundation

func getUrl(pageNumber: Int, linesOnPage: Int) -> URL? {
    var queryParams: [String: String] = [
        "domains": "wsj.com",
        "apiKey": "2536f886c0a5482b930a8da1f0ebecfa"
    ]
    queryParams["pageSize"] = String(linesOnPage)
    queryParams["page"] = String(pageNumber)
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "newsapi.org"
    urlComponents.path = "/v2/everything"
    urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
    return urlComponents.url
}
