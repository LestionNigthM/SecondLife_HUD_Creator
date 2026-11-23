# Ejemplos de Uso - HUD Creator (v1.1 corregida)

Los mensajes entre scripts se mandan con `llMessageLinked(LINK_SET, 0, "COMANDO", "dato")`.
El número es **0** (la versión anterior usaba `-1002` y no funcionaba).
Estos ejemplos van en un script dentro del mismo objeto que los managers.

## Ejemplo 1: Aplicar textura

```lsl
llMessageLinked(LINK_SET, 0, "APPLY_TEXTURE", "89556747-24cb-43ed-920b-47caed15465f");
```

## Ejemplo 2: Configurar PBR

```lsl
// Metal pulido: mucho metal, poco roughness.
llMessageLinked(LINK_SET, 0, "SET_METALNESS", "1.0");
llMessageLinked(LINK_SET, 0, "SET_ROUGHNESS", "0.1");

// Mate: nada de metal, mucho roughness.
llMessageLinked(LINK_SET, 0, "SET_METALNESS", "0.0");
llMessageLinked(LINK_SET, 0, "SET_ROUGHNESS", "0.9");

// Transparente (modo alpha del PBR).
llMessageLinked(LINK_SET, 0, "SET_ALPHA_MODE", "BLEND");
```

## Ejemplo 3: Reproducir sonido

```lsl
// Cambia "tu-uuid-de-sonido" por el UUID real de un sonido en tu inventario.
llMessageLinked(LINK_SET, 0, "PLAY_SOUND", "tu-uuid-de-sonido");
llMessageLinked(LINK_SET, 0, "SET_VOLUME", "0.5");
llMessageLinked(LINK_SET, 0, "STOP_SOUND", "");
```

## Ejemplo 4: Iniciar animación

```lsl
// Cambia "tu-uuid-de-animacion" por el UUID real de una animación en tu inventario.
// El HUD pide el permiso PERMISSION_TRIGGER_ANIMATION al arrancar: acéptalo.
llMessageLinked(LINK_SET, 0, "START_ANIMATION", "tu-uuid-de-animacion");
llMessageLinked(LINK_SET, 0, "STOP_ANIMATION", "");
```

## Ejemplo 5: Cambiar color

```lsl
// Rojo.
llMessageLinked(LINK_SET, 0, "SET_COLOR", "<1.0, 0.0, 0.0>");
// Medio transparente.
llMessageLinked(LINK_SET, 0, "SET_ALPHA", "0.5");
// Con brillo.
llMessageLinked(LINK_SET, 0, "SET_GLOW", "0.3");
```

## Ejemplo 6: Abrir la tienda desde el HUD

```lsl
llMessageLinked(LINK_SET, 0, "OPEN_STORE", "");
```
