import Cocoa
final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var server = WebSocketServer(port: 9999)
    private var song   = SongInfo()
    private var displayedTitle: String = "\u{1}" 
    private var clipContainer: NSView?
    private var titleLabel:    NSTextField?
    private var timeLabel:     NSTextField?
    private let titleAreaWidth: CGFloat = 130
    private let timeAreaWidth:  CGFloat = 70
    private let itemWidth:      CGFloat = 214  
    private weak var volumeLabelItem: NSMenuItem?
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        setupStatusView()
        configureButton()
        rebuildMenu()
        server.onSongUpdate = { [weak self] info in
            self?.song = info
            self?.configureButton()
            self?.rebuildMenu()
        }
        server.start()
    }
    private func setupStatusView() {
        guard let btn = statusItem.button else { return }
        btn.title         = ""
        btn.imagePosition = .noImage
        statusItem.length = itemWidth
        let barH: CGFloat = 22
        let clip = NSView(frame: NSRect(x: 4, y: 0, width: titleAreaWidth, height: barH))
        clip.wantsLayer          = true
        clip.layer?.masksToBounds = true
        btn.addSubview(clip)
        clipContainer = clip
        let tl = NSTextField(labelWithString: "")
        tl.font                     = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        tl.lineBreakMode            = .byTruncatingTail
        tl.cell?.usesSingleLineMode = true        
        tl.frame           = NSRect(x: 0, y: 3, width: titleAreaWidth, height: 16)
        tl.wantsLayer      = true
        tl.drawsBackground = false
        tl.isBezeled       = false
        clip.addSubview(tl)
        titleLabel = tl
        let dl = NSTextField(labelWithString: "")
        dl.font            = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        dl.alignment       = .right
        dl.frame           = NSRect(x: 4 + titleAreaWidth + 6, y: 3, width: timeAreaWidth, height: 16)
        dl.drawsBackground = false
        dl.isBezeled       = false
        btn.addSubview(dl)
        timeLabel = dl
    }
    private func configureButton() {
        let titleText = song.isEmpty ? "♪ YTMusic" : song.title
        let timeText  = song.isEmpty ? ""
                      : song.timeInfo.replacingOccurrences(of: " / ", with: "/")
        timeLabel?.stringValue = timeText
        updateTitle(text: titleText)
    }
    private func updateTitle(text: String) {
        guard let label = titleLabel, let clip = clipContainer else { return }
        if text == displayedTitle { return }
        displayedTitle = text
        label.layer?.removeAllAnimations()
        label.alignment = .left
        let clipW = clip.frame.width
        let textH = label.frame.height
        let minY  = label.frame.minY
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        label.stringValue = text
        label.frame = NSRect(x: 0, y: minY, width: clipW, height: textH)
        CATransaction.commit()
    }
    private func rebuildMenu() {
        let menu = NSMenu()
        if song.isEmpty {
            menu.addItem(disabled(L.notConnected))
        } else {
            menu.addItem(disabled(truncated(song.title,  max: 36)))
            menu.addItem(disabled("    " + truncated(song.artist, max: 32)))
        }
        menu.addItem(.separator())
        menu.addItem(makeItem(L.prev,  action: #selector(prevTrack)))
        menu.addItem(makeItem(song.isPlaying ? L.pause : L.play, action: #selector(togglePlay)))
        menu.addItem(makeItem(L.next,  action: #selector(nextTrack)))
        menu.addItem(.separator())
        menu.addItem(volumeSliderItem())
        menu.addItem(.separator())
        menu.addItem(makeItem(song.isLiked    ? L.liked    : L.like,    action: #selector(toggleLike)))
        menu.addItem(makeItem(song.isDisliked ? L.disliked : L.dislike, action: #selector(toggleDislike)))
        menu.addItem(.separator())
        let playMenu = NSMenu()
        if song.playlists.isEmpty {
            playMenu.addItem(disabled(L.noPlaylists))
        } else {
            for pl in song.playlists {
                let item = NSMenuItem(title: pl.title, action: #selector(playPlaylist(_:)), keyEquivalent: "")
                item.target = self; item.representedObject = pl.id
                playMenu.addItem(item)
            }
        }
        let playlistItem = NSMenuItem(title: L.myPlaylists, action: nil, keyEquivalent: "")
        playlistItem.submenu = playMenu
        menu.addItem(playlistItem)
        menu.addItem(.separator())
        let langMenu = NSMenu()
        for lang in Lang.allCases {
            let item = NSMenuItem(title: lang.displayName, action: #selector(setLanguage(_:)), keyEquivalent: "")
            item.target = self; item.representedObject = lang.rawValue
            item.state  = (lang == Lang.current) ? .on : .off
            langMenu.addItem(item)
        }
        let langItem = NSMenuItem(title: L.language, action: nil, keyEquivalent: "")
        langItem.submenu = langMenu
        menu.addItem(langItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: L.quit, action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
    }
    private func volumeSliderItem() -> NSMenuItem {
        let item      = NSMenuItem()
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 230, height: 26))
        let lbl = NSTextField(labelWithString: L.volume)
        lbl.frame     = NSRect(x: 14, y: 5, width: 52, height: 17)
        lbl.font      = NSFont.systemFont(ofSize: 12, weight: .regular)
        lbl.textColor = .secondaryLabelColor
        container.addSubview(lbl)
        volumeLabelItem = item
        let btnDown = makeVolBtn(title: "−", x: 72, action: #selector(volumeDown))
        container.addSubview(btnDown)
        let slider = NSSlider(frame: NSRect(x: 96, y: 5, width: 98, height: 16))
        slider.minValue     = 0
        slider.maxValue     = 100
        slider.doubleValue  = Double(song.volume)
        slider.target       = self
        slider.action       = #selector(volumeSliderChanged(_:))
        slider.isContinuous = true
        slider.controlSize  = .small
        container.addSubview(slider)
        let btnUp = makeVolBtn(title: "+", x: 196, action: #selector(volumeUp))
        container.addSubview(btnUp)
        item.view = container
        return item
    }
    private func makeVolBtn(title: String, x: CGFloat, action: Selector) -> NSButton {
        let btn = NSButton(frame: NSRect(x: x, y: 4, width: 22, height: 18))
        btn.title       = title
        btn.bezelStyle  = .rounded
        btn.target      = self
        btn.action      = action
        btn.font        = NSFont.systemFont(ofSize: 12, weight: .medium)
        btn.controlSize = .small
        return btn
    }
    private func truncated(_ s: String, max: Int) -> String {
        guard s.count > max else { return s }
        return String(s.prefix(max - 1)) + "…"
    }
    private func disabled(_ title: String) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.isEnabled = false; return item
    }
    private func makeItem(_ title: String, action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self; return item
    }
    @objc private func togglePlay() {
        server.sendCommand("PLAY_PAUSE")
        song.isPlaying.toggle()
        rebuildMenu()
    }
    @objc private func nextTrack() { server.sendCommand("NEXT") }
    @objc private func prevTrack() { server.sendCommand("PREV") }
    @objc private func toggleLike() {
        server.sendCommand("LIKE")
        song.isLiked.toggle()
        if song.isLiked { song.isDisliked = false }
        rebuildMenu()
    }
    @objc private func toggleDislike() {
        server.sendCommand("DISLIKE")
        song.isDisliked.toggle()
        if song.isDisliked { song.isLiked = false }
        rebuildMenu()
    }
    @objc private func playPlaylist(_ sender: NSMenuItem) {
        guard let id = sender.representedObject as? String else { return }
        server.sendCommand("PLAY_PLAYLIST", extras: ["playlistId": id])
    }
    @objc private func volumeDown() {
        let v = max(0, song.volume - 10)
        server.sendCommand("VOLUME_SET", extras: ["value": v])
        song.volume = v; rebuildMenu()
    }
    @objc private func volumeUp() {
        let v = min(100, song.volume + 10)
        server.sendCommand("VOLUME_SET", extras: ["value": v])
        song.volume = v; rebuildMenu()
    }
    @objc private func volumeSliderChanged(_ sender: NSSlider) {
        let v = Int(sender.doubleValue)
        server.sendCommand("VOLUME_SET", extras: ["value": v])
        song.volume = v
    }
    @objc private func setLanguage(_ sender: NSMenuItem) {
        guard let raw  = sender.representedObject as? String,
              let lang = Lang(rawValue: raw) else { return }
        Lang.current = lang; rebuildMenu(); configureButton()
    }
}