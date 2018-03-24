//
//  NetworkClient.swift
//  iOSRecruitmentTest
//
//  Created by Marcel Mierzejewski on 3/24/18.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol HttpRequest {
    var method: HttpMethod { get }
    var path: String { get }
    var parameters: [String : String] { get }
}

extension HttpRequest {
    func request(baseURL: URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(self.path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL components")
        }
        
        components.queryItems = self.parameters.map {
            URLQueryItem(name: String($0), value: String($1))
        }
        
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

struct API {
    private static let baseURL = URL(string: "http://localhost:8080/api/")!
    
    static func fetchData<T: Decodable>(request: HttpRequest, success: @escaping (T) -> (), failure: @escaping (Error) -> ()) {
        let request = request.request(baseURL: API.baseURL)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                success(model)
            } catch let error {
                failure(error)
            }
        }
        task.resume()
    }
}
