//
//  IncomingMessage.swift
//  MicroExpress
//
//  Created by Arjun Singh on 03/11/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import NIOHTTP1

open class IncomingMessage {
    
    public let header : HTTPRequestHead
    public var userInfo = [String : Any] ()
    
    init(header: HTTPRequestHead) {
        self.header = header
    }
}
