//
//  File.swift
//  
//
//  Created by Keval Patel on 10/18/23.
//

import Foundation

public struct ProductPayLoad: Codable {
    public let products: [Product]
}

public struct Product: Codable, Equatable {
    public let id: Int
    public let title: String?
    public let description: String?
    public let brand: String?
    public let images: [String]?
    
    public init(id: Int,
                title: String = "") {
        self.id = id
        self.title = title
        self.description = nil
        self.brand = nil
        self.images = nil
    }
}
