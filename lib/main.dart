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
  bool modo_manual = true;
  bool reset = false;
  bool start = false;
  bool stop = false;
  bool direcao = false;
  bool eixo_1 = false;
  bool eixo_2 = false;
  bool eixo_3 = false;
  bool eixo_4 = false;
  bool eixo_5 = false;
  bool eixo_6 = false;

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
                        padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                        child: const Center(
                          child: Text(
                            'DL ROBO SIX',
                            style: TextStyle(
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
                      //MODO MANUAL
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: modo_manual ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "manual",
                            onPressed: () {
                              modo_manual = !modo_manual;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  modo_manual.toString(),
                                );
                              });
                              client.publishMessage("manual",
                                  MqttQos.atLeastOnce, builder2.payload!);
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      //RESET
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: reset ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "reset",
                            onPressed: () {
                              reset = !reset;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  reset.toString(),
                                );
                              });
                              client.publishMessage("reset",
                                  MqttQos.atLeastOnce, builder2.payload!);
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      //START
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: start ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "start",
                            onPressed: () {
                              start = !start;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  start.toString(),
                                );
                              });
                              client.publishMessage("start",
                                  MqttQos.atLeastOnce, builder2.payload!);
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      //STOP
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: stop ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "stop",
                            onPressed: () {
                              stop = !stop;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  stop.toString(),
                                );
                              });
                              client.publishMessage("stop", MqttQos.atLeastOnce,
                                  builder2.payload!);
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      //DIREÇÃO
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: direcao ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "direção",
                            onPressed: () {
                              direcao = !direcao;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  direcao.toString(),
                                );
                              });
                              client.publishMessage("direcao",
                                  MqttQos.atLeastOnce, builder2.payload!);
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      //EIXO_1
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: eixo_1 ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "Eixo 1",
                            onPressed: () {
                              eixo_1 = !eixo_1;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  eixo_1.toString(),
                                );
                              });
                              client.publishMessage("eixo1",
                                  MqttQos.atLeastOnce, builder2.payload!);
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      //EIXO_2
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: eixo_2 ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "Eixo 2",
                            onPressed: () {
                              eixo_2 = !eixo_2;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  eixo_2.toString(),
                                );
                              });
                              client.publishMessage("eixo2",
                                  MqttQos.atLeastOnce, builder2.payload!);
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      //EIXO_3
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: eixo_3 ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "Eixo 3",
                            onPressed: () {
                              eixo_3 = !eixo_3;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  eixo_3.toString(),
                                );
                              });
                              client.publishMessage("eixo3",
                                  MqttQos.atLeastOnce, builder2.payload!);
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      //EIXO_4
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: eixo_4 ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "Eixo 4",
                            onPressed: () {
                              eixo_4 = !eixo_4;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  eixo_4.toString(),
                                );
                              });
                              client.publishMessage("eixo4",
                                  MqttQos.atLeastOnce, builder2.payload!);
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      //EIXO_5
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: eixo_5 ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "Eixo 5",
                            onPressed: () {
                              eixo_5 = !eixo_5;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  eixo_5.toString(),
                                );
                              });
                              client.publishMessage("eixo5",
                                  MqttQos.atLeastOnce, builder2.payload!);
                            },
                            icon: const Icon(
                              Icons.cached,
                            ),
                          ),
                        ),
                      ),
                      //EIXO_6
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: eixo_6 ? Colors.green : Colors.red,
                        ),
                        height: 70,
                        width: 70,
                        child: Center(
                          child: IconButton(
                            tooltip: "Eixo 6",
                            onPressed: () {
                              eixo_6 = !eixo_6;

                              setState(() {
                                builder2.clear();

                                builder2.addUTF16String(
                                  eixo_6.toString(),
                                );
                              });
                              client.publishMessage("eixo6",
                                  MqttQos.atLeastOnce, builder2.payload!);
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
