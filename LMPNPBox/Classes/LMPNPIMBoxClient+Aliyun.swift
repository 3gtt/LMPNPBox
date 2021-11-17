//
//  IMPlugBoxClient+AliyunMQTT.swift
//  LMPNPBox
//
//  Created by Liam on 2020/2/26.
//  Copyright © 2020 Liam. All rights reserved.
//

extension LMPNPIMBoxClient {
    
    public func configureImPlatform(transport: AliyunTransport) {
        session = initAliyunSession(transport: transport)
    }
    
    private func initAliyunSession<Transport: IMTransportProtocol>(transport: Transport) -> AliyunImSession? {
        guard let transportOfCast = transport as? AliyunTransport else { return nil }
        let session = AliyunImSession.init(transportOfCast)
        return session
    }
}
