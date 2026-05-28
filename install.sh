#!/usr/bin/env bash
# install.sh — Sıfırdan kurulum scripti
# Tek komutla her şeyi hazırlar.
set -euo pipefail

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🎵 YTMusic MenuBar — Kurulum"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── 1. Command Line Tools ──────────────────────────────────────────────────
if ! command -v swift &>/dev/null; then
    echo "📥 Xcode Command Line Tools kuruluyor…"
    echo "   (Açılan pencerede 'Install' butonuna tık)"
    xcode-select --install
    echo ""
    echo "⏳ Kurulum bitince bu scripti tekrar çalıştır:"
    echo "   ./install.sh"
    exit 0
else
    echo "✅ Swift mevcut: $(swift --version 2>&1 | head -1)"
fi

echo ""

# ── 2. Swift uygulamasını derle ────────────────────────────────────────────
echo "🔨 Uygulama derleniyor…"
bash build.sh

echo ""

# ── 3. Chrome Extension kurulum rehberi ────────────────────────────────────
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  🧩 Chrome Extension Kurulumu"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
EXTENSION_PATH="$(pwd)/extension"
echo "  1. Chrome'da şu adresi aç:"
echo "     chrome://extensions/"
echo ""
echo "  2. Sağ üstte 'Developer mode' anahtarını AÇ"
echo ""
echo "  3. 'Load unpacked' butonuna tıkla"
echo ""
echo "  4. Şu klasörü seç:"
echo "     $EXTENSION_PATH"
echo ""
echo "  5. music.youtube.com'u aç ve bir şarkı çal"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Menu bar'da ▶ şarkı adı ♡ görünmeli!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Clipboard'a extension path'i kopyala
echo "$EXTENSION_PATH" | pbcopy
echo ""
echo "💡 Extension klasör yolu panoya kopyalandı."
