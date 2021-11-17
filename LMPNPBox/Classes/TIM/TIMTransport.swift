//
//  TimTransport.swift
//  LMPNPBox
//
//  Created by Lucas Lin on 2020/2/19.
//  Copyright © 2020 Liam. All rights reserved.
//

import Foundation

/// 腾讯云设置
public struct TIMConfiguration: IMConfigurationProtocol {
    
    let registrationConfig: TIMRegistrationConfiguration
    let loginConfig: TIMLoginConfiguration
    
    public init(
        configuration: TIMRegistrationConfiguration,
        loginConfig: TIMLoginConfiguration
    ) {
        self.registrationConfig = configuration
        self.loginConfig = loginConfig
    }
}

/// 腾讯云App鉴权
public struct TIMRegistrationConfiguration {
    
    let sdkAppId: Int32
    
    public init(sdkAppId: Int32) {
        self.sdkAppId = sdkAppId
    }
}

/// 腾讯云登录
public struct TIMLoginConfiguration {
    let id: String
    let token: String
    
    public init(id: String, token: String) {
        self.id = id
        self.token = token
    }
}

public struct TIMTransport: IMTransportProtocol {
    
    public var configuration: TIMConfiguration
    
    public typealias Configurations = TIMConfiguration
            
    public func getIMPlugPlatform() -> IMPlugPlatform {
        return .tim
    }
    public init(configuration: TIMConfiguration)
    {
        self.configuration = configuration
    }
    
}

