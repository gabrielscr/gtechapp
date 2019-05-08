import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produtos'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Card(
              color: Colors.white10,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage('assets/img/admin.png'),
                ),
                title: Text('Produto 01'),
                subtitle: Text('teste'),
                trailing: Icon(Icons.delete, color: Colors.red,),
                onTap: () => {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
