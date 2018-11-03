//
//  main.swift
//  MicroExpress
//
//  Created by Arjun Singh on 03/11/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import Foundation
import NIO

let app = Express()

// Logging
app.use { req, res, next in
    print("\(req.header.method):", req.header.uri)
    next() // continue processing
}

// Request Handling
app.use { _, res, _ in
    res.send("Hello, Schwifty world!")
}

app.listen(1337)
