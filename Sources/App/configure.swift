import Vapor
import NIOSSL

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    // register routes
    
    let corsConfiguration = CORSMiddleware.Configuration(
           allowedOrigin: .custom("https://127.0.0.1:18080"), // 허용할 도메인 (필요에 따라 조정)
           allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH], // 허용할 HTTP 메소드
           allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith]
       )
    let cors = CORSMiddleware(configuration: corsConfiguration)
    app.middleware.use(cors)
    app.http.server.configuration.port = 18080
    // Enable TLS.
    app.http.server.configuration.tlsConfiguration = .makeServerConfiguration(
        certificateChain: try NIOSSLCertificate.fromPEMFile("/Library/WebPrintSDK/Certificate/Bixolon Self Signed.crt").map { .certificate($0) },
        privateKey: .file("/Library/WebPrintSDK/Certificate/Bixolon Self Signed.pem")
    )

    try routes(app)
}
