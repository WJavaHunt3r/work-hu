// Shows push notifications while the web app is closed or in the background, and opens the right page on tap.
// The config must match lib/app/notifications/firebase_options.dart.
importScripts('https://www.gstatic.com/firebasejs/11.0.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/11.0.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyBrqSUmLzHJARi9PX-hisBq0NGmqintxYM',
  authDomain: 'dukapp-494509.firebaseapp.com',
  projectId: 'dukapp-494509',
  storageBucket: 'dukapp-494509.firebasestorage.app',
  messagingSenderId: '470140408680',
  appId: '1:470140408680:web:6235683a7eaf8cc8d3fcdd',
});

const messaging = firebase.messaging();

// Messages with a `notification` payload are displayed by the SDK itself. Data-only messages are shown here.
messaging.onBackgroundMessage((payload) => {
  if (payload.notification) return;
  const data = payload.data || {};
  if (!data.title) return;
  self.registration.showNotification(data.title, {
    body: data.body || '',
    icon: '/icons/Icon-192.png',
    data,
  });
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const data = (event.notification.data && (event.notification.data.FCM_MSG ? event.notification.data.FCM_MSG.data : event.notification.data)) || {};
  const route = data.route || data.deepLink || data.link || '/';
  const target = new URL(route, self.location.origin).href;

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((windows) => {
      for (const w of windows) {
        if ('focus' in w && w.url.startsWith(self.location.origin)) {
          w.navigate(target);
          return w.focus();
        }
      }
      return clients.openWindow(target);
    }),
  );
});
