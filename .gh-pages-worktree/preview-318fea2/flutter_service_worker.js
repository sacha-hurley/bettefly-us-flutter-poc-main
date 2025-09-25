self.addEventListener("install",(e)=>{self.skipWaiting();});
self.addEventListener("activate",(event)=>{event.waitUntil((async()=>{try{await self.clients.claim();await self.registration.unregister();}catch(e){}})());});
