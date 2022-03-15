import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lazy_data_table/lazy_data_table.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/components/uniform_center/uniform_items/uniform_item_list.dart';
import 'package:school_management_system/model/uniform/uniform_attribute_model.dart';
import 'package:school_management_system/model/uniform/uniform_item_model.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:chitose/chitose.dart';
import 'package:firebase/firebase.dart' as fb;

class AddUniformVariation extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;
  List<String> variants;UniformItemModel uniformItemModel;
  List<SelectedUniformItemAttributeModel> selectedUniformItemAttributeModel;

  AddUniformVariation(this._scaffoldKey,this.variants,this.uniformItemModel,this.selectedUniformItemAttributeModel);

  @override
  _AddUniformVariationState createState() => _AddUniformVariationState();
}

class _AddUniformVariationState extends State<AddUniformVariation> {

  List<String> imageUrl=[];
  fb.UploadTask? _uploadTask;
  Uri? imageUri;
  List<bool> imageUploading=[];

  uploadToFirebase(File imageFile,index) async {
    final filePath = 'images/${DateTime.now()}.png';

    print("put");
    setState((){
      imageUploading[index]=true;
      _uploadTask = fb.storage().refFromURL(storageBucketPath).child(filePath).put(imageFile);
    });

    fb.UploadTaskSnapshot taskSnapshot = await _uploadTask!.future;
    imageUri = await taskSnapshot.ref.getDownloadURL();
    setState((){
      imageUrl[index]=imageUri.toString();
      imageUploading[index]=false;
      print(imageUrl);
    });

  }

  uploadImage(int index) async {
    // HTML input element
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen(
          (changeEvent) {
        final file = uploadInput.files!.first;
        final reader = FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen(
              (loadEndEvent) async {
            uploadToFirebase(file,index);
          },
        );
      },
    );
  }

  Future addUniformItem(id) async{
    FirebaseFirestore.instance.collection('uniform_items').doc(id).set({
      'name': widget.uniformItemModel.name,
      'description': widget.uniformItemModel.description,
      'gallery': widget.uniformItemModel.gallery,
      'lowStockQuantity': widget.uniformItemModel.lowStockQuantity,
      'quantity': widget.uniformItemModel.quantity,
      'price': widget.uniformItemModel.price,
      'stock': widget.uniformItemModel.stock,
      'sku': widget.uniformItemModel.sku,
      'category': widget.uniformItemModel.category,
      'image': widget.uniformItemModel.image,
      'code': widget.uniformItemModel.code,
      'isArchived': false,
      'categoryId': widget.uniformItemModel.categoryId,
      'datePosted': DateTime.now().millisecondsSinceEpoch,
    }).then((value) {
      print("added");
    });
  }

  Future addUniformVariation(int index,itemId) async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: widget.variants.length, msg: "Adding variants");
    // String id,name,price,sku,quantity,image;
    FirebaseFirestore.instance.collection('uniform_variations').add({
      'name': widget.variants[index],
      'price': price[index].text,
      'item': widget.uniformItemModel.name,
      'itemId': itemId,
      'quantity': quantity[index].text,
      'sku': sku[index].text,
      'image': imageUrl[index],
      'isArchived': false,
      'datePosted': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future addSelectedUniformAttribute(int index,itemId) async{
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: widget.variants.length, msg: "Adding variants");
    // String id,name,price,sku,quantity,image;
    FirebaseFirestore.instance.collection('selected_item_attributes').add({
      'itemId': itemId,
      'name': widget.selectedUniformItemAttributeModel[index].name,
      'attributeId':  widget.selectedUniformItemAttributeModel[index].id,
      'valueIds': widget.selectedUniformItemAttributeModel[index].valueIds,

    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Item Variants",widget._scaffoldKey),
            SizedBox(height: defaultPadding),
            Padding(
              padding: const EdgeInsets.all(16),
              child: DataTable2(
                  columnSpacing: 12,
                  horizontalMargin: 12,
                  minWidth: 600,
                  columns: [

                    DataColumn(
                      label: Text('Variant'),
                    ),
                    DataColumn(
                      label: Text('Price'),
                    ),
                    DataColumn(
                      label: Text('SKU'),
                    ),
                    DataColumn(
                      label: Text('Quantity'),
                    ),
                    DataColumn(
                      label: Text('Picture'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                      widget.variants.length,
                          (index) => DataRow(cells: [
                            DataCell(
                                Text(widget.variants[index])
                            ),

                            DataCell(
                                TextFormField(
                                  controller: price[index],
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                ),
                            ),
                            DataCell(
                              TextFormField(
                              controller: sku[index],
                              style: TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 0.5
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7.0),
                                  borderSide: BorderSide(
                                    color: primaryColor,
                                    width: 0.5,
                                  ),
                                ),
                                hintText: "",
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                              ),
                            ),
                            ),
                            DataCell(
                                TextFormField(
                                  controller: quantity[index],
                                  style: TextStyle(color: Colors.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                          color: primaryColor,
                                          width: 0.5
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "",
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                )
                            ),
                            DataCell(
                                imageUploading[index]?Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Uploading",style: TextStyle(color: primaryColor),),
                                      SizedBox(width: 10,),
                                      CircularProgressIndicator()
                                    ],),
                                ):imageUrl==""?
                                Image.asset("assets/images/placeholder.png",height: 100,width: 150,fit: BoxFit.cover,)
                                    :Image.network(imageUrl[index],height: 100,width: 150,fit: BoxFit.cover,),
                              onTap: (){
                                uploadImage(index);
                              }
                            ),
                            DataCell(
                              IconButton(
                                onPressed: (){
                                  setState(() {
                                    widget.variants.removeAt(index);
                                  });
                                },
                                icon: Icon(Icons.delete_forever,color: Colors.red,),
                              ),
                            )


                      ]))),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                ElevatedButton.icon(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: defaultPadding * 1.5,
                      vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                    ),
                  ),
                  onPressed: () async{
                    String id = DateTime.now().millisecondsSinceEpoch.toString();
                    final ProgressDialog pr = ProgressDialog(context: context);
                    pr.show(max: 100, msg: "Adding variants",barrierDismissible: true);
                    await addUniformItem(id).then((value)async{
                      for(int i=0;i<widget.variants.length;i++){
                        await addUniformVariation(i,id);
                      }
                      for(int i=0;i<widget.selectedUniformItemAttributeModel.length;i++){
                        await addSelectedUniformAttribute(i,id);
                      }
                    });
                    pr.close();
                  },
                  icon: Icon(Icons.add),
                  label: Text("Add Uniform Item"),
                ),
              ],
            ),


          ],
        ),
      ),
    );
  }
  List<TextEditingController> price=[];
  List<TextEditingController> sku=[];
  List<TextEditingController> quantity=[];
  List<String> imageUrls=[];
  @override
  void initState() {
    super.initState();
    imageUrl=List<String>.generate(widget.variants.length, (index) => "");
    imageUploading=List<bool>.generate(widget.variants.length, (index) => false);
    widget.variants.forEach((element) {
      price.add(TextEditingController());
      sku.add(TextEditingController());
      quantity.add(TextEditingController());
    });
  }
}
