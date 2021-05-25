import 'package:flutter/material.dart';
import 'Item.dart';

class ItemCard extends StatelessWidget {
  
  final Item ? item;
  ItemCard({this.item});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Colors.blueGrey[800],
        margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 14,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    item!.name.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    )
                  ),
              ),
            ),
              
            
            
            Expanded(
              child: Container(
              
                color: Colors.blueGrey[900],
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Center(
                      child: Text(
                      item!.quantity.toString(),
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                ),
                    ),
                  ),
              ),
            ),
            new Spacer(),
          ],
        )
      ),
    );
  }
}