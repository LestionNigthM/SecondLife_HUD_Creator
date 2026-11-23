# Guía de Usuario - HUD Creator (v1.1 corregida)

## Instalación

1. Crea un cubo en un sandbox (o en tu tierra). Primero se prueba como
   objeto normal en el suelo, no como HUD todavía.
2. Mete **únicamente** los 7 scripts del núcleo:
   - `config.lsl`
   - `hud_main.lsl`
   - `texture_manager.lsl`
   - `pbr_material.lsl`
   - `sound_manager.lsl`
   - `animation_controller.lsl`
   - `color_controller.lsl`
3. Si el editor de Second Life marca un error en rojo al guardar un
   script, ese script no compiló: anota cuál y no sigas con él.
4. Cuando el núcleo funcione, adjunta el cubo como HUD.

No copies los 28 scripts juntos: son varios sistemas separados y los
extras (tienda, cupones, base de datos, web) se prueban uno por uno
después, solo si los necesitas.

## Comandos

- `/hud menu` - Menú principal (también se abre tocando el HUD)

## Uso

1. Toca el HUD (o escribe `/hud menu`) para abrir el menú.
2. Elige una opción: Texturas, Materiales PBR, Sonidos, Animaciones
   o Color. Cada una abre su submenú.
3. Para probar con tus propios sonidos y animaciones, pon sus UUIDs
   en `DEMO_SOUND` y `DEMO_ANIM`, arriba de `hud_main.lsl`
   (clic derecho en el sonido o la animación en tu inventario →
   Copiar UUID).
4. La primera vez que uses una animación, el visor te pedirá el
   permiso de animación: acéptalo.
5. Para cambiar los valores por defecto (color, alpha, volumen,
   metalness, roughness), edita `config.lsl`: los demás scripts
   reciben los valores solos al arrancar.

## Sistema de ropa (para LYS)

Es un sistema aparte del HUD principal:

- `hud_ropa_main.lsl` - El HUD con la lista de texturas.
- `ropa_receiver.lsl` - Va dentro de la prenda, recibe la textura
  y la aplica.
- `button_ropa.lsl`, `category_button.lsl`, `control_button.lsl` -
  Botones del HUD de ropa.

1. En `hud_ropa_main.lsl`, agrega tus texturas reales: cada producto
   son 4 datos (categoría, nombre, UUID de la textura, precio).
2. Mete `ropa_receiver.lsl` en la prenda. Al ponértela, la prenda
   se anuncia sola y el HUD la detecta.
3. Cada parte de un vestido (top, corset, falda) lleva su propio
   receptor, igual que el HUD por partes del LYS0005.

Los archivos `*_pro.lsl` son variantes del mismo sistema: no instales
las dos versiones a la vez, quédate con una.

## Tienda en el HUD

El botón "Ver tienda" abre https://lysstore.com con `llLoadURL`.
La sincronización web y con base de datos están desactivadas por
defecto: necesitan un servidor real, que se configurará cuando el
dominio lysstore.com ya esté funcionando.
