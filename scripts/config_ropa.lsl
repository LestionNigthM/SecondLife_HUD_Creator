// ============================================
// Configuración para HUD de Ropa
// ============================================
string HUD_NAME = "HUD Creator - Tienda de Ropa";
string HUD_VERSION = "2.0";

list CATEGORIAS = [
    "Algodón", "Seda", "Cuero", "Poliéster", "Lino",
    "Encaje", "Piel", "Jeans", "Deportivo", "Formal"
];

list SUBCATEGORIAS = [
    ["Camisetas", "Camisas", "Pantalones", "Vestidos", "Faldas"],
    ["Blusas", "Vestidos", "Pijamas", "Ropa Interior", "Pañuelos"],
    ["Chaquetas", "Pantalones", "Faldas", "Botines", "Cinturones"],
    ["Camisetas", "Pantalones", "Chándales", "Abrigos", "Trajes"],
    ["Camisas", "Pantalones", "Vestidos", "Faldas", "Trajes"],
    ["Ropa Interior", "Medias", "Guantes", "Detalles", "Velos"],
    ["Abrigos", "Chaquetas", "Pantalones", "Botines", "Accesorios"],
    ["Pantalones", "Faldas", "Chaquetas", "Vestidos", "Shorts"],
    ["Camisetas", "Pantalones", "Zapatillas", "Chándales", "Leggings"],
    ["Trajes", "Vestidos", "Camisas", "Pantalones", "Chaquetas"]
];

list FACES_ROPA = [
    "head", "upper_torso", "lower_torso", "left_arm", "right_arm",
    "left_leg", "right_leg", "hands", "feet", "pelvis"
];

float IMPUESTO = 0.10;
integer DESCUENTO_VIP = 15;
integer DESCUENTO_GRUPO = 10;

list COLORES_DISPONIBLES = [
    "Blanco", "Negro", "Rojo", "Azul", "Verde", "Amarillo",
    "Rosa", "Morado", "Naranja", "Gris", "Beige", "Marrón"
];

list COLORES_HEX = [
    <1.0, 1.0, 1.0>, <0.0, 0.0, 0.0>, <1.0, 0.0, 0.0>, <0.0, 0.0, 1.0>,
    <0.0, 1.0, 0.0>, <1.0, 1.0, 0.0>, <1.0, 0.5, 0.8>, <0.5, 0.0, 0.8>,
    <1.0, 0.5, 0.0>, <0.5, 0.5, 0.5>, <0.9, 0.85, 0.7>, <0.5, 0.25, 0.0>
];

integer HUD_CHANNEL = -9999;
integer HUD_FILAS = 4;
integer HUD_COLUMNAS = 5;
float HUD_TAMANO_BOTON = 0.12;
float HUD_SEPARACION = 0.02;
