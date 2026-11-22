// ============================================
// Texture Manager
// ============================================
integer DATA_CHANNEL = -1002;
vector gRepeat = <1.0, 1.0, 0.0>;
vector gOffset = <0.0, 0.0, 0.0>;
float gRotation = 0.0;

applyTexture(string uuid) {
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
            if (str == "APPLY_TEXTURE") applyTexture(id);
            else if (str == "REMOVE_TEXTURE") removeTexture();
            else if (str == "SET_REPEAT") setRepeat((vector)id);
            else if (str == "SET_OFFSET") setOffset((vector)id);
            else if (str == "SET_ROTATION") setRotation((float)id);
        }
    }
}
