// ============================================
// HUD Main
// ============================================
integer HUD_CHANNEL = -9999;
string COMMAND_PREFIX = "/hud";
key gOwnerKey;

list MAIN_MENU = ["Texturas", "Materiales PBR", "Sonidos", "Animaciones", "Color", "Guardar", "Salir"];

initHUD() {
    gOwnerKey = llGetOwner();
    llOwnerSay("HUD Creator listo. Usa: " + COMMAND_PREFIX + " menu");
    llListen(0, "", gOwnerKey, "");
}

showDialog(key user, list buttons, string title) {
    llDialog(user, "\n" + title + "\n", buttons, HUD_CHANNEL);
}

default {
    state_entry() { initHUD(); }
    listen(integer channel, string name, key id, string message) {
        if (channel == 0 && llSubStringIndex(message, COMMAND_PREFIX) == 0) {
            string cmd = llToLower(llGetSubString(message, llStringLength(COMMAND_PREFIX) + 1, -1));
            if (cmd == "menu") showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
        }
        if (channel == HUD_CHANNEL) {
            integer choice = (integer)message;
            if (choice == 6) { llOwnerSay("Adiós"); llDie(); }
        }
    }
    on_rez(integer start_param) { initHUD(); }
}
