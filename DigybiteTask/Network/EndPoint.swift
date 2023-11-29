//
//  EndPoint.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation
import Alamofire
struct Endpoint {
    let base: String
    let path: String
}
extension Endpoint {
    var url: URL? {
        return URL(string: base + path)
    }
}
