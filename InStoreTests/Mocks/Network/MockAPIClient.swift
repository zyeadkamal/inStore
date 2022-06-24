//
//  MockAPIClient.swift
//  InStoreTests
//
//  Created by sandra on 6/23/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
@testable import InStore

class MockAPIClient: APIClientProtocol {
    
    var baseURL: String = ""
    // MARK: - Properties
    
    var fileName: String?
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    // MARK: - Handlers
    
    func postRequest<T>(fromEndpoint: EndPoint, httpBody: Data?, httpMethod: HTTPMethod, ofType: T.Type, json: String) -> Observable<T> where T : Decodable {
        return Observable.create { (observer) -> Disposable in
            guard let data = self.data(in: self.fileName, extension: "json") else {
                assertionFailure("Unable to find the file with name: \(self.fileName ?? "")")
                observer.onError(NSError(domain: ApiError.NetworkFaild.rawValue, code: 500, userInfo: nil))
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(T.self, from: data)
                observer.onNext(apiResponse)
            } catch {
                observer.onError(NSError(domain: ApiError.NetworkFaild.rawValue, code: 500, userInfo: nil))
                print(error.localizedDescription)
            }
        }
    }
    
    func getRequest<T>(fromEndpoint: EndPoint, httpMethod: HTTPMethod, parameters: Parameters?, ofType: T.Type, json: String) -> Observable<T> where T : Decodable {
        return Observable.create { (observer) -> Disposable in
            guard let data = self.data(in: self.fileName, extension: "json") else {
                assertionFailure("Unable to find the file with name: \(self.fileName ?? "")")
                observer.onError(NSError(domain: ApiError.NetworkFaild.rawValue, code: 500, userInfo: nil))
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(T.self, from: data)
                observer.onNext(apiResponse)
            } catch {
                observer.onError(NSError(domain: ApiError.NetworkFaild.rawValue, code: 500, userInfo: nil))
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    /// Data in file
    /// - Parameters:
    ///   - fileName: File name
    ///   - extension: File extensio
    /// - Returns: Optional data
    func data(in fileName: String?, extension: String?) -> Data? {
        guard let path = Bundle(for: type(of: self)).url(forResource: fileName, withExtension: `extension`) else {
            assertionFailure("Unable to find file name \(String(describing: fileName))")
            return nil
        }
        
        guard let data = try? Data(contentsOf: path) else {
            assertionFailure("Unable to parse data")
            return nil
        }
        
        return data
    }
    
}

