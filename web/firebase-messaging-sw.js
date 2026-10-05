// Shows push notifications while the web app is closed or in the background, and opens the right page on tap.
// The config must match lib/app/notifications/firebase_options.dart.
importScripts('https://www.gstatic.com/firebasejs/11.0.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/11.0.2/firebase-messaging-compat.js');

// Where a tap on a notification leads. Mirrors DeepLink.fromPushData (lib/app/notifications/deep_link.dart): the backend
// sends `type` and ids (`jobId`), and an explicit `route` wins if a message ever has one.
function routeFor(data) {
  const route = data.route || data.deepLink || data.link;
  if (route) return route;
  switch ((data.type || '').toUpperCase()) {
    case 'JOB_NEW':
    case 'JOB_REGISTERED_BY_OTHER':
    case 'JOB_CANCELLED':
    case 'JOB_NOT_CLOSED':
      return data.jobId ? '/jobs/' + data.jobId : '/jobs';
    case 'JOB_CHAT_MESSAGE':
      return data.jobId ? '/jobs/' + data.jobId + '/chat' : '/jobs';
    case 'TRANSACTION_CREATED':
      return '/status';
    default:
      return '/';
  }
}
}

// Registered BEFORE firebase.messaging() on purpose: the Firebase SDK adds its own click handler when it starts, which
// closes the notification and only opens a window for messages with a link (fcmOptions.link). Ours carries none, so
// with the SDK's handler first a tap just dismissed the notification. Stopping propagation here keeps the SDK's from
// also running.
self.addEventListener('notificationclick', (event) => {
  event.stopImmediatePropagation();
  event.notification.close();
  const raw = event.notification.data || {};
  const data = (raw.FCM_MSG && raw.FCM_MSG.data) || raw;
  const target = new URL(routeFor(data), self.location.origin).href;

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((windows) => {
      for (const w of windows) {
        if (w.url.startsWith(self.location.origin) && 'focus' in w) {
          // An open app: focus it and send it there. navigate() can fail for pages the worker doesn't control.
          return w.focus().then(() => w.navigate(target)).catch(() => clients.openWindow(target));
        }
      }
      return clients.openWindow(target);
    }),
  );
});

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
