'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "472cbe398b2add0677331a7f4e94b916",
"assets/AssetManifest.bin.json": "833e9be8057b036e8ca84b9446de394c",
"assets/AssetManifest.json": "4265af090125cbaba0479a030de8408c",
"assets/assets/icons/aptitud-fisica.png": "a54836f155198994a456a5ff71d52817",
"assets/assets/icons/estirado.png": "f3637fa643a60b6b48a1dcf507c173e3",
"assets/assets/icons/nutrition.png": "83c22bf08147710a5503b828139a7a54",
"assets/assets/icons/pills.png": "5fe2cc749f9ad934a74fac0bcc781281",
"assets/assets/icons/psychology.png": "bd5fe466ef7187492471cf682b4a3b83",
"assets/assets/icons/telemedicine.png": "829bfa4a3a2d4f52958e81b98a4d7219",
"assets/assets/images/avatar_female.png": "5261bd492ef52666d60258a067239007",
"assets/assets/images/avatar_male.png": "6b4fd241ab4046ff41ca5ace665f44a7",
"assets/assets/images/doctor_female_1.png": "14b46f838d540fa0c7fe1cd083fbb698",
"assets/assets/images/doctor_female_10.png": "fc64ff9d6d3e602ace5be4d6bfd4a3ce",
"assets/assets/images/doctor_female_2.png": "00e4e3b9f64abddff0cbfc6726c8747d",
"assets/assets/images/doctor_female_3.png": "2f8c3e1581a066cabf3fcba4bd8f0dd7",
"assets/assets/images/doctor_female_4.png": "f6f30e85fe39cd136d09e26b9e908834",
"assets/assets/images/doctor_female_5.png": "b8aef9ceaa78b3860200020d15a42af0",
"assets/assets/images/doctor_female_6.png": "ad15be98d2425ecd8f6d2b1599e551e9",
"assets/assets/images/doctor_female_7.png": "1b2a2d814448dae9f7da40763cefcba6",
"assets/assets/images/doctor_female_8.png": "cd7a9e0b595a130ebee32c330fd914b5",
"assets/assets/images/doctor_female_9.png": "fa7db743046e237dad15317e72451c47",
"assets/assets/images/doctor_male_1.png": "3c6d50f88ebae561bdc5ec88ee9caa2a",
"assets/assets/images/doctor_male_10.png": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/images/doctor_male_2.png": "010979a50c8b1efd0b433d7a4cd7b08c",
"assets/assets/images/doctor_male_3.png": "3ed9bba93b5df41e7edf00be8f9489fb",
"assets/assets/images/doctor_male_4.png": "524a1e2b0f6a7361b3b000d0454f2182",
"assets/assets/images/doctor_male_5.png": "be09c301d549672b3f9137a3cdabf139",
"assets/assets/images/doctor_male_6.png": "1167a5bf34796961dfe34308bb8d80a6",
"assets/assets/images/doctor_male_7.png": "c2336e2f24e46175166fc6187cb652f2",
"assets/assets/images/doctor_male_8.png": "c0d0a2a1957cf2d4e4cc5bf5519d4b67",
"assets/assets/images/doctor_male_9.png": "d1f7459beb4a5a449d791a02039d1ec0",
"assets/assets/images/logo.svg": "2e0b7f24877228ed3dee79e964ffdcd8",
"assets/assets/images/logo_azul.png": "f929d2f6052a7c1e68ae32bda3ea44d7",
"assets/assets/images/logo_blanco.png": "0e23c58290927fbd73695a87946a2af9",
"assets/assets/meds/bevacizumab.png": "849b99b0105f85f0f679cdd140eb6cb4",
"assets/assets/meds/bortezomib.png": "47a42b00a25e86a228c6b20d5041f75f",
"assets/assets/meds/cisplatino.png": "ce16d179960ef6f0f3482d8b25612ecc",
"assets/assets/meds/cyclophosphamide.png": "a6ac45102aabf962fcf4eea58547450d",
"assets/assets/meds/docetaxel.png": "f633fe307e4b936b8d63917fd1a7cb05",
"assets/assets/meds/doxorrubicina.png": "29629d02a607ad90af0cad58f5cab18a",
"assets/assets/meds/erlotinib.png": "13093642d5f5727fc8e941ed384b0ef2",
"assets/assets/meds/fluorouracilo.png": "9c8867bf3da29aae6d501646679147a3",
"assets/assets/meds/imatinib.png": "58af7df4e080e4233f536922f89185ef",
"assets/assets/meds/lapatinib.png": "85a7550f07bbadc9ca8a5aaede9ca438",
"assets/assets/meds/lenalidomida.png": "ef21cf1d543a82c262113952cd54dae1",
"assets/assets/meds/leucovorina.png": "514c8ccb96280cc94bf4da3a00d2d23c",
"assets/assets/meds/metotrexato.png": "b35c2fe90ae10046ef1d220f2a4d026c",
"assets/assets/meds/oxaliplatino.png": "1c7441743ec760777db531df5e98582f",
"assets/assets/meds/paclitaxel.png": "d98c45f318ee861926e42cbe69cd4556",
"assets/assets/meds/paracetamol.png": "bb3f566ea066078777cea385c6ff9477",
"assets/assets/meds/rituximab.png": "6f9c6c440c38e2ebf90771bcd6e45354",
"assets/assets/meds/tamoxifeno.png": "d3940c490326beb5c5d0b37ace3e846c",
"assets/assets/meds/trastuzumab.png": "1ff4127da9167eb8ab91168f98320a51",
"assets/assets/meds/vincristina.png": "b99ff5464c650d4ea943de7e437b66f8",
"assets/assets/payment/masterdcard.png": "041e9a1ab8186753bbfdad881b851835",
"assets/assets/payment/plin.png": "b869049125e3fdb005bc36217adb88a7",
"assets/assets/payment/visa.png": "db00f7b727ab3fe79d0d027d2e33be97",
"assets/assets/payment/yape.png": "25eae5baf1e0dafd4590716817316ef8",
"assets/assets/submodules/group_support.png": "f57bdf339b3b45fee55585c367ec8f29",
"assets/assets/submodules/psychology.png": "c6c367de0bac18f556e4549485012dcf",
"assets/assets/submodules/psy_eval.png": "8d776be8771b4c5ab09ff06f6a3206ce",
"assets/assets/submodules/spiritual_support.png": "8feec3bf134b9187db9021a1177f3a0f",
"assets/FontManifest.json": "5a32d4310a6f5d9a6b651e75ba0d7372",
"assets/fonts/MaterialIcons-Regular.otf": "4651b7664c66f58de4645af2c0530bfe",
"assets/NOTICES": "d7327b739e703ba5c47914c7d386d454",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/font_awesome_flutter/lib/fonts/fa-brands-400.ttf": "00a0d5a58ed34a52b40eb372392a8b98",
"assets/packages/font_awesome_flutter/lib/fonts/fa-regular-400.ttf": "3ca5dc7621921b901d513cc1ce23788c",
"assets/packages/font_awesome_flutter/lib/fonts/fa-solid-900.ttf": "e1cfafab040d06d51a5de93eb05c87b4",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "e14ed6204a0c730df261f763451721d1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "eedfe9417fcb2383ed25afda2fa2d92f",
"/": "eedfe9417fcb2383ed25afda2fa2d92f",
"main.dart.js": "7bfa6c4bfbe6152552fa444c404e214d",
"manifest.json": "78d68c752481ce0c1039747180ccd3e8",
"version.json": "28ee0d31aba675d526bc1f20777dbdef"};
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
