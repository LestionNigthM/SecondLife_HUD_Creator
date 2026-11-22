// ============================================
// Lighting Controller
// ============================================
list LIGHT_PROFILES = ["cotton", "silk", "leather", "metal"];
list LIGHT_COTTON = [0.8, 0.8, 0.8, 0.9, 0.9, 0.9, 0.0];
list LIGHT_SILK = [0.7, 0.6, 0.8, 0.8, 0.7, 0.9, 0.1];
list LIGHT_LEATHER = [0.6, 0.5, 0.4, 0.7, 0.6, 0.5, 0.0];
list LIGHT_METAL = [0.4, 0.4, 0.5, 0.6, 0.6, 0.7, 0.0];

integer applyLightProfile(integer profile_index) {
    if (profile_index < 0 || profile_index >= llGetListLength(LIGHT_PROFILES)) return FALSE;
    list profile;
    if (profile_index == 0) profile = LIGHT_COTTON;
    else if (profile_index == 1) profile = LIGHT_SILK;
    else if (profile_index == 2) profile = LIGHT_LEATHER;
    else if (profile_index == 3) profile = LIGHT_METAL;
    float ar = llList2Float(profile, 0);
    float ag = llList2Float(profile, 1);
    float ab = llList2Float(profile, 2);
    float dr = llList2Float(profile, 3);
    float dg = llList2Float(profile, 4);
    float db = llList2Float(profile, 5);
    float glow = llList2Float(profile, 6);
    llSetPrimitiveParams([
        PRIM_COLOR, ALL_SIDES, <ar, ag, ab>, 1.0,
        PRIM_GLOW, ALL_SIDES, glow
    ]);
    llOwnerSay("Perfil de luz aplicado: " + llList2String(LIGHT_PROFILES, profile_index));
    return TRUE;
}

default {
    state_entry() { llOwnerSay("Lighting Controller initialized"); }
}
