//
//  WatchReceive.swift
//  shops24 Watch App
//
//  Created by Diederick de Buck on 26/03/2023.
//


import UIKit
import WatchConnectivity
import P42_extensions


class WatchReceive: NSObject, WCSessionDelegate {
    
    var portfolio = PortfolioModel.instance
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print(message)
        let shop = message[Shops42TKN.shop.rawValue] as! String
        let accessToken = message[Shops42TKN.access_token.rawValue] as! String
        let views = message[Shops42TKN.views.rawValue] as! [String : Bool]

        
        DispatchQueue.main.async {
            self.portfolio.destroy()
            self.portfolio.addShop(
                shop,
                accessToken: accessToken,
                views: views
            )
            replyHandler([Shops42TKN.status.rawValue: "OK"])
        }
    }
}
