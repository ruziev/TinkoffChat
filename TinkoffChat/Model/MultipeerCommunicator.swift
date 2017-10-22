//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by Jamshid Ruziev on 21/10/2017.
//  Copyright © 2017 Jamshid Ruziev. All rights reserved.
//

import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    private let myPeerID: MCPeerID
    weak var delegate: CommunicatorDelegate?
    var online: Bool = false {
        didSet {
            if online {
                browser.startBrowsingForPeers()
                advertiser.startAdvertisingPeer()
            } else {
                browser.startBrowsingForPeers()
                advertiser.stopAdvertisingPeer()
            }
        }
    }
    private let browser: MCNearbyServiceBrowser
    private let advertiser: MCNearbyServiceAdvertiser
    private var sessions: [MCPeerID: MCSession] = [:]
    private var usernames: [MCPeerID: String] = [:]
    
    func sendMessage(string: String, to userID: String, completionHandler: ((Bool, Error?) -> ())?) {
        var peerID: MCPeerID?
        for peer in sessions.keys {
            if peer.displayName == userID {
                peerID = peer
                break
            }
        }
        if let peerID = peerID {
            let message = Message(text: string, type: .outgoing)
            do {
                try sessions[peerID]!.send(JSONEncoder().encode(message), toPeers: [peerID], with: .reliable)
                completionHandler?(true, nil)
            } catch {
                completionHandler?(false, error)
            }
        } else {
            completionHandler?(false, NSError(domain: "no such active user", code: 228, userInfo: nil))
        }
    }
    
    override init() {
        guard let idForVendor = UIDevice.current.identifierForVendor else {
            fatalError("Current device has no identifierForVendor")
        }
        let username = ProfileManager.shared.name
        let serviceType = "tinkoff-chat"
        
        myPeerID = MCPeerID(displayName: idForVendor.description)
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["userName": username ?? "Unknown"], serviceType: serviceType)
        
        super.init()
        browser.delegate = self
        advertiser.delegate = self
    }
    
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // not implemented
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // not implemented
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // not implemented
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            delegate?.didFoundUser(userID: peerID.displayName, userName: usernames[peerID])
        case .notConnected:
            delegate?.didLostUser(userID: peerID.displayName)
        default:
            break
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            var message = try JSONDecoder().decode(Message.self, from: data)
            message.type = .incoming
            delegate?.didReceiveMessage(text: message.text, fromUser: peerID.displayName, toUser: myPeerID.displayName)
        } catch {
            return
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        delegate?.failedToStartBrowsingForUsers(error: error)
        online = false
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if let username = info?["userName"] {
            usernames[peerID] = username
        }
        // creating session
        let session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessions[peerID] = session
        // inviting peer to session
        browser.invitePeer(peerID, to: session, withContext: encodedInvitationContext, timeout: 0)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.didLostUser(userID: peerID.displayName)
        sessions.removeValue(forKey: peerID)
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        delegate?.failedToStartAdvertising(error: error)
        online = false
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // create session
        let session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)
        session.delegate = self
        sessions[peerID] = session
        // accept invitation
        invitationHandler(true, session)
        // save username for this peer
        if let username = decodeUsernameFromInvitationContext(from: context) {
            usernames[peerID] = username
        }
    }
    
    private var encodedInvitationContext: Data {
        // JSON encoded discoveryInfo to send while inviting to session
        let username = ProfileManager.shared.name
        let discoveryInfo = ["userName": username ?? "Unknown"]
        let data: Data
        do {
            data = try JSONEncoder().encode(discoveryInfo)
        } catch {
            fatalError("Could not JSON encode Discovery Info")
        }
        return data
    }
    
    func decodeUsernameFromInvitationContext(from data: Data?) -> String? {
        // get username or nil from invitationContext when someone invites to session
        guard let fromData = data else { return nil }
        do {
            let username = try JSONDecoder().decode([String:String].self, from: fromData)["userName"]
            if username != nil {
                return username
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
}
