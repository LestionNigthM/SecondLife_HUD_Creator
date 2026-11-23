// ============================================
// Color Controller — CORREGIDO (v1.1)
// ============================================
// Qué estaba mal: llSetGlow(gGlow) no compila. En LSL llSetGlow
// necesita la cara: llSetGlow(intensidad, cara).
//
// Comandos (por llMessageLinked, número 0):
//   SET_COLOR "<r,g,b>" | SET_ALPHA "0.0-1.0" | SET_GLOW "0.0-1.0"
// También recibe CONFIG_COLOR y CONFIG_ALPHA de config.lsl.

vector gColor = <1.0, 1.0, 1.0>;
float gAlpha = 1.0;
float gGlow = 0.0;

setColor(vector c) {
    gColor = c;
    llSetColor(gColor, ALL_SIDES);
    llOwnerSay("Color: " + (string)c);
}

setAlpha(float a) {
    gAlpha = llClamp(a, 0.0, 1.0);
    llSetAlpha(gAlpha, ALL_SIDES);
    llOwnerSay("Alpha: " + (string)gAlpha);
}

setGlow(float g) {
    gGlow = llClamp(g, 0.0, 1.0);
    llSetGlow(gGlow, ALL_SIDES);
    llOwnerSay("Glow: " + (string)gGlow);
}

default {
    link_message(integer s, integer n, string str, key id) {
        if (n == 0) {
            if (str == "SET_COLOR") setColor((vector)id);
            else if (str == "SET_ALPHA") setAlpha((float)id);
            else if (str == "SET_GLOW") setGlow((float)id);
            // Valores por defecto que manda config.lsl al arrancar.
            else if (str == "CONFIG_COLOR") setColor((vector)id);
            else if (str == "CONFIG_ALPHA") setAlpha((float)id);
        }
    }
}
