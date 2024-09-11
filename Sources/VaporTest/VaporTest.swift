// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Vapor
import NIOSSL

// configures your application
public func configure(_ app: Application, port: Int, withTSL tlsInfo: PEMFile?) async throws {

    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .custom("https://127.0.0.1:\(port)"),
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH], // 허용할 HTTP 메소드
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith]
    )
    
    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.middleware.use(cors)
    app.http.server.configuration.port = port

    if let tlsInfo = tlsInfo {
        do {
            let certificateChain: [NIOSSLCertificate] = try NIOSSLCertificate.fromPEMFile(tlsInfo.certPath)
            let privateKey = NIOSSLPrivateKeySource.privateKey(try .init(file: tlsInfo.keyPath, format: .pem))
            
            let tlsConfig = TLSConfiguration.makeServerConfiguration(certificateChain: certificateChain.map { .certificate($0) }, privateKey: privateKey)

            app.http.server.configuration.tlsConfiguration = tlsConfig
        }
        catch let error  {
            app.logger.report(error: error)
            throw ServerConfigurationError.failedToLoadCertificate
        }
    }
}

public func routes(_ app: Application, method: HTTPMethod, path: String, parameter: String) throws {
    
    app.on(method, "\(path)", ":\(parameter)") { req in
        print(req.body)
        //        "It works!"
        return ""
    }
}

public func run(_ app: Application) async throws {
    try await app.execute()
    try await app.asyncShutdown()
}
    
//
//    app.get { req async in
//        "It works!"
//    }
//
//    app.get("hello") { req async -> String in
//        "Hello, world!"
//    }
//    
//    app.post("WebPrintSDK",":\(parameter)") { req async -> String in
//        return "d"
//    }
