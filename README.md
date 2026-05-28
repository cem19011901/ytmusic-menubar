# YTMusic MenuBar

A sleek and lightweight macOS menu bar controller for YouTube Music. 
Control your music, change the volume, switch playlists, and like/dislike songs directly from your Mac's menu bar without switching tabs!

## Features

- **Now Playing:** Displays the current song and artist.
- **Playback Controls:** Play, Pause, Next, and Previous track controls.
- **Volume Control:** Built-in volume slider.
- **Like / Dislike:** Easily like or dislike the current playing track.
- **Playlists:** Quick access to your YouTube Music playlists.
- **Multi-language Support:** Built-in multi-language menu.

## How it works

The project consists of two parts:
1. **The macOS App:** Lives in your menu bar and provides the user interface.
2. **The Browser Extension:** Connects the macOS app to your active YouTube Music tab via WebSockets.

## Installation

### 1. The macOS App
*(You can download the latest `.dmg` from the [Releases](../../releases) tab, or build it from source).*
- Open the `.dmg` file and drag `YTMusicMenuBar.app` to your `Applications` folder. 
- Open it from your Applications folder.

> [!WARNING]
> **"App is damaged and can't be opened" Error:**
> Because this app is not signed with a paid Apple Developer certificate, macOS Gatekeeper might show a "damaged" error when you try to open it after downloading. To fix this:
> 1. Open your **Terminal**.
> 2. Run the following command to remove the quarantine flag:
> ```bash
> xattr -cr /Applications/YTMusicMenuBar.app
> ```
> 3. Now you can open the app normally!

### 2. The Browser Extension
For the app to communicate with YouTube Music, you must install the companion browser extension:
1. Open your Chromium-based browser (Chrome, Brave, Edge, Arc).
2. Go to the Extensions page (`chrome://extensions`).
3. Enable **Developer mode** in the top right corner.
4. Click **Load unpacked** and select the `extension` folder located inside this repository.
5. Open [YouTube Music](https://music.youtube.com). The menu bar app will instantly connect!

## Build from Source

**Requirements:**
- macOS 13.0+
- Xcode or Swift Command Line Tools

Clone the repository and run the build script:

```bash
git clone https://github.com/cem19011901/ytmusic-menubar.git
cd ytmusic-menubar
./build.sh
```

## Support

If this app makes your daily music listening easier, the best way to support the development right now is to give this repository a ⭐️ Star on GitHub!

## License

MIT License
