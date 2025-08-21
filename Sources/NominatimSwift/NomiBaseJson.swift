//
//  NomiJsonProvider.swift
//  NominatimSwift
//
//  Created by Ringo Wathelet on 2025/08/20.
//
import Foundation
import SwiftUI


/**
 * provide access to the Nominatim data JSON API 
 */
@Observable
@MainActor
public class NomiBaseJson {
    
    public var isLoading = false
    public var error: APIError?
    public let client: NomiClient
    
    /// default endpoint
    public init(urlString: String = "https://nominatim.openstreetmap.org/") {
        self.client = NomiClient(urlString: urlString, format: .jsonv2)
    }
    
    /// get the reverse geocoding for the given location with the given options
    public func baseReverse(lat: Double, lon: Double, options: NomiOptions) async -> NominatimPlace {
        do {
            let data = try await client.fetchDataAsync(lat: lat, lon: lon, options: options)
            let response: NominatimPlace = try JSONDecoder().decode(NominatimPlace.self, from: data)
            return response
        } catch {
            self.error = error as? APIError
            print(error)
            return NominatimPlace()
        }
    }
    
    /// get the geocode for the given address with the given options
    public func baseSearch(address: String, options: NomiOptions) async -> [NominatimPlace]  {
        do {
            let data = try await client.fetchDataAsync(address: address, options: options)
            let response: [NominatimPlace] = try JSONDecoder().decode([NominatimPlace].self, from: data)
            return response
        } catch {
            self.error = error as? APIError
            print(error)
            return []
        }
    }
    
    /// get the geocode for the given NomiSearch parameters with the given options
    public func baseSearch(search: NomiSearch, options: NomiOptions) async -> [NominatimPlace] {
        do {
            let data = try await client.fetchDataAsync(search: search, options: options)
            let response: [NominatimPlace] = try JSONDecoder().decode([NominatimPlace].self, from: data)
            return response
        } catch {
            self.error = error as? APIError
            print(error)
            return []
        }
    }
    
    /// get the geocode for the given address with the given options
    public func baseLookup(osmids: String, options: NomiOptions) async -> [NominatimPlace] {
        do {
            let data = try await client.fetchDataAsync(lookup: osmids, options: options)
            let response: [NominatimPlace] = try JSONDecoder().decode([NominatimPlace].self, from: data)
            return response
        } catch {
            self.error = error as? APIError
            print(error)
            return []
        }
    }
    
    /// check the status of the Nominatim server
    public func checkStatus() async -> StatusResponse? {
        do {
            let data = try await client.checkStatus()
            let status: StatusResponse = try JSONDecoder().decode(StatusResponse.self, from: data)
            return status
        } catch {
            print(error)
            return nil
        }
    }
}
