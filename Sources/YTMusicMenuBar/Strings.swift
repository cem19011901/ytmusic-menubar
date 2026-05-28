import Foundation

enum Lang: String, CaseIterable {
    case en, tr, ru, zh, hi, es, ar, fr, bn, pt, id, ur
    
    var displayName: String {
        switch self {
        case .en: return "🇬🇧 English"
        case .tr: return "🇹🇷 Türkçe"
        case .ru: return "🇷🇺 Русский"
        case .zh: return "🇨🇳 中文"
        case .hi: return "🇮🇳 हिन्दी"
        case .es: return "🇪🇸 Español"
        case .ar: return "🇸🇦 العربية"
        case .fr: return "🇫🇷 Français"
        case .bn: return "🇧🇩 বাংলা"
        case .pt: return "🇵🇹 Português"
        case .id: return "🇮🇩 Bahasa Indonesia"
        case .ur: return "🇵🇰 اردو"
        }
    }
    
    static var current: Lang {
        get {
            let raw = UserDefaults.standard.string(forKey: "appLang") ?? "en"
            return Lang(rawValue: raw) ?? .en
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "appLang")
        }
    }
}

typealias L = Strings

struct Strings {
    static var lang: Lang { Lang.current }
    
    static var play: String {
        switch lang {
        case .tr: return "▶  Oynat"
        case .en: return "▶  Play"
        case .ru: return "▶  Играть"
        case .zh: return "▶  播放"
        case .hi: return "▶  चलाएं"
        case .es: return "▶  Reproducir"
        case .ar: return "▶  تشغيل"
        case .fr: return "▶  Lecture"
        case .bn: return "▶  চালান"
        case .pt: return "▶  Reproduzir"
        case .id: return "▶  Putar"
        case .ur: return "▶  چلائیں"
        }
    }
    
    static var pause: String {
        switch lang {
        case .tr: return "⏸  Durdur"
        case .en: return "⏸  Pause"
        case .ru: return "⏸  Пауза"
        case .zh: return "⏸  暂停"
        case .hi: return "⏸  रोकें"
        case .es: return "⏸  Pausar"
        case .ar: return "⏸  إيقاف مؤقت"
        case .fr: return "⏸  Pause"
        case .bn: return "⏸  থামান"
        case .pt: return "⏸  Pausar"
        case .id: return "⏸  Jeda"
        case .ur: return "⏸  روکیں"
        }
    }
    
    static var next: String {
        switch lang {
        case .tr: return "⏭  Sonraki"
        case .en: return "⏭  Next"
        case .ru: return "⏭  Далее"
        case .zh: return "⏭  下一首"
        case .hi: return "⏭  अगला"
        case .es: return "⏭  Siguiente"
        case .ar: return "⏭  التالي"
        case .fr: return "⏭  Suivant"
        case .bn: return "⏭  পরবর্তী"
        case .pt: return "⏭  Próxima"
        case .id: return "⏭  Berikutnya"
        case .ur: return "⏭  اگلا"
        }
    }
    
    static var prev: String {
        switch lang {
        case .tr: return "⏮  Önceki"
        case .en: return "⏮  Previous"
        case .ru: return "⏮  Назад"
        case .zh: return "⏮  上一首"
        case .hi: return "⏮  पिछला"
        case .es: return "⏮  Anterior"
        case .ar: return "⏮  السابق"
        case .fr: return "⏮  Précédent"
        case .bn: return "⏮  পূর্ববর্তী"
        case .pt: return "⏮  Anterior"
        case .id: return "⏮  Sebelumnya"
        case .ur: return "⏮  پچھلا"
        }
    }
    
    static var like: String {
        switch lang {
        case .tr: return "♡  Beğen"
        case .en: return "♡  Like"
        case .ru: return "♡  Нравится"
        case .zh: return "♡  喜欢"
        case .hi: return "♡  पसंद करें"
        case .es: return "♡  Me gusta"
        case .ar: return "♡  إعجاب"
        case .fr: return "♡  J'aime"
        case .bn: return "♡  পছন্দ"
        case .pt: return "♡  Gostei"
        case .id: return "♡  Suka"
        case .ur: return "♡  پسند"
        }
    }
    
    static var liked: String {
        switch lang {
        case .tr: return "♥  Beğenildi"
        case .en: return "♥  Liked"
        case .ru: return "♥  Понравилось"
        case .zh: return "♥  已喜欢"
        case .hi: return "♥  पसंद किया"
        case .es: return "♥  Te gusta"
        case .ar: return "♥  أعجبني"
        case .fr: return "♥  Aimé"
        case .bn: return "♥  পছন্দ হয়েছে"
        case .pt: return "♥  Marcado como gostei"
        case .id: return "♥  Disukai"
        case .ur: return "♥  پسند کیا"
        }
    }
    
    static var dislike: String {
        switch lang {
        case .tr: return "♡̸  Beğenme"
        case .en: return "♡̸  Dislike"
        case .ru: return "♡̸  Не нравится"
        case .zh: return "♡̸  不喜欢"
        case .hi: return "♡̸  नापसंद करें"
        case .es: return "♡̸  No me gusta"
        case .ar: return "♡̸  عدم إعجاب"
        case .fr: return "♡̸  Je n'aime pas"
        case .bn: return "♡̸  অপছন্দ"
        case .pt: return "♡̸  Não gostei"
        case .id: return "♡̸  Tidak suka"
        case .ur: return "♡̸  ناپسند"
        }
    }
    
    static var disliked: String {
        switch lang {
        case .tr: return "♡̸  Beğenilmedi"
        case .en: return "♡̸  Disliked"
        case .ru: return "♡̸  Не понравилось"
        case .zh: return "♡̸  已不喜欢"
        case .hi: return "♡̸  नापसंद किया"
        case .es: return "♡̸  No te gusta"
        case .ar: return "♡̸  لم يعجبني"
        case .fr: return "♡̸  Pas aimé"
        case .bn: return "♡̸  অপছন্দ হয়েছে"
        case .pt: return "♡̸  Marcado como não gostei"
        case .id: return "♡̸  Tidak disukai"
        case .ur: return "♡̸  ناپسند کیا"
        }
    }
    
    static var volume: String {
        switch lang {
        case .tr: return "Ses"
        case .en: return "Volume"
        case .ru: return "Громкость"
        case .zh: return "音量"
        case .hi: return "आवाज़"
        case .es: return "Volumen"
        case .ar: return "مستوى الصوت"
        case .fr: return "Volume"
        case .bn: return "ভলিউম"
        case .pt: return "Volume"
        case .id: return "Volume"
        case .ur: return "آواز"
        }
    }
    
    static var myPlaylists: String {
        switch lang {
        case .tr: return "Playlist"
        case .en: return "Playlist"
        case .ru: return "Плейлисты"
        case .zh: return "播放列表"
        case .hi: return "प्लेलिस्ट"
        case .es: return "Listas"
        case .ar: return "قوائم التشغيل"
        case .fr: return "Playlists"
        case .bn: return "প্লেলিস্ট"
        case .pt: return "Playlists"
        case .id: return "Daftar Putar"
        case .ur: return "پلے لسٹس"
        }
    }
    
    static var language: String {
        switch lang {
        case .tr: return "◎ Dil"
        case .en: return "◎ Language"
        case .ru: return "◎ Язык"
        case .zh: return "◎ 语言"
        case .hi: return "◎ भाषा"
        case .es: return "◎ Idioma"
        case .ar: return "◎ اللغة"
        case .fr: return "◎ Langue"
        case .bn: return "◎ ভাষা"
        case .pt: return "◎ Idioma"
        case .id: return "◎ Bahasa"
        case .ur: return "◎ زبان"
        }
    }
    
    static var connActive: String {
        switch lang {
        case .tr: return "🟢 Bağlantı aktif"
        case .en: return "🟢 Connected"
        case .ru: return "🟢 Подключено"
        case .zh: return "🟢 已连接"
        case .hi: return "🟢 जुड़ा हुआ"
        case .es: return "🟢 Conectado"
        case .ar: return "🟢 متصل"
        case .fr: return "🟢 Connecté"
        case .bn: return "🟢 সংযুক্ত"
        case .pt: return "🟢 Conectado"
        case .id: return "🟢 Terhubung"
        case .ur: return "🟢 منسلک"
        }
    }
    
    static var connWaiting: String {
        switch lang {
        case .tr: return "🔴 Bağlantı bekleniyor…"
        case .en: return "🔴 Waiting for connection…"
        case .ru: return "🔴 Ожидание подключения…"
        case .zh: return "🔴 等待连接…"
        case .hi: return "🔴 कनेक्शन की प्रतीक्षा है…"
        case .es: return "🔴 Esperando conexión…"
        case .ar: return "🔴 جاري انتظار الاتصال…"
        case .fr: return "🔴 En attente de connexion…"
        case .bn: return "🔴 সংযোগের জন্য অপেক্ষা করা হচ্ছে…"
        case .pt: return "🔴 Aguardando conexão…"
        case .id: return "🔴 Menunggu koneksi…"
        case .ur: return "🔴 کنکشن کا انتظار ہے…"
        }
    }
    
    static var notConnected: String {
        switch lang {
        case .tr: return "YouTube Music bağlı değil"
        case .en: return "YouTube Music not connected"
        case .ru: return "YouTube Music не подключён"
        case .zh: return "YouTube Music 未连接"
        case .hi: return "YouTube Music कनेक्ट नहीं है"
        case .es: return "YouTube Music no conectado"
        case .ar: return "YouTube Music غير متصل"
        case .fr: return "YouTube Music non connecté"
        case .bn: return "YouTube Music সংযুক্ত নয়"
        case .pt: return "YouTube Music não conectado"
        case .id: return "YouTube Music tidak terhubung"
        case .ur: return "YouTube Music منسلک نہیں ہے"
        }
    }
    
    static var quit: String {
        switch lang {
        case .tr: return "Çıkış"
        case .en: return "Quit"
        case .ru: return "Выход"
        case .zh: return "退出"
        case .hi: return "बाहर निकलें"
        case .es: return "Salir"
        case .ar: return "إنهاء"
        case .fr: return "Quitter"
        case .bn: return "প্রস্থান"
        case .pt: return "Sair"
        case .id: return "Keluar"
        case .ur: return "باہر نکلیں"
        }
    }
    
    static var noPlaylists: String {
        switch lang {
        case .tr: return "Playlist bulunamadı"
        case .en: return "No playlists found"
        case .ru: return "Плейлисты не найдены"
        case .zh: return "未找到播放列表"
        case .hi: return "कोई प्लेलिस्ट नहीं मिली"
        case .es: return "No hay listas"
        case .ar: return "لا توجد قوائم تشغيل"
        case .fr: return "Aucune playlist trouvée"
        case .bn: return "কোন প্লেলিস্ট পাওয়া যায়নি"
        case .pt: return "Nenhuma playlist encontrada"
        case .id: return "Tidak ada daftar putar"
        case .ur: return "کوئی پلے لسٹ نہیں ملی"
        }
    }
    
    static var port: String { "(port 9999)" }
}
