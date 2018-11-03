//
//  Middleware.swift
//  MicroExpress
//
//  Created by Arjun Singh on 03/11/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import Foundation

public typealias Next = ( Any... ) -> Void

public typealias Middleware =
                    ( IncomingMessage,
                    ServerResponse,
                    @escaping Next ) -> Void
