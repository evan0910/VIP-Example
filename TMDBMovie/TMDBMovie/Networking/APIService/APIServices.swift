//
//  APIServices.swift
//  TMDBMovie
//
//  Created by Evan Eka Laksana on 23/10/23.
//

import Foundation

protocol IAPIServices: AnyObject {
    func sendRequest<T: Decodable>(endpoint: IEndpoint,responseModel: T.Type) async -> Result<T, RequestError>
}

class APIServices: IAPIServices {
    
    static let share = APIServices()

    func sendRequest<T: Decodable>(
        endpoint: IEndpoint,
        responseModel: T.Type
    ) async -> Result<T, RequestError> {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = endpoint.URL
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.body
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                return .failure(.noResponse)
            }
            switch response.statusCode {
            case 200...299:

                guard let decodedResponse = try? JSONDecoder().decode(responseModel, from: data) else {
                    return .failure(.decode)
                }

                return .success(decodedResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
        } catch {
            return .failure(.unknown)
        }
    }
}
