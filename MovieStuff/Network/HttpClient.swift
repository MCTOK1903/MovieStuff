//
//  HttpClient.swift
//  MovieStuff
//
//  Created by Muhammed Celal Tok on 11.08.2022.
//

import Foundation
import Alamofire

typealias resultClosure<T: Codable> = (Result<T, Error>) -> Void

enum HttpError: Error {
    case badURL, badResponse, errorDecodingData, invalidURL
}

protocol HttpClientProtocol: AnyObject {
    func fetch<T: Codable>(url: URL, completion: @escaping resultClosure<T>)
}

class HttpClient: HttpClientProtocol {
    
    // MARK: Properties
    private var afSession: Session
    
    // MARK: Init
    init(afSession: Session) {
        self.afSession = afSession
    }
    
    func fetch<T: Codable>(url: URL,
                           completion: @escaping resultClosure<T>) {
        
        afSession.request(url, method: .get).responseDecodable(of: T.self) { movie  in
            guard let data = movie.value else {
                return completion(.failure(HttpError.errorDecodingData))
            }
            completion(.success(data))
        }
    }
}
