# Referencia de la API - HUD Creator (v1.1 corregida)

## Cómo se comunican los scripts

- **Entre scripts del mismo objeto:** `llMessageLinked(LINK_SET, 0, "COMANDO", "dato")`.
  El número es **0**. La documentación anterior decía `-1002`, pero ningún
  script escuchaba ese número: los managers solo reaccionan al 0.
- **Menús:** `llDialog` en el canal `-9999`. El diálogo devuelve el **texto**
  del botón (por ejemplo `"Color"`), no un número.
- **Comandos por chat:** `/hud menu` (también abre el menú tocando el HUD).
- **Sistema de ropa (HUD y prenda son objetos distintos):** canal `-12350`
  con `llRegionSayTo` / `listen`. La prenda anuncia `ROPA_LISTO` y el HUD
  le manda `APPLY_TEXTURE|cara,uuid`.
- **Configuración:** `config.lsl` manda los valores por defecto al arrancar
  con mensajes `CONFIG_COLOR`, `CONFIG_ALPHA`, `CONFIG_VOLUME`,
  `CONFIG_METALNESS`, `CONFIG_ROUGHNESS` y `CONFIG_TEXTURE`.

## Funciones principales

### Texturas (`texture_manager.lsl`)
- `APPLY_TEXTURE` (UUID) - Aplica textura
- `REMOVE_TEXTURE` - Quita textura
- `SET_REPEAT` (`<u,v,0>`) - Ajusta repetición
- `SET_OFFSET` (`<u,v,0>`) - Ajusta offset
- `SET_ROTATION` (grados) - Ajusta rotación

### PBR (`pbr_material.lsl`)
- `SET_METALNESS` (0.0-1.0) - Metalness
- `SET_ROUGHNESS` (0.0-1.0) - Roughness
- `SET_EMISSIVE` (0.0-1.0) - Intensidad emisiva
- `SET_EMISSIVE_COLOR` (`<r,g,b>`) - Color emisivo
- `SET_ALPHA_MODE` (`OPAQUE` / `BLEND` / `MASK`) - Modo alpha del PBR
- El PBR usa `llSetLinkPrimitiveParams` con `PRIM_GLTF_*`. La función
  `llSetMaterialParam` no existe en LSL.

### Sonidos (`sound_manager.lsl`)
- `PLAY_SOUND` (UUID) - Reproduce (el sonido debe estar en el inventario)
- `STOP_SOUND` - Detiene
- `SET_VOLUME` (0.0-1.0) - Volumen
- `SET_RADIUS` (metros) - Radio del sonido
- `SET_FALLOFF` (0.0-1.0) - Caída del sonido

### Animaciones (`animation_controller.lsl`)
- `START_ANIMATION` (UUID) - Inicia (la animación debe estar en el inventario)
- `STOP_ANIMATION` - Detiene la animación actual
- `STOP_ALL_ANIMATIONS` - Detiene la animación actual
- `SET_SPEED` (0.1-2.0) - Solo reinicia la animación: LSL no tiene control
  de velocidad de animaciones
- El script pide `PERMISSION_TRIGGER_ANIMATION` al arrancar. Sin ese
  permiso, las animaciones no se reproducen.

### Color (`color_controller.lsl`)
- `SET_COLOR` (`<r,g,b>`) - Color
- `SET_ALPHA` (0.0-1.0) - Transparencia
- `SET_GLOW` (0.0-1.0) - Brillo

### Ropa (`hud_ropa_main.lsl` + `ropa_receiver.lsl`)
- `SELECT_TEXTURE` (número de producto) - El HUD lo manda por mensaje
  interno y `hud_ropa_main.lsl` lo reenvía a la prenda por el canal -12350.
- Cada producto son 4 datos: categoría, nombre, UUID de la textura, precio.
  Los UUIDs deben ser reales (clic derecho en la textura → Copiar UUID).
- La cara de la prenda es un número del 0 al 9. Por ahora siempre 0.

### Web (`web_sync.lsl` + `database_connector.lsl`)
- `OPEN_STORE` - Abre la tienda con `llLoadURL` (https://lysstore.com)
- `SYNC_WEB` / `SYNC_DB` - Sincronización manual. Desactivada por defecto:
  hay que poner la URL real del servidor en `WEB_SYNC_URL` / `DB_SERVER_URL`.
