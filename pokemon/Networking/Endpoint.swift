//
//  Endpoint.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Alamofire

enum Endpoint {
    case list(offset: Int, limit: Int)
    case detail(url: String)
}

// MARK: Path URL
extension Endpoint {
    func path() -> String {
        switch self {
        case .list(let offset, let limit):
            return "pokemon?offset=\(offset)&limit=\(limit)"
        case .detail(let url) :
            return url
        }
    }
}

// MARK: Method
extension Endpoint {
    func method() -> HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}

// MARK: Parameter
extension Endpoint {
    var parameter: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }
}

// MARK: Header
extension Endpoint {
    var header: HTTPHeaders {
        switch self {
        default:
            let params: HTTPHeaders = [
                "Accept": "*/*"
            ]
            return params
        }
    }
}

extension Endpoint {
    func urlString() -> String {
        switch self {
        case .detail:
            return path()
        default:
            return "https://pokeapi.co/api/v2/" + path()
        }
    }
}
