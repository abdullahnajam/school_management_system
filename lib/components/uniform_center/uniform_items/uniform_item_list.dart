import 'dart:html';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/model/uniform/uniform_item_model.dart';
import 'package:school_management_system/model/book_model.dart';
import 'package:school_management_system/model/department_model.dart';
import 'package:school_management_system/model/uniform/uniform_category_model.dart';
import 'package:school_management_system/screens/uniform/uniform_edit_item_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_items_screen.dart';
import 'package:school_management_system/screens/uniform/uniform_variation_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
class UniformItemList extends StatefulWidget {
  List<String> categories=[];

  UniformItemList(this.categories);

  @override
  _UniformItemListState createState() => _UniformItemListState();
}


class _UniformItemListState extends State<UniformItemList> {

  String selectedCategory="All Categories";

  Future<List<String>> getCategories()async{
    List<String> list=[];
    list.add("All Categories");
    await FirebaseFirestore.instance.collection('uniform_categories').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        setState(() {
          list.add(UniformCategoryModel.fromMap(data, doc.reference.id).name);
        });
      });
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Items",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(flex: 7,child: Container(),),

              Expanded(
                  flex: 3,
                  child:  Container(
                    padding: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      border: Border.all(
                        color: primaryColor,
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      isExpanded: true,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                          /*filteredCategories.forEach((element) {
                                      if(element!=newValue && element!="All Categories")
                                        filteredCategories.remove(element);
                                    });*/
                        });
                      },
                      items: widget.categories.map<DropdownMenuItem<String>>(
                              (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                  )
              ),

            ],
          ),
          if(selectedCategory=="All Categories")
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('uniform_items').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/json/empty.json',height: 100,width: 120),
                      Text('Something went wrong'),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.size==0){
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(80),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/json/empty.json',height: 100,width: 120),
                        Text('No items are added'),
                      ],
                    ),
                  );
                }
                print("size ${snapshot.data!.size}");
                return new SizedBox(
                  width: double.infinity,
                  child: DataTable2(

                      showCheckboxColumn: false,
                      columnSpacing: defaultPadding,
                      minWidth: 600,
                      columns: [

                        DataColumn(
                          label: Text("Name"),
                        ),
                        DataColumn(
                          label: Text("Thumbnail"),
                        ),
                        DataColumn(
                          label: Text("Code"),
                        ),

                        DataColumn(
                          label: Text("Category"),
                        ),
                        DataColumn(
                          label: Text("Price"),
                        ),
                        DataColumn(
                          label: Text("Quantity Stock"),
                        ),
                        DataColumn(
                          label: Text("SKU"),
                        ),
                        DataColumn(
                          label: Text("Low"),
                        ),
                        DataColumn(
                          label: Text("Variants"),
                        ),
                        DataColumn(
                          label: Text("Gallery"),
                        ),


                        DataColumn(
                          label: Text("Actions"),
                        ),


                      ],
                      rows: _buildList(context, snapshot.data!.docs)

                  ),
                );
              },
            )
          else
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('uniform_items').where("category",isEqualTo: selectedCategory).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/json/empty.json',height: 100,width: 120),
                      Text('Something went wrong'),
                    ],
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    margin: EdgeInsets.all(30),
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.size==0){
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(80),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/json/empty.json',height: 100,width: 120),
                        Text('No items are added'),
                      ],
                    ),
                  );
                }
                print("size ${snapshot.data!.size}");
                return new SizedBox(
                  width: double.infinity,
                  child: DataTable2(

                      showCheckboxColumn: false,
                      columnSpacing: defaultPadding,
                      minWidth: 600,
                      columns: [

                        DataColumn(
                          label: Text("Name"),
                        ),
                        DataColumn(
                          label: Text("Thumbnail"),
                        ),
                        DataColumn(
                          label: Text("Code"),
                        ),

                        DataColumn(
                          label: Text("Category"),
                        ),
                        DataColumn(
                          label: Text("Price"),
                        ),
                        DataColumn(
                          label: Text("Quantity Stock"),
                        ),
                        DataColumn(
                          label: Text("SKU"),
                        ),
                        DataColumn(
                          label: Text("Low"),
                        ),
                        DataColumn(
                          label: Text("Variants"),
                        ),
                        DataColumn(
                          label: Text("Gallery"),
                        ),


                        DataColumn(
                          label: Text("Actions"),
                        ),


                      ],
                      rows: _buildList(context, snapshot.data!.docs)

                  ),
                );
              },
            ),



        ],
      ),
    );
  }
  List<DataRow> _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return  snapshot.map((data) => _buildListItem(context, data)).toList();
  }

  DataRow _buildListItem(BuildContext context, DocumentSnapshot data) {
    UniformItemModel model = UniformItemModel.fromSnapshot(data);
    return DataRow(
        cells: [
          DataCell(Text(model.name)),
          DataCell(Image.network(model.image,height: 50,width: 50,)),
          DataCell(Text(model.code)),
          DataCell(Text(model.category)),
          DataCell(Text(model.price.toString())),
          DataCell(Text(model.stock.toString())),
          DataCell(Text(model.sku.toString())),
          DataCell(Text(model.lowStockQuantity.toString())),

          DataCell(Text("View"),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UniformVariationScreen(model.id)));

              }),
          DataCell(Text("View"),

              onTap: (){
                showDialog<void>(
                  context: context,
                  barrierDismissible: true, // user must tap button!
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) {




                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                          insetAnimationDuration: const Duration(seconds: 1),
                          insetAnimationCurve: Curves.fastOutSlowIn,
                          elevation: 2,

                          child: Container(
                            padding: EdgeInsets.all(20),
                            //height: MediaQuery.of(context).size.height*0.8,
                            width: MediaQuery.of(context).size.width*0.5,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Text("Gallery",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: IconButton(
                                          icon: Icon(Icons.close,color: Colors.grey,),
                                          onPressed: ()=>Navigator.pop(context),
                                        ),
                                      ),
                                    )
                                  ],
                                ),

                                Expanded(
                                  child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                      ),
                                      itemCount: model.gallery.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return Image.network(model.gallery[index]);
                                      }
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
          DataCell(Row(
            children: [
              IconButton(
                icon: Icon(Icons.delete_forever),
                color: primaryColor,
                onPressed: (){
                  AwesomeDialog(
                    dialogBackgroundColor: Colors.white,
                    width: MediaQuery.of(context).size.width*0.3,
                    context: context,
                    dialogType: DialogType.QUESTION,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Delete Item',
                    desc: 'Are you sure you want to delete this record?',
                    btnCancelOnPress: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformItemsScreen(widget.categories)));
                    },
                    btnOkOnPress: () {
                      FirebaseFirestore.instance.collection('uniform_items').doc(model.id).delete().then((value) =>
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => UniformItemsScreen(widget.categories))));
                    },
                  )..show();
                },
              ),
              IconButton(
                icon: Icon(Icons.edit),
                color: primaryColor,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UniformEditItemScreen(model)));

                },
              ),
            ],
          )),

        ]);
  }
}



