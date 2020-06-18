+++
title = "How To Use Twitter OAuth On Android"
author = ["Honza Pokorny"]
date = 2010-09-28T22:31:00-03:00
categories = ["android", "code", "twitter"]
draft = false
+++

If you are developing an application for the Android platform, and you need to
interact with the Twitter API, you now have to use OAuth to authenticate the
user. In this article, we will have a look on how you can do that.

## What is OAuth? {#what-is-oauth}

OAuth is a way of accessing a user's data (e.g. tweets) without asking for the
user's username and password. Your application opens the Twitter website which
will ask the user if they want to allow you to access their data. If they do,
they are taken back to the application and can start using it. You can find
more about OAuth all over the web.

## Prerequisites {#prerequisites}

There are a couple of .jars that you will need for this to work.

### signpost-commonshttp4-1.2.1.1.jar {#signpost-commonshttp4-1-dot-2-dot-1-dot-1-dot-jar}

### signpost-core-1.2.1.1.jar {#signpost-core-1-dot-2-dot-1-dot-1-dot-jar}

You can download them [here](https://github.com/kaeppler/signpost).

## Basic Activity {#basic-activity}

Let's say we have an activity running where the user can start the
authentication process. There is nothing special about this activity, except
for some text and a button. When the user clicks the button, the OAuth process
will be started. From the button's `onClickListener()` we will call the
`startOAuth()` method of our activity.

We will add a few attributes to our activity. Let's call the activity Main.

```java
public class Main extends Activity {

    private CommonsHttpOAuthConsumer httpOauthConsumer;
    private OAuthProvider httpOauthprovider;
    public final static String consumerKey = "abc";
    public final static String consumerSecret = "abc";
    private final String CALLBACKURL = "app://twitter";

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        ...
}
```

`consumerKey` and `consumerSecret` will store your app's unique keys that
you will get from Twitter. `CALLBACK` is a little different. This is used
when the application is authorized on the web, and the control is returned back
to the Main activity. For the mobile browser to be able to call the application
and tell it that the OAuth business has gone well, it needs a call back. Both
app and twitter can be exchanged for anything else.

Now let's have a look at the `startOAuth()` method.

```java
try {
    httpOauthConsumer = new CommonsHttpOAuthConsumer(consumerKey, consumerSecret);
    httpOauthprovider = new DefaultOAuthProvider("http://twitter.com/oauth/request_token",
                                            "http://twitter.com/oauth/access_token",
                                            "http://twitter.com/oauth/authorize");
    String authUrl = httpOauthprovider.retrieveRequestToken(httpOauthConsumer, CALLBACKURL);
    // Open the browser
    startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(authUrl)));
} catch (Exception e) {
    Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG).show();
}
```

Here we create the necessary OAuth objects which will in turn generate the
unique authenticating URL. Once we have the URL we open the browser and point
it to that URL. The user will be presented with a dialog asking them to allow
or to deny your application access.

In order for our activity to be able to receive the callback, we need to add a
few things the Android manifest file. Change the applications definition to the
following:

```xml
<activity android:name="Main" android:launchMode="singleInstance">
    <intent-filter>
         <action android:name="android.intent.action.VIEW" />
         <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="app" android:host="twitter" />
    </intent-filter>
</activity>
```

Note that if you changed the app and twitter in the `CALLBACK` variable
above, you will need to make sure that the change is reflected here. This
basically allows the activity to receive data from a foreign source - our
browser.

Now we need to catch the callback and handle it. We do that by overriding the
`onNewIntent()` method of our Main activity.

```java
@Override
protected void onNewIntent(Intent intent) {
    super.onNewIntent(intent);

    Uri uri = intent.getData();

    //Check if you got NewIntent event due to Twitter Call back only

    if (uri != null && uri.toString().startsWith(CALLBACKURL)) {

        String verifier = uri.getQueryParameter(oauth.signpost.OAuth.OAUTH_VERIFIER);

        try {
            // this will populate token and token_secret in consumer

            httpOauthprovider.retrieveAccessToken(httpOauthConsumer, verifier);
            String userKey = httpOauthConsumer.getToken();
            String userSecret = httpOauthConsumer.getTokenSecret();

            // Save user_key and user_secret in user preferences and return

            SharedPreferences settings = getBaseContext().getSharedPreferences("your_app_prefs", 0);
            SharedPreferences.Editor editor = settings.edit();
            editor.putString("user_key", userKey);
            editor.putString("user_secret", userSecret);
            editor.commit();

        } catch(Exception e){

        }
    } else {
        // Do something if the callback comes from elsewhere
    }

}
```

OK, there's quite a bit there. We extract the data that the browser sent back
to us. This data is used to verify that the authentication was successful and
that we can now access the user's data. From the data, we get the user's key
and their secret. We save that into the application's shared preferences file
and return.

Now we are good to go. We can make authenticated requests to Twitter API on
behalf of the user.

For example, to get the user's home timeline, you would do something like:

```java
HttpGet get = new HttpGet("http://api.twitter.com/version/statuses/home_timeline.json");
HttpParams params = new BasicHttpParams();
HttpProtocolParams.setUseExpectContinue(params, false);
get.setParams(params);
// sign the request to authenticate
httpOauthConsumer.sign(get);
String responsex = mClient.execute(get, new BasicResponseHandler());
JSONArray array = new JSONArray(responsex);
```

And the array variable is a list of the latest tweets in the user's home timeline.
