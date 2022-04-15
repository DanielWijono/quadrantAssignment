//
//  NetworkService.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 15/04/22.
//

import Foundation
import Moya

struct NetworkService {
    public static let instance = NetworkService()
    fileprivate let provider: MoyaProvider<MultiTarget>

    private init() {
        self.provider = MoyaProvider<MultiTarget>(
            requestClosure: { (endpoint, closure) in
                guard let request = try? endpoint.urlRequest() else { return }
                closure(.success(request))
            }
        )
    }
}

extension NetworkService {
    func request<T: TargetType, C: Decodable>(_ t: T, c: C.Type, completion: @escaping (Result<C, NetworkError>) -> Void) {
        provider.request(MultiTarget(t)) { (result) in
            switch result {
            case .success(let value):
                do {
                    let responses = try value.filterSuccessfulStatusCodes()
                    let result = try responses.map(C.self)
                    completion(.success(result))
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                    completion(.failure(.incorrectDataReturned))
                } catch DecodingError.keyNotFound(_, _) {
                        completion(.failure(.incorrectDataReturned))
                } catch DecodingError.valueNotFound(_, _) {
                    completion(.failure(.incorrectDataReturned))
                } catch DecodingError.typeMismatch(_, _) {
                    completion(.failure(.incorrectDataReturned))
                } catch {
                    if let errorResponse = try? value.map(ErrorResponse.self) {
                        completion(.failure(NetworkError.SoftError(message: errorResponse.message)))
                    } else {
                        completion(.failure(NetworkError.SoftError(message: "Error")))
                    }
                }
            case .failure(let error):
                switch error {
                case .underlying(let error, _):
                    completion(.failure(NetworkError(error: error as NSError)))
                default:
                    do {
                        completion(.failure(NetworkError.SoftError(message: "")))
                    }
                }
            }
        }
    }
}
