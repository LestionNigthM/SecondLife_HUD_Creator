// ============================================
// Ropa Receiver — CORREGIDO (v1.1)
// ============================================
// Va DENTRO de la prenda. Habla con el HUD de ropa por el canal
// -12350 (no por link_message: eso solo funciona dentro del mismo
// objeto, y el HUD y la prenda son objetos distintos).
//
// Qué estaba mal:
// - Escuchaba link_message, que el HUD nunca le podía mandar.
// - applyLightingForTexture cambiaba el COLOR de la prenda según el
//   nombre de la textura... pero comparaba el UUID, que nunca contiene
//   palabras como "cotton". Era código muerto que además teñía la ropa
//   de gris o morado. Se quitó.
// - PRIM_TEXTURE usaba repeticiones <0,0,0>: con 0 repeticiones la
//   textura no se ve. Ahora usa <1,1,0>, lo normal.
// - La lista de nombres de caras ("head", "upper_torso"...) era
//   inventada: las caras de un mesh son solo números. Se quitó.

integer ROPA_CHANNEL = -12350;
integer gListenHandle = 0;
key gCurrentTexture = NULL_KEY;
integer gCurrentFace = 0;
list gTextureHistory = [];

initReceiver() {
    llOwnerSay("Ropa Receiver inicializado");
    llSetPrimitiveParams([PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0]);
    if (gListenHandle) llListenRemove(gListenHandle);
    gListenHandle = llListen(ROPA_CHANNEL, "", NULL_KEY, "");
    // Avisar al HUD que esta prenda está lista.
    llRegionSayTo(llGetOwner(), ROPA_CHANNEL, "ROPA_LISTO");
}

applyTexture(integer face, string texture_uuid) {
    if (face < 0 || face > 9) {
        llOwnerSay("ERROR: Cara inválida para ropa (0-9)");
        return;
    }
    if (texture_uuid == "" || (key)texture_uuid == NULL_KEY) {
        llOwnerSay("ERROR: UUID de textura vacío.");
        return;
    }
    llSetLinkPrimitiveParams(llGetLinkNumber(), [
        PRIM_TEXTURE, face, (key)texture_uuid, <1.0, 1.0, 0.0>, <0.0, 0.0, 0.0>, 0.0
    ]);
    gCurrentTexture = (key)texture_uuid;
    gCurrentFace = face;
    gTextureHistory += [face, texture_uuid, llGetUnixTime()];
    llOwnerSay("Textura aplicada a cara " + (string)face);
}

default {
    state_entry() { initReceiver(); }

    listen(integer channel, string name, key id, string message) {
        if (channel != ROPA_CHANNEL) return;
        // Solo aceptar mensajes de tus propios objetos.
        if (llGetOwnerKey(id) != llGetOwner()) return;
        if (message == "ROPA_BUSCAR") {
            llRegionSayTo(llGetOwner(), ROPA_CHANNEL, "ROPA_LISTO");
        }
        else if (llSubStringIndex(message, "APPLY_TEXTURE|") == 0) {
            string datos = llGetSubString(message, 14, -1);
            list parts = llParseString2List(datos, [","], []);
            if (llGetListLength(parts) >= 2) {
                applyTexture((integer)llList2String(parts, 0), llList2String(parts, 1));
            }
        }
    }

    on_rez(integer start_param) { initReceiver(); }
}
