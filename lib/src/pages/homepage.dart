
import 'package:flutter/material.dart';


import 'package:whiterabittest/src/provider/db_provider.dart';
import 'package:whiterabittest/src/provider/employee_api_provider.dart';


import 'employee_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var isLoading = false;
  bool serch = false;
  var names = [];

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    // Widget buildSearch() => SearchWidget(
    //   text: query,
    //   hintText: 'Title or Author Name',
    //   onChanged: searchBook,
    // );

    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.settings_input_antenna),
              onPressed: () async {
                await _loadFromApi();
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await _deleteData();
              },
            ),
          ),
          IconButton(icon: Icon(Icons.search_rounded), onPressed: (){
            setState(() {
              serch = true;

            });

          })
        ],
      ),
      body: serch==false?isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : _buildEmployeeListView()
      : FutureBuilder(
        future: DBProvider.db.getAllEmployees(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [

                Expanded(
                  child: ListView.separated(

                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black12,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        hoverColor: Colors.teal,

                        onTap: (){
                          print(index);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EmployeeDetailPage(email:snapshot.data[index].email,name: snapshot.data[index].id.toString(),)),
                          );

                        },
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow
                          ),
                          child: snapshot.data[index].avatar==null?Text("hello"):Image.network(snapshot.data[index].avatar),
                        ),
                        title: Text(snapshot.data[index].id.toString()),
                        subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
                      );
                    },
                  ),
                )
              ],
            );
          }
        },
      ),
    );

  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;

    });

    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    print('All employees deleted');
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(

            separatorBuilder: (context, index) => Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmployeeDetailPage(email:snapshot.data[index].email,name: snapshot.data[index].id.toString(),)),
                  );
                },
                leading: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow
                  ),
                  child: snapshot.data[index].avatar==null?Text("hello"):Image.network(snapshot.data[index].avatar),
                ),
                title: Text(snapshot.data[index].id.toString()),
                subtitle: Text('EMAIL: ${snapshot.data[index].email}'),
              );
            },
          );
        }
      },
    );
  }

}
//${snapshot.data[index].firstName} ${snapshot.data[index].lastName}
//${snapshot.data[index].email}