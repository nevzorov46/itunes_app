//
//  NetworkService.swift
//  iTunesSearch
//
//  Created by Admin on 12.10.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case transport(Error)
    case emptyResponse
    case decoding(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL: return Resources.errorInvalidURLText
        case .transport: return Resources.errorTransportText
        case .emptyResponse: return Resources.errorEmptyResponseText
        case .decoding: return Resources.errorDecodingText
        }
    }
}

class NetworkService {
    
    static let shared = NetworkService()
    
    func getSongs(_ song: String, completionHandler: ((Result<ResultModel, NetworkError>) -> Void)?) {
        let url = Resources.getSongsURLString
        let urlString = url + song
        guard let escapingString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            completionHandler?(.failure(.invalidURL))
            return
        }
        httpGet(escapingString, completionHandler: completionHandler)
    }
    
    private func httpGet<T: Decodable>(_ url: String, completionHandler: ((Result<T, NetworkError>) -> Void)?) {
        guard let url = URL(string: url) else {
            completionHandler?(.failure(.invalidURL))
            return
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error {
                completionHandler?(.failure(.transport(error)))
                return
            }
            guard let data = data else {
                completionHandler?(.failure(.emptyResponse))
                return
            }
            completionHandler?(NetworkService.parseJSON(data: data))
        })
        task.resume()
    }
    
    private static func parseJSON<T: Decodable>(data: Data) -> Result<T, NetworkError> {
        let decoder = JSONDecoder()
        do {
            return .success(try decoder.decode(T.self, from: data))
        } catch {
            return .failure(.decoding(error))
        }
    }
    
    private init() {}
}
