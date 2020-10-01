//
//  UserConfiguration.swift
//  SomeChat
//
//  Created by Алексей Махутин on 22.09.2020.
//  Copyright © 2020 Алексей Махутин. All rights reserved.
//

import Foundation

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: String)
    func string(forKey defaultName: String) -> String?
}

extension UserDefaults: UserDefaultsProtocol {}

internal final class UserConfiguration {

    private struct Constants {
        static let storagePrefix = "someChat"
        static let userFistName = "userFistName"
        static let userLastName = "userLastName"
        static let userBio = "userBio"
        static let userAvatarExist = "userAvatarExist"
    }

    static let shared = UserConfiguration()
    let queue = DispatchQueue.init(label: "UserConfiguration", qos: .utility)
    let userDefaults: UserDefaultsProtocol

    init(with userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    var userFistName: String? {
        get {
            return self.userDefaults.string(forKey: self.forKey(string: Constants.userFistName))
        }
        set {
            self.userDefaults.set(newValue, forKey: self.forKey(string: Constants.userFistName))
        }
    }

    var userLastName: String? {
        get {
            return self.userDefaults.string(forKey: self.forKey(string: Constants.userLastName))
        }
        set {
            self.userDefaults.set(newValue, forKey: self.forKey(string: Constants.userLastName))
        }
    }

    var userBio: String? {
        get {
            return self.userDefaults.string(forKey: self.forKey(string: Constants.userBio))
        }
        set {
            self.userDefaults.set(newValue, forKey: self.forKey(string: Constants.userBio))
        }
    }

    var userAvatarExist: Bool {
        get {
            guard let bool = self.userDefaults.string(forKey: self.forKey(string: Constants.userAvatarExist))
                else { return false }

            return .boolFromString(bool)
        }
        set {
            self.userDefaults.set(newValue, forKey: self.forKey(string: Constants.userAvatarExist))
        }
    }

    private func forKey(string: String) -> String {
        return "\(Constants.storagePrefix).\(string)"
    }
}

extension Bool {
    static func boolFromString(_ string: String) -> Bool {
        return ["1", "true", "yes"].contains(string.lowercased())
    }
}
