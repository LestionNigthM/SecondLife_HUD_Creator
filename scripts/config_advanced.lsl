// ============================================
// Advanced Configuration
// ============================================
// Database
string DB_SERVER_URL = "https://your-server.com/sl-api/database.php";
string DB_API_KEY = "your-api-key";
integer DB_SYNC_INTERVAL = 300;

// Web Sync
string WEB_SYNC_URL = "https://your-server.com/sl-api/sync.php";
string WEB_API_KEY = "your-web-api-key";
integer WEB_SYNC_INTERVAL = 600;

// E-commerce
string ECOMMERCE_PLATFORM = "woocommerce";
string ECOMMERCE_API_URL = "https://your-store.com/wp-json/wc/v3";
string ECOMMERCE_CONSUMER_KEY = "ck_your_key";
string ECOMMERCE_CONSUMER_SECRET = "cs_your_secret";

// Coupons
list COUPON_CODES = ["WELCOME10", "SUMMER20", "VIP25"];
list COUPON_DISCOUNTS = [10, 20, 25];
list COUPON_EXPIRY_DAYS = [30, 60, 90];
list COUPON_MAX_USES = [100, 50, 25];

// Payments
integer PAYMENT_TIMEOUT = 60;
float TAX_RATE = 0.10;
string CURRENCY = "L$";
integer MAX_CART_ITEMS = 50;

// Social
string SL_GROUP_NAME = "My Store Customers";
string SL_GROUP_UUID = "";
boolean AUTO_INVITE_TO_GROUP = TRUE;
boolean SHARE_PURCHASES = TRUE;

// Reviews
integer MAX_RATING = 5;
integer MIN_REVIEW_LENGTH = 10;
integer REVIEW_APPROVAL_REQUIRED = TRUE;
integer VERIFIED_PURCHASE_REQUIRED = TRUE;

// Lighting
list LIGHT_PROFILES = ["cotton", "silk", "leather", "metal"];
list LIGHT_COTTON = [0.8, 0.8, 0.8, 0.9, 0.9, 0.9, 0.0];
list LIGHT_SILK = [0.7, 0.6, 0.8, 0.8, 0.7, 0.9, 0.1];
list LIGHT_LEATHER = [0.6, 0.5, 0.4, 0.7, 0.6, 0.5, 0.0];
list LIGHT_METAL = [0.4, 0.4, 0.5, 0.6, 0.6, 0.7, 0.0];

// Catalog
integer CATALOG_ITEMS_PER_PAGE = 12;
integer CATALOG_MAX_PAGES = 10;
list CATALOG_SORT_OPTIONS = ["name_asc", "name_desc", "price_asc", "price_desc"];

// HUD
integer HUD_CHANNEL = -9999;
integer HUD_ROWS = 4;
integer HUD_COLS = 5;
float HUD_BUTTON_SIZE = 0.12;
float HUD_BUTTON_SPACING = 0.02;
