//
//  NomiJsonProvider.swift
//  NominatimSwift
//
//  Created by Ringo Wathelet on 2025/08/20.
//
import Foundation


/**
 * prov ide access to the Nominatim data JSON API using simple stand alone functions
 */
@MainActor
public struct NomiJsonProvider {

    public let client: NomiClient
    
    /// default endpoint
    public init(urlString: String = "https://nominatim.openstreetmap.org/", format: NomiFormats = .jsonv2) {
        self.client = NomiClient(urlString: urlString, format: format)
    }
    
    /// get the reverse geocoding for the given location with the given options
    public func reverse(lat: Double, lon: Double, options: NomiOptions) async throws -> NominatimPlace {
        do {
            let data = try await client.fetchDataAsync(lat: lat, lon: lon, options: options)
            let response: NominatimPlace = try JSONDecoder().decode(NominatimPlace.self, from: data)
            return response
        } catch {
            print(error)
            return NominatimPlace()
        }
    }
    
    /// get the reverse geocoding for the given location with the given options, with completion handler
    public func reverse(lat: Double, lon: Double, options: NomiOptions, completion: @escaping (NominatimPlace) -> Void) {
        Task {
            let results: NominatimPlace = try await self.reverse(lat: lat, lon: lon, options: options)
            completion(results)
        }
    }
    
    /// get the geocode for the given address with the given options
    public func search(address: String, options: NomiOptions) async throws -> [NominatimPlace]  {
        do {
            let data = try await client.fetchDataAsync(address: address, options: options)
            let response: [NominatimPlace] = try JSONDecoder().decode([NominatimPlace].self, from: data)
            return response
        } catch {
            print(error)
            return []
        }
    }
    
    /// get the geocode for the given address with the given options, with completion handler
    public func search(address: String, options: NomiOptions, completion: @escaping ([NominatimPlace]) -> Void) {
        Task {
            let results: [NominatimPlace] = try await self.search(address: address, options: options)
            completion(results)
        }
    }
    
    /// get the geocode for the given NomiSearch parameters with the given options
    public func search(search: NomiSearch, options: NomiOptions) async throws -> [NominatimPlace] {
        do {
            let data = try await client.fetchDataAsync(search: search, options: options)
            let response: [NominatimPlace] = try JSONDecoder().decode([NominatimPlace].self, from: data)
            return response
        } catch {
            print(error)
            return []
        }
    }
    
    /// get the geocode for the given NomiSearch with the given options, with completion handler
    public func search(search: NomiSearch, options: NomiOptions, completion: @escaping ([NominatimPlace]) -> Void) {
        Task {
            let results: [NominatimPlace] = try await self.search(search: search, options: options)
            completion(results)
        }
    }
    
    /// get the geocode for the given address with the given options
    public func lookup(osmids: String, options: NomiOptions) async throws -> [NominatimPlace] {
        do {
            let data = try await client.fetchDataAsync(lookup: osmids, options: options)
            let response: [NominatimPlace] = try JSONDecoder().decode([NominatimPlace].self, from: data)
            return response
        } catch {
            print(error)
            return []
        }
    }
    
    /// get the geocode for the given address with the given options, with completion handler
    public func lookup(osmids: String, options: NomiOptions, completion: @escaping ([NominatimPlace]) -> Void) {
        Task {
            let results: [NominatimPlace] = try await self.lookup(osmids: osmids, options: options)
            completion(results)
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
