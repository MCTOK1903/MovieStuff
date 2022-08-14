//
//  HttpClientTest.swift
//  MovieStuffTests
//
//  Created by Muhammed Celal Tok on 14.08.2022.
//

import XCTest
import Alamofire
@testable import MovieStuff

class HttpClientTest: XCTestCase {

    var sessionManager: Session!
    var httpClient: HttpClientProtocol!
    let reqURL = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=fc6fbc3ee72d36c19e1752a6ee0f6273")!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        sessionManager = Alamofire.Session(configuration: configuration)
        
        httpClient = HttpClient(afSession: sessionManager)
    }
    
    override func tearDown() {
        sessionManager = nil
        httpClient = nil
        
        super.tearDown()
    }
    
    func test_Should_Have_PopularMovie_When_Path_Invalid() {
        
        let response = HTTPURLResponse(url: Constants.generateURL(with: .movie_popular, searchKey: "badUrl")!,
                                       statusCode: 400,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
        
        let mockData: Data = Data("mockString".utf8)
        
        MockURLProtocol.requestHandler = { request in
            return (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "isValidResponse")
        
        httpClient.fetch(url: reqURL) { (response: Result<SearchResult, Error>) in
            switch response {
            case .success:
                XCTFail("url is valid")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, HttpError.badRequest.localizedDescription)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_Should_Have_PopularMovie_When_Data_Invalid() {
        let response = HTTPURLResponse(url: Constants.generateURL(with: .movie_popular, searchKey: .empty)!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
        
        let mockString = """
            {
            "page": 1,
            "results": [
            {
                "adult": false,
                "backdrop_path": "/7ZO9yoEU2fAHKhmJWfAc2QIPWJg.jpg",
                "genre_ids": [
                    28,
                    53,
                    878
                ],
                "id": 766507,
                "original_language": "en",
                "original_title": "Prey",
                "overview": "When danger threatens her camp, the fierce and highly skilled Comanche warrior Naru sets out to protect her people. But the prey she stalks turns out to be a highly evolved alien predator with a technically advanced arsenal.",
                "popularity": 12286.389,
                "poster_path": "/ujr5pztc1oitbe7ViMUOilFaJ7s.jpg",
                "release_date": "2022-08-02",
                "title": "Prey",
                "video": false,
                "vote_average": 8.2,
                "vote_count": 2137
            }
            
            ]
        }
        """
        
        let mockData: Data = Data(mockString.utf8)
        
        
        MockURLProtocol.requestHandler = { request in
            return (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "EndocingError")
        
        httpClient.fetch(url: reqURL) { (response: Result<PersonModel, Error>) in
            switch response {
            case .success(let data):
                print(data)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, HttpError.errorDecodingData.localizedDescription)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_Should_Have_PopularMovie_When_Data_Valid() {
        let response = HTTPURLResponse(url: Constants.generateURL(with: .movie_popular, searchKey: .empty)!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: ["Content-Type": "application/json"])!
        
        let mockString = """
            {
            "page": 1,
            "results": [
            {
                "adult": false,
                "backdrop_path": "/7ZO9yoEU2fAHKhmJWfAc2QIPWJg.jpg",
                "genre_ids": [
                    28,
                    53,
                    878
                ],
                "id": 766507,
                "original_language": "en",
                "original_title": "Prey",
                "overview": "When danger threatens her camp, the fierce and highly skilled Comanche warrior Naru sets out to protect her people. But the prey she stalks turns out to be a highly evolved alien predator with a technically advanced arsenal.",
                "popularity": 12286.389,
                "poster_path": "/ujr5pztc1oitbe7ViMUOilFaJ7s.jpg",
                "release_date": "2022-08-02",
                "title": "Prey",
                "video": false,
                "vote_average": 8.2,
                "vote_count": 2137
            }
            
            ]
        }
        """
        
        let mockData: Data = Data(mockString.utf8)
        
        
        MockURLProtocol.requestHandler = { request in
            return (response, mockData)
        }
        
        let expectation = XCTestExpectation(description: "successData")
        
        httpClient.fetch(url: reqURL) { (response: Result<SearchResult, Error>) in
            switch response {
            case .success(let data):
                XCTAssertNotNil(data)
                expectation.fulfill()
            case .failure:
                XCTFail("Data should be full")
            }
        }
        
        wait(for: [expectation], timeout: 10)
    }

}
