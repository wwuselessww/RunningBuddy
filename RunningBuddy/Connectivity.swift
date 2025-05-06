////
////  Connectivity.swift
////  RunningBuddy
////
////  Created by Alexander Kozharin on 25.04.25.
////
//
//import Foundation
//import WatchConnectivity
//
//class Connectivity: NSObject, ObservableObject, WCSessionDelegate {
//    @Published var text = ""
//    
//    override init() {
//        super.init()
//        if WCSession.isSupported() {
//            let session = WCSession.default
//            session.delegate = self
//            session.activate()
//        }
//    }
//    #if os(iOS)
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
//        if activationState == .activated {
//            if session.isCompanionAppInstalled {
//                text = "app installed"
//            }
//                
//        }
//    }
//    #else
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
//        if activationState == .activated {
//            text = "app watch installed"
//        }
//    }
//    #endif
//    
//    func send(data: [String : Any]) {
//        let session = WCSession.default
//        if session.isReachable {
//            session.sendMessage(data) { response in
//                self.text = "cool,"
//            }
//        }
//    }
//}
