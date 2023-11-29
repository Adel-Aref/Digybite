//
//  Environment.swift
//  DigybiteTask
//
//  Created by Adel Aref on 29/11/2023.
//

import Foundation

public enum Environment {
    // MARK: - Keys
        enum PlistKeys {
            static let baseURL = "Base_URL"
            static let apiKey = "API_KEY"
        }
    
    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    
    static let baseURL: String = {
        guard let baseURLstring = Environment.infoDictionary[PlistKeys.baseURL] as? String else {
            fatalError("base URL not set in plist for this environment")
        }
        guard let url = URL(string: baseURLstring) else {
            fatalError("Base URL is invalid")
        }
        return baseURLstring
    }()
    
    static let apiKey: String = {
        guard let baseURLstring = Environment.infoDictionary[PlistKeys.apiKey] as? String else {
            fatalError("apiKey not set in plist for this environment")
        }
        guard let url = URL(string: baseURLstring) else {
            fatalError("apiKey is invalid")
        }
        return baseURLstring
    }()
}
