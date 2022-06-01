//
//  ApiClient.swift
//  rxNetworkLayer
//
//  Created by Mohamed Ahmed on 01/06/2022.
//


import RxSwift
import Alamofire

class ApiClient {
    
    static func getCustomers() -> Observable<LoginResponse>{
        var aaa : Observable<LoginResponse>?
 
            
        aaa = getRequest(fromEndpoint: EndPoint.customers, parameters: ["email":"yalhwaaaaaaaay@gmail.com"],ofType: LoginResponse.self)
    
        
        // return makeAPIRequest(ApiRouter.postCustomer(customer: customer))

        
        return aaa!
    }
    static func postCustomer(customer: NewCustomer) -> Observable<NewCustomer> {
        //print(ApiRouter.postCustomer(customer: customer))
        var aaa : Observable<NewCustomer>?
        do{
            
            let postBody = try JSONEncoder().encode(customer)
            aaa = postRequest(fromEndpoint: EndPoint.customers , httpBody: postBody, httpMethod: .post, ofType: NewCustomer.self)
            
        }catch{}
        // return makeAPIRequest(ApiRouter.postCustomer(customer: customer))
        // return makeAPIRequest()
        
        return aaa!
    }
    
    //MARK: - The request function to get results in an Observable
    
    static func postRequest<T: Decodable>(fromEndpoint: EndPoint, httpBody: Data, httpMethod : HTTPMethod , ofType : T.Type) -> Observable<T> {
        
        return Observable<T>.create { observer in
            guard let url = URL(string: "\(APIConstants.baseUrl)\(fromEndpoint)") else {
                observer.onError(NSError(domain: "", code: 500, userInfo: nil))
                return Disposables.create {}
            }
            var request = URLRequest(url: url)
            request.httpMethod = httpMethod.rawValue
            let session = URLSession.shared
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
    static func getRequest<T: Decodable>(fromEndpoint: EndPoint, httpMethod: HTTPMethod = .get, parameters: Parameters? , ofType : T.Type , json : String = ".json" ) -> Observable<T> {
        
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
//
//    func login(email: String, password: String){
//        AF.request(URLs.customers()).validate().responseDecodable(of:LoginResponse.self) { (response) in
//            completion(response)
//        }
//    }
//    private static func makeAPIRequest<T: Codable>(_ urlConvertible: URLRequestConvertible) -> Observable<T> {
//            return Observable<T>.create { observer in
////                guard let url = URL(string: "https://www.thesportsdb.com/api/v1/json/2/all_sports.php" )  else {
////                    observer.onError(NSError(domain: "", code: 500, userInfo: nil))
////                    return Disposables.create {}
////                }
//
////                var request = URLRequest(url: url)
////                request.httpMethod = "POST"
////
////                request.httpBody =
////
////
////                request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//                let task = URLSession.shared.dataTask(with: urlConvertible.urlRequest!) { (data, response, error) in
//                    guard error == nil else{
//
//                        observer.onError(error!)
//                        return
//                    }
//                    do {
//                        let result = try JSONDecoder().decode(T.self, from: data ?? Data())
//                        observer.onNext( result )
//                    } catch let error {
//                        observer.onError(error)
//                    }
//                    observer.onCompleted()
//                }
//                task.resume()
//
//                return Disposables.create {
//                    task.cancel()
//                }
//            }
//        }
//}


//    private static func request<T: Codable> (_ urlConvertible: URLRequestConvertible) -> Observable<T> {
//        //Create an RxSwift observable, which will be the one to call the request when subscribed to
//        return Observable<T>.create { observer in
//            //Trigger the HttpRequest using AlamoFire (AF)
//
//            let request = AF.request(urlConvertible).responseJSON { (response) in
//
//                guard let statusCode = response.response?.statusCode else {
//                                print("StatusCode not found")
//                    observer.onError(NSError())
//                                return
//                            }
//
//                            // 7
//                            if statusCode == 200 {
//
//                                // 8
//                                guard let jsonResponse = try? response.result.get() else {
//                                    print("jsonResponse error")
//                                    observer.onError(NSError())
//                                    return
//                                }
//                                // 9
//                                guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
//                                    print("theJSONData error")
//                                    observer.onError(NSError())
//                                    return
//                                }
//                                // 10
//                                guard let responseObj = try? JSONDecoder().decode(T.self, from: theJSONData) else {
//                                    print("responseObj error")
//                                    observer.onError(NSError())
//                                    return
//                                }
//                                observer.onNext(responseObj)
//                                observer.onCompleted()
//                            } else {
//                                print("error statusCode is \(statusCode)")
//                                observer.onError(NSError())
//
//                            }
//
////                switch response.result {
////
////                case .success(let value):
////                   // print(value)
////                    guard let jsonResponse = try? response.result.get() else {
////                        print("jsonResponse error")
////                        observer.onError(NSError())
////                        return
////                    }
////
////                    // 9
////                    guard let theJSONData = try? JSONSerialization.data(withJSONObject: jsonResponse, options: []) else {
////                        print("theJSONData error")
////                        observer.onError(NSError())
////                        return
////                    }
////                    // 10
////                    guard let responseObj = try? JSONDecoder().decode(T.self, from: theJSONData) else {
////                        print("responseObj error")
////                        observer.onError(NSError())
////                        return
////                    }
////                    //Everything is fine, return the value in onNext
////                    observer.onNext(responseObj)
////                    observer.onCompleted()
////                case .failure(let error):
////
////                    //Something went wrong, switch on the status code and return the error
////                    switch response.response?.statusCode {
////                    case 403:
////                        observer.onError(ApiError.forbidden)
////                    case 404:
////                        observer.onError(ApiError.notFound)
////                    case 409:
////                        observer.onError(ApiError.conflict)
////                    case 500:
////                        observer.onError(ApiError.internalServerError)
////                    default:
////                        observer.onError(error)
////                    }
////                }
//            }
//
//            //Finally, we return a disposable to stop the request
//            return Disposables.create {
//
//                request.cancel()
//
//            }
//        }
//    }
//}
