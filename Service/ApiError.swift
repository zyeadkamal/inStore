//
//  ApiError.swift
//  rxNetworkLayer
//
//  Created by Mohamed Ahmed on 01/06/2022.
//

import Foundation

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}
