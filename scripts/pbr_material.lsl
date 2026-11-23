// ============================================
// PBR Material — CORREGIDO (v1.1)
// ============================================
// Qué estaba mal: usaba llSetMaterialParam con MATERIAL_METALNESS,
// MATERIAL_ROUGHNESS, MATERIAL_EMISSIVE y MATERIAL_EMISSIVE_COLOR.
// Esas funciones y constantes NO existen en LSL, así que el script
// no compilaba.
// El PBR real en LSL se hace con llSetLinkPrimitiveParams y las
// constantes PRIM_GLTF_*.
// OJO: PRIM_GLTF_METALLIC_ROUGHNESS lleva al final metallic y luego
// roughness, en ese orden.
//
// Comandos (por llMessageLinked, número 0):
//   SET_METALNESS "0.0-1.0" | SET_ROUGHNESS "0.0-1.0"
//   SET_EMISSIVE "0.0-1.0"  | SET_EMISSIVE_COLOR "<r,g,b>"
//   SET_ALPHA_MODE "OPAQUE" / "BLEND" / "MASK"  (o "0" / "1" / "2")

float gMetal = 0.0;
float gRough = 0.5;
float gEmissive = 0.0;
vector gEmissiveColor = <1.0, 1.0, 1.0>;
integer gAlphaMode = PRIM_GLTF_ALPHA_MODE_OPAQUE; // 0 opaco, 1 transparente, 2 recortado

aplicarPBR() {
    llSetLinkPrimitiveParams(LINK_THIS, [
        PRIM_GLTF_METALLIC_ROUGHNESS, ALL_SIDES,
        "", <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0,
        gMetal, gRough,
        PRIM_GLTF_EMISSIVE, ALL_SIDES, "", gEmissiveColor, gEmissive,
        PRIM_GLTF_ALPHA_MODE, ALL_SIDES, gAlphaMode ]);
}

setMetalness(float v) {
    gMetal = llClamp(v, 0.0, 1.0);
    aplicarPBR();
    llOwnerSay("Metalness: " + (string)gMetal);
}

setRoughness(float v) {
    gRough = llClamp(v, 0.0, 1.0);
    aplicarPBR();
    llOwnerSay("Roughness: " + (string)gRough);
}

setEmissive(float v) {
    gEmissive = llClamp(v, 0.0, 1.0);
    aplicarPBR();
    llOwnerSay("Emissive: " + (string)gEmissive);
}

setEmissiveColor(vector c) {
    gEmissiveColor = c;
    aplicarPBR();
    llOwnerSay("Color emisivo: " + (string)c);
}

setAlphaMode(string m) {
    m = llToUpper(m);
    if (m == "BLEND" || m == "1") gAlphaMode = PRIM_GLTF_ALPHA_MODE_BLEND;
    else if (m == "MASK" || m == "2") gAlphaMode = PRIM_GLTF_ALPHA_MODE_MASK;
    else gAlphaMode = PRIM_GLTF_ALPHA_MODE_OPAQUE;
    aplicarPBR();
    llOwnerSay("Modo alpha: " + m);
}

default {
    link_message(integer s, integer n, string str, key id) {
        if (n == 0) {
            if (str == "SET_METALNESS") setMetalness((float)id);
            else if (str == "SET_ROUGHNESS") setRoughness((float)id);
            else if (str == "SET_EMISSIVE") setEmissive((float)id);
            else if (str == "SET_EMISSIVE_COLOR") setEmissiveColor((vector)id);
            else if (str == "SET_ALPHA_MODE") setAlphaMode((string)id);
            // Valores por defecto que manda config.lsl al arrancar.
            else if (str == "CONFIG_METALNESS") setMetalness((float)id);
            else if (str == "CONFIG_ROUGHNESS") setRoughness((float)id);
        }
    }
}
