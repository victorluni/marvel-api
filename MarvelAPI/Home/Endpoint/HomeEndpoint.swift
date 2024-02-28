//
//  HomeEndpoint.swift
//  MarvelAPI
//
//  Created by Victor Luni on 26/02/24.
//

import Foundation
struct HomeEndpoint {
    private let publicKey = "YOUR_PUBLIC_KEY"
    private let privateKey = "YOUR_PRIVATE_KEY"
    private let baseURLString: String
    private let offset: Int
    
    init(offset: Int) {
        self.offset = offset
        self.baseURLString = "https://gateway.marvel.com/v1/public/characters"
    }
    
    func getRequestURL(offset: Int = 0, query: String = "") -> URL? {
        let ts = String(Date().timeIntervalSince1970)
        let hash = (ts + privateKey + publicKey).md5
        
        var urlComponents = URLComponents(string: baseURLString)
        var queryItems = [
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "hash", value: hash),
            URLQueryItem(name: "limit", value: "\(20)"),
            URLQueryItem(name: "offset", value: "\(offset)"),
        ]
        if !query.isEmpty {
            queryItems.append(URLQueryItem(name: "nameStartsWith", value: query))
        }
        
        urlComponents?.queryItems = queryItems
        
        return urlComponents?.url
    }
}
