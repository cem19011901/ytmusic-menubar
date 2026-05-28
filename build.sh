#!/usr/bin/env bash
set -euo pipefail

APP_NAME="YTMusicMenuBar"
BUILD_DIR=".build/release"
APP_BUNDLE="${APP_NAME}.app"
CONTENTS="${APP_BUNDLE}/Contents"

# ── Ön Kontroller ─────────────────────────────────────────────────────────
if ! command -v swift &>/dev/null; then
    echo "❌ Swift bulunamadı. Çalıştır: xcode-select --install"
    exit 1
fi

SWIFT_VERSION=$(swift --version 2>&1 | head -1)
echo "🐦 $SWIFT_VERSION"

if lsof -i :9999 &>/dev/null; then
    echo "⚠️  Port 9999 kullanımda:"
    lsof -i :9999 | awk 'NR>1 {print "   PID " $2 " — " $1}'
    echo "   Devam etmek istiyor musun? (e/h)"
    read -r answer
    [[ "$answer" =~ ^[Ee]$ ]] || exit 0
fi

# ── Derleme ───────────────────────────────────────────────────────────────
echo ""
echo "🔨 Derleniyor (release mod)…"
swift build -c release

# ── .app Bundle ───────────────────────────────────────────────────────────
echo "📦 .app bundle oluşturuluyor…"
rm -rf "${APP_BUNDLE}"
mkdir -p "${CONTENTS}/MacOS"
mkdir -p "${CONTENTS}/Resources"

cp "${BUILD_DIR}/${APP_NAME}"              "${CONTENTS}/MacOS/${APP_NAME}"
cp "Info.plist"    "${CONTENTS}/Info.plist"

/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -f "${APP_BUNDLE}" 2>/dev/null || true

echo ""
echo "✅ Derleme tamamlandı!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Çalıştır : open ${APP_BUNDLE}"
echo "  Durdur   : pkill ${APP_NAME}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Uygulamayı şimdi başlatayım mı? (e/h)"
read -r launch
if [[ "$launch" =~ ^[Ee]$ ]]; then
    pkill "${APP_NAME}" 2>/dev/null || true
    sleep 0.3
    open "${APP_BUNDLE}"
    echo "🚀 Başlatıldı! Menu bar'ı kontrol et."
fi
