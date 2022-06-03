//
//  APIClient.swift
//  InStore
//
//  Created by mac on 6/1/22.
//  Copyright © 2022 mac. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire


protocol APIClientProtocol {
    
    func postRequest<T: Decodable>(fromEndpoint: EndPoint, httpBody: Data?, httpMethod : HTTPMethod , ofType : T.Type, json: String) -> Observable<T>
    
    func getRequest<T: Decodable>(fromEndpoint: EndPoint, httpMethod: HTTPMethod, parameters: Parameters? , ofType : T.Type , json : String) -> Observable<T>
}


class ApiClient: APIClientProtocol {
    
    //MARK: - The request function to get results in an Observable
    
    func postRequest<T: Decodable>(fromEndpoint: EndPoint, httpBody: Data?, httpMethod : HTTPMethod , ofType : T.Type, json: String) -> Observable<T> {
        
        return Observable<T>.create { observer in
            guard let url = URL(string: "\(APIConstants.baseUrl)\(fromEndpoint)\(json)") else {
                observer.onError(NSError(domain: "", code: 500, userInfo: nil))
                return Disposables.create {}
            }
            print(url)
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            request.httpShouldHandleCookies = false
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = httpBody
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error{
                    print(error)
                    observer.onError(error)
                }else{
                    if let data = data {
                        do{
                            print(String(decoding: data, as: UTF8.self))

                            let jsonDecoder = JSONDecoder()
                            let result = try jsonDecoder.decode(T.self, from: data)
                            observer.onNext( result )
                        }catch{
                            observer.onError(error)
                            
                        }
                    }
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    
    
    func getRequest<T: Decodable>(fromEndpoint: EndPoint, httpMethod: HTTPMethod = .get, parameters: Parameters? , ofType : T.Type , json : String = ".json" ) -> Observable<T> {
        
        return Observable<T>.create { observer in
            
            guard let url = URL(string: "\(APIConstants.baseUrl)\(fromEndpoint)\(json)") else {
                observer.onError(NSError(domain: "", code: 500, userInfo: nil))
                return Disposables.create {}
            }
            print(url)
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            
            AF.request(url, method: httpMethod, parameters: parameters, encoding: URLEncoding(destination: .queryString), headers: nil).responseJSON { (response) in
                if let error = response.error {
                    observer.onError(error)
                }
                
                guard let urlResponse = response.response else {
                    observer.onError(ApiError.notFound)
                    return
                }
                if !(200..<300).contains(urlResponse.statusCode) {
                    observer.onError(ApiError.forbidden)
                }
                guard let data = response.data else { return }
                
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    observer.onNext( response )
                    
                } catch {
                    debugPrint("Could not translate the data to the requested type. Reason: \(error.localizedDescription)")
                    observer.onError(ApiError.conflict)
                }
                
            }
            return Disposables.create ()
        
        }
        
    }
}
