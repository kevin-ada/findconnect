import 'package:findconnect/screens/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/error.dart';
import '../components/loading_page.dart';
import '../controller/discover_controller.dart';

class Discover extends ConsumerStatefulWidget {
  const Discover({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _DiscoverState();
}

class _DiscoverState extends ConsumerState<Discover> {
  final searchController = TextEditingController();
  bool isShousers = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF2B2730),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF2B2730),
          title: SizedBox(
            height: 50,
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  isShousers = true;
                });
              },
              textAlign: TextAlign.center,
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                fillColor: const Color(0xff2B2730),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Color(0xff46458C)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade600),
                ),
              ),
            ),
          ),
        ),
        body: isShousers
            ? ref.watch(searchUserProvider(searchController.text)).when(
                  data: (users) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(13),
                        child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (BuildContext context, int index) {
                              final user = users[index];
                              return SearchTile(userModel: user);
                            }),
                      ),
                    );
                  },
                  error: (err, stack) => Errorpage(error: err.toString()),
                  loading: () => const Loader(),
                )
            : const SizedBox());
  }
}
