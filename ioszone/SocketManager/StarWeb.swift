
//  SocketIOManager.swift
//  ioszone
//
//  Created by Mayra on 19/02/2019.
//  Copyright © 2019 Mayra. All rights reserved.
//

import Starscream
import Alamofire

class StarWebSocket: NSObject {
    static let sharedInstance = StarWebSocket()
    var mySocket: WebSocket!
    
    /// Stores cert and trust data from certificate
    struct IdentityAndTrust {
        public var identityRef: SecIdentity
        public var trust: SecTrust
        public var certArray: NSArray
    }
    
    /// used by AFManager for SSL requests to the hub
    struct TrustAndIdentityError: LocalizedError {
        let value: String
        var localizedDescription: String {
            return value
        }
    }
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        do {
            if let certificatePath = Bundle.main.url(forResource: "onlyclient", withExtension: "p12") {
                let trust = try createTrust(certificatePath: certificatePath)
                
                // retrieve identity cert from cert array
                let identityCertificate = trust.certArray.object(at: 0) as! SecCertificate
                
                let client = SSLClientCertificate(identity: trust.identityRef, identityCertificate: identityCertificate)
                
                let strUrl: String = "ws://zonetactsbackend-pre-env-1.eu-west-1.elasticbeanstalk.com:8082" // "ws://echo.websocket.org/" //
                
                mySocket = WebSocket(url: URL(string: strUrl)!, protocols: [])
                mySocket.sslClientCertificate = client
                mySocket.enabledSSLCipherSuites = [TLS_RSA_WITH_AES_256_GCM_SHA384]
                mySocket.disableSSLCertValidation = true
                mySocket.delegate = self
                
                mySocket.onConnect = {
                    print("websocket is connected")
                }
                
                mySocket.connect()
            }
        } catch {
            print(error)
        }
    }
    
    func closeConnection() {
        mySocket.disconnect()
    }
    
    /// Create trust by passing in cert data to the extractTrustAndIdentity func
    ///
    /// - Returns: Identity and trust struct which contains necessary info for handling https challenges
    private func createTrust(certificatePath: URL) throws -> IdentityAndTrust {
        do {
            let certificateData = try Data(contentsOf: certificatePath)
            switch try extractTrustAndIdentity(certData: certificateData, certPassword: "password") {
            case .success(let identity):
                return identity
            case .failure(let error):
                throw error
            }
        } catch {
            throw error
        }
    }
    
    /// Extracts cert trust information from certificate
    ///
    /// - Parameters:
    ///   - certData: data of certificate
    ///   - certPassword: certificate password
    /// - Returns: Identity and trust struct which contains necessary info for handling https challenges
    private func extractTrustAndIdentity(certData: Data, certPassword: String) throws -> Alamofire.Result<IdentityAndTrust> {
        var identityAndTrust: IdentityAndTrust
        var securityError = errSecSuccess
        var items: CFArray?
        let certOptions = [kSecImportExportPassphrase as String: certPassword]
        // import certificate to read its entries
        securityError = SecPKCS12Import(certData as CFData, certOptions as CFDictionary, &items)
        
        if securityError == errSecSuccess {
            let certItems: CFArray = items!
            let certItemsArray: Array = certItems as Array
            let dict: AnyObject? = certItemsArray.first
            if let certEntry = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer: AnyObject? = certEntry["identity"]
                let secIdentityRef: SecIdentity = identityPointer! as! SecIdentity
                // grab the trust
                let trustPointer: AnyObject? = certEntry["trust"]
                let trustRef: SecTrust = trustPointer as! SecTrust
                // grab the certificate chain
                var certRef: SecCertificate?
                SecIdentityCopyCertificate(secIdentityRef, &certRef)
                let certArray = NSMutableArray()
                certArray.add(certRef!)
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef, trust: trustRef, certArray: certArray)
                return Result.success(identityAndTrust)
            } else {
                return .failure(TrustAndIdentityError(value: "Identity and trust failure"))
            }
        } else {
            return .failure(TrustAndIdentityError(value: "Identity and trust failure"))
        }
    }
}

extension StarWebSocket: WebSocketDelegate {
    func websocketDidReceiveMessage(socket ws: WebSocketClient, text: String) {
        print(text)
    }
    
    func websocketDidDisconnect(socket ws: WebSocketClient, error: Error?) {
        if let e = error {
            print("live socket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidConnect(socket ws: WebSocketClient) {
        print("connected!")
        //ws.write(string: "SocketConstants.socketSecretKey")
    }
    
    func websocketDidReceiveData(socket ws: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
}
