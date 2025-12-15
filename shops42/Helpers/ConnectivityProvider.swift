//
//  ConnectivityProvider.swift
//  shops42
//
//  Created by Diederick de Buck on 05/08/2024.
//

import WatchConnectivity


@Observable class ConnectivityProvider: NSObject, WCSessionDelegate {
    
    var isSyncing: Bool
    var semaphore: DispatchSemaphore
    var watchIsReady: Bool

    override init() {
        self.semaphore = DispatchSemaphore(value: 1)
        self.isSyncing = false
        self.watchIsReady = false
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        
    }
    
    func session(
        _ session: WCSession,
        activationDidCompleteWith activationState: WCSessionActivationState,
        error: Error?) {
    }
    
    @MainActor
    func send(message: [String : Any]) {
        let session = WCSession.default
        self.watchIsReady = session.isReachable
        if self.watchIsReady {
            self.isSyncing = true
            session.sendMessage(
                message,
                replyHandler: { _ in
                    self.isSyncing = false
                },
                errorHandler: { _ in
                    self.isSyncing = false
                }
            )
        }
    }    
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        session.activate()
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
}
