(function () {
  "use strict";
  const SEL = {
    title:        "yt-formatted-string.title.ytmusic-player-bar",
    artist:       ".byline.ytmusic-player-bar",
    playBtn:      ".play-pause-button",
    nextBtn:      ".next-button",
    prevBtn:      ".previous-button",
    likeBtn:      "ytmusic-like-button-renderer #button-shape-like button",
    dislikeBtn:   "ytmusic-like-button-renderer #button-shape-dislike button",
    timeInfo:     ".time-info.ytmusic-player-bar",
    volumeSlider: "#volume-slider",
    moviePlayer:  "#movie_player",
  };
  function getVolume() {
    const player = document.querySelector(SEL.moviePlayer);
    if (player?.getVolume) return Math.round(player.getVolume());
    const raw = document.querySelector(SEL.volumeSlider)?.getAttribute("aria-valuenow") ?? "100";
    const v = Math.round(parseFloat(raw));
    return isNaN(v) ? 100 : v;
  }
  function setVolume(val) {
    const clamped = Math.max(0, Math.min(100, val));
    const player  = document.querySelector(SEL.moviePlayer);
    if (player?.setVolume) {
      player.setVolume(clamped);
      player.unMute?.();
      return;
    }
    const slider = document.querySelector(SEL.volumeSlider);
    if (!slider) return;
    const current = parseInt(slider.getAttribute("aria-valuenow") ?? "50", 10);
    const diff    = clamped - current;
    if (diff === 0) return;
    slider.focus();
    const key   = diff > 0 ? "ArrowRight" : "ArrowLeft";
    for (let i = 0; i < Math.abs(diff); i++) {
      slider.dispatchEvent(new KeyboardEvent("keydown", { key, bubbles: true, cancelable: true, composed: true }));
      slider.dispatchEvent(new KeyboardEvent("keyup",   { key, bubbles: true, cancelable: true, composed: true }));
    }
  }
  function getPlaylists() {
    const results = [];
    const seen    = new Set();
    document.querySelectorAll("a[href]").forEach(a => {
      const href  = a.getAttribute("href") || "";
      const match = href.match(/playlist\?list=([^&]+)/);
      if (!match) return;
      const id    = match[1];
      const title = (
        a.querySelector(".title, .primary-text, yt-formatted-string")?.textContent ||
        a.getAttribute("aria-label") ||
        a.textContent
      )?.trim();
      if (!id || !title || seen.has(id)) return;
      seen.add(id);
      results.push({ id, title });
    });
    return results;
  }
  function playPlaylist(playlistId) {
    const link = document.querySelector(`a[href*="list=${playlistId}"]`);
    if (!link) {
      console.warn("[YTMenuBar] Playlist link bulunamadı:", playlistId);
      return;
    }
    const item =
      link.closest("ytmusic-two-row-item-renderer") ||
      link.parentElement;
    item.dispatchEvent(new MouseEvent("mouseenter", { bubbles: true, composed: true }));
    item.dispatchEvent(new MouseEvent("mouseover",  { bubbles: true, composed: true }));
    const tryClick = (attempts) => {
      if (attempts <= 0) {
        console.warn("[YTMenuBar] ytmusic-play-button-renderer bulunamadı, link tıklanıyor");
        link.click();
        return;
      }
      const playBtn = item.querySelector("ytmusic-play-button-renderer");
      if (playBtn) {
        playBtn.click();
        console.log("[YTMenuBar] Playlist play tıklandı:", playlistId);
        item.dispatchEvent(new MouseEvent("mouseleave", { bubbles: true, composed: true }));
      } else {
        setTimeout(() => tryClick(attempts - 1), 200);
      }
    };
    setTimeout(() => tryClick(8), 150);
  }
  function clickLikeButton() {
    const btn =
      document.querySelector(SEL.likeBtn) ||
      document.querySelector("ytmusic-like-button-renderer yt-button-shape:first-child button") ||
      document.querySelector("#button-shape-like button");
    if (btn) {
      btn.dispatchEvent(new MouseEvent("click", { bubbles: true, cancelable: true, view: window }));
    }
  }
  function clickDislikeButton() {
    const btn =
      document.querySelector(SEL.dislikeBtn) ||
      document.querySelector("ytmusic-like-button-renderer yt-button-shape:last-child button") ||
      document.querySelector("#button-shape-dislike button");
    if (btn) {
      btn.dispatchEvent(new MouseEvent("click", { bubbles: true, cancelable: true, view: window }));
    }
  }
  function getSongInfo() {
    const playBtnWrapper = document.querySelector(SEL.playBtn);
    const innerBtn       = playBtnWrapper?.querySelector("button") || playBtnWrapper;
    const label = (
      innerBtn?.getAttribute("aria-label") ||
      playBtnWrapper?.getAttribute("title") || ""
    ).toLowerCase();
    const likeBtn    = document.querySelector(SEL.likeBtn);
    const dislikeBtn = document.querySelector(SEL.dislikeBtn);
    let isPlaying = false;
    const pauseWords = ["pause", "duraklat", "пауза", "durakla"];
    const playWords  = ["play",  "oynat",    "воспр", "başlat"];
    if (pauseWords.some(w => label.includes(w)))     isPlaying = true;
    else if (playWords.some(w => label.includes(w))) isPlaying = false;
    else isPlaying = (innerBtn?.querySelectorAll("path")?.length ?? 0) >= 2;
    return {
      title:      document.querySelector(SEL.title)?.textContent?.trim()  ?? "",
      artist:     document.querySelector(SEL.artist)?.textContent?.trim() ?? "",
      isPlaying,
      isLiked:    likeBtn?.getAttribute("aria-pressed")    === "true",
      isDisliked: dislikeBtn?.getAttribute("aria-pressed") === "true",
      timeInfo:   document.querySelector(SEL.timeInfo)?.textContent?.trim() ?? "",
      volume:     getVolume(),
      playlists:  getPlaylists(),
    };
  }
  function isContextValid() {
    try { return !!chrome.runtime?.id; } catch { return false; }
  }
  function sendUpdate() {
    if (!isContextValid()) return;
    chrome.runtime.sendMessage({ type: "SONG_UPDATE", data: getSongInfo() }).catch(() => {});
  }
  function sendDelayedUpdates() {
    setTimeout(sendUpdate, 400);
    setTimeout(sendUpdate, 900);
    setTimeout(sendUpdate, 1800);
  }
  chrome.runtime.onMessage.addListener((msg) => {
    if (!isContextValid() || msg.type !== "COMMAND") return;
    switch (msg.command) {
      case "PLAY_PAUSE":
        document.querySelector(SEL.playBtn)?.click();
        sendDelayedUpdates();
        break;
      case "NEXT":
        document.querySelector(SEL.nextBtn)?.click();
        sendDelayedUpdates();
        break;
      case "PREV":
        document.querySelector(SEL.prevBtn)?.click();
        sendDelayedUpdates();
        break;
      case "LIKE":
        clickLikeButton();
        setTimeout(sendUpdate, 350);
        break;
      case "DISLIKE":
        clickDislikeButton();
        setTimeout(sendUpdate, 350);
        break;
      case "VOLUME_SET":
        setVolume(msg.value ?? 50);
        setTimeout(sendUpdate, 400);
        break;
      case "PLAY_PLAYLIST":
        playPlaylist(msg.playlistId);
        break;
    }
  });
  function keepBackgroundAlive() {
    if (!isContextValid()) return;
    try {
      const port = chrome.runtime.connect({ name: "keepAlive" });
      port.onDisconnect.addListener(() => {
        if (isContextValid()) setTimeout(keepBackgroundAlive, 1000);
      });
    } catch {}
  }
  keepBackgroundAlive();
  const observer = new MutationObserver(sendUpdate);
  observer.observe(document.body, {
    childList: true, subtree: true, characterData: true,
    attributeFilter: ["aria-label", "aria-pressed", "aria-valuenow", "value"],
  });
  sendUpdate();
})();
