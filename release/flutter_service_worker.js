'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "aee9579bb5ffd15b77e67aee59946a8c",
"assets/AssetManifest.bin.json": "6bd7fdc26b91dfaaf09fd869797e0e73",
"assets/AssetManifest.json": "bf0f798cd3d6e5cc3252a712c982d496",
"assets/assets/icons/Accessories.svg": "2a6cee8ef674c6e5421f172e7cacce2d",
"assets/assets/icons/Address.svg": "482cae5fc5a6e5f53c31bb21f9cae8a4",
"assets/assets/icons/Arrow%2520-%2520Down.svg": "d63a6c9f90c0bfec2462b74e8081ffc7",
"assets/assets/icons/Arrow%2520-%2520Left.svg": "b0178c95f40ca6abcccea2bce3ce38c4",
"assets/assets/icons/Arrow%2520-%2520Right.svg": "2bb9300824633b8beb92fbd8897abb5b",
"assets/assets/icons/Arrow%2520-%2520Up.svg": "0eca929b8073ce4c8c4cf5a56d4a0e01",
"assets/assets/icons/Bag.svg": "3d6872b253693631428f57248df83b5b",
"assets/assets/icons/bag_full.svg": "fce80aaa4be7a75b67119baa641eaf6d",
"assets/assets/icons/Behance.svg": "deea4904ef087695e7d69c5ec62ec74e",
"assets/assets/icons/Bookmark.svg": "5ac947ef310d30b458345e3f8d6af4b8",
"assets/assets/icons/Calender.svg": "a76476d0106c84f1f1ec8e70d35f7020",
"assets/assets/icons/Call.svg": "b409188d7192a5fe6e6b6fc2f8a209fd",
"assets/assets/icons/Camera-add.svg": "111202d08c081b13a01c7c7f6aa4f594",
"assets/assets/icons/Camera-Bold.svg": "861a201a87e921b263c0f96f08a18028",
"assets/assets/icons/card.svg": "0fbcd318614a350505c69737ee9ff50b",
"assets/assets/icons/Card_Pattern.svg": "a6c10f8624ff8fc248c12cd1d8a23f17",
"assets/assets/icons/Cash.svg": "4db30cad04df02f3272b73b0b1db81f2",
"assets/assets/icons/Category.svg": "83bedadff1b411792b0b2190a754bec6",
"assets/assets/icons/Chat-add.svg": "f0f28cd7e8b7bd034ff3936e3ccbae18",
"assets/assets/icons/Chat.svg": "bc67db756016b2d5efe26a9ba515004f",
"assets/assets/icons/Child.svg": "f785030f16ae6d996b394c27bb2c5adc",
"assets/assets/icons/Clock.svg": "2ae9b447f785b786d0f7cc13f7e65fe4",
"assets/assets/icons/Close-Circle.svg": "92750584201af5fa9d0081e495e47efd",
"assets/assets/icons/Close.svg": "35151040b045a54ba4264707a6efa424",
"assets/assets/icons/Coupon.svg": "83fd9f477473270d9bddbcc6fdc0dae8",
"assets/assets/icons/CVV.svg": "d843cbbabcbe9f9f4da0aa629eb2609e",
"assets/assets/icons/Danger%2520Circle.svg": "6e7e430fff0b7cb2c1d62935b397254a",
"assets/assets/icons/Date.svg": "114c701d58e9b940f56882031bcd33e1",
"assets/assets/icons/Delete.svg": "7dc67a67b739abf12f2b3c84336c69f2",
"assets/assets/icons/Delivery.svg": "a9f803f9003d013e4c2b23880ada6e29",
"assets/assets/icons/diamond.svg": "252b34d4a4a27e0422bcc7d49b340448",
"assets/assets/icons/Discount.svg": "dc3fce65b71cb267268f2345fe823844",
"assets/assets/icons/Discount_tag.svg": "43d20207e8e8b85ecb5411e115144671",
"assets/assets/icons/Dislike.svg": "68110b499d4fccb18e6e06fc70d2a460",
"assets/assets/icons/document.svg": "184949442c75ceeb6a7d057dc9b215ce",
"assets/assets/icons/dot.svg": "f9bf3af217ddfb33aaa5474d0471f12b",
"assets/assets/icons/DotsH.svg": "b3166c0569e9b2855ccd504e4a97bcc9",
"assets/assets/icons/DotsV.svg": "e2c719b975ed6bb67d10cff103d26fa8",
"assets/assets/icons/Doublecheck.svg": "7cf9316efb71b58ecdc6166275c471d8",
"assets/assets/icons/Dribbble.svg": "dfac2d297e6d2d5c4827dc728297dcb8",
"assets/assets/icons/Drive.svg": "7813b9744bbfeb346dc0bb8445a60e02",
"assets/assets/icons/Edit%2520Square.svg": "15cc6eff0b30aaa6d1d19587d375c6ec",
"assets/assets/icons/Edit-Bold.svg": "0c80771c4bb414198df955a317c85f2a",
"assets/assets/icons/Emoji.svg": "18f793180b9c4b34919d047028098a9f",
"assets/assets/icons/Facebook.svg": "21247ef09c0bde91367781b8a1f69109",
"assets/assets/icons/FaceId.svg": "21d3df947a5a59ca930dcee1d649a810",
"assets/assets/icons/FAQ.svg": "4bf93ee85282c364b8046af77f057a15",
"assets/assets/icons/Filter.svg": "a0342114cb79b5cc9f4b3a958c0f1ed8",
"assets/assets/icons/Fingerprint.svg": "01a8bb07e402b7c85475765f0d3f37f8",
"assets/assets/icons/Flashlight.svg": "8bf62049bf778404442cef91bb024a53",
"assets/assets/icons/Gift.svg": "3f4d8a3acb176effee2201a0c5d66795",
"assets/assets/icons/Help.svg": "60d6b153e0301ee4a28b9c9de7c4c9b9",
"assets/assets/icons/Image.svg": "6f4c27958e4558c04f64f988778ad2f1",
"assets/assets/icons/info.svg": "25ecbd8a34e907cdde7558e9ab3726a0",
"assets/assets/icons/Instagram.svg": "2a981272313ab565b169de53b771f36b",
"assets/assets/icons/Language.svg": "a4248a8a6e4308364c4fcc2ff6d9ea61",
"assets/assets/icons/Like.svg": "f21a6eeeba41976bbb2d88e5533a8dbd",
"assets/assets/icons/Link.svg": "eeaa36f38bbd8cc2442a9d2dafc9998a",
"assets/assets/icons/Linkedin.svg": "e8c05e63206e6b1e19ee9856c343205d",
"assets/assets/icons/Loading.svg": "10f37efe1d477572e399c90664ffb334",
"assets/assets/icons/Location.svg": "cb1ad1ca63ce294f471c9d2b07c7f2c1",
"assets/assets/icons/Lock.svg": "84871668c425b3d453c9c07a9edb375b",
"assets/assets/icons/Logout.svg": "3437047a2def4b7003e623c82fb92006",
"assets/assets/icons/Man&Woman.svg": "7c766ba1d677c3d9b3143d8581fa79fb",
"assets/assets/icons/Man.svg": "b0bc5a119023b9c188e68af365bf382b",
"assets/assets/icons/Manage-profile.svg": "f1b960c1b7e02b528c4eca9be817d8a4",
"assets/assets/icons/Message.svg": "8bc665df7c2d21baebb0335088790a34",
"assets/assets/icons/miniDown.svg": "96742d60dbe4e4983f25e8cae3ad65a0",
"assets/assets/icons/miniLeft.svg": "91b28bf477ed7458b3d10602c78a97b9",
"assets/assets/icons/miniRight.svg": "1c530b78f629abe3192c47b8e252e1b5",
"assets/assets/icons/miniTop.svg": "35e1635ef245ea41d240db02239dabbb",
"assets/assets/icons/Minus.svg": "91f3832437f8a8fd342e673b6c8fb9c0",
"assets/assets/icons/Mylocation.svg": "02a7b431b41e778c5e1810f243bb3ed9",
"assets/assets/icons/Newcard.svg": "50e9da3822eff4accba030e73da67c51",
"assets/assets/icons/Notification.svg": "fb90504a46709d006109b2d916833251",
"assets/assets/icons/Order.svg": "102c885f33e9dc17248c4320cb71645e",
"assets/assets/icons/Payonline.svg": "ddb6351f1952c24ca0c7dadd67a3ae87",
"assets/assets/icons/Plus1.svg": "082fab37118b5c87ad97218a3c7b1c55",
"assets/assets/icons/Preferences.svg": "b26f8c31b887ed8ac257b7893c26e25e",
"assets/assets/icons/Product.svg": "c050f613012500ad8179104275654e80",
"assets/assets/icons/Profile.svg": "06e07af4a7b9b9b18e0551e20062ce67",
"assets/assets/icons/Request.svg": "1b303cf8876aa84d999608e78f9ed3bb",
"assets/assets/icons/Return.svg": "71d5fd134a9642d13da12f1b38cdfdd8",
"assets/assets/icons/Sale.svg": "d7575e82f0ba870b4ff8e52c003d6517",
"assets/assets/icons/Scan.svg": "443731f739069ceedb6b09e827d100d1",
"assets/assets/icons/Search.svg": "faf1640821c283fd4a3b0b0c867faf8c",
"assets/assets/icons/Send.svg": "e8d1337eb1a24eb46bac5975b810b333",
"assets/assets/icons/Setting.svg": "ed47eb1a5c474af9801bfe5936f04e85",
"assets/assets/icons/Share.svg": "a07230ceaaff01117a3351c2090bd5da",
"assets/assets/icons/Shop.svg": "61c0ff8e6d64a22379ad7df3c5464f05",
"assets/assets/icons/Show.svg": "c22761d2e45e304594f0e17159066e9a",
"assets/assets/icons/Singlecheck.svg": "e132858fc7d8510c9f4654253d859489",
"assets/assets/icons/Sizeguid.svg": "c0c70c222fc287cc6632b54c75ba85e7",
"assets/assets/icons/Sort.svg": "1f036ed3ffc2f6be63e7d8bfdacf8756",
"assets/assets/icons/Standard.svg": "c534f926996d0111afe0d30cad932b13",
"assets/assets/icons/Star-bold.svg": "209ca45311f67c499d368f658fedd0e6",
"assets/assets/icons/Star.svg": "b098fd9ed04d0582b0b0a927f07b9f82",
"assets/assets/icons/Star_filled.svg": "8da656b625dff45a2c48a56c36f84605",
"assets/assets/icons/Stores.svg": "dd8ae6d55c3084baa3bfa2d276d25256",
"assets/assets/icons/Task.svg": "064e2dba0e8598c732c0a090d2dbf409",
"assets/assets/icons/Trackorder.svg": "583d0d4ef6c3f6124f9bfc1b72e95721",
"assets/assets/icons/Twitter.svg": "2d8b6184ad31b892cb473dcffe791411",
"assets/assets/icons/Wallet.svg": "a8b46a29acc5631746899b7ffbb223de",
"assets/assets/icons/Wishlist.svg": "5c3a40ef9eb9ff9755db295486804afd",
"assets/assets/icons/Woman.svg": "8271221148a7895d6b091b47112746eb",
"assets/assets/icons/world_map.svg": "78c374aaf76123d02e879e769181127a",
"assets/assets/images/employee-dashboard.png": "a7be2b2d76ecaefc323a240f9e4c6c92",
"assets/assets/images/Logo.png": "cceefa09d23f0dd5c013bef2f119f3df",
"assets/assets/images/news-dashboard.png": "0732ad9f294c1507b0f0af5df9995392",
"assets/FontManifest.json": "7df10702a8c60a62e6694f43081d46e7",
"assets/fonts/MaterialIcons-Regular.otf": "f6e43115769e3ba2ae248ce63fae99db",
"assets/NOTICES": "b4930585ecf5f4e0ab8a1c4194d8d83a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "83c878235f9c448928034fe5bcba1c8a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "ac55f2c2ca6f1682fd611819c1c45edb",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "40e54742ea26ece2cc21a841d5a8afc0",
"/": "40e54742ea26ece2cc21a841d5a8afc0",
"main.dart.js": "1704b875a3e23b678a2451ade85ac6b4",
"manifest.json": "52f944a65f75fee6c4c56e447d9b05ea",
"version.json": "ca0027bede2d00eafb1b01ef02a83be9"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
