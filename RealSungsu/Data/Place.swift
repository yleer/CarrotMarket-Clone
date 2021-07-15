//
//  Place.swift
//  RealSungsu
//
//  Created by Yundong Lee on 2021/07/04.
//

import Foundation

struct documentResponse :Codable{
    var documents : [Document]
    var meta : Meta!
}

struct Document : Codable {
    var address : Address!
    var x : String!
    var y : String!
}


struct Address : Codable {
    var address_name : String
}

struct Meta : Codable{
    var pageable_count : Int!
    var total_count : Int!
}
