import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/components/uniform_center/uniform_items/uniform_item_list.dart';
import 'package:school_management_system/model/uniform/uniform_attribute_model.dart';
import 'package:school_management_system/model/uniform/uniform_item_model.dart';
import 'package:school_management_system/screens/uniform/uniform_add_variation_screen.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:chitose/chitose.dart';
import 'package:firebase/firebase.dart' as fb;

class AddUniformItem extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;

  AddUniformItem(this._scaffoldKey);

  @override
  _AddUniformItemState createState() => _AddUniformItemState();
}

class _AddUniformItemState extends State<AddUniformItem> {

  var _nameController=TextEditingController();
  var _codeController=TextEditingController();
  var _categoryController=TextEditingController();
  var _priceController=TextEditingController();
  var _quantityController=TextEditingController();
  var _desController=TextEditingController();
  var _lowStockWarningController=TextEditingController();
  var _stockController=TextEditingController();
  var _skuController=TextEditingController();
  List<TextEditingController> _valueController = [];
  List<List<bool>> selectedValues=[];
  List<List<UniformAttributeModel>> attributeValues=[];
  List<UniformAttributeModel> attributes=[];
  Future<List<UniformAttributeModel>> getAttributes()async{
    attributes=[];
    await FirebaseFirestore.instance.collection('uniform_attributes').get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) async{
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
        attributes.add(UniformAttributeModel.fromMap(data, doc.reference.id));
        _valueController.add(TextEditingController());
        List<bool> valueCheck=[];
        List<UniformAttributeModel> valuePlaceholder=[];
        await FirebaseFirestore.instance.collection('attribute_values').where("attributeId",isEqualTo: doc.reference.id).get().then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
            valuePlaceholder.add(UniformAttributeModel.fromMap(data, doc.reference.id));
            valueCheck.add(false);


          });
        });
        attributeValues.add(valuePlaceholder);
        selectedValues.add(valueCheck);

      });
    });
    
    print("lenghts controller ${_valueController.length}, attributes ${attributes.length} values ${attributeValues.length}");
    return attributes;
  }
  Future<List<UniformAttributeModel>> getAttributeValues(String id,int index)async{
    List<UniformAttributeModel> values=[];

    return values;
  }
  String _categoryId="";

  String imageUrl="";
  fb.UploadTask? _uploadTask;
  Uri? imageUri;
  bool imageUploading=false;

  List<String> galleryImagesUrl=[];
  Uri? galleryImageUri;
  List<bool> galleryImageUploading=[];


  uploadToFirebase(File imageFile) async {
    final filePath = 'images/${DateTime.now()}.png';

    print("put");
    setState((){
      imageUploading=true;
      _uploadTask = fb.storage().refFromURL(storageBucketPath).child(filePath).put(imageFile);
    });

    fb.UploadTaskSnapshot taskSnapshot = await _uploadTask!.future;
    imageUri = await taskSnapshot.ref.getDownloadURL();
    setState((){
      imageUrl=imageUri.toString();
      imageUploading=false;
      //imageUrl= "https://firebasestorage.googleapis.com/v0/b/accesfy-882e6.appspot.com/o/bookingPics%2F1622649147001?alt=media&token=45a4483c-2f29-48ab-bcf1-813fd8fa304b";
      print(imageUrl);
    });

  }

  uploadGalleryImagesToFirebase(File imageFile,int index) async {
    final filePath = 'images/${DateTime.now()}.png';

    print("put");
    setState((){
      galleryImageUploading[index]=true;
      _uploadTask = fb.storage().refFromURL(storageBucketPath).child(filePath).put(imageFile);
    });

    fb.UploadTaskSnapshot taskSnapshot = await _uploadTask!.future;
    galleryImageUri = await taskSnapshot.ref.getDownloadURL();
    setState((){
      galleryImagesUrl[index]=galleryImageUri.toString();
      galleryImageUploading[index]=false;

    });

  }

  uploadGalleryImage(int index) async {
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
                uploadGalleryImagesToFirebase(file, index);
          },
        );
      },
    );
  }
  uploadImage() async {
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
            uploadToFirebase(file);
          },
        );
      },
    );
  }


  Future<void> _showVariationDialog( List<String> variations) async {
    final _formKey = GlobalKey<FormState>();
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context,setState){
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
                width: MediaQuery.of(context).size.width*0.5,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child: Text("Add Variations",textAlign: TextAlign.center,style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
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
                        child: ListView.builder(
                          itemCount: variations.length,
                          itemBuilder: (BuildContext context, int index){
                            return Text(variations[index]);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(defaultPadding),
        child: ListView(
          children: [
            Header("Uniform Item",widget._scaffoldKey),
            SizedBox(height: defaultPadding),
            Container(
              padding: EdgeInsets.all(defaultPadding*2),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Item Information",
                    style: Theme.of(context).textTheme.headline6!.apply(color:primaryColor),
                  ),
                  SizedBox(height: 10,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                      ),
                      TextFormField(
                        controller: _nameController,
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

                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                      ),
                      TextFormField(
                        controller: _desController,
                        maxLines: 3,
                        minLines: 3,
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

                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Barcode",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                      ),
                      TextFormField(
                        controller: _codeController,
                        style: TextStyle(color: Colors.black),
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

                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Unit Price",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                      ),
                      TextFormField(
                        controller: _priceController,
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

                    ],
                  ),

                  SizedBox(height: 10,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Low Stock Warning",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                      ),
                      TextFormField(
                        controller: _lowStockWarningController,
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

                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quantity Stock",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                      ),
                      TextFormField(
                        controller: _stockController,
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

                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "SKU",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                      ),
                      TextFormField(
                        controller: _skuController,
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

                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Category",
                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                      ),
                      TextFormField(
                        readOnly: true,
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return StatefulBuilder(
                                  builder: (context,setState){
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
                                        width: MediaQuery.of(context).size.width*0.3,
                                        child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance.collection('uniform_categories').snapshots(),
                                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                            if (snapshot.hasError) {
                                              return Center(
                                                child: Column(
                                                  children: [
                                                    Image.asset("assets/images/wrong.png",width: 150,height: 150,),
                                                    Text("Something Went Wrong",style: TextStyle(color: Colors.black))

                                                  ],
                                                ),
                                              );
                                            }

                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return Center(
                                                child: CircularProgressIndicator(),
                                              );
                                            }
                                            if (snapshot.data!.size==0){
                                              return Center(
                                                child: Column(
                                                  children: [
                                                    Image.asset("assets/images/empty.png",width: 150,height: 150,),
                                                    Text("No Category Added",style: TextStyle(color: Colors.black))

                                                  ],
                                                ),
                                              );

                                            }

                                            return new ListView(
                                              shrinkWrap: true,
                                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                                Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                                                return new Padding(
                                                  padding: const EdgeInsets.all(15.0),
                                                  child: ListTile(
                                                    onTap: (){
                                                      setState(() {
                                                        _categoryController.text="${data['name']}";
                                                        _categoryId=document.reference.id;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
                                                  ),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                          );
                        },
                        controller: _categoryController,
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

                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 100,
                        width: 150,
                        child: imageUploading?Padding(
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
                            :Image.network(imageUrl,height: 100,width: 150,fit: BoxFit.cover,),
                      ),

                      InkWell(
                        onTap: (){
                          uploadImage();
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width*0.2,
                          color: Colors.black,
                          alignment: Alignment.center,
                          child: Text("Add Thumbnail Image",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width*0.5,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: galleryImagesUrl.length,
                          itemBuilder: (BuildContext context , int index){
                            return Stack(
                              children: [
                                Container(
                                  height: 100,
                                  width: 150,
                                  child: galleryImageUploading[index]?Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text("Uploading",style: TextStyle(color: primaryColor),),
                                        SizedBox(width: 10,),
                                        CircularProgressIndicator()
                                      ],),
                                  ):galleryImagesUrl[index]==""?
                                  Image.asset("assets/images/placeholder.png",height: 100,width: 150,fit: BoxFit.cover,)
                                      :Image.network(galleryImagesUrl[index],height: 100,width: 150,fit: BoxFit.cover,),
                                ),
                                galleryImagesUrl[index]==""?Container():Align(
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: (){
                                      setState(() {
                                        galleryImageUploading.removeAt(index);
                                        galleryImagesUrl.removeAt(index);
                                      });
                                    },
                                    child: Icon(Icons.close,color: Colors.white,size: 15,),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),


                      InkWell(
                        onTap: (){
                          setState(() {
                            galleryImagesUrl.add("");
                            galleryImageUploading.add(true);

                          });
                          uploadGalleryImage(galleryImagesUrl.length-1);
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width*0.2,
                          color: Colors.black,
                          alignment: Alignment.center,
                          child: Text("Add Gallery Images",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10,),
                      Text(
                        "Attributes",
                        style: Theme.of(context).textTheme.headline6!.apply(color:primaryColor),
                      ),
                      SizedBox(height: 10,),
                      FutureBuilder<List<UniformAttributeModel>>(
                        future: getAttributes(),
                        builder: (BuildContext context, AsyncSnapshot<List<UniformAttributeModel>> snapshot) {
                          if (snapshot.hasData) {
                            if(snapshot.data==null){
                              return Text("No Attributes");
                            }
                            else{
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (BuildContext context,int index){
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].name,
                                        style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),
                                      ),
                                      TextFormField(
                                        readOnly: true,
                                        onTap: (){
                                          print("index $index");

                                          if(attributeValues[index].length>0){
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext context){
                                                  return StatefulBuilder(
                                                    builder: (context,setState){
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
                                                          width: MediaQuery.of(context).size.width*0.3,
                                                          height: MediaQuery.of(context).size.height*0.8,
                                                          child: Column(
                                                            children: [

                                                              Container(
                                                                height: MediaQuery.of(context).size.height*0.65,
                                                                child: ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: attributeValues[index].length,
                                                                  itemBuilder: (BuildContext context,int valueIndex){
                                                                    return Padding(
                                                                        padding: const EdgeInsets.all(15.0),
                                                                        child: CheckboxListTile(
                                                                          title: Text(attributeValues[index][valueIndex].name),
                                                                          value: selectedValues[index][valueIndex],
                                                                          onChanged: (bool? value) {
                                                                            setState(() {
                                                                              selectedValues[index][valueIndex] = value!;
                                                                            });
                                                                          },
                                                                        )
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              InkWell(
                                                                onTap: (){
                                                                  String values="";
                                                                  for(int i=0;i<selectedValues[index].length;i++){
                                                                    if(selectedValues[index][i]){
                                                                      values+=" ${attributeValues[index][i].name}";
                                                                    }
                                                                  }

                                                                  _valueController[index].text=values;
                                                                  Navigator.pop(context);
                                                                },
                                                                child: Container(
                                                                  height: 50,
                                                                  margin: EdgeInsets.all(10),
                                                                  color: Colors.black,
                                                                  alignment: Alignment.center,
                                                                  child: Text("Add",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                }
                                            );
                                          }
                                          else{
                                            showDialog<void>(
                                              context: context,
                                              barrierDismissible: false, // user must tap button!
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('No Values',style: TextStyle(color: Colors.black),),
                                                  content: SingleChildScrollView(
                                                    child: ListBody(
                                                      children:  <Widget>[
                                                        Text("This attribute has no values",style: TextStyle(color: Colors.black)),
                                                      ],
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(

                                                      child: const Text('OK',style: TextStyle(color: Colors.black)),
                                                      onPressed: () async{
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }

                                        },
                                        controller: _valueController[index],
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
                                      SizedBox(height: 10,),

                                    ],
                                  );
                                },
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          else {
                            return Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text(''),
                            );
                          }

                        },
                      ),

                    ],
                  ),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: (){
                      final ProgressDialog pr = ProgressDialog(context: context);
                      pr.show(max: 100, msg: "Adding");
                      List<List<String>> selectedAttributeValuesName=[];
                      List<SelectedUniformItemAttributeModel> selectedAttributeObj=[];

                      print("selectedValues ${selectedValues.length} attributes ${attributes.length}");
                      for(int j=0;j<selectedValues.length;j++){
                        selectedAttributeValuesName.add([]);
                        String id=attributes[j].id;
                        String name=attributes[j].name;
                        List valueIds=[];

                        for(int i=0;i<selectedValues[j].length;i++){
                          if(selectedValues[j][i]){
                            valueIds.add(attributeValues[j][i].id);
                            selectedAttributeValuesName[selectedAttributeValuesName.length-1].add(attributeValues[j][i].name);
                          }
                        }

                        SelectedUniformItemAttributeModel model=new SelectedUniformItemAttributeModel(
                          "id",
                          name,
                          id,
                          valueIds
                        );
                        selectedAttributeObj.add(model);
                        if(selectedAttributeValuesName[selectedAttributeValuesName.length-1].length==0){
                          selectedAttributeValuesName.removeAt(selectedAttributeValuesName.length-1);
                        }
                      }

                      List<List<String>> variations=combinations(selectedAttributeValuesName).map((e) => e.toList()).toList();
                      List<String> itemVariation=[];
                      for(int i=0;i<variations.length;i++){
                        print("variation main $i ${variations[i]}");
                        String variation="";
                        variations[i].forEach((element) {
                          variation+=", $element";
                        });

                        itemVariation.add(variation.substring(2));
                      }
                      itemVariation.forEach((element) {
                        print("sahi wali $element");
                      });
                      pr.close();
                      UniformItemModel item=new UniformItemModel(
                        "",
                        _nameController.text,
                        _codeController.text,
                        _lowStockWarningController.text,
                        galleryImagesUrl,
                        _categoryId,
                        _categoryController.text,
                        _desController.text,
                        _quantityController.text,
                        imageUrl,
                        int.parse(_priceController.text),
                          int.parse(_stockController.text),
                          int.parse(_skuController.text),
                        false,
                        DateTime.now().millisecondsSinceEpoch
                      );

                      print("check the list");
                      selectedAttributeObj.removeWhere((element) => element.valueIds.length==0);
                      for(int i =0;i<selectedAttributeObj.length;i++){
                        print("index $i name : ${selectedAttributeObj[i].name} values : ${selectedAttributeObj[i].valueIds.length}");
                      }

                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => UniformAddVariationScreen(item,itemVariation,selectedAttributeObj)));

                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width*0.7,
                      color: primaryColor,
                      alignment: Alignment.center,
                      child: Text("Add Uniform Item",style: Theme.of(context).textTheme.button!.apply(color: Colors.white),),
                    ),
                  )




                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
