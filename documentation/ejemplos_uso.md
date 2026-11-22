# Ejemplos de Uso - HUD Creator

## Ejemplo 1: Aplicar textura
```lsl
llMessageLinked(LINK_ALL_OTHERS, -1002, "APPLY_TEXTURE", "texture-uuid-123");

## Ejemplo 2: Configurar PBR
llMessageLinked(LINK_ALL_OTHERS, -1002, "SET_METALNESS", "0.8");
llMessageLinked(LINK_ALL_OTHERS, -1002, "SET_ROUGHNESS", "0.2");

Ejemplo 3: Reproducir sonido
llMessageLinked(LINK_ALL_OTHERS, -1002, "PLAY_SOUND", "sound-uuid-456");

Ejemplo 4: Iniciar animación
llMessageLinked(LINK_ALL_OTHERS, -1002, "START_ANIMATION", "animation-uuid-789");

Ejemplo 5: Cambiar color
llMessageLinked(LINK_ALL_OTHERS, -1002, "SET_COLOR", "<1.0,0.0,0.0>");
