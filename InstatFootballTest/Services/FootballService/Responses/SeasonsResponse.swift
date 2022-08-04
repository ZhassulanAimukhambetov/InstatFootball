//
//  SeasonsResponse.swift
//  InstatFootballTest
//
//  Created by Zhassulan Aimukhambetov on 04.08.2022.
//

import Foundation

struct SeasonsResponse: Decodable {
    let status: Bool
    let data: DataType
}

struct DataType: Decodable {
    let name: String?
    let desc: String
    let abbreviation: String?
    let seasons: [Season]
}

struct Season: Decodable {
    let year: Int
    let startDate: String
    let endDate: String
    let displayName: String
    let types: [TypeElement]
}

struct TypeElement: Decodable {
    let id: String
    let name: String
    let abbreviation: String
    let startDate: String
    let endDate: String
    let hasStandings: Bool
}
