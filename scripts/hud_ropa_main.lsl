// ============================================
// HUD Ropa Main — CORREGIDO (v1.1)
// ============================================
// Qué estaba mal:
// 1. La lista de texturas traía UUIDs FALSOS ("texture-uuid-alg-001").
//    Eso no es un UUID válido: al aplicarlo no pasaba nada. La lista
//    ahora empieza vacía; agrega tus texturas reales con su UUID
//    (clic derecho en la textura en tu inventario → Copiar UUID).
// 2. El HUD nunca fijaba la prenda destino (gCurrentObject siempre era
//    NULL_KEY), así que SELECT_TEXTURE no aplicaba nada.
// 3. applyTextureToObject usaba llMessageLinked(objeto, ...), pero
//    llMessageLinked solo habla con scripts del MISMO objeto, no con
//    otra prenda. Ahora HUD y prenda hablan por el canal -12350 con
//    llRegionSayTo / listen (igual que tu HUD por partes del LYS0005).
//
// Cómo funciona ahora:
// - La prenda (con ropa_receiver.lsl) anuncia "ROPA_LISTO" al
//   rezzarse o al ponérsela, y el HUD la guarda como destino.
// - El HUD también puede buscarla: al arrancar pregunta "ROPA_BUSCAR".
// - Los botones del HUD mandan SELECT_TEXTURE con el número de producto
//   (por llMessageLinked interno, número 0) y este script lo reenvía
//   a la prenda por el canal -12350.
//
// Formato de cada producto (4 datos): categoría, nombre, UUID, precio.

integer ROPA_CHANNEL = -12350;
key gOwnerKey;
integer gListenHandle = 0;
key gCurrentObject = NULL_KEY;
integer gCurrentFace = 0; // Cara de la prenda (0-9). Por ahora siempre 0.
list gTextures = [
    // AGREGA AQUÍ TUS TEXTURAS REALES. Ejemplo (quítales // para activar):
    // "Algodón", "Camiseta Blanca", "00000000-0000-0000-0000-000000000000", 250,
    // "Seda", "Blusa Roja", "00000000-0000-0000-0000-000000000000", 800
];

initHUD() {
    gOwnerKey = llGetOwner();
    llOwnerSay("HUD de Ropa inicializado");
    loadTextures();
    if (gListenHandle) llListenRemove(gListenHandle);
    gListenHandle = llListen(ROPA_CHANNEL, "", NULL_KEY, "");
    buscarPrenda();
}

loadTextures() {
    integer total = llGetListLength(gTextures) / 4;
    llOwnerSay("Texturas cargadas: " + (string)total + " productos");
}

buscarPrenda() {
    // Pregunta en toda la región si hay una prenda con receptor.
    llRegionSay(ROPA_CHANNEL, "ROPA_BUSCAR");
}

applyTextureToObject(key object, integer face, string texture_uuid) {
    llRegionSayTo(object, ROPA_CHANNEL, "APPLY_TEXTURE|" + (string)face + "," + texture_uuid);
    llOwnerSay("Textura aplicada: " + texture_uuid);
}

default {
    state_entry() { initHUD(); }

    listen(integer channel, string name, key id, string message) {
        if (channel != ROPA_CHANNEL) return;
        // Solo aceptar mensajes de tus propios objetos.
        if (llGetOwnerKey(id) != gOwnerKey) return;
        if (message == "ROPA_LISTO") {
            gCurrentObject = id;
            llOwnerSay("Prenda detectada y lista.");
        }
    }

    link_message(integer s, integer n, string str, key id) {
        if (n == 0 && str == "SELECT_TEXTURE") {
            integer index = (integer)id;
            integer total = llGetListLength(gTextures) / 4;
            if (index >= 0 && index < total) {
                string texture_uuid = llList2String(gTextures, index * 4 + 2);
                string texture_name = llList2String(gTextures, index * 4 + 1);
                llOwnerSay("Seleccionada: " + texture_name);
                if (texture_uuid == "" || (key)texture_uuid == NULL_KEY) {
                    llOwnerSay("Ese producto no tiene un UUID real todavía.");
                    return;
                }
                if (gCurrentObject != NULL_KEY) {
                    applyTextureToObject(gCurrentObject, gCurrentFace, texture_uuid);
                } else {
                    llOwnerSay("No hay prenda detectada. Ponte la prenda con el receptor y se detectará sola.");
                    buscarPrenda();
                }
            }
        }
    }

    on_rez(integer start_param) { initHUD(); }
}
