const WS_URL = "ws://localhost:9999";
let ws = null;
let activeTabId = null;
let lastSongData = null;
chrome.alarms.create("wsKeepalive", { periodInMinutes: 0.4 });
chrome.alarms.onAlarm.addListener((alarm) => {
  if (alarm.name === "wsKeepalive") ensureConnected();
});
chrome.runtime.onConnect.addListener((port) => {});
function ensureConnected() {
  if (ws && (ws.readyState === WebSocket.OPEN || ws.readyState === WebSocket.CONNECTING)) return;
  connectWebSocket();
}
function connectWebSocket() {
  ws = new WebSocket(WS_URL);
  ws.onopen = () => {
    if (lastSongData) sendToSwift({ type: "SONG_UPDATE", data: lastSongData });
  };
  ws.onmessage = (event) => {
    try {
      const msg = JSON.parse(event.data);
      if (msg.type === "COMMAND" && activeTabId !== null) {
        chrome.tabs.sendMessage(activeTabId, msg);
      }
    } catch (e) {}
  };
  ws.onclose = () => setTimeout(connectWebSocket, 3000);
  ws.onerror = () => ws.close();
}
function sendToSwift(payload) {
  if (ws?.readyState === WebSocket.OPEN) ws.send(JSON.stringify(payload));
}
chrome.runtime.onMessage.addListener((msg, sender) => {
  if (msg.type !== "SONG_UPDATE") return false;
  activeTabId = sender.tab?.id ?? activeTabId;
  lastSongData = msg.data;
  sendToSwift(msg);
  return false;
});
connectWebSocket();
