//
//  NomiBatchJsonModel.swift
//  NominatimSwift
//
//  Created by Ringo Wathelet on 2025/08/20.
//


import Foundation
import SwiftUI


/**
 * provide access to the Nominatim data observable for use in SwiftUI views
 */
@Observable
@MainActor
public final class NomiBatchJsonModel: NomiBaseJson {
    
    public var batchReverses: [NominatimPlace] = []
    public var batchSearches: [[NominatimPlace]] = []
    public var batchLookups: [[NominatimPlace]] = []
    
    
    /// get the batch/concurrent reverse geocoding for the given locations with the given options
    public func batchReverse(_ locations: [Location], options: NomiOptions) async  {
        return await withTaskGroup(of: NominatimPlace.self) { group -> Void in
            for location in locations {
                group.addTask {
                    await self.baseReverse(lat: location.lat, lon: location.lon, options: options)
                }
            }
            for await response in group {
                batchReverses.append(response)
            }
        }
    }
    
    /// get the batch/concurrent forward geocoding for the given addresses with the given options
    public func batchSearch(_ addresses: [String], options: NomiOptions) async  {
        return await withTaskGroup(of: [NominatimPlace].self) { group -> Void in
            for address in addresses {
                group.addTask {
                    await self.baseSearch(address: address, options: options)
                }
            }
            for await response in group {
                batchSearches.append(response)
            }
        }
    }
    
    /// get the batch/concurrent lookup geocoding for the given addresses with the given options
    public func batchLookup(_ osmids: [String], options: NomiOptions) async  {
        return await withTaskGroup(of: [NominatimPlace].self) { group -> Void in
            for osmid in osmids {
                group.addTask {
                    await self.baseLookup(osmids: osmid, options: options)
                }
            }
            for await response in group {
                batchLookups.append(response)
            }
        }
    }
    
}
