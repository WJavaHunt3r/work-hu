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

// Registered BEFORE firebase.messaging() on purpose: the Firebase SDK adds its own click handler when it starts, which
// closes the notification and only opens a window for messages with a link (fcmOptions.link). Ours carries none, so
// with the SDK's handler first a tap just dismissed the notification. Stopping propagation here keeps the SDK's from
// also running.
self.addEventListener('notificationclick', (event) => {
  event.stopImmediatePropagation();
  event.notification.close();
  const raw = event.notification.data || {};
  const data = (raw.FCM_MSG && raw.FCM_MSG.data) || raw;
  const route = routeFor(data);

  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(async (windows) => {
      const app = windows.find((w) => w.url.startsWith(self.location.origin));
      if (app) {
        // The app is open: tell it where to go (it navigates itself). WindowClient.navigate() only works for pages
        // this worker controls, and the app's window is controlled by Flutter's own worker, so it was rejected.
        app.postMessage({ type: 'dukapp-open', route });
        try {
          await app.focus();
        } catch (e) {
          // focus() isn't allowed everywhere; the message has been sent anyway
        }
        return;
      }
      // The app is closed: open it straight at the page
      return clients.openWindow(new URL(route, self.location.origin).href);
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
