import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ayolee_stores/sample/sample_data_provider.dart';
import 'package:flutter/widgets.dart';
import 'package:folding_cell/folding_cell.dart';

class Products extends StatefulWidget {

  static const String id = 'available_drinks';

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {

  @override
  Widget build(BuildContext context) {
    //addText(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              //showSearchPage(context, _searchDelegate);
            },
          ),
          /*PopupMenuButton<CustomPopupMenu>(
            elevation: 3.2,
            initialValue: choices[1],
            onCanceled: () {
              print('You have not chosen anything');
            },
            tooltip: 'This is tooltip',
            onSelected: _select,
            itemBuilder: (BuildContext context) {
              return choices.map((CustomPopupMenu choice) {
                return PopupMenuItem<CustomPopupMenu>(
                  value: choice,
                  child: Text(choice.title),
                );
              }).toList();
            },
          )*/
        ],
      ),
      body: ListView.builder(
        itemCount: AvailableProducts.availableProducts.length,
        itemBuilder: (context, index) {
          return SimpleFoldingCell(
            frontWidget: buildFrontWidget(AvailableProducts.availableProducts[index]),
            innerTopWidget: buildInnerTopWidget(AvailableProducts.availableProducts[index]),
            innerBottomWidget: buildInnerBottomWidget(),
            cellSize: Size(MediaQuery.of(context).size.width, 90),
            padding: EdgeInsets.all(8.0),
            animationDuration: Duration(milliseconds: 300),
            borderRadius: 10,
            onOpen: () => print('$index cell opened'),
            onClose: () => print('$index cell closed')
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        tooltip: 'Add new product',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildFrontWidget(String productName) {
    return Builder(
      builder: (BuildContext context){
        return GestureDetector(
          onTap: (){
            SimpleFoldingCellState foldingCellState = context.ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());
            foldingCellState?.toggleFold();
          },
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.expand_more, color: Colors.lightBlueAccent),
                    onPressed: (){
                      SimpleFoldingCellState foldingCellState = context.ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());
                      foldingCellState?.toggleFold();
                    },
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    productName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget buildInnerTopWidget(String productName) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
      child: Text(
        productName,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget buildInnerBottomWidget() {
    return Builder(
      builder: (context){
        return GestureDetector(
          onTap: (){
            SimpleFoldingCellState foldingCellState = context.ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());
            foldingCellState?.toggleFold();
          },
          child: Card(
            color: Colors.white,
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.expand_less, color: Colors.lightBlueAccent),
                    onPressed: (){
                      SimpleFoldingCellState foldingCellState = context.ancestorStateOfType(TypeMatcher<SimpleFoldingCellState>());
                      foldingCellState?.toggleFold();
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Initial quantity: 500',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Current quantity: 200',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Quantity Sold: 300',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('CP: 820'),
                      Text('SP: 870'),
                    ],
                  ),
                  IconButton(
                    icon: Icon(Icons.info, color: Colors.lightBlueAccent),
                    onPressed: (){
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

}