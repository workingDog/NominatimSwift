//
//  NomiSearch.swift
//  NominatimSwift
//
//  Created by Ringo Wathelet on 2025/08/20.
//

import Foundation


/*
 * NomiSearch
 */
public struct NomiSearch: Codable, Sendable {
    
    public var amenity: String?
    public var street: String?
    public var city: String?
    public var county: String?
    public var state: String?
    public var country: String?
    public var postalcode: String?
    
    
    enum CodingKeys: String, CodingKey {
        case amenity, street, city, county, state, country, postalcode
    }
    
    public init(amenity: String? = nil, street: String? = nil, city: String? = nil, county: String? = nil, state: String? = nil, country: String? = nil, postalcode: String? = nil) {
        self.amenity = amenity
        self.street = street
        self.city = city
        self.county = county
        self.state = state
        self.country = country
        self.postalcode = postalcode
    }
    
    public func toQueryItems() -> [URLQueryItem] {
        guard let data = try? JSONEncoder().encode(self),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return []
        }
        return dict.compactMap { key, value in
            URLQueryItem(name: key, value: "\(value)")
        }
    }
}
