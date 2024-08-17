import 'dart:async';

import '../droplet_repo.dart';
import '../droplet_model.dart';
import 'package:flutter/material.dart';

class DropletBasicDetailsWidget extends StatefulWidget {
  final Droplet droplet;
  const DropletBasicDetailsWidget({super.key, required this.droplet});

  @override
  State<DropletBasicDetailsWidget> createState() =>
      _DropletBasicDetailsWidgetState();
}

class _DropletBasicDetailsWidgetState extends State<DropletBasicDetailsWidget> {
  final _dpInstance = DigitalDroplet.instance;
  final ValueNotifier<String> actionStatus = ValueNotifier<String>("");
  Droplet? localDroplet;
  bool isExpanded = false;

  String getMemory(int memory) {
    final inGB = memory / 1024;
    if (inGB < 1) {
      return "$memory MB";
    } else {
      return "$inGB GB";
    }
  }

  getActionStatus(int dropletID, int actionID) async {
    actionStatus.value = "in-progress";
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      final response = await _dpInstance.getActionStatus(
          dropletID.toString(), actionID.toString());
      if (response.action.status == "completed") {
        // final response = await _dpInstance.getDroplet(dropletID);
        localDroplet = response.action.type == "power_on" ? Droplet(status: "active") : Droplet(status: "off");
        actionStatus.value = "completed";
        timer.cancel();
      }
    });
  }

  bool getDropletPowerStatus(Droplet droplet) {
    return droplet.status == "active" ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (index, state) {
        setState(() {
          isExpanded = state;
        });
      },
      children: [
        ExpansionPanel(
            isExpanded: isExpanded,
            headerBuilder: (context, isexpanded) {
              return ListTile(
                title: Text(widget.droplet.name ?? "Droplet Name"),
                trailing: ValueListenableBuilder<String>(
                    valueListenable: actionStatus,
                    builder: (context, value, child) {
                      return Switch(
                        value: localDroplet != null
                            ? getDropletPowerStatus(localDroplet!)
                            : getDropletPowerStatus(widget.droplet),
                        onChanged: value == "in-progress"
                            ? null
                            : (value) async {
                                actionStatus.value = "in-progress";
                                DropletActionResponse response;
                                if (widget.droplet.status == "active") {
                                  response = await _dpInstance
                                      .powerOff(widget.droplet.id!);
                                } else {
                                  response = await _dpInstance
                                      .powerOn(widget.droplet.id!);
                                }
                                getActionStatus(
                                    widget.droplet.id!, response.action.id);
                              },
                      );
                    }),
                contentPadding: const EdgeInsets.only(
                  left: 8.0,
                ),
              );
            },
            body: Padding(
              padding: const EdgeInsets.fromLTRB(
                16.0,
                8.0,
                16.0,
                16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "ID",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(widget.droplet.id.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Image Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(widget.droplet.image?.name ?? "image"),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Memory",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(getMemory(widget.droplet.memory!)),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Region Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(widget.droplet.region?.name ?? "region"),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "vCPUs",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(widget.droplet.vcpus.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Status",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(widget.droplet.status ?? "status"),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Disk",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text("${widget.droplet.disk}GB"),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Hourly Price",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text("${widget.droplet.size?.priceHourly} USD"),
                    ],
                  ),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Text(
                          "Monthly Price",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text("${widget.droplet.size?.priceMonthly} USD"),
                    ],
                  ),
                ],
              ),
            ))
      ],
    );
  }

  @override
  void dispose() {
    actionStatus.dispose();
    super.dispose();
  }
}
