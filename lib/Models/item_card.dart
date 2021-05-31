import 'package:flutter/material.dart';
import 'Item.dart';

class ItemCard extends StatelessWidget {
  final Item? item;
  ItemCard({this.item});

  @override
  Widget build(BuildContext context) {
    return itemCard(item: item);
  }
}

class itemCard extends StatefulWidget {
  const itemCard({
    Key? key,
    required this.item,
  }) : super(key: key);

  final Item? item;

  @override
  _itemCardState createState() => _itemCardState();
}

class _itemCardState extends State<itemCard> {
  get item => widget.item;

  @override
  Widget build(BuildContext context) {
    return Card(
        // color: Colors.blueGrey[800],
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(this.item.name, style: TextStyle(fontSize: 20)),
              ),
            ),
            IconButton(
              //color: Colors.white,
              onPressed: () {
                setState(() {
                  widget.item!.quantity = (widget.item!.quantity! + 1);
                });
              },
              icon: Icon(Icons.add),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  height: 30.0,
                  //color: Colors.blueGrey[900],
                  child: Center(
                    child: Text(
                      widget.item!.quantity.toString(),
                      //style: TextStyle(color: Colors.blue)
                    ),
                  )),
            ),

            IconButton(
              //color: Colors.blue,
              onPressed: () {
                setState(() {
                  widget.item!.quantity = (widget.item!.quantity! - 1);
                });
              },
              icon: Icon(Icons.remove),
            ),
            //new Spacer(),
          ],
        ));
  }
}
