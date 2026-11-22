// ============================================
// Web Synchronization
// ============================================
string WEB_SYNC_URL = "https://your-server.com/sl-api/sync.php";
string WEB_API_KEY = "your-web-api-key";
integer WEB_SYNC_INTERVAL = 600;

string listToJSON(list input) {
    string json = "[";
    integer i;
    for (i = 0; i < llGetListLength(input); i++) {
        if (i > 0) json += ",";
        json += "\"" + llEscapeURL(llList2String(input, i)) + "\"";
    }
    json += "]";
    return json;
}

syncAllWithWeb() {
    llOwnerSay("Starting web sync...");
    llHTTPRequest(WEB_SYNC_URL, [HTTP_METHOD, "POST"], "action=sync_all&api_key=" + WEB_API_KEY);
}

default {
    state_entry() {
        llOwnerSay("Web Sync initialized");
        llSetTimerEvent(WEB_SYNC_INTERVAL);
    }
    timer() { syncAllWithWeb(); }
}
