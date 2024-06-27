//
//  ApiManager.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Foundation
import Alamofire
import Combine

enum ErrorHandler: Error {
    case failedParsing
    case unknownError
    case dataEmpty
    case unauthorized
}

class ApiManager {
    
    private static let session: Session = {
            let evaluator: [String: ServerTrustEvaluating] = [
                "pokeapi.co": DisabledTrustEvaluator()
            ]
            let manager = ServerTrustManager(evaluators: evaluator)
            let session = Session(serverTrustManager: manager)
            return session
        }()
    
    func requestApiPublisher<T: Codable>(_ endpoint: Endpoint, timeout: TimeInterval = 60) -> AnyPublisher<T, Error> {
        return Future<T, Error> { promise in
            Task {
                do {
                    let result: T = try await withUnsafeThrowingContinuation({ continuation in
                        ApiManager.session.request(
                            endpoint.urlString(),
                            method: endpoint.method(),
                            parameters: endpoint.parameter,
                            encoding: JSONEncoding.default,
                            headers: endpoint.header,
                            interceptor: nil,
                            requestModifier: { $0.timeoutInterval = timeout })
                        .responseData(
                            queue: .main,
                            dataPreprocessor: DataResponseSerializer.defaultDataPreprocessor,
                            emptyResponseCodes: [200, 401],
                            emptyRequestMethods: DataResponseSerializer.defaultEmptyRequestMethods) { response in
                                if let error = response.error {
                                    continuation.resume(throwing: error)
                                } else {
                                    guard let urlResponse = response.response else {
                                        continuation.resume(throwing: ErrorHandler.unknownError)
                                        return
                                    }
                                    switch urlResponse.statusCode {
                                    case 401:
                                        continuation.resume(throwing: ErrorHandler.unauthorized)
                                    default:
                                        if let data = response.data {
                                            do {
                                                let decoded = try JSONDecoder().decode(T.self, from: data)
                                                continuation.resume(returning: decoded)
                                            } catch {
                                                continuation.resume(throwing: error)
                                            }
                                        } else {
                                            continuation.resume(throwing: ErrorHandler.unknownError)
                                        }
                                    }
                                }
                            }
                    })
                    
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
