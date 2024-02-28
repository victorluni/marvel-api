//
//  NetworkRequest.swift
//  MarvelAPI
//
//  Created by Victor Luni on 24/02/24.
//

import Foundation
import Network

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case noInternet
    
    var message: String {
        switch self {
        case .invalidURL:
            "URL Inválida"
        case .requestFailed:
            "Requisição falhou"
        case .invalidResponse:
            "Resposta inválida"
        case .noInternet:
            "Sem conexão com a internet :("
        }
    }
    
    var image: String {
        switch self {
        case .invalidURL, .requestFailed, .invalidResponse:
            "multiply.circle.fill"
        case .noInternet:
            "wifi"
        }
    }
}


class NetworkManager {
    
    private let monitor = NWPathMonitor()
    private var isConnected = false

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
        }
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }

    func hasInternetConnection() -> Bool {
        return isConnected
    }
    
    typealias ResultCallback<T> = (Result<T, NetworkError>) -> Void
    
    func makeRequest<T: Decodable>(to endpoint: URL, offset: Int = 0, limit: Int = 20 ,completion: @escaping ResultCallback<T>) {
        
        if !hasInternetConnection() {
            completion(.failure(NetworkError.noInternet))
            return
        }
        
        
        let task = URLSession.shared.dataTask(with: endpoint) { data, response, error in
            if error != nil {
                completion(.failure(NetworkError.requestFailed))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.requestFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch {
                completion(.failure(NetworkError.invalidResponse))
            }
        }
        
        task.resume()
    }
}
