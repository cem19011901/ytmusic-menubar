import Foundation
enum Lang: String, CaseIterable {
    case tr, en, ru
    var displayName: String {
        switch self {
        case .tr: return "🇹🇷 Türkçe"
        case .en: return "🇬🇧 English"
        case .ru: return "🇷🇺 Русский"
        }
    }
    static var current: Lang {
        get {
            let raw = UserDefaults.standard.string(forKey: "appLang") ?? "tr"
            return Lang(rawValue: raw) ?? .tr
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "appLang")
        }
    }
}
typealias L = Strings
struct Strings {
    static var lang: Lang { Lang.current }
    static var play:          String { pick("▶  Oynat",       "▶  Play",       "▶  Играть") }
    static var pause:         String { pick("⏸  Durdur",      "⏸  Pause",      "⏸  Пауза") }
    static var next:          String { pick("⏭  Sonraki",     "⏭  Next",       "⏭  Далее") }
    static var prev:          String { pick("⏮  Önceki",      "⏮  Previous",   "⏮  Назад") }
    static var like:          String { pick("♡  Beğen",       "♡  Like",       "♡  Нравится") }
    static var liked:         String { pick("♥  Beğenildi",   "♥  Liked",      "♥  Понравилось") }
    static var dislike:       String { pick("♡̸  Beğenme",     "♡̸  Dislike",    "♡̸  Не нравится") }
    static var disliked:      String { pick("♡̸  Beğenilmedi", "♡̸  Disliked",   "♡̸  Не понравилось") }
    static var volume:        String { pick("Ses",            "Volume",        "Громкость") }
    static var myPlaylists:   String { pick("Playlist",       "Playlist",      "Плейлисты") }
    static var language:      String { pick("◎ Dil",          "◎ Language",    "◎ Язык") }
    static var connActive:    String { pick("🟢 Bağlantı aktif",  "🟢 Connected",      "🟢 Подключено") }
    static var connWaiting:   String { pick("🔴 Bağlantı bekleniyor…", "🔴 Waiting for connection…", "🔴 Ожидание подключения…") }
    static var notConnected:  String { pick("YouTube Music bağlı değil", "YouTube Music not connected", "YouTube Music не подключён") }
    static var quit:          String { pick("Çıkış", "Quit", "Выход") }
    static var noPlaylists:   String { pick("Playlist bulunamadı", "No playlists found", "Плейлисты не найдены") }
    static var port:          String { "(port 9999)" }
    private static func pick(_ tr: String, _ en: String, _ ru: String) -> String {
        switch lang {
        case .tr: return tr
        case .en: return en
        case .ru: return ru
        }
    }
}
