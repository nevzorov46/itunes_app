//
//  NetworkService.swift
//  itunes_app
//
//  Created by Admin on 12.10.2023.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    func getSongs(_ song: String, completionHandler: ((ResultModel?) -> Void)?) {
        let url = Resources.getSongsURLString
        let urlString = url + song 
        if let escapingString = urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            httpGet(escapingString, completionHandler: completionHandler)
        }
    }
    
    private func httpGet<T: Decodable>(_ url: String,  completionHandler : ((T?) -> Void)?) {
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url, completionHandler: { [ weak self] (data, _ , error) in
            guard let this = self else { return }
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let data = data else { return }
            let songs: T? = this.parseJSON(data: data)
            completionHandler?(songs)
            
        })
        task.resume()
    }
    
    private func parseJSON<T: Decodable>(data: Data) -> T? {
        let decoder = JSONDecoder()
        let type = T.self
        do {
            return try decoder.decode(type, from: data)
        } catch let error as NSError {
            print(String(describing: error))
        }
        return nil
    }
}
