// ============================================
// PBR Material
// ============================================
integer DATA_CHANNEL = -1002;
float gMetalness = 0.0;
float gRoughness = 0.5;
float gEmissive = 0.0;
vector gEmissiveColor = <1.0, 1.0, 1.0>;

setMetalness(float v) {
    gMetalness = llClamp(v, 0.0, 1.0);
    llSetMaterialParam(MATERIAL_METALNESS, gMetalness);
    llOwnerSay("Metalness: " + (string)gMetalness);
}

setRoughness(float v) {
    gRoughness = llClamp(v, 0.0, 1.0);
    llSetMaterialParam(MATERIAL_ROUGHNESS, gRoughness);
    llOwnerSay("Roughness: " + (string)gRoughness);
}

setEmissive(float v) {
    gEmissive = llClamp(v, 0.0, 1.0);
    llSetMaterialParam(MATERIAL_EMISSIVE, gEmissive);
}

setEmissiveColor(vector c) {
    gEmissiveColor = c;
    llSetMaterialParam(MATERIAL_EMISSIVE_COLOR, gEmissiveColor);
}

default {
    link_message(integer s, integer n, string str, key id) {
        if (n == 0) {
            if (str == "SET_METALNESS") setMetalness((float)id);
            else if (str == "SET_ROUGHNESS") setRoughness((float)id);
            else if (str == "SET_EMISSIVE") setEmissive((float)id);
            else if (str == "SET_EMISSIVE_COLOR") setEmissiveColor((vector)id);
        }
    }
}
