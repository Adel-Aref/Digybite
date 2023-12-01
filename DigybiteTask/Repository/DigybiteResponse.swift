//
//  DigybiteResponse.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation

struct DigybiteResponse<T: Codable>: Codable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: T?
}
