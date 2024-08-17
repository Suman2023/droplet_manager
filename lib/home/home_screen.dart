import '../droplet_repo.dart';
import 'droplet_basic_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dpInstance = DigitalDroplet.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Currently Running Droplets",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    setState(() {});
                  },
                  child: FutureBuilder(
                    future: _dpInstance.getAllDroplets(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return snapshot.data!.droplets.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("No Droplets Deployed"),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {});
                                        },
                                        icon: const Icon(Icons.refresh_rounded))
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: snapshot.data!.droplets.length,
                                itemBuilder: (context, index) {
                                  return DropletBasicDetailsWidget(
                                    droplet: snapshot.data!.droplets[index],
                                  );
                                },
                              );
                      }
                      if (snapshot.hasError) {
                        if (snapshot.error is TokenMissingException) {
                          return const Center(
                            child: Text("Auth Token Missing"),
                          );
                        } else {
                          return Center(
                            child: Text("${snapshot.error}"),
                          );
                        }
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
