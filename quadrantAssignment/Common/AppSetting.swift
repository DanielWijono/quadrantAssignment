//
//  AppSetting.swift
//  quadrantAssignment
//
//  Created by Daniel Wijono on 15/04/22.
//

import Foundation

protocol AppSettingProtocol {
    func infoForKey(_ key: String, defaultValue: String) -> String
}

class AppSettingDelegate: AppSettingProtocol {
    func infoForKey(_ key: String, defaultValue: String) -> String {
        let dictionary = Bundle.main.infoDictionary?[AppConstant.config.rawValue] as? NSDictionary
        if let value = (dictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "") {
            return value
        } else {
            return defaultValue
        }
    }
}

class AppSetting {
    static let shared = AppSetting()
    private var delegate: AppSettingProtocol?

    init(appSettingDelegate: AppSettingProtocol = AppSettingDelegate()) {
        delegate = appSettingDelegate
    }

    public func infoForKey(_ key: String, defaultValue: String = "") -> String {
        return delegate?.infoForKey(key, defaultValue: defaultValue) ?? ""
    }
}
