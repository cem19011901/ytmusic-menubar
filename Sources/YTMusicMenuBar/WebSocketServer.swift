import Foundation
import Network
final class WebSocketServer {
    var onSongUpdate: ((SongInfo) -> Void)?
    private(set) var isRunning = false
    private var listener:    NWListener?
    private var connections: [ObjectIdentifier: NWConnection] = [:]
    private let port:        NWEndpoint.Port
    private let queue =      DispatchQueue(label: "com.ytmenubar.ws", qos: .userInitiated)
    init(port: UInt16 = 9999) {
        self.port = NWEndpoint.Port(rawValue: port)!
    }
    func start() {
        let params = NWParameters.tcp
        params.allowLocalEndpointReuse = true
        let wsOpts = NWProtocolWebSocket.Options()
        wsOpts.autoReplyPing = true
        params.defaultProtocolStack.applicationProtocols.insert(wsOpts, at: 0)
        do { listener = try NWListener(using: params, on: port) }
        catch { print("[WS] Listener hatası: \(error)"); return }
        listener?.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:   self?.isRunning = true;  print("[WS] Dinleniyor :9999")
            case .failed:  self?.isRunning = false
            default: break
            }
        }
        listener?.newConnectionHandler = { [weak self] conn in self?.accept(conn) }
        listener?.start(queue: queue)
    }
    func stop() {
        listener?.cancel()
        connections.values.forEach { $0.cancel() }
        connections.removeAll()
        isRunning = false
    }
    func sendCommand(_ command: String, extras: [String: Any] = [:]) {
        var payload: [String: Any] = ["type": "COMMAND", "command": command]
        extras.forEach { payload[$0] = $1 }
        guard let data = try? JSONSerialization.data(withJSONObject: payload) else { return }
        broadcast(data: data)
    }
    private func accept(_ connection: NWConnection) {
        let id = ObjectIdentifier(connection)
        connections[id] = connection
        connection.stateUpdateHandler = { [weak self] state in
            if case .failed    = state { self?.connections.removeValue(forKey: id) }
            if case .cancelled = state { self?.connections.removeValue(forKey: id) }
        }
        connection.start(queue: queue)
        receive(from: connection, id: id)
    }
    private func receive(from connection: NWConnection, id: ObjectIdentifier) {
        connection.receiveMessage { [weak self] data, _, _, error in
            guard let self else { return }
            if error != nil { self.connections.removeValue(forKey: id); return }
            if let data, !data.isEmpty { self.handle(data: data) }
            self.receive(from: connection, id: id)
        }
    }
    private func handle(data: Data) {
        guard
            let json     = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let msgType  = json["type"] as? String, msgType == "SONG_UPDATE",
            let songData = json["data"] as? [String: Any]
        else { return }
        var playlists: [PlaylistInfo] = []
        if let rawList = songData["playlists"] as? [[String: Any]] {
            playlists = rawList.compactMap { item in
                guard let id    = item["id"]    as? String,
                      let title = item["title"] as? String else { return nil }
                return PlaylistInfo(id: id, title: title)
            }
        }
        let info = SongInfo(
            title:      songData["title"]      as? String ?? "",
            artist:     songData["artist"]     as? String ?? "",
            isPlaying:  songData["isPlaying"]  as? Bool   ?? false,
            isLiked:    songData["isLiked"]    as? Bool   ?? false,
            isDisliked: songData["isDisliked"] as? Bool   ?? false,
            timeInfo:   songData["timeInfo"]   as? String ?? "",
            volume:     songData["volume"]     as? Int    ?? 100,
            playlists:  playlists
        )
        DispatchQueue.main.async { [weak self] in self?.onSongUpdate?(info) }
    }
    private func broadcast(data: Data) {
        let metadata = NWProtocolWebSocket.Metadata(opcode: .text)
        let context  = NWConnection.ContentContext(identifier: "cmd", metadata: [metadata])
        connections.values.forEach { conn in
            conn.send(content: data, contentContext: context, isComplete: true, completion: .idempotent)
        }
    }
}
