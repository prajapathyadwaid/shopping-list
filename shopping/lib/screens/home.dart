import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:shopping/custom_widgets/list_tile.dart';
import 'package:shopping/logic/time.dart';
import '../global.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int i = 0;
  late final Box box;
  List items = [];
  var controller = TextEditingController();

  void loadData() async {
    box = await Hive.openBox('shoppinglist');
    items = await box.get("details");
    setState(
      () {
        i = items.length;
      },
    );
  }

  void updateData() async {
    box.put("details", items);
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    Hive.close();
    super.dispose();
  }

  Future<void> share() async {
    // ignore: prefer_interpolation_to_compose_strings
    var sharedata = "Shopping List\n" + items.join("\n");
    await FlutterShare.share(
      title: 'Shopping List',
      text: sharedata,
    );
  }

  @override
  Widget build(BuildContext context) {
    var dimension = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: darkColor,
      appBar: AppBar(
        toolbarHeight: dimension.height * 0.1,
        title: Container(
          margin: const EdgeInsets.only(top: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                "${getGreeting()}, Shopper👋",
                style: GoogleFonts.roboto(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Let's Go Shopping!",
                style: GoogleFonts.roboto(
                    color: Colors.black.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    fontSize: 13),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Image.asset("assets/cart.jpg"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: share,
        backgroundColor: Colors.white.withOpacity(0.05),
        child: Icon(
          Icons.share,
          color: accentColor,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: dimension.height * 0.12,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: i == 0
                    ? Text(
                        "You have no items in your list\n Add items",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      )
                    : i == 1
                        ? Text(
                            "You have $i item in your list",
                            style: GoogleFonts.roboto(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          )
                        : Text(
                            "You have $i items in your list",
                            style: GoogleFonts.roboto(
                                color: Colors.black.withOpacity(0.8),
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 300,
                            color: Colors.white.withOpacity(0.05),
                          )),
                    ),
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 18),
                      padding: const EdgeInsets.only(top: 30),
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: i,
                        itemBuilder: (BuildContext context, int index) {
                          return Dismissible(
                            direction: DismissDirection.endToStart,
                            dismissThresholds: const {
                              DismissDirection.endToStart: 0.2
                            },
                            background: Container(
                              padding: const EdgeInsets.only(right: 10),
                              color: accentColor.withOpacity(0.1),
                              height: 50,
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.delete,
                                color: accentColor,
                              ),
                            ),
                            onDismissed: (direction) {
                              setState(() {
                                i--;
                              });
                              items.removeAt(index);
                              updateData();
                            },
                            key: Key(i.toString()),
                            child: CustomTiles(
                              items[index],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.only(top: dimension.height * .12 - 28),
            height: 56,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text(
                        "Add Item",
                        style: GoogleFonts.roboto(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: Colors.white,
                      content: SizedBox(
                        height: dimension.width * 0.15,
                        width: dimension.width * 0.6,
                        child: Column(
                          children: [
                            TextField(
                              maxLength: 40,
                              enableIMEPersonalizedLearning: true,
                              enableSuggestions: true,
                              decoration: const InputDecoration(
                                  counterText: "",
                                  hintText: "Rice 1 kg ...",
                                  focusedBorder: InputBorder.none,
                                  hintStyle: TextStyle(fontSize: 15)),
                              cursorColor: Colors.black,
                              onSubmitted: (nam) async {
                                if (nam.trim() != "") {
                                  items.add(nam);
                                  setState(() {
                                    i = i + 1;
                                  });
                                  controller.clear();
                                  updateData();
                                }

                                Navigator.pop(context);
                              },
                              controller: controller,
                            )
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (controller.text.trim() != "") {
                              items.add(controller.text);
                              setState(() {
                                i = i + 1;
                              });
                              controller.clear();
                              updateData();
                            }
                          },
                          child: Text(
                            "Save",
                            style: GoogleFonts.roboto(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: accentColor,
              child: const Icon(
                Icons.add,
                size: 35,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
