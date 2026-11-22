// ============================================
// Ropa Receiver
// ============================================
integer RECEIVER_CHANNEL = 0;
key gCurrentTexture = NULL_KEY;
integer gCurrentFace = 0;
list gTextureHistory = [];

initReceiver() {
    llOwnerSay("Ropa Receiver initialized");
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0]);
}

applyTexture(integer face, string texture_uuid) {
    if (face < 0 || face > 9) {
        llOwnerSay("ERROR: Cara inválida para ropa (0-9)");
        return;
    }
    llSetLinkPrimitiveParams(llGetLinkNumber(), [
        PRIM_TEXTURE, face, (key)texture_uuid, ZERO_VECTOR, ZERO_VECTOR, 0.0
    ]);
    gCurrentTexture = (key)texture_uuid;
    gCurrentFace = face;
    gTextureHistory += [face, texture_uuid, llGetUnixTime()];
    llOwnerSay("Textura aplicada a cara " + (string)face + " (" + getFaceName(face) + ")");
    applyLightingForTexture(texture_uuid);
}

string getFaceName(integer face) {
    list names = ["head", "upper_torso", "lower_torso", "left_arm", "right_arm",
                  "left_leg", "right_leg", "hands", "feet", "pelvis"];
    if (face >= 0 && face < llGetListLength(names)) return llList2String(names, face);
    return "unknown";
}

applyLightingForTexture(string texture_uuid) {
    string material = llToLower(texture_uuid);
    if (llSubStringIndex(material, "cotton") != -1 || llSubStringIndex(material, "alg") != -1) {
        llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, <0.8, 0.8, 0.8>, 1.0, PRIM_GLOW, ALL_SIDES, 0.0]);
    } else if (llSubStringIndex(material, "silk") != -1 || llSubStringIndex(material, "sed") != -1) {
        llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, <0.7, 0.6, 0.8>, 1.0, PRIM_GLOW, ALL_SIDES, 0.1]);
    } else if (llSubStringIndex(material, "leather") != -1 || llSubStringIndex(material, "cuer") != -1) {
        llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, <0.6, 0.5, 0.4>, 1.0, PRIM_GLOW, ALL_SIDES, 0.0]);
    }
}

default {
    state_entry() { initReceiver(); }
    link_message(integer s, integer n, string str, key id) {
        if (str == "APPLY_TEXTURE") {
            list parts = llParseString2List(id, [","], []);
            if (llGetListLength(parts) >= 2) {
                applyTexture((integer)llList2String(parts, 0), llList2String(parts, 1));
            }
        }
    }
    on_rez(integer start_param) { initReceiver(); }
}
