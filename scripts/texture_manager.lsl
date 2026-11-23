// ============================================
// Texture Manager — CORREGIDO (v1.1)
// ============================================
// Cambios: se quitó la variable DATA_CHANNEL = -1002, que no se usaba
// y confundía (los managers no escuchan un canal, escuchan mensajes
// internos con número 0). Ahora recibe CONFIG_TEXTURE de config.lsl.
//
// Comandos (por llMessageLinked, número 0):
//   APPLY_TEXTURE "uuid" | REMOVE_TEXTURE
//   SET_REPEAT "<u,v,0>" | SET_OFFSET "<u,v,0>" | SET_ROTATION "grados"

vector gRepeat = <1.0, 1.0, 0.0>;
vector gOffset = <0.0, 0.0, 0.0>;
float gRotation = 0.0;

applyTexture(string uuid) {
    if (uuid == "" || (key)uuid == NULL_KEY) {
        llOwnerSay("Falta el UUID de la textura.");
        return;
    }
    llSetTexture(uuid, ALL_SIDES, gRepeat, gOffset, gRotation * DEG_TO_RAD);
    llOwnerSay("Textura aplicada");
}

removeTexture() {
    llSetTexture("", ALL_SIDES);
    llOwnerSay("Textura removida");
}

setRepeat(vector r) { gRepeat = r; llOwnerSay("Repetición: " + (string)r); }
setOffset(vector o) { gOffset = o; llOwnerSay("Offset: " + (string)o); }
setRotation(float r) { gRotation = r; llOwnerSay("Rotación: " + (string)r); }

default {
    link_message(integer s, integer n, string str, key id) {
        if (n == 0) {
            if (str == "APPLY_TEXTURE") applyTexture((string)id);
            else if (str == "REMOVE_TEXTURE") removeTexture();
            else if (str == "SET_REPEAT") setRepeat((vector)id);
            else if (str == "SET_OFFSET") setOffset((vector)id);
            else if (str == "SET_ROTATION") setRotation((float)id);
            // Textura por defecto que manda config.lsl al arrancar.
            else if (str == "CONFIG_TEXTURE") applyTexture((string)id);
        }
    }
}
