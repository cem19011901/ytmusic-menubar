import Foundation
struct PlaylistInfo: Codable {
    var id:    String
    var title: String
}
struct SongInfo {
    var title:      String         = ""
    var artist:     String         = ""
    var isPlaying:  Bool           = false
    var isLiked:    Bool           = false
    var isDisliked: Bool           = false
    var timeInfo:   String         = ""
    var volume:     Int            = 100
    var playlists:  [PlaylistInfo] = []
    var isEmpty: Bool { title.isEmpty }
    var marqueeText: String { title }
}
