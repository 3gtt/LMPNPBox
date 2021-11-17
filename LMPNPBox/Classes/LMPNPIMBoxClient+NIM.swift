//
//  IMPlugBoxClient+NIM.swift
//  LMPNPBox
//
//  Created by Liam on 2020/2/26.
//  Copyright © 2020 Liam. All rights reserved.
//

import UIKit

extension LMPNPIMBoxClient {
    
    public func configureImPlatform(transport: NIMTransport) {
        session = initNIMSession(transport: transport)
    }
    
    private func initNIMSession<Transport: IMTransportProtocol>(transport: Transport) -> NIMLiteSession? {
        guard let transportOfCast = transport as? NIMTransport else { return nil }
        let session = NIMLiteSession(transportOfCast)
        return session
    }
    
}
