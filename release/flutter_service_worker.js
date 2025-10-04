'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "433d23c436e8e51bf81a939119853764",
"version.json": "ca0027bede2d00eafb1b01ef02a83be9",
"index.html": "7ad6f8a37a25a25af0a577d48702abc4",
"/": "7ad6f8a37a25a25af0a577d48702abc4",
"main.dart.js": "4e8379282c3ee8e696de19acc01cf4bc",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "2be5adb4fcfb413bef3bc9d09cd6fe7d",
"assets/AssetManifest.json": "292f9c2767624cbafe4cee05e21e74bf",
"assets/NOTICES": "609844426f7e43b5239556b3a8fbda04",
"assets/FontManifest.json": "e7d8f75105156c17d3f035e355b8d63e",
"assets/AssetManifest.bin.json": "01e0d48f612f668fa641880abd2fd0df",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "d7d83bd9ee909f8a9b348f56ca7b68c6",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "6ebc7bc5b74956596611c6774d8beb5b",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/squiggly.png": "9894ce549037670d25d2c786036b810b",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/strikethrough.png": "26f6729eee851adb4b598e3470e73983",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/highlight.png": "2fbda47037f7c99871891ca5e57e030b",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/light/underline.png": "a98ff6a28215341f764f96d627a5d0f5",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/squiggly.png": "68960bf4e16479abb83841e54e1ae6f4",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/strikethrough.png": "72e2d23b4cdd8a9e5e9cadadf0f05a3f",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/highlight.png": "2aecc31aaa39ad43c978f209962a985c",
"assets/packages/syncfusion_flutter_pdfviewer/assets/icons/dark/underline.png": "59886133294dd6587b0beeac054b2ca3",
"assets/packages/syncfusion_flutter_pdfviewer/assets/fonts/RobotoMono-Regular.ttf": "5b04fdfec4c8c36e8ca574e40b7148bb",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "f8e5ed2e28003a95cfe094d7c2251b47",
"assets/fonts/MaterialIcons-Regular.otf": "6ec10fa2b09f7070a8f538315d252042",
"assets/assets/images/ic_goto.png": "4f3fabe7bbf3df58a2fed368f2e0e6a9",
"assets/assets/images/Google_Files.png": "f32584e08bd8bdc1133f37905ec36ea9",
"assets/assets/images/Logo.png": "f80e11ca64afd6535aceac2c038687d3",
"assets/assets/images/ic_download.png": "c8da9fc1f8a9bf4ad58239e19d4da587",
"assets/assets/images/ic_send.png": "f3c2a9dea20a5c65dd160eaf9d811996",
"assets/assets/images/employee-dashboard.png": "a7be2b2d76ecaefc323a240f9e4c6c92",
"assets/assets/images/news-dashboard.png": "0732ad9f294c1507b0f0af5df9995392",
"assets/assets/icons/Search.svg": "f7933c688860cc630d85f4ddef242c1e",
"assets/assets/icons/Camera-add.svg": "a7ad3295398c580a47eee86bda860acd",
"assets/assets/icons/Task.svg": "064e2dba0e8598c732c0a090d2dbf409",
"assets/assets/icons/Like.svg": "21d2a93c7430d2226b63a597319a0208",
"assets/assets/icons/Camera-Bold.svg": "40c0bc18c979b6e6985bafe112a5e3ab",
"assets/assets/icons/Flashlight.svg": "7e6de05e659986a882d71108d93ef0e1",
"assets/assets/icons/Doublecheck.svg": "a3015b8b22e605679fc0b87b9d3e9caf",
"assets/assets/icons/Man&Woman.svg": "1e76d777351f5759da3e72928156d1fd",
"assets/assets/icons/Shop.svg": "6cc579b11738cd2d230f734c5843d7cc",
"assets/assets/icons/world_map.svg": "5d9cf73b48573bb186d96567bf3bc2ca",
"assets/assets/icons/Logout.svg": "f463f1cbcac0477cc32953893c1ea5e3",
"assets/assets/icons/Show.svg": "a30d98c15fd80d0da12195eb9fa6b6e0",
"assets/assets/icons/CVV.svg": "7cd5eb0041587339a3080e1fd00bef54",
"assets/assets/icons/Trackorder.svg": "0cfd06731537de6384fbc4bf0fe8fc0c",
"assets/assets/icons/Delivery.svg": "dfc70c38d18344f2cf1203fd1513481d",
"assets/assets/icons/Address.svg": "48c219ea0cb0f11f5a1042a809e06c7c",
"assets/assets/icons/dot.svg": "f55f268609ac1d945bea8c2f3ecd7735",
"assets/assets/icons/Manage-profile.svg": "83e73480264a690d502d72054edd6f5f",
"assets/assets/icons/Lock.svg": "900d707849312cb786a59349329ef9c1",
"assets/assets/icons/Calender.svg": "519f312bcc7e7657d47fef03c8f0a908",
"assets/assets/icons/Discount.svg": "091d6870cb2cdef75f5ac2bdacd7ff52",
"assets/assets/icons/Dislike.svg": "246ee0ef4ed2f475945447ef14100948",
"assets/assets/icons/Instagram.svg": "85df9c81fecacd20761f9edaa45456af",
"assets/assets/icons/Link.svg": "3725d81d95d4c7b6a26be0953b436158",
"assets/assets/icons/Product.svg": "d8a65d7161854b8d8f45b0fcbf802712",
"assets/assets/icons/Order.svg": "7d32862fc35cb93679bf6362e1be11dc",
"assets/assets/icons/Standard.svg": "c7a789a47fac931879d946dab50a1ed2",
"assets/assets/icons/DotsH.svg": "d680d627134a9ed445072afcf1ffaa1c",
"assets/assets/icons/Singlecheck.svg": "a6cb9b3a7b46e0e8b1754629214da482",
"assets/assets/icons/Return.svg": "cb668cd41ff0bda744045a5c908209cb",
"assets/assets/icons/Arrow%2520-%2520Left.svg": "ae0705c7cb75ebc7d5c1f34123cd593a",
"assets/assets/icons/Close-Circle.svg": "9549dc0656cac4ab000a1fe7ced5d990",
"assets/assets/icons/Emoji.svg": "560cb4b5775de159cf5dc95c2db2964a",
"assets/assets/icons/Stores.svg": "5540e0e2541034a8d2f25526e27649d9",
"assets/assets/icons/Plus1.svg": "59596579ccc6a2bfd742082e2e44e735",
"assets/assets/icons/Star_filled.svg": "0ec0ecf88f557340b44f6d607222171f",
"assets/assets/icons/Sale.svg": "d7874b9c06fcf5574049d6b557482e8f",
"assets/assets/icons/Danger%2520Circle.svg": "39caebfcb2d167b7397feba91315929a",
"assets/assets/icons/Wallet.svg": "9ed16eb7157c67d182774c7c34065464",
"assets/assets/icons/Category.svg": "e6b2c8fe8b25f4580dbc1ad0cc5c2293",
"assets/assets/icons/document.svg": "367f9568f0c7ad6f88f0afd2e0bb5363",
"assets/assets/icons/miniDown.svg": "a8c0c7164530f7de8a3922e5a4d2f7ca",
"assets/assets/icons/card.svg": "f377cfcb1187ea0e19486056762f952a",
"assets/assets/icons/info.svg": "62530c25a4262e13fc147f7eba157b0f",
"assets/assets/icons/bag_full.svg": "df8f24a2f48b378ce7dee304d43754b0",
"assets/assets/icons/Wishlist.svg": "f14e0e383768d7bc3ddddf110a217330",
"assets/assets/icons/Close.svg": "717998fab3c2892b6394d7593df14d24",
"assets/assets/icons/Bag.svg": "615e91a7ba7c2052f9e5b290b201fd25",
"assets/assets/icons/Arrow%2520-%2520Down.svg": "c7cc911645096a95c78ef3d4f8888893",
"assets/assets/icons/Child.svg": "f29568a054fa2b440212431575ad9498",
"assets/assets/icons/miniTop.svg": "71bb20df4eb28fc245e592355d1dc8da",
"assets/assets/icons/Image.svg": "d65c2d5f60f54dd3d15ece55a367787f",
"assets/assets/icons/DotsV.svg": "68ed7e21cdf23aef326f8dec46e2c9a5",
"assets/assets/icons/Scan.svg": "ee52a9779b233c409d2dd3791db3bc30",
"assets/assets/icons/Card_Pattern.svg": "da59c879333b53ba1e24c4d57a941b7b",
"assets/assets/icons/Setting.svg": "072edefa8c4f0e699f1d57afd507bb31",
"assets/assets/icons/Loading.svg": "926aac526b5e9be4e7519661adb1fe4f",
"assets/assets/icons/Payonline.svg": "5ee51d781f5d4e5bdf7accb6e99c74f1",
"assets/assets/icons/Message.svg": "d285cb7af743bc7ba26509fa45909d29",
"assets/assets/icons/Discount_tag.svg": "fc3a7fd1448782446e7cfa1df74ed834",
"assets/assets/icons/Chat.svg": "aed365fed79a34ab03121f7cab7486c3",
"assets/assets/icons/Notification.svg": "6ea9ca3f499134d6566807efbf60f51f",
"assets/assets/icons/Send.svg": "eee08afb31307226143c6abde0aa0014",
"assets/assets/icons/Coupon.svg": "d58a2d49795fbe3e8c038e8542153652",
"assets/assets/icons/Preferences.svg": "7106845e0fc04fccb96a13e87ebe7b6c",
"assets/assets/icons/Facebook.svg": "3f2d0c68f43522a4a1b285f76c919e7b",
"assets/assets/icons/FaceId.svg": "07d6b78825a3a744ed89699a4be0010e",
"assets/assets/icons/miniLeft.svg": "3f1ecffa36a92a5453f1b8187c93c0db",
"assets/assets/icons/Star.svg": "e3756fd4afd722a172b8d9f9770a1a0d",
"assets/assets/icons/FAQ.svg": "e39e36426442fc4a42ffe96d4462367e",
"assets/assets/icons/Accessories.svg": "be73af01b01038f3b44d15df43d37699",
"assets/assets/icons/Edit-Bold.svg": "70bfce09128659b50b4d8a9dcd68371d",
"assets/assets/icons/Cash.svg": "0a0296a916cd317d5a0c76500ba8e6cb",
"assets/assets/icons/Woman.svg": "65db0394e47c506b82a2bb5892bf52cc",
"assets/assets/icons/Language.svg": "7d437b21e3e2baa53d182f084b00386b",
"assets/assets/icons/diamond.svg": "6b9904263fed251f8bcfab8050c7cfa5",
"assets/assets/icons/Delete.svg": "3e42f361717b25753dccf69283223ff4",
"assets/assets/icons/Clock.svg": "a18f380b924236927d1dbbb47e208f1b",
"assets/assets/icons/Call.svg": "7daebd238ca2e83c2e7d996d43af04d1",
"assets/assets/icons/Location.svg": "d386baa6180975ca3b1c412213c43817",
"assets/assets/icons/Dribbble.svg": "457afc40d424462547c23eacab702f2f",
"assets/assets/icons/Gift.svg": "a694fd6e54d1a030329023221e1e074b",
"assets/assets/icons/Drive.svg": "7060dcb46927f7a82d62b636c503d5a6",
"assets/assets/icons/Star-bold.svg": "9ef02ca54c9ec0ffe06f0674cd77196e",
"assets/assets/icons/Profile.svg": "7e56a4b92cfb5e87662fd7246f301283",
"assets/assets/icons/Share.svg": "e2e454436bda9f231c8a68f67e2f9c4a",
"assets/assets/icons/Arrow%2520-%2520Up.svg": "4598538bbb0967853115b649d809744d",
"assets/assets/icons/Linkedin.svg": "ce19fb5dcbe0991dcacb545f95025dda",
"assets/assets/icons/Sort.svg": "72d527c3ff66641baba34e060ebc0270",
"assets/assets/icons/Twitter.svg": "cda0971ca01042ec2ca8753469d3cd71",
"assets/assets/icons/Filter.svg": "1c64f687e6c85f9746884e926d6549a3",
"assets/assets/icons/Arrow%2520-%2520Right.svg": "f6b04f78c34a7365e9178739a9442941",
"assets/assets/icons/Mylocation.svg": "d8431a354ed499fa141447d0cd6301bc",
"assets/assets/icons/Sizeguid.svg": "0825894e65e584c282cdf97bbdf153e1",
"assets/assets/icons/Bookmark.svg": "784d807e7f513529bdf913e5eee5c717",
"assets/assets/icons/Date.svg": "0accaba1290e6a5139dd0eadcdec3b0d",
"assets/assets/icons/Help.svg": "228c31b99c04fa09a04824713b555607",
"assets/assets/icons/miniRight.svg": "3720205c7d4ae01d4f6710137e5027bb",
"assets/assets/icons/Man.svg": "0804c4c324e5f63b7ff52a11949c865b",
"assets/assets/icons/Edit%2520Square.svg": "77b337567cee323fb72690cd218cbf17",
"assets/assets/icons/Fingerprint.svg": "81a7ec0dab34604fb2d0048398b54d09",
"assets/assets/icons/Newcard.svg": "6d7e6ad692948e8826bc28032753cbc9",
"assets/assets/icons/Request.svg": "c3b786659a9483bff171d93a716c246a",
"assets/assets/icons/Minus.svg": "63a163ca84a11a87058e55f2468fdb39",
"assets/assets/icons/Behance.svg": "000392aea59f0f8ac9145a43569d943c",
"assets/assets/icons/Chat-add.svg": "95adaf56003db4bd0653fac2ca728b1a",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b"};
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
