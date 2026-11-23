// ============================================
// Web Synchronization — CORREGIDO (v1.1)
// ============================================
// Qué estaba mal:
// - Apuntaba a https://your-server.com/sl-api/sync.php, un servidor
//   que NO existe, y lo intentaba cada 10 minutos con un temporizador.
// - No tenía http_response: ni siquiera se enteraba de si fallaba.
//
// Ahora la sincronización está DESACTIVADA por defecto (URL vacía).
// Para activarla necesitas un sync.php real en tu hosting. Eso se hará
// después del 27 de noviembre, cuando lysstore.com ya esté funcionando.
//
// Lo que SÍ funciona hoy: el botón "Ver tienda" abre tu blog con
// llLoadURL. El HUD principal lo puede llamar con:
//   llMessageLinked(LINK_SET, 0, "OPEN_STORE", "")
// Y la sincronización manual con:
//   llMessageLinked(LINK_SET, 0, "SYNC_WEB", "")

string WEB_SYNC_URL = ""; // <-- pon aquí tu sync.php cuando exista.
string WEB_API_KEY = "";  // <-- pon aquí tu clave cuando exista.
string STORE_URL = "https://lysstore.com"; // Tu tienda (dominio activo desde el 27 nov 2026).
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
    if (WEB_SYNC_URL == "") {
        llOwnerSay("Sincronización web desactivada: pon tu URL en WEB_SYNC_URL.");
        return;
    }
    llOwnerSay("Starting web sync...");
    llHTTPRequest(WEB_SYNC_URL, [HTTP_METHOD, "POST"], "action=sync_all&api_key=" + WEB_API_KEY);
}

default {
    state_entry() {
        llOwnerSay("Web Sync inicializado");
        // El temporizador solo arranca si hay una URL real configurada.
        if (WEB_SYNC_URL != "") llSetTimerEvent(WEB_SYNC_INTERVAL);
    }

    link_message(integer s, integer n, string str, key id) {
        if (n == 0) {
            if (str == "OPEN_STORE") llLoadURL(llGetOwner(), "Tienda LYS", STORE_URL);
            else if (str == "SYNC_WEB") syncAllWithWeb();
        }
    }

    timer() { syncAllWithWeb(); }

    http_response(integer request_id, integer status, list metadata, string body) {
        if (status == 200) llOwnerSay("Sync web OK");
        else llOwnerSay("Sync web falló: " + (string)status);
    }
}
