//
//  NomiClient.swift
//  NominatimSwift
//
//  Created by Ringo Wathelet on 2025/08/20.
//

import Foundation

/*
 * represents an error during a connection
 */
public enum APIError: Swift.Error, LocalizedError {
    
    case unknown, apiError(reason: String), parserError(reason: String), networkError(from: URLError)
    
    public var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason), .parserError(let reason):
            return reason
        case .networkError(let from):
            return from.localizedDescription
        }
    }
}

/*
 * a network connection to Nominatim API server
 * info at: https://nominatim.org/release-docs/develop/api
 * urlString: https://nominatim.openstreetmap.org/
 *
 */
public actor NomiClient {

    public var sessionManager: URLSession
    public var acceptType = "application/json; charset=utf-8"
    public var contentType = "application/json; charset=utf-8"
    
    private var format: NomiFormats = NomiFormats.json
    private var baseurl: String = ""

    public init(urlString: String, format: NomiFormats) {
        self.baseurl = urlString
        self.format = format
        self.sessionManager = {
            let configuration = URLSessionConfiguration.default
            configuration.timeoutIntervalForRequest = 30  // seconds
            configuration.timeoutIntervalForResource = 30 // seconds
            return URLSession(configuration: configuration)
        }()
    }

    /*
     * general fetch data from the server.
     * A GET request with the chosen query is sent to the server.
     * The server response Data is returned.
     *
     * @components the URLComponents
     * @options NomiOptions
     * @return Data
     */
    public func fetchDataAsyncQ(components: URLComponents, options: NomiOptions) async throws -> Data {

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.addValue(acceptType, forHTTPHeaderField: "Accept")
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue(options.acceptLanguage ?? "en", forHTTPHeaderField: "Accept-Language")

     //   print("---> components.url: \(components.url!)")
        
        do {
            let (data, response) = try await sessionManager.data(for: request)
            
       //     print("---> data: \(String(data: data, encoding: .utf8) as AnyObject)")
   
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.unknown
            }

            if (httpResponse.statusCode == 401) {
                throw APIError.apiError(reason: "Unauthorized")
            }
            if (httpResponse.statusCode == 402) {
                throw APIError.apiError(reason: "Quota exceeded")
            }
            if (httpResponse.statusCode == 403) {
                throw APIError.apiError(reason: "Resource forbidden")
            }
            if (httpResponse.statusCode == 404) {
                throw APIError.apiError(reason: "Resource not found")
            }
            if (httpResponse.statusCode == 429) {
                throw APIError.apiError(reason: "Requesting too quickly")
            }
            if (405..<500 ~= httpResponse.statusCode) {
                throw APIError.apiError(reason: "Client error")
            }
            if (500..<600 ~= httpResponse.statusCode) {
                throw APIError.apiError(reason: "Server error")
            }
            if (httpResponse.statusCode != 200) {
                throw APIError.networkError(from: URLError(.badServerResponse))
            }

            return data
        }
        catch let error as APIError {
            throw error
        }
        catch {
            throw APIError.unknown
        }
    }

    /*
     * fetch data from the server.
     * A GET request with the chosen parameters is sent to the server.
     * The server response Data is returned.
     *
     * @lat latitude
     * @lon longitude
     * @options NomiOptions
     * @return Data
     */
    public func fetchDataAsync(lat: Double, lon: Double, options: NomiOptions) async throws -> Data {
        
        let urlstr = baseurl + "/reverse?format=\(format.rawValue)"
        guard let url = URL(string: urlstr) else {
            throw APIError.apiError(reason: "bad URL")
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        var queryItems: [URLQueryItem] = await options.toQueryItems()
        queryItems.append(URLQueryItem(name: "lat", value: "\(lat)"))
        queryItems.append(URLQueryItem(name: "lon", value: "\(lon)"))
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        return try await fetchDataAsyncQ(components: components, options: options)
    }
    
    /*
     * fetch data from the server.
     * A GET request with the chosen parameters is sent to the server.
     * The server response Data is returned.
     *
     * @address address
     * @options NomiOptions
     * @return Data
     */
    public func fetchDataAsync(address: String, options: NomiOptions) async throws -> Data {
        
        let urlstr = baseurl + "?format=\(format.rawValue)"
        guard let url = URL(string: urlstr) else {
            throw APIError.apiError(reason: "bad URL")
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        var queryItems: [URLQueryItem] = await options.toQueryItems()
        queryItems.append(URLQueryItem(name: "q", value: address))
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        return try await fetchDataAsyncQ(components: components, options: options)
    }
    
    /*
     * fetch data from the server.
     * A GET request with the chosen parameters is sent to the server.
     * The server response Data is returned.
     *
     * @search NomiSearch
     * @options NomiOptions
     * @return Data
     */
    public func fetchDataAsync(search: NomiSearch, options: NomiOptions) async throws -> Data {
        
        let urlstr = baseurl + "?format=\(format.rawValue)"
        guard let url = URL(string: urlstr) else {
            throw APIError.apiError(reason: "bad URL")
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        var queryItems: [URLQueryItem] = await search.toQueryItems()
        queryItems.append(contentsOf: await options.toQueryItems())
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        return try await fetchDataAsyncQ(components: components, options: options)
    }
    
    /*
     * fetch data from the server.
     * A GET request with the chosen parameters is sent to the server.
     * The server response Data is returned.
     *
     * @search NomiSearch
     * @options NomiOptions
     * @return Data
     */
    public func fetchDataAsync(lookup: String, options: NomiOptions) async throws -> Data {
        
        let urlstr = baseurl + "/lookup?format=\(format.rawValue)"
        guard let url = URL(string: urlstr) else {
            throw APIError.apiError(reason: "bad URL")
        }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        var queryItems: [URLQueryItem] = await options.toQueryItems()
        queryItems.append(URLQueryItem(name: "osm_ids", value: lookup))
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        return try await fetchDataAsyncQ(components: components, options: options)
    }

}


