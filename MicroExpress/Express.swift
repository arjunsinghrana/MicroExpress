//
//  Express.swift
//  MicroExpress
//
//  Created by Arjun Singh on 03/11/18.
//  Copyright © 2018 Arjun Singh. All rights reserved.
//

import Foundation
import NIO
import NIOHTTP1

open class Express : Router {
    
    let loopGroup =
        MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    
    open func listen(_ port: Int) {
        let reuseAddrOpt = ChannelOptions.socket(
            SocketOptionLevel(SOL_SOCKET),
            SO_REUSEADDR)
        let bootstrap = ServerBootstrap(group: loopGroup)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(reuseAddrOpt, value: 1)
            
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline().then {
                    channel.pipeline.add(handler: HTTPHandler(router: self))
                }
                // this is where the action is going to be!
            }
            
            .childChannelOption(ChannelOptions.socket(
                IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(reuseAddrOpt, value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead,
                                value: 1)
        
        do {
            let serverChannel =
                try bootstrap.bind(host: "localhost", port: port)
                    .wait()
            print("Server running on:", serverChannel.localAddress!)
            
            try serverChannel.closeFuture.wait() // runs forever
        }
        catch {
            fatalError("failed to start server: \(error)")
        }
    }
    
    final class HTTPHandler : ChannelInboundHandler {
        typealias InboundIn = HTTPServerRequestPart
        
        let router : Router
        
        init(router: Router) {
            self.router = router
        }
        
        func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
            let reqPart = unwrapInboundIn(data)
            
            switch reqPart {
            case .head(let header):
                let request  = IncomingMessage(header: header)
                let response = ServerResponse(channel: ctx.channel)
                
                // trigger Router
                router.handle(request: request, response: response) {
                    (items : Any...) in // the final handler
                    response.status = .notFound
                    response.send("No middleware handled the request!")
                }
                
            // ignore incoming content to keep it micro :-)
            case .body, .end: break
            }
        }
    }
}
