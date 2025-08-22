//
//  Untitled.swift
//  NominatimSwift
//
//  Created by Ringo Wathelet on 2025/08/20.
//
import Foundation
import SwiftUI

/**
 * provide access to the Nominatim JSON data observable for use in SwiftUI views
 */
@Observable
@MainActor
public final class NomiDataJsonModel: NomiBaseJson {

    public var reverseResult: NominatimPlace = NominatimPlace()
    public var searchResults: [NominatimPlace] = []
    public var lookupResults: [NominatimPlace] = []

    /// get the reverse geocoding for the given location with the given options
    public func reverse(lat: Double, lon: Double, options: NomiOptions) async {
        reverseResult = await baseReverse(lat: lat, lon: lon, options: options)
    }

    /// get the geocode for the given address with the given options
    public func search(address: String, options: NomiOptions) async {
        searchResults = await baseSearch(address: address, options: options)
    }
    
    /// get the geocode for the given NomiSearch parameters with the given options
    public func search(search: NomiSearch, options: NomiOptions) async {
        searchResults = await baseSearch(search: search, options: options)
    }
    
    /// get the geocode for the given address with the given options
    public func lookup(osmids: String, options: NomiOptions) async {
        lookupResults = await baseLookup(osmids: osmids, options: options)
    }
 
}

