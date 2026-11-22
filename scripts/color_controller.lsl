// ============================================
// Color Controller
// ============================================
integer DATA_CHANNEL = -1002;
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
    llSetGlow(gGlow);
    llOwnerSay("Glow: " + (string)gGlow);
}

default {
    link_message(integer s, integer n, string str, key id) {
        if (n == 0) {
            if (str == "SET_COLOR") setColor((vector)id);
            else if (str == "SET_ALPHA") setAlpha((float)id);
            else if (str == "SET_GLOW") setGlow((float)id);
        }
    }
}
