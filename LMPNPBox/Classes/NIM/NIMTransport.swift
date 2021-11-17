//
//  NIMTransport.swift
//  LMPNPBox
//
//  Created by Lucas Lin on 2020/2/14.
//  Copyright © 2020 Liam. All rights reserved.
//

import Foundation

/// 云信设置
public struct NIMConfiguration: IMConfigurationProtocol {
    
    let registrationConfig: NIMRegistrationConfiguration
    let loginConfig: NIMLoginConfiguration
    
    public init(
        registrationConfig: NIMRegistrationConfiguration,
        loginConfig: NIMLoginConfiguration
    ) {
        self.registrationConfig = registrationConfig
        self.loginConfig = loginConfig
    }

}

/// 云信App鉴权
public struct NIMRegistrationConfiguration {
    
    let appID: String
    let cerName: String
    
    public init(
        appID: String,
        cerName: String
    ) {
        self.appID = appID
        self.cerName = cerName
    }
    
}

/// 云信登录
public struct NIMLoginConfiguration {
    
    let id: String
    let token: String
    
    public init(
        id: String,
        token: String
    ) {
        self.id = id
        self.token = token
    }
    
}

public struct NIMTransport: IMTransportProtocol {
    
    public var configuration: NIMConfiguration
    
    public typealias Configurations = NIMConfiguration
            
    public func getIMPlugPlatform() -> IMPlugPlatform {
        return .nim
    }
    
    public init(configuration: NIMConfiguration) {
        self.configuration = configuration
    }
}
