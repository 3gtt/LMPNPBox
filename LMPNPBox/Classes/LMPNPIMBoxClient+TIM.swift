//
//  IMPlugBoxClient+TIM.swift
//  LMPNPBox
//
//  Created by Liam on 2020/2/26.
//  Copyright © 2020 Liam. All rights reserved.
//

extension LMPNPIMBoxClient {
    
    public func configureImPlatform(transport: TIMTransport) {
        session = initTIMSession(transport: transport)
    }
    
    private func initTIMSession<Transport: IMTransportProtocol>(transport: Transport) -> TIMSession? {
        guard let transportOfCast = transport as? TIMTransport else { return nil }
        let session = TIMSession(transportOfCast)
        return session
    }
}
