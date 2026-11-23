// ============================================
// HUD Main — CORREGIDO (v1.1)
// ============================================
// Qué estaba mal:
// - El menú devolvía el TEXTO del botón ("Color"), pero el código lo
//   convertía a número con (integer)message. "Color" como número es 0,
//   así que ningún botón hacía nada, ni siquiera "Salir".
// - "Salir" usaba llDie(), que destruye el objeto entero (el HUD
//   desaparecería de tu pantalla). Ahora solo cierra el menú.
// - Tocar el HUD no abría nada: faltaba touch_start.
//
// Cómo habla con los demás scripts:
//   llMessageLinked(LINK_SET, 0, "COMANDO", "dato")
//   El número es 0 (no -1002): los managers solo escuchan el 0.

integer HUD_CHANNEL = -9999;
string COMMAND_PREFIX = "/hud";
key gOwnerKey;
integer gListenHandle = 0;

// ---- EDITA ESTO: pon aquí UUIDs reales para probar los botones ----
// Textura de demostración: la textura "madera" que trae Second Life.
string DEMO_TEXTURE = "89556747-24cb-43ed-920b-47caed15465f";
// Sonido y animación de demostración: vacíos hasta que pongas un UUID real
// (clic derecho en el sonido o la animación en tu inventario → Copiar UUID).
string DEMO_SOUND = "";
string DEMO_ANIM = "";

list MAIN_MENU = ["Texturas", "Materiales PBR", "Sonidos", "Animaciones", "Color", "Guardar", "Salir"];
list COLOR_MENU = ["Rojo", "Verde", "Azul", "Blanco", "Atrás"];
list PBR_MENU = ["Metal", "Mate", "Atrás"];
list TEXTURE_MENU = ["Poner demo", "Quitar textura", "Atrás"];
list SOUND_MENU = ["Sonido demo", "Parar sonido", "Atrás"];
list ANIM_MENU = ["Animación demo", "Parar animación", "Atrás"];

initHUD() {
    gOwnerKey = llGetOwner();
    llOwnerSay("HUD Creator listo. Toca el HUD o escribe: " + COMMAND_PREFIX + " menu");
    if (gListenHandle) llListenRemove(gListenHandle);
    gListenHandle = llListen(0, "", gOwnerKey, "");
}

showDialog(key user, list buttons, string title) {
    llDialog(user, "\n" + title + "\n", buttons, HUD_CHANNEL);
}

default {
    state_entry() { initHUD(); }

    touch_start(integer n) {
        showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
    }

    listen(integer channel, string name, key id, string message) {
        // Comando por chat: /hud menu (o solo /hud)
        if (channel == 0 && llSubStringIndex(message, COMMAND_PREFIX) == 0) {
            string cmd = llToLower(llGetSubString(message, llStringLength(COMMAND_PREFIX) + 1, -1));
            if (cmd == "menu" || cmd == "") showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
        }
        // Respuesta del diálogo: message es el TEXTO del botón, no un número.
        else if (channel == HUD_CHANNEL) {
            if (message == "Texturas") showDialog(gOwnerKey, TEXTURE_MENU, "[HUD] Texturas");
            else if (message == "Materiales PBR") showDialog(gOwnerKey, PBR_MENU, "[HUD] Materiales PBR");
            else if (message == "Sonidos") showDialog(gOwnerKey, SOUND_MENU, "[HUD] Sonidos");
            else if (message == "Animaciones") showDialog(gOwnerKey, ANIM_MENU, "[HUD] Animaciones");
            else if (message == "Color") showDialog(gOwnerKey, COLOR_MENU, "[HUD] Color");
            else if (message == "Guardar") {
                llOwnerSay("Los ajustes se guardan en los scripts. Para cambiar los valores por defecto, edita config.lsl");
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            else if (message == "Salir") {
                llOwnerSay("Menú cerrado.");
            }
            else if (message == "Atrás") {
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            // --- Submenú Texturas ---
            else if (message == "Poner demo") {
                llMessageLinked(LINK_SET, 0, "APPLY_TEXTURE", DEMO_TEXTURE);
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            else if (message == "Quitar textura") {
                llMessageLinked(LINK_SET, 0, "REMOVE_TEXTURE", "");
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            // --- Submenú PBR ---
            else if (message == "Metal") {
                llMessageLinked(LINK_SET, 0, "SET_METALNESS", "1.0");
                llMessageLinked(LINK_SET, 0, "SET_ROUGHNESS", "0.1");
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            else if (message == "Mate") {
                llMessageLinked(LINK_SET, 0, "SET_METALNESS", "0.0");
                llMessageLinked(LINK_SET, 0, "SET_ROUGHNESS", "0.9");
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            // --- Submenú Sonidos ---
            else if (message == "Sonido demo") {
                if (DEMO_SOUND == "") llOwnerSay("Pon el UUID de un sonido en DEMO_SOUND (arriba de este script).");
                else llMessageLinked(LINK_SET, 0, "PLAY_SOUND", DEMO_SOUND);
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            else if (message == "Parar sonido") {
                llMessageLinked(LINK_SET, 0, "STOP_SOUND", "");
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            // --- Submenú Animaciones ---
            else if (message == "Animación demo") {
                if (DEMO_ANIM == "") llOwnerSay("Pon el UUID de una animación en DEMO_ANIM (arriba de este script).");
                else llMessageLinked(LINK_SET, 0, "START_ANIMATION", DEMO_ANIM);
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            else if (message == "Parar animación") {
                llMessageLinked(LINK_SET, 0, "STOP_ANIMATION", "");
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            // --- Submenú Color ---
            else if (message == "Rojo") {
                llMessageLinked(LINK_SET, 0, "SET_COLOR", "<1.0, 0.0, 0.0>");
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            else if (message == "Verde") {
                llMessageLinked(LINK_SET, 0, "SET_COLOR", "<0.0, 1.0, 0.0>");
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            else if (message == "Azul") {
                llMessageLinked(LINK_SET, 0, "SET_COLOR", "<0.0, 0.0, 1.0>");
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
            else if (message == "Blanco") {
                llMessageLinked(LINK_SET, 0, "SET_COLOR", "<1.0, 1.0, 1.0>");
                showDialog(gOwnerKey, MAIN_MENU, "[HUD] Menú");
            }
        }
    }

    on_rez(integer start_param) { initHUD(); }
}
