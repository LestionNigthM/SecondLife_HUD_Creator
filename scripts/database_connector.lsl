// ============================================
// Database Connector
// ============================================
string DB_SERVER_URL = "https://your-server.com/sl-api/database.php";
string DB_API_KEY = "your-api-key";
integer DB_SYNC_INTERVAL = 300;
integer gHTTPRequestID = 0;

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

sendToServer(string action, list data) {
    string requestBody = "action=" + llEscapeURL(action) +
                        "&api_key=" + llEscapeURL(DB_API_KEY) +
                        "&data=" + llEscapeURL(listToJSON(data));
    gHTTPRequestID = llHTTPRequest(DB_SERVER_URL, [
        HTTP_METHOD, "POST",
        HTTP_MIMETYPE, "application/x-www-form-urlencoded"
    ], requestBody);
    llOwnerSay("Request sent: " + action);
}

syncAllWithDatabase() {
    llOwnerSay("Starting database sync...");
    sendToServer("sync_inventory", []);
    sendToServer("sync_orders", []);
    sendToServer("sync_users", []);
}

default {
    state_entry() {
        llOwnerSay("Database Connector initialized");
        llSetTimerEvent(DB_SYNC_INTERVAL);
    }
    timer() { syncAllWithDatabase(); }
    http_response(integer request_id, integer status, list metadata, string body) {
        if (status == 200) llOwnerSay("Sync successful");
        else llOwnerSay("Sync failed: " + (string)status);
    }
}
