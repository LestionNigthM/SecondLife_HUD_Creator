// ============================================
// HUD Creator - Configuration — CORREGIDO (v1.1)
// ============================================
// Qué estaba mal: este archivo era texto Markdown, no LSL. Un archivo
// .lsl con "##" y "```" no compila en Second Life.
//
// Además, antes no hacía nada: eran solo variables sueltas que ningún
// script leía. En LSL cada script es independiente y NO puede leer las
// variables de otro script. Por eso este script ahora ENVÍA los valores
// a los demás con llMessageLinked al arrancar (y una vez más a los
// 2 segundos, por si algún manager arrancó tarde). Cada manager tiene
// su parte para recibirlos: CONFIG_COLOR, CONFIG_ALPHA, etc.
//
// Para cambiar un valor por defecto, edítalo AQUÍ y vuelve a guardar
// este script: los demás lo reciben solos al arrancar.

string HUD_NAME = "HUD Creator";
string HUD_VERSION = "1.1.0";
integer HUD_CHANNEL = -9999;
string COMMAND_PREFIX = "/hud";

vector DEFAULT_COLOR = <1.0, 1.0, 1.0>;
float DEFAULT_ALPHA = 1.0;
float DEFAULT_VOLUME = 1.0;
float DEFAULT_METALNESS = 0.0;
float DEFAULT_ROUGHNESS = 0.5;
string DEFAULT_TEXTURE = ""; // Vacío = sin textura por defecto.

broadcast() {
    llMessageLinked(LINK_SET, 0, "CONFIG_COLOR", (string)DEFAULT_COLOR);
    llMessageLinked(LINK_SET, 0, "CONFIG_ALPHA", (string)DEFAULT_ALPHA);
    llMessageLinked(LINK_SET, 0, "CONFIG_VOLUME", (string)DEFAULT_VOLUME);
    llMessageLinked(LINK_SET, 0, "CONFIG_METALNESS", (string)DEFAULT_METALNESS);
    llMessageLinked(LINK_SET, 0, "CONFIG_ROUGHNESS", (string)DEFAULT_ROUGHNESS);
    if (DEFAULT_TEXTURE != "") llMessageLinked(LINK_SET, 0, "CONFIG_TEXTURE", DEFAULT_TEXTURE);
}

default {
    state_entry() {
        broadcast();
        llSetTimerEvent(2.0);
    }
    on_rez(integer start_param) {
        broadcast();
        llSetTimerEvent(2.0);
    }
    timer() {
        // Segundo envío por si algún manager arrancó tarde. Solo una vez.
        llSetTimerEvent(0.0);
        broadcast();
    }
}
