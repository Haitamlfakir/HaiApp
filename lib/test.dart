import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:haiapp/chat.dart';
import 'package:http/http.dart' as http;

class HomePaget extends StatefulWidget {
  @override
  State<HomePaget> createState() => _HomePagetState();
}

class _HomePagetState extends State<HomePaget> {
  String? _token;
  String? _accessToken;

  getInit() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && initialMessage.notification != null) {
      String? title = initialMessage.notification!.title;
      String? body = initialMessage.notification!.body;
      if (initialMessage.data['type'] == 'chat') {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Chat(
                  title: title!,
                  body: body!,
                )));
      }
    }
  }

  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print("======================================");
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);
        print("======================================");

        AwesomeDialog(
            context: context,
            title: "${message.notification!.title}",
            body: Text("${message.notification!.body}"),
            dialogType: DialogType.info)
          ..show();
      }
    });

    super.initState();
    getToken();
    fetchAccessToken();
    getInit();
  }

  Future<void> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permissions for iOS (optional, required for iOS)
    await messaging.requestPermission();

    // Get the FCM token
    String? token = await messaging.getToken();

    setState(() {
      _token = token;
    });

    print("FCM Token: $_token");
  }

  Future<void> fetchAccessToken() async {
    // JSON data from your service account file (replace the values with actual data).
    const String serviceAccountJson = '''
    {
  "type": "service_account",
  "project_id": "haiapp-2b951",
  "private_key_id": "ae455917a85174e4f919860d6e7820bd59656573",
  "private_key": "-----BEGIN PRIVATE KEY-----\\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDK9FS7Z2ll+fEa\\nD49GJt4o4zVAR0AlmHx+f28b3jgAK+RErOLHhMXq2YYQnmUYZHTGfeC3xNLecIRH\\nEC3ryV2NUjZHhIzx5rTztd3gXj4+Zays+zmDIppGvzDY4zYR/YK449n+9g7HPIHd\\nN14mII+Dmz1tls7CqvLnfKgm6H0JMAITHZXnS8d+eQcowVzQ8iDHihpArzh/xjVw\\nUWAurL3VnrwW1NgABwSI3LZlWsEyXWkjpzkVdl2F+0/f9aE0ErbbYhIYUUowvsKe\\noSoQ6u9nNumi2EDuKfuiqKInibm7ykbbRZD87LAidgH6P6RF65CHN+TpIynxaBU2\\nIQ9LYISpAgMBAAECggEAYq6uzHiZ3QXM37kVFy0q9IKVj+2VGTKtxew8oDZK0HqH\\nAYV2t0Ct42VlNItv6I5f4Wuvamt/hLz89Hi/e1hr7p0820VuKujcr2uMuN3aMgjK\\nD0oQStz2WtP38l14GwNDHpdblgcaZHHdSyzy0GMgpQNEuRaM7kak2T3ZnSGKOn6J\\nlbYTwecl28J6avfPS2rBgwSnwmphq3UpHs2Zx4u2f1Mr9rrE1fuNv8JuTXMbF2xT\\nTNHgZOIJh4Hj7dxT06jqTl0qbB2ySfxALy5kb8D6lD/QkUisrFjF7ePNt9vINwhw\\nFA41DOzAgXwTganrq8JKFrqwIfWhhYbW9eGnv9zHCQKBgQDsLjFWIAyMjUfmALb4\\nINb00a5w57i28UG1E0brFwyUci5pbYzgvBKrdquABgt9eufuDLMEAtmTmD6iqeG0\\nv5f0n0dUNHeib4CCWvnFA82pD9i9e12yMaZMqIk2/Rd3UhI8Kgu29zXiCfKygGbK\\nMWTeNXzL+uBu0YXKY9+RjeHwrwKBgQDb/FoGaxPqLkLNVn1Blk0620gLjuZPQFf1\\nUUYYLpsdv1SIPxYpKhVBgYFCU8tMsanOX41yggT/c9K5tq2kUCEeoKAofHTQU8nb\\nuEP9Uda8mkjw58MRzhiwcyz/pXIEkD418QLDnY0t5y6D9CwBYiGmkN54ekXaKECJ\\n/fhOw2tGJwKBgQCmdjxBtp8BpUYqnxBWvFalAPCRFVFEZ7BnHqoaYgl0yzFZD2R+\\ntS/3d9GSjzAkBa9YQc0eo5+UfnaPEWtKiMtiF60fdUdozmvl9JccO/0FDm01x7CX\\nOpU6bIMhpaqXZ9oAW6YcFAr/QQG0u/k2wy+TymEmJ7FtifFhX5kgrr6zcwKBgQCl\\n0boqTFxekTBZh3AzGBBu5QuRas2/v0iN6g1j/P1/ltEpQiR6MvaCwhOk43TDAsh0\\nfyInxknuJGgbBNAuoxfT9k/DNMz4m6/0pxjYwe+TitigfpJTwX5qwuaQbS1csz2x\\ne1ISEZhxmWk+nbbt9AJZg6muNrygjObZHU8mT7d00QKBgCIjkamB/PVZEhrGu9Ww\\n3zQ5WThz0iI7kwhzUrL24LUAsGuSxiClxDNSpniTQPZEov+GKBulGNRrWL2Oiumo\\nNywogHt/K4S3SKbPoVau3rhTzgdKgktyH1pg7H/BX9mHhqmKBxxjCZQtTaq7jLNU\\nJBT/pYZurqPXnqVFYzNw46TC\\n-----END PRIVATE KEY-----\\n",
  "client_email": "haitam@haiapp-2b951.iam.gserviceaccount.com",
  "client_id": "116539971990999922034",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/haitam%40haiapp-2b951.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
    ''';

    try {
      // Decode the JSON string
      final jsonKey = jsonDecode(serviceAccountJson);

      // Create service account credentials
      final accountCredentials = ServiceAccountCredentials.fromJson(jsonKey);

      // Define the required scopes
      const scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

      // Request an authenticated client
      final authClient =
          await clientViaServiceAccount(accountCredentials, scopes);

      // Retrieve the OAuth 2 access token
      final accessToken = authClient.credentials.accessToken.data;

      // Update the UI
      setState(() {
        _accessToken = accessToken;
      });

      print('Access Token: $_accessToken');

      // Close the client
      authClient.close();
    } catch (e) {
      print('Error fetching OAuth 2 access token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notification')),
      body: Container(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () async {
                await FirebaseMessaging.instance.subscribeToTopic('haitamlfakir');
              },
              child: Text("Subscribe"),
            ),
            MaterialButton(
              color: Colors.black,
              textColor: Colors.white,
              onPressed: () async {
                await FirebaseMessaging.instance.unsubscribeFromTopic('haitamlfakir');
              },
              child: Text("Unsubrcribe"),
            ),
            MaterialButton(
              color: Colors.purple,
              textColor: Colors.white,
              onPressed: () async {
                await SendMessageTopic("hello", "Salaaaam!", 'haitamlfakir');
              },
              child: Text("Send Messgae Topic"),
            )
          ],
        ),
      ),
    );
  }
}

SendMessage(title, message) async {
  var headersList = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ya29.c.c0ASRK0GZOcAEhIxAx2E0BJ2NLMQcp9za675OdtRF4GBOJURZWv26-ZLKxRct8-Z9C-Dkvix0ZcXhjSpf6pTk5ffzI1mhknefmBouvNfQ5904vleNhd0PwRrWlaH7XGD53t24oh9nQKiftJQan9ppQ_MoQhx_tzO8gcZaZbcyLqqNvCQW3rNSWNzLlfwJbQSBJhdN5slcyRhzYX7vRJ1MnVJLxvcmo2PhHD8FxblV-qtAPpZJ8QJeMnaAbe6u9hnqQMZYzeQzAUsvd7N2pgqybk0rYNG3cvPdt2tipp7lziWwnelLWGB7rE68rnd8xrwD8iXbYxvgBQb2Zualf-DM2b7OFja6sSqimVu8OMC_lrC-g4hoFaXpE6H0N384AcR_OmumY1WVhy-zu6qxSZ8482FVoh67twpkga9lZVjkkiVmVhWqu06rqWyaYVvc6S_JS-yllgs7gVfscwokY9g8uScIslgyjF7_l43f12RF-kqjcsyYp8-sSgtpOjJQzht9YMmVe0UZ3XmdFpubJj53sOZueZ9v2UMI4BieYhs3tUJlYZzkrX1ikz5lSlfIIf8sxj6F1YOdSR1YfOj71ZYWkkbt_SiM376Zgia0m1iIsQhyib62Jn_eqXQqx7j9RFYfI2Ut4ay9Qy4nm9ddd74t4pZht9-1iecy0ptR8-vqiVBgtWz0_6uJMqmSlVVakrd8ag7fylFMZW9cMII8V40ddt95nQZ4hknrqbVkrO_5nyqZes5urfdwkmUuteZM-aub17UsS-tvyo88O7ZRu-qzivI49SjZ8i1ZZ9viZezByesc1_BzOXZ8vFpBgw-fZuyx8SaeiMrtBbJOXszrbkBw-6zM_k_p6vewsubfr11gxzrry_0Ya-cqe4m_ZiWlSw2WXYIXmX_5w7wrBar98fi9StvrtpIcf6d0d7MWj1bd8oznthmQnS_WgBqSVfxsbSfBFyUr47iXyYvMRiXyenvmMdyrzShbZQm37eMm4OxZy'
  };
  var url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/haiapp-2b951/messages:send');

  var body = {
    "message": {
      "token":
          "cfNT0DBlSe26gznxMl-W7Q:APA91bFZGzCEwvgc22DbHxQnRas2Ai3W-1YbQsKekQkXzbYlFaS-marv7903RVzOJLs8b1-ZTgODScV7j7l-qbKw7pNf5Iw7LhyaUPHy0XCc4xQpQLNt0eI",
      "notification": {"title": "Haiatm sahbi", "body": "Salam labas kidayr"},
      "data": {"id": "123", "name": "omar", "type": "chat", "time": "23:11"}
    }
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}

SendMessageTopic(title, message, topic) async {
  var headersList = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer ya29.c.c0ASRK0GZOcAEhIxAx2E0BJ2NLMQcp9za675OdtRF4GBOJURZWv26-ZLKxRct8-Z9C-Dkvix0ZcXhjSpf6pTk5ffzI1mhknefmBouvNfQ5904vleNhd0PwRrWlaH7XGD53t24oh9nQKiftJQan9ppQ_MoQhx_tzO8gcZaZbcyLqqNvCQW3rNSWNzLlfwJbQSBJhdN5slcyRhzYX7vRJ1MnVJLxvcmo2PhHD8FxblV-qtAPpZJ8QJeMnaAbe6u9hnqQMZYzeQzAUsvd7N2pgqybk0rYNG3cvPdt2tipp7lziWwnelLWGB7rE68rnd8xrwD8iXbYxvgBQb2Zualf-DM2b7OFja6sSqimVu8OMC_lrC-g4hoFaXpE6H0N384AcR_OmumY1WVhy-zu6qxSZ8482FVoh67twpkga9lZVjkkiVmVhWqu06rqWyaYVvc6S_JS-yllgs7gVfscwokY9g8uScIslgyjF7_l43f12RF-kqjcsyYp8-sSgtpOjJQzht9YMmVe0UZ3XmdFpubJj53sOZueZ9v2UMI4BieYhs3tUJlYZzkrX1ikz5lSlfIIf8sxj6F1YOdSR1YfOj71ZYWkkbt_SiM376Zgia0m1iIsQhyib62Jn_eqXQqx7j9RFYfI2Ut4ay9Qy4nm9ddd74t4pZht9-1iecy0ptR8-vqiVBgtWz0_6uJMqmSlVVakrd8ag7fylFMZW9cMII8V40ddt95nQZ4hknrqbVkrO_5nyqZes5urfdwkmUuteZM-aub17UsS-tvyo88O7ZRu-qzivI49SjZ8i1ZZ9viZezByesc1_BzOXZ8vFpBgw-fZuyx8SaeiMrtBbJOXszrbkBw-6zM_k_p6vewsubfr11gxzrry_0Ya-cqe4m_ZiWlSw2WXYIXmX_5w7wrBar98fi9StvrtpIcf6d0d7MWj1bd8oznthmQnS_WgBqSVfxsbSfBFyUr47iXyYvMRiXyenvmMdyrzShbZQm37eMm4OxZy'
  };
  var url = Uri.parse(
      'https://fcm.googleapis.com/v1/projects/haiapp-2b951/messages:send');

  var body = {
    "message": {
      "to": "/topics/$topic",
      "notification": {"title": "Haiatm sahbi", "body": "Salam labas kidayr"},
      "data": {"id": "123", "name": "omar", "type": "chat", "time": "23:11"}
    }
  };

  var req = http.Request('POST', url);
  req.headers.addAll(headersList);
  req.body = json.encode(body);

  var res = await req.send();
  final resBody = await res.stream.bytesToString();

  if (res.statusCode >= 200 && res.statusCode < 300) {
    print(resBody);
  } else {
    print(res.reasonPhrase);
  }
}
