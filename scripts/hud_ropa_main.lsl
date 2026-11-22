// ============================================
// HUD Ropa Main
// ============================================
integer HUD_CHANNEL = -9999;
key gOwnerKey;
key gCurrentObject = NULL_KEY;
integer gCurrentFace = 0;
integer gCurrentCategory = 0;
list gTextures = [];

initHUD() {
    gOwnerKey = llGetOwner();
    llOwnerSay("HUD de Ropa inicializado");
    loadTextures();
}

loadTextures() {
    gTextures = [
        "Algodón", "Camiseta Blanca", "texture-uuid-alg-001", 250,
        "Algodón", "Camiseta Negra", "texture-uuid-alg-002", 250,
        "Seda", "Blusa Roja", "texture-uuid-sed-001", 800,
        "Seda", "Vestido Negro", "texture-uuid-sed-002", 1500,
        "Cuero", "Chaqueta Negra", "texture-uuid-cue-001", 2500,
        "Cuero", "Pantalón Cuero", "texture-uuid-cue-002", 1800,
        "Jeans", "Jeans Azul", "texture-uuid-jean-001", 600,
        "Jeans", "Jeans Negro", "texture-uuid-jean-002", 650
    ];
    llOwnerSay("Texturas cargadas: " + (string)llGetListLength(gTextures));
}

applyTextureToObject(key object, integer face, string texture_uuid) {
    llMessageLinked(object, 0, "APPLY_TEXTURE", (string)face + "," + texture_uuid);
    llOwnerSay("Textura aplicada: " + texture_uuid);
}

default {
    state_entry() { initHUD(); }
    link_message(integer s, integer n, string str, key id) {
        if (n == 0 && str == "SELECT_TEXTURE") {
            integer index = (integer)id;
            if (index >= 0 && index < llGetListLength(gTextures)) {
                string texture_uuid = llList2String(gTextures, index * 4 + 2);
                string texture_name = llList2String(gTextures, index * 4 + 1);
                llOwnerSay("Seleccionada: " + texture_name);
                if (gCurrentObject != NULL_KEY) {
                    applyTextureToObject(gCurrentObject, gCurrentFace, texture_uuid);
                }
            }
        }
    }
    on_rez(integer start_param) { initHUD(); }
}
