//
//  NomiOptions.swift
//  NominatimSwift
//
//  Created by Ringo Wathelet on 2025/08/20.
//
import Foundation


/*
 * Response format types
 */
public enum NomiFormats: String, Identifiable, CaseIterable, Sendable {
    public var id: String {
        return self.rawValue
    }
    case json
    case geojson
    case xml
    case jsonv2
}

/*
 * Options
 */
public struct NomiOptions: Codable, Sendable {
    
    public var limit: Int?
    public var language: String?
    public var addressdetails: Int?
    public var email: String?
    
    public var debug: String?

    public var extratags: Int?
    public var namedetails: Int?
    public var zoom: Int?
    public var layer: [String]?
    public var polygon_geojson: Int?
    public var polygon_kml: Int?
    public var polygon_svg: Int?
    public var polygon_text: Int?
    public var polygon_threshold: Double?
    
    
    enum CodingKeys: String, CodingKey {
        case limit, addressdetails, email, debug
        case extratags, namedetails, zoom, layer, polygon_geojson
        case polygon_kml, polygon_svg, polygon_text, polygon_threshold
        case language = "accept-language"
    }
    
public init(limit: Int? = nil, language: String? = nil, addressdetails: Int? = nil, email: String? = nil, debug: String? = nil, extratags: Int? = nil, namedetails: Int? = nil, zoom: Int? = nil, layer: [String]? = nil, polygon_geojson: Int? = nil, polygon_kml: Int? = nil, polygon_svg: Int? = nil, polygon_text: Int? = nil, polygon_threshold: Double? = nil) {
        self.limit = limit
        self.language = language
        self.addressdetails = addressdetails
        self.email = email
        self.debug = debug
        self.extratags = extratags
        self.namedetails = namedetails
        self.zoom = zoom
        self.layer = layer
        self.polygon_geojson = polygon_geojson
        self.polygon_kml = polygon_kml
        self.polygon_svg = polygon_svg
        self.polygon_text = polygon_text
        self.polygon_threshold = polygon_threshold
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


