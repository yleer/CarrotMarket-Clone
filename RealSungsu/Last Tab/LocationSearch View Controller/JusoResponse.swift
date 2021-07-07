//
//  JusoResponse.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/03.
//

import Foundation


struct JusoResponse : Codable {
    var results: JusoResults!
}

struct JusoResults: Codable {
    var common: Common!
    var juso: [Juso]!
}

struct Common: Codable {
    var errorCode: String!
    var currentPage: String!
    var totalCount: String!
    var errorMessage: String!
}

struct Juso: Codable {
    var roadAddr: String!
    var jibunAddr: String!
}
