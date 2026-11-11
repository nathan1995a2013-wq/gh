const CACHE_NAME='rastro-shell-v2';
const APP_SHELL=['./','./index.html','./manifest.webmanifest','./supabase-config.js','./icons/rastro.svg'];

self.addEventListener('install',event=>{
  event.waitUntil(caches.open(CACHE_NAME).then(cache=>cache.addAll(APP_SHELL)));
  self.skipWaiting();
});

self.addEventListener('activate',event=>{
  event.waitUntil(
    caches.keys()
      .then(keys=>Promise.all(keys.filter(key=>key!==CACHE_NAME).map(key=>caches.delete(key))))
      .then(()=>self.clients.claim())
  );
});

self.addEventListener('fetch',event=>{
  const request=event.request;
  const url=new URL(request.url);
  if(request.method!=='GET'||url.origin!==self.location.origin)return;

  event.respondWith((async()=>{
    const cache=await caches.open(CACHE_NAME);
    if(request.mode==='navigate'){
      try{
        const response=await fetch(request);
        if(response.ok)await cache.put('./index.html',response.clone());
        return response;
      }catch{
        return await cache.match(request)||await cache.match('./index.html');
      }
    }
    if(url.pathname.endsWith('/supabase-config.js')){
      try{
        const response=await fetch(request);
        if(response.ok)await cache.put(request,response.clone());
        return response;
      }catch{
        return await cache.match(request)||await cache.match('./supabase-config.js');
      }
    }
    const cached=await cache.match(request);
    if(cached)return cached;
    const response=await fetch(request);
    if(response.ok)await cache.put(request,response.clone());
    return response;
  })());
});
