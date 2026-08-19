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
    /// The request was superseded by a newer one. Never shown to the user.
    case cancelled

    var errorDescription: String? {
        switch self {
        case .invalidURL: return Resources.errorInvalidURLText
        case .transport: return Resources.errorTransportText
        case .emptyResponse: return Resources.errorEmptyResponseText
        case .decoding: return Resources.errorDecodingText
        case .cancelled: return nil
        }
    }
}

protocol NetworkCancellable {
    func cancel()
}

extension URLSessionDataTask: NetworkCancellable {}

protocol NetworkServiceProtocol {
    @discardableResult
    func getSongs(_ song: String, completionHandler: ((Result<ResultModel, NetworkError>) -> Void)?) -> NetworkCancellable?
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    
    @discardableResult
    func getSongs(_ song: String, completionHandler: ((Result<ResultModel, NetworkError>) -> Void)?) -> NetworkCancellable? {
        let url = Resources.getSongsURLString
        let urlString = url + song
        guard let escapingString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            completionHandler?(.failure(.invalidURL))
            return nil
        }
        return httpGet(escapingString, completionHandler: completionHandler)
    }
    
    private func httpGet<T: Decodable>(_ url: String, completionHandler: ((Result<T, NetworkError>) -> Void)?) -> NetworkCancellable? {
        guard let url = URL(string: url) else {
            completionHandler?(.failure(.invalidURL))
            return nil
        }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) in
            if let error = error {
                completionHandler?(.failure(Self.isCancellation(error) ? .cancelled : .transport(error)))
                return
            }
            guard let data = data else {
                completionHandler?(.failure(.emptyResponse))
                return
            }
            completionHandler?(NetworkService.parseJSON(data: data))
        })
        task.resume()
        return task
    }
    
    private static func isCancellation(_ error: Error) -> Bool {
        let error = error as NSError
        return error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled
    }
    
    private static func parseJSON<T: Decodable>(data: Data) -> Result<T, NetworkError> {
        let decoder = JSONDecoder()
        do {
            return .success(try decoder.decode(T.self, from: data))
        } catch {
            return .failure(.decoding(error))
        }
    }
    
}
