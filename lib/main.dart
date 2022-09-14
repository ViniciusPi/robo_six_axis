import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:typed_data/typed_data.dart';
import 'dart:io';

void main(List<String> args) {
  runApp(
    RoboSixApp(),
  );
}

class RoboSixApp extends StatefulWidget {
  const RoboSixApp({super.key});

  @override
  State<RoboSixApp> createState() => _RoboSixAppState();
}

class _RoboSixAppState extends State<RoboSixApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TelaPrincipal(),
      debugShowCheckedModeBanner: false,
    );
  }
}

final client = MqttServerClient('broker.mqttdashboard.com', '');
var pongCount = 0;
void pong() {
  pongCount++;
}

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  bool liga = true;
  dynamic dado = 0;
  String pubTopic = 'Virgulino';
  bool motor_ligado = true;

  aquisicao2() async {
    client.logging(on: true);

    client.setProtocolV311();

    client.keepAlivePeriod = 20;

    client.pongCallback = pong;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      client.disconnect();
    } on SocketException catch (e) {
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
    } else {
      client.disconnect();
      exit(-1);
    }

    var texto;

    client.updates!.listen(
      (List<MqttReceivedMessage<MqttMessage?>>? c) {
        final recMess = c![0].payload as MqttPublishMessage;
        final pt =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        print(' valor da tensao $pt');

        setState(() {
          dado = pt;
        });
      },
    );

    final builder = MqttClientPayloadBuilder();
    const topicoLinhos = "dlb000";
    builder.addUTF16String("funciona");

    client.subscribe(pubTopic, MqttQos.exactlyOnce);

    client.publishMessage(topicoLinhos, MqttQos.atMostOnce, builder.payload!);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    aquisicao2();
  }

  final builder2 = MqttClientPayloadBuilder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              flex: 2,
              child: Container(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Center(
                          child: Image.asset(
                            'imagens/Logo_DLB_2021_Preto.png',
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: Center(
                          child: Text(
                            'DL ROBO SIX',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Arial',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 12,
              child: Container(
                color: Colors.black,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'imagens/dl_robo_sixs.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                color: Colors.grey,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            onPressed: () {
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                              setState(() {
                                motor_ligado = !motor_ligado;
                                builder2.clear();
                                motor_ligado
                                    ? builder2.addUTF16String("true")
                                    : builder2.addUTF16String("false");
                              });
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
