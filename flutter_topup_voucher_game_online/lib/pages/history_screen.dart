import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../Providers/favorite_provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = FavoriteProvider.of(context);
    final finalList = provider.favorites;
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'History Order',
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            itemCount: finalList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 30, left: 5),
                child: Slidable(
                  endActionPane:
                      ActionPane(motion: const ScrollMotion(), children: [
                    SlidableAction(
                      onPressed: (context) {
                        finalList.removeAt(index);
                        setState(() {});
                      },
                      backgroundColor: Colors.white10,
                      foregroundColor: Colors.black,
                      icon: Icons.delete,
                      label: 'Delete',
                    ),
                  ]),
                  child: ListTile(
                    tileColor: const Color.fromARGB(255, 71, 71, 72),
                    title: Text(
                      finalList[index].name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      "test",
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: const CircleAvatar(
                      radius: 35,
                      backgroundImage: AssetImage("ml-1.png"),
                      backgroundColor: Colors.amberAccent,
                    ),
                    trailing: const Text(
                      'test',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          )),
        ],
      ),
    );
  }
}
