// ============================================
// Sound Manager — CORREGIDO (v1.1)
// ============================================
// Cambios: se quitó la variable DATA_CHANNEL = -1002, que no se usaba
// y confundía (los managers no escuchan un canal, escuchan mensajes
// internos con número 0). Ahora recibe CONFIG_VOLUME de config.lsl.
//
// Comandos (por llMessageLinked, número 0):
//   PLAY_SOUND "uuid" | STOP_SOUND | SET_VOLUME "0.0-1.0"
//   SET_RADIUS "metros" | SET_FALLOFF "0.0-1.0"
// El sonido debe estar en el inventario del objeto para poder sonar.

key gCurrentSound;
float gVolume = 1.0;
float gRadius = 10.0;
float gFalloff = 1.0;
integer gLoop = FALSE;

playSound(string uuid) {
    if (uuid == "" || (key)uuid == NULL_KEY) {
        llOwnerSay("Falta el UUID del sonido.");
        return;
    }
    llStopSound();
    gCurrentSound = (key)uuid;
    llPlaySound(gCurrentSound, gVolume);
    llSetSoundRadius(gRadius);
    llSetSoundFalloff(gFalloff);
    llOwnerSay("Sonido: " + uuid);
}

stopSound() {
    llStopSound();
    gCurrentSound = NULL_KEY;
    llOwnerSay("Sonido detenido");
}

setVolume(float v) {
    gVolume = llClamp(v, 0.0, 1.0);
    if (gCurrentSound != NULL_KEY) llPlaySound(gCurrentSound, gVolume);
    llOwnerSay("Volumen: " + (string)gVolume);
}

setRadius(float r) { gRadius = r; llSetSoundRadius(gRadius); }
setFalloff(float f) { gFalloff = f; llSetSoundFalloff(gFalloff); }

default {
    link_message(integer s, integer n, string str, key id) {
        if (n == 0) {
            if (str == "PLAY_SOUND") playSound((string)id);
            else if (str == "STOP_SOUND") stopSound();
            else if (str == "SET_VOLUME") setVolume((float)id);
            else if (str == "SET_RADIUS") setRadius((float)id);
            else if (str == "SET_FALLOFF") setFalloff((float)id);
            // Volumen por defecto que manda config.lsl al arrancar.
            else if (str == "CONFIG_VOLUME") setVolume((float)id);
        }
    }
}
