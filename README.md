# Laravel Web Push Notifications

* pure javascript and jquery

# Dependencies

Node library 'package.json'
- "axios": "^0.18.1",
- "bootstrap-sass": "^3.4.1",
- "jquery": "^3.4.1",
- "laravel-echo": "^1.5.4",
- "pusher-js": "^4.4.0",

Composer library 'composer.json'
- "laravel-notification-channels/webpush": "dev-master#93cd1df5e43ff61a1a4d68229ec1908089114a7a",
- "pusher/pusher-php-server": "^3.0"



# Code

resource/js/app.js
```javascript

import './bootstrap'

require("./main")


```

resource/js/bootstrap.js

```javascript
window._ = require('lodash');

import axios from 'axios'
import Pusher from 'pusher-js'
import Echo from 'laravel-echo'

window.Pusher = Pusher
window.Popper = require('popper.js').default;
window.$ = window.jQuery = require('jquery');

require('bootstrap');


// Configure Laravel Echo
const { key, cluster } = window.Laravel.pusher
if (key) {
  window.Echo = new Echo({
    broadcaster: 'pusher',
    key: key,
    cluster: cluster,
    forceTLS: true
  })

  axios.interceptors.request.use(
    config => {
      config.headers['X-Socket-ID'] = window.Echo.socketId()
      return config
    },
    error => Promise.reject(error)
  )
}

window.axios = axios

```

resource/js/main.js
```javascript

import axios from 'axios'

var NOTIF = {
    /**
     * Register the service worker.
     */
    loading: false,
    isPushEnabled: false,
    pushButtonDisabled: true,
    registerServiceWorker: function () {
        if (!('serviceWorker' in navigator)) {
            console.log('Service workers aren\'t supported in this browser.')
            return
        }

        navigator.serviceWorker.register('/sw.js')
            .then(() => this.initialiseServiceWorker())
    },

    initialiseServiceWorker: function () {
        if (!('showNotification' in ServiceWorkerRegistration.prototype)) {
            console.log('Notifications aren\'t supported.')
            return
        }

        if (Notification.permission === 'denied') {
            console.log('The user has blocked notifications.')
            return
        }

        if (!('PushManager' in window)) {
            console.log('Push messaging isn\'t supported.')
            return
        }

        navigator.serviceWorker.ready.then(registration => {
            registration.pushManager.getSubscription()
                .then(subscription => {
                    this.pushButtonDisabled = false

                    if (!subscription) {
                        return
                    }

                    this.updateSubscription(subscription)

                    this.isPushEnabled = true
                })
                .catch(e => {
                    console.log('Error during getSubscription()', e)
                })
        })
    },

    /**
     * Subscribe for push notifications.
     */
    subscribe:function() {
        HELPER.statusStart("Loading ...");
        navigator.serviceWorker.ready.then(registration => {
            const options = { userVisibleOnly: true }
            const vapidPublicKey = window.Laravel.vapidPublicKey

            if (vapidPublicKey) {
                options.applicationServerKey = this.urlBase64ToUint8Array(vapidPublicKey)
            }

            registration.pushManager.subscribe(options)
                .then(subscription => {
                    this.isPushEnabled = true
                    this.pushButtonDisabled = false

                    this.updateSubscription(subscription)
                    console.log("Subscribe");
                    HELPER.statusEnd("Subscribe");
                })
                .catch(e => {
                    if (Notification.permission === 'denied') {
                        console.log('Permission for Notifications was denied')
                        this.pushButtonDisabled = true
                    } else {
                        console.log('Unable to subscribe to push.', e)
                        this.pushButtonDisabled = false
                    }
                })
        })
    },

    /**
     * Unsubscribe from push notifications.
     */
    unsubscribe:function(){
        HELPER.statusStart("Loading ...");
        navigator.serviceWorker.ready.then(registration => {
            registration.pushManager.getSubscription().then(subscription => {
                if (!subscription) {
                    this.isPushEnabled = false
                    this.pushButtonDisabled = false
                    return
                }

                subscription.unsubscribe().then(() => {
                    this.deleteSubscription(subscription)

                    this.isPushEnabled = false
                    this.pushButtonDisabled = false
                    HELPER.statusEnd("Unsubscribe");
                    console.log("Unsubscribe")
                }).catch(e => {
                    console.log('Unsubscription error: ', e)
                    this.pushButtonDisabled = false
                })
            }).catch(e => {
                console.log('Error thrown while unsubscribing.', e)
            })
        })
    },

    /**
     * Toggle push notifications subscription.
     */
    togglePush:function(){
        if (this.isPushEnabled) {
            this.unsubscribe()
        } else {
            this.subscribe()
        }
    },

    /**
     * Send a request to the server to update user's subscription.
     *
     * @param {PushSubscription} subscription
     */
    updateSubscription:function(subscription) {
        const key = subscription.getKey('p256dh')
        const token = subscription.getKey('auth')
        const contentEncoding = (PushManager.supportedContentEncodings || ['aesgcm'])[0]

        const data = {
            endpoint: subscription.endpoint,
            publicKey: key ? btoa(String.fromCharCode.apply(null, new Uint8Array(key))) : null,
            authToken: token ? btoa(String.fromCharCode.apply(null, new Uint8Array(token))) : null,
            contentEncoding
        }

        this.loading = true

        axios.post('/subscriptions', data)
            .then(() => { this.loading = false })
    },

    /**
     * Send a requst to the server to delete user's subscription.
     *
     * @param {PushSubscription} subscription
     */
    deleteSubscription:function(subscription) {
        this.loading = true

        axios.post('/subscriptions/delete', { endpoint: subscription.endpoint })
            .then(() => { this.loading = false })
    },

    /**
     * Send a request to the server for a push notification.
     */
    sendNotification:function() {
        this.loading = true
        HELPER.statusStart("sending notification ...");
        axios.post('/notifications')
            .catch(error => console.log(error))
            .then(() => { 
                HELPER.statusEnd("notification sent");
                this.loading = false 
            })
    },

    /**
     * https://github.com/Minishlink/physbook/blob/02a0d5d7ca0d5d2cc6d308a3a9b81244c63b3f14/app/Resources/public/js/app.js#L177
     *
     * @param  {String} base64String
     * @return {Uint8Array}
     */
    urlBase64ToUint8Array(base64String) {
        const padding = '='.repeat((4 - base64String.length % 4) % 4)
        const base64 = (base64String + padding)
            .replace(/\-/g, '+')
            .replace(/_/g, '/')

        const rawData = window.atob(base64)
        const outputArray = new Uint8Array(rawData.length)

        for (let i = 0; i < rawData.length; ++i) {
            outputArray[i] = rawData.charCodeAt(i)
        }

        return outputArray
    }
}

var HELPER={
    statusStart:function(text){
        $("#notif").show();
        $("#notifMsg").html(text);
    },
    statusEnd:function(text=""){
        
        $("#notifMsg").html(text);
        setTimeout(() => {
            $("#notif").hide();
        }, 1000);
    }
}

NOTIF.registerServiceWorker();
window.NOTIF=NOTIF;

```

resources/views/layouts/app.blade.php
```
 <!-- GCM Manifest (optional if VAPID is used) -->
  @if (config('webpush.gcm.sender_id'))
      <link rel="manifest" href="/manifest.json">
  @endif

  <!-- CSRF Token -->
  <meta name="csrf-token" content="{{ csrf_token() }}">
  <script>
      window.Laravel = {!! json_encode([
          'user' => Auth::user(),
          'csrfToken' => csrf_token(),
          'vapidPublicKey' => config('webpush.vapid.public_key'),
          'pusher' => [
              'key' => config('broadcasting.connections.pusher.key'),
              'cluster' => config('broadcasting.connections.pusher.options.cluster'),
          ],
      ]) !!};
  </script>

```

resources/views/home.blade.php
```
@extends('layouts.app')

@section('content')
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header">Dashboard</div>

                <div class="card-body">
                    @if (session('status'))
                        <div class="alert alert-success" role="alert">
                            {{ session('status') }}
                        </div>
                    @endif

                    <div id="notif" class="alert alert-primary alert-block collapse">
                        <button type="button" class="close" data-dismiss="alert">×</button>	
                        <strong id="notifMsg"></strong>
                    </div>
                    <div class="container">
                        
                        <button onclick="NOTIF.subscribe()" class="btn btn-success">Subscribe Notification</button>
                        <button onclick="NOTIF.unsubscribe()" class="btn btn-danger">UnSubscribeNotification</button>
                    </div>
                    <div class="container">
                        <button onclick="NOTIF.sendNotification()" class="btn btn-primary">Send Notification</button>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>
</div>
@endsection
```

routes/web.php

```
// Notifications
Route::post('notifications', 'NotificationController@store');
Route::get('notifications', 'NotificationController@index');
Route::patch('notifications/{id}/read', 'NotificationController@markAsRead');
Route::post('notifications/mark-all-read', 'NotificationController@markAllRead');
Route::post('notifications/{id}/dismiss', 'NotificationController@dismiss');

// Push Subscriptions
Route::post('subscriptions', 'PushSubscriptionController@update');
Route::post('subscriptions/delete', 'PushSubscriptionController@destroy');

// Manifest file (optional if VAPID is used)
Route::get('manifest.json', function () {
    return [
        'name' => config('app.name'),
        'gcm_sender_id' => config('webpush.gcm.sender_id')
    ];
});
```

app/Http/Controllers/NotificationController.php
```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Events\NotificationRead;
use App\Events\NotificationReadAll;
use App\Notifications\HelloNotification;
use App\User;
use NotificationChannels\WebPush\PushSubscription;

class NotificationController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth')->except('last', 'dismiss');
    }

    /**
     * Get user's notifications.
     *
     * @param  \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function index(Request $request)
    {
        $user = $request->user();

        // Limit the number of returned notifications, or return all
        $query = $user->unreadNotifications();
        $limit = (int) $request->input('limit', 0);
        if ($limit) {
            $query = $query->limit($limit);
        }

        $notifications = $query->get()->each(function ($n) {
            $n->created = $n->created_at->toIso8601String();
        });

        $total = $user->unreadNotifications->count();

        return compact('notifications', 'total');
    }

    /**
     * Create a new notification.
     *
     * @param  \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $to= User::where("id",2)->first();

        $to->notify(new HelloNotification("Hei, its work"));

        return response()->json('Notification sent.', 201);
    }

    /**
     * Mark user's notification as read.
     *
     * @param  \Illuminate\Http\Request $request
     * @param  int $id
     * @return \Illuminate\Http\Response
     */
    public function markAsRead(Request $request, $id)
    {
        $notification = $request->user()
                                ->unreadNotifications()
                                ->where('id', $id)
                                ->first();

        if (is_null($notification)) {
            return response()->json('Notification not found.', 404);
        }

        $notification->markAsRead();

        event(new NotificationRead($request->user()->id, $id));
    }

    /**
     * Mark all user's notifications as read.
     *
     * @param  \Illuminate\Http\Request $request
     * @return \Illuminate\Http\Response
     */
    public function markAllRead(Request $request)
    {
        $request->user()
                ->unreadNotifications()
                ->get()->each(function ($n) {
                    $n->markAsRead();
                });

        event(new NotificationReadAll($request->user()->id));
    }

    /**
     * Mark the notification as read and dismiss it from other devices.
     *
     * This method will be accessed by the service worker
     * so the user is not authenticated and it requires an endpoint.
     *
     * @param  \Illuminate\Http\Request $request
     * @param  int $id
     * @return \Illuminate\Http\Response
     */
    public function dismiss(Request $request, $id)
    {
        if (empty($request->endpoint)) {
            return response()->json('Endpoint missing.', 403);
        }

        $subscription = PushSubscription::findByEndpoint($request->endpoint);
        if (is_null($subscription)) {
            return response()->json('Subscription not found.', 404);
        }

        $notification = $subscription->user->notifications()->where('id', $id)->first();
        if (is_null($notification)) {
            return response()->json('Notification not found.', 404);
        }

        $notification->markAsRead();

        event(new NotificationRead($subscription->user->id, $id));
    }
}
```

app/Http/Controllers/PushSubscriptionController.php
```php
<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Routing\Controller;
use Illuminate\Foundation\Validation\ValidatesRequests;

class PushSubscriptionController extends Controller
{
    use ValidatesRequests;

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    /**
     * Update user's subscription.
     *
     * @param  \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request)
    {
        $this->validate($request, ['endpoint' => 'required']);

        $request->user()->updatePushSubscription(
            $request->endpoint,
            $request->publicKey,
            $request->authToken,
            $request->contentEncoding
        );

        return response()->json(null, 204);
    }

    /**
     * Delete the specified subscription.
     *
     * @param  \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy(Request $request)
    {
        $this->validate($request, ['endpoint' => 'required']);

        $request->user()->deletePushSubscription($request->endpoint);

        return response()->json(null, 204);
    }
}
```

app/Notifications/HelloNotification.php
```php
<?php

namespace App\Notifications;

use Illuminate\Bus\Queueable;
use Illuminate\Support\Carbon;
use Illuminate\Notifications\Notification;
use Illuminate\Contracts\Queue\ShouldQueue;
use NotificationChannels\WebPush\WebPushMessage;
use NotificationChannels\WebPush\WebPushChannel;

class HelloNotification extends Notification
{
    use Queueable;

    /**
     * Create a new notification instance.
     *
     * @return void
     */
    public function __construct($text)
    {
        $this->text=$text;
    }

    /**
     * Get the notification's delivery channels.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function via($notifiable)
    {
        return ['database', 'broadcast', WebPushChannel::class];
    }

    /**
     * Get the array representation of the notification.
     *
     * @param  mixed  $notifiable
     * @return array
     */
    public function toArray($notifiable)
    {
        return [
            'title' => 'Hello from Laravel!',
            'body' => 'It work',
            'action_url' => 'https://laravel.com',
            'created' => Carbon::now()->toIso8601String()
        ];
    }

    /**
     * Get the web push representation of the notification.
     *
     * @param  mixed  $notifiable
     * @param  mixed  $notification
     * @return \Illuminate\Notifications\Messages\DatabaseMessage
     */
    public function toWebPush($notifiable, $notification)
    {
        return (new WebPushMessage)
            ->title('Hello from Laravel!')
            ->icon('/notification-icon.png')
            ->body($this->text)
            ->action('View app', 'view_app')
            ->data(['id' => $notification->id]);
    }
}

```


/database/migrations/2016_07_30_000002_create_notifications_table.php

```php
<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateNotificationsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('notifications', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->string('type');
            $table->string('notifiable_type');
            $table->integer('notifiable_id');
            $table->text('data');
            $table->dateTime('read_at')->nullable();
            $table->timestamps();

            $table->index(['notifiable_type', 'notifiable_id']);
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::drop('notifications');
    }
}

```

database/migrations/2019_07_27_114830_create_push_subscriptions_table.php
```php
<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePushSubscriptionsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::connection(config('webpush.database_connection'))->create(config('webpush.table_name'), function (Blueprint $table) {
            $table->increments('id');
            $table->morphs('subscribable');
            $table->string('endpoint', 500)->unique();
            $table->string('public_key')->nullable();
            $table->string('auth_token')->nullable();
            $table->string('content_encoding')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::connection(config('webpush.database_connection'))->dropIfExists(config('webpush.table_name'));
    }
}

```


# Source 

https://github.com/cretueusebiu/laravel-web-push-demo



