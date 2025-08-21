//
//  NominatimPlace.swift
//  NominatimSwift
//
//  Created by Ringo Wathelet on 2025/08/20.
//

import Foundation
import CoreLocation


// MARK: - NominatimPlace
public struct NominatimPlace: Codable, Identifiable, Sendable {
    public let id = UUID()

    public let placeID: Int
    public let licence: String?
    public let osmType: String
    public let osmID: Int
    public let lat: String
    public let lon: String
    public let displayName: String
    public let boundingBox: [String]?
    public let importance: Double?
    public let icon: String?
     
    public let clazz: String?
    public let category: String?
    public let type: String?
    public let placeRank: Int?
     
    public let address: NominatimAddress?
    public let extratags: [String: String]?
    public let namedetails: [String: String]?
     
//    public let geojson: [String: String]?
//    public let geokml: String?
//    public let geotext: String?
//    public let svg: String?
     
     enum CodingKeys: String, CodingKey {
         case licence, address, lat, lon, extratags
         case category, namedetails, type, importance, icon
         case osmType = "osm_type"
         case osmID = "osm_id"
         case placeID = "place_id"
         case displayName = "display_name"
         case boundingBox = "boundingbox"
         case clazz = "class"
         case placeRank = "place_rank"
         // case geojson, geokml, geotext, svg
     }
    
    public init(placeID: Int, licence: String?, osmType: String, osmID: Int, lat: String, lon: String, displayName: String, boundingBox: [String]?, importance: Double?, icon: String?, clazz: String?, category: String?, type: String?, placeRank: Int?, address: NominatimAddress?, extratags: [String : String]?, namedetails: [String : String]?) {
        self.placeID = placeID
        self.licence = licence
        self.osmType = osmType
        self.osmID = osmID
        self.lat = lat
        self.lon = lon
        self.displayName = displayName
        self.boundingBox = boundingBox
        self.importance = importance
        self.icon = icon
        self.clazz = clazz
        self.category = category
        self.type = type
        self.placeRank = placeRank
        self.address = address
        self.extratags = extratags
        self.namedetails = namedetails
    }

    public init() {
        self.placeID = 0
        self.licence = nil
        self.osmType = ""
        self.osmID = 0
        self.lat = ""
        self.lon = ""
        self.displayName = ""
        self.boundingBox = nil
        self.importance = nil
        self.icon = nil
        self.clazz = nil
        self.category = nil
        self.type = nil
        self.placeRank = nil
        self.address = nil
        self.extratags = nil
        self.namedetails = nil
    }
    
    public func asCoordinate() -> CLLocationCoordinate2D? {
        if let latd = Double(lat), let lond = Double(lon) {
            return CLLocationCoordinate2D(latitude: latd, longitude: lond)
        }
        return nil
    }
 }

 // MARK: - NominatimAddress
public struct NominatimAddress: Codable, Identifiable, Sendable {
    public let id = UUID()
     
    public let houseNumber: String?
    public let road: String?
    public let neighbourhood: String?
    public let suburb: String?
    public let city: String?
    public let town: String?
    public let village: String?
    public let county: String?
    public let stateDistrict: String?
    public let state: String?
    public let postcode: String?
    public let country: String?
    public let countryCode: String?
     
     enum CodingKeys: String, CodingKey {
         case road, neighbourhood, suburb, city, town, village, county
         case state, postcode, country
         case stateDistrict = "state_district"
         case countryCode = "country_code"
         case houseNumber = "house_number"
     }
    
    public init(houseNumber: String?, road: String?, neighbourhood: String?, suburb: String?, city: String?, town: String?, village: String?, county: String?, stateDistrict: String?, state: String?, postcode: String?, country: String?, countryCode: String?) {
        self.houseNumber = houseNumber
        self.road = road
        self.neighbourhood = neighbourhood
        self.suburb = suburb
        self.city = city
        self.town = town
        self.village = village
        self.county = county
        self.stateDistrict = stateDistrict
        self.state = state
        self.postcode = postcode
        self.country = country
        self.countryCode = countryCode
    }
    
    public init() {
        self.houseNumber = nil
        self.road = nil
        self.neighbourhood = nil
        self.suburb = nil
        self.city = nil
        self.town = nil
        self.village = nil
        self.county = nil
        self.stateDistrict = nil
        self.state = nil
        self.postcode = nil
        self.country = nil
        self.countryCode = nil
    }
 }

// MARK: - Location
public struct Location: Codable, Sendable {
    public let lat, lon: Double
    
    public func asCoordinate() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}

// MARK: - StatusResponse
public struct StatusResponse: Codable, Sendable {
    public let status: Int
    public let message: String
    public let dataUpdated: String?
    public let softwareVersion, databaseVersion: String?

    enum CodingKeys: String, CodingKey {
        case status, message
        case dataUpdated = "data_updated"
        case softwareVersion = "software_version"
        case databaseVersion = "database_version"
    }
}
