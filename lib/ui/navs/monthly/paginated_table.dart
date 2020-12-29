import 'package:ayolee_stores/networking/rest_data.dart';
import 'package:ayolee_stores/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DTS extends DataTableSource{

  DTS({@required this.salesList, @required this.context, @required this.editable});

  final List<Map> salesList;

  final BuildContext context;

  final bool editable;

  /// Converting [dateTime] in string format to return a formatted time
  /// of hrs, minutes and am/pm
  String _getFormattedTime(String dateTime) {
    return DateFormat('EEE, MMM d, h:mm a').format(DateTime.parse(dateTime)).toString();
  }

  @override
  DataRow getRow(int index) {
    if(editable){
      return DataRow.byIndex(index: index, cells: [
        DataCell(
          Text(salesList[index]['qty'].toString()),
        ),
        DataCell(
          Text(salesList[index]['productName'].toString()),
        ),
        DataCell(
          Text(Constants.money(double.parse(salesList[index]['unitPrice']))),
        ),
        DataCell(
          Text(Constants.money(double.parse(salesList[index]['totalPrice']))),
        ),
        DataCell(
          Text(salesList[index]['paymentMode'].toString()),
        ),
        DataCell(
          Text(_getFormattedTime(salesList[index]['time'])),
        ),
      ],
          onSelectChanged: (value){
            _displayDialog(salesList[index]);
          }
      );
    } else {
      return DataRow.byIndex(index: index, cells: [
        DataCell(
          Text(salesList[index]['qty'].toString()),
        ),
        DataCell(
          Text(salesList[index]['productName'].toString()),
        ),
        DataCell(
          Text(Constants.money(double.parse(salesList[index]['unitPrice']))),
        ),
        DataCell(
          Text(Constants.money(double.parse(salesList[index]['totalPrice']))),
        ),
        DataCell(
          Text(salesList[index]['paymentMode'].toString()),
        ),
        DataCell(
          Text(_getFormattedTime(salesList[index]['time'])),
        ),
      ]);
    }

  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => salesList.length;

  @override
  int get selectedRowCount => 0;

  /// Function to display dialog of sales details [index]
  void _displayDialog(Map index){
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(); // To close the dialog
                    _confirmDeleteDialog(index['id']);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                padding: EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Qty: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '${index['qty']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                padding: EdgeInsets.only(right: 10.0, top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Product: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '${index['productName']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                padding: EdgeInsets.only(right: 10.0, top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Unit Price: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '${Constants.money(double.parse(index['unitPrice']))}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                padding: EdgeInsets.only(right: 10.0, top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Total Price: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '${Constants.money(double.parse(index['totalPrice']))}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                padding: EdgeInsets.only(right: 10.0, top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Payment Mode: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '${index['paymentMode']}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5.0, right: 5.0),
                padding: EdgeInsets.only(right: 10.0, top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Time: ',
                      style: TextStyle(
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    Text(
                      '${_getFormattedTime(index['time'])}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  color: Colors.transparent,
                  //textColor: Color(0xFF008752),
                  child: Text('CANCEL'),
                ),
              ),
            ],
          ),
        ),
      ),
      //barrierDismissible: false,
    );
  }

  /// Function to confirm if a report wants to be deleted
  void _confirmDeleteDialog(String id){
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Container(
          //height: 320.0,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Are you sure you want to delete this sales',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // To close the dialog
                        _deleteReport(id);
                      },
                      textColor: Colors.red,
                      child: Text('YES'),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pop(); // To close the dialog
                      },
                      textColor: Colors.red,
                      child: Text('NO'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      //barrierDismissible: false,
    );
  }

  /// Function that deletes a report by calling
  /// [deleteReport] in the [RestDataSource] class
  void _deleteReport(String id){
    var api = new RestDataSource();
    try {
      api.deleteReport(id).then((value) {
        Constants.showMessage('Report successfully deleted');
        notifyListeners();
        //_refreshData();
      }).catchError((error) {
        Constants.showMessage(error.toString());
      });
    } catch (e) {
      print(e);
      Constants.showMessage(e.toString());
    }
  }

}