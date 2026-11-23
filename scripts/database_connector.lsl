// ============================================
// Database Connector — CORREGIDO (v1.1)
// ============================================
// Qué estaba mal: apuntaba a https://your-server.com/sl-api/database.php,
// un servidor que NO existe, y lo intentaba cada 5 minutos con un
// temporizador (3 peticiones cada vez).
//
// Ahora está DESACTIVADO por defecto (URL vacía). Para activarlo
// necesitas un database.php real en tu hosting. Eso se hará después
// del 27 de noviembre, cuando lysstore.com ya esté funcionando.
//
// Sincronización manual desde otro script:
//   llMessageLinked(LINK_SET, 0, "SYNC_DB", "")

string DB_SERVER_URL = ""; // <-- pon aquí tu database.php cuando exista.
string DB_API_KEY = "";    // <-- pon aquí tu clave cuando exista.
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
    if (DB_SERVER_URL == "") {
        llOwnerSay("Base de datos desactivada: pon tu URL en DB_SERVER_URL.");
        return;
    }
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
        llOwnerSay("Database Connector inicializado");
        // El temporizador solo arranca si hay una URL real configurada.
        if (DB_SERVER_URL != "") llSetTimerEvent(DB_SYNC_INTERVAL);
    }

    link_message(integer s, integer n, string str, key id) {
        if (n == 0 && str == "SYNC_DB") syncAllWithDatabase();
    }

    timer() { syncAllWithDatabase(); }

    http_response(integer request_id, integer status, list metadata, string body) {
        if (status == 200) llOwnerSay("Sync successful");
        else llOwnerSay("Sync failed: " + (string)status);
    }
}
