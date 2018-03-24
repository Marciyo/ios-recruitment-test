//
//  APIClient.swift
//  iOSRecruitmentTest
//
//  Created by Marcel Mierzejewski on 3/24/18.
//  Copyright © 2018 Snowdog. All rights reserved.
//

import Foundation

class APIClient {
    private static let baseURL = URL(string: "http://localhost:8080/api/")!
    
    static func fetchData<T: Decodable>(request: HttpRequest, success: @escaping (T) -> (), failure: @escaping (Error) -> ()) {
        let request = request.request(baseURL: APIClient.baseURL)
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
