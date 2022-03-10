import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:school_management_system/components/uniform_center/uniform_delivery/uniform_delivery_list.dart';
import 'package:school_management_system/model/checklist_model.dart';
import 'package:school_management_system/model/student_model.dart';
import 'package:school_management_system/model/uniform/uniform_delivery_model.dart';
import 'package:school_management_system/model/uniform/uniform_item_model.dart';
import 'package:school_management_system/model/uniform/uniform_variant_model.dart';
import 'package:school_management_system/utils/constants.dart';
import 'package:school_management_system/utils/header.dart';
import 'package:school_management_system/utils/responsive.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:firebase/firebase.dart' as fb;



class UniformAddDeliveryItem extends StatefulWidget {

  GlobalKey<ScaffoldState> _scaffoldKey;
  List<String> categories=[];

  UniformAddDeliveryItem(this._scaffoldKey,this.categories);

  @override
  _UniformAddDeliveryItemState createState() => _UniformAddDeliveryItemState();
}

class _UniformAddDeliveryItemState extends State<UniformAddDeliveryItem> {



  DateTime? dueDate,fromDate;
  int dueDateInMilli=DateTime.now().millisecondsSinceEpoch;
  int fromDateInMilli=DateTime.now().millisecondsSinceEpoch;

  Future setQuantity(List<_ItemDeliveryModel> items) async {
    items.forEach((element) {
      int newQuantity=element.item.stock-element.quantity;
      FirebaseFirestore.instance.collection('uniform_items').doc(element.item.id).update({
        'stock': newQuantity,
      });
    });


  }


  add(StudentModel _student,List<_ItemDeliveryModel> selectedItem,int fees) async{
    final f = new DateFormat('MM-yyyy');
    print("rr");
    final ProgressDialog pr = ProgressDialog(context: context);
    pr.show(max: 100, msg: "Adding");
    List<String> itemIds=[];
    List<String> variantIds=[];
    List<int> quantities=[];
    selectedItem.forEach((element) {
      itemIds.add(element.item.id);
      variantIds.add(element.variants.id);
      quantities.add(element.quantity);

    });
    FirebaseFirestore.instance.collection('uniform_deliveries').add({
      'student': "${_student.firstName} ${_student.lastName}",
      'item': itemIds,
      'variants': variantIds,
      'quantities': quantities,
      'studentId': _student.id,
      'status': "Pending",
      'payment': "Not Paid",
      'amount': getCount(selectedItem),
      'isArchived': false,
      'datePosted': DateTime.now().millisecondsSinceEpoch,
    }).then((value) {
      FirebaseFirestore.instance.collection('payment_info').add({
        'itemId': value.id,
        'amountPaid': 0,
        'amountDue': fees,
        'cashPayment': 0,
        'visaPayment': 0,
        'masterCardPayment': 0,
        'message':"none",

        'depositorName':"",
        'visaPaymentDate':"",
        'bankPaymentDate':"",
        'receiptNumber':"",
        'bankReceiptNumber':"",
        'image':"",
        'discountCategory':"",
        'discountName':"",
        'finalAmount':"",

        'isArchived': false,
        'datePosted': DateTime.now().millisecondsSinceEpoch,
      });
      FirebaseFirestore.instance.collection('fees').add({
        'student':  "${_student.firstName} ${_student.lastName}",
        'school': _student.school,
        'itemId': value.id,
        'department': _student.department,
        'studentId': _student.id,
        'parentId': _student.parentId,
        'parent': _student.parent,
        'schoolId': _student.schoolId,
        'dueDate': "",
        'fromDate': f.format(DateTime.now()),
        'discount': "none",
        'discountId': "none",
        'feeCategoryId': "none",
        'feeCategory': "Uniform Fees",
        'fees': fees,
        'academicYear': "",
        'dueDateInMilli': dueDateInMilli,
        'fromDateInMilli': fromDateInMilli,
        'grade': _student.grade,
        'message':"none",
        'gradeId': _student.gradeId,
        'departmentId': _student.departmentId,
        'isArchived': false,
        'isDiscountInPercentage': false,
        'status':"Not Paid",
        'amountPaid': 0,
        'amountDue': fees,
        'cashPayment': 0,
        'visaPayment': 0,
        'masterCardPayment': 0,
        'datePosted': DateTime.now().millisecondsSinceEpoch,
      }).then((value) async{
        await setQuantity(selectedItem);
        pr.close();
        print("added");
        Navigator.pop(context);
      });
    });
  }


  int getCount(List<_ItemDeliveryModel> list){
    int i = 0;
    list.forEach((element) {
      i+=element.item.price*element.quantity;
    });
    return i;
  }

  List<String> filteredCategories=[];
  String selectedCategory="All Categories";
  @override
  void initState() {
    super.initState();
    setState(() {

      filteredCategories=widget.categories;
    });
  }

  Future variantSelection(int index){
    return showDialog(
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
                  child: Column(

                    children: [
                      Expanded(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('uniform_variations').snapshots(),
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
                                    Text("No Variants Added",style: TextStyle(color: Colors.black))

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
                                      setVariant(index, VariantModel.fromMap(data, document.reference.id));
                                      Navigator.pop(context);
                                    },
                                    leading: CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(data['image']),
                                      backgroundColor: Colors.indigoAccent,
                                      foregroundColor: Colors.white,
                                    ),
                                    title: Text("${data['name']}",style: TextStyle(color: Colors.black),),
                                    subtitle:  Text("${data['price']} EGP",style: TextStyle(color: Colors.black),),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }
  setVariant(int index,variant){
    setState(() {
      list[index].variants=variant;
    });

  }

  StudentModel? stdModel;
  List<_ItemDeliveryModel> list=[];

  addItemToCart(_ItemDeliveryModel item){
    setState(() {
      list.add(item);
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            Header("Uniform Delivery",widget._scaffoldKey),
            SizedBox(height: defaultPadding),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(flex: 4,child: Container(),),
                          Expanded(
                            flex: 3,
                            child: Container(
                              margin: EdgeInsets.all(10),
                              child:TypeAheadField(

                                textFieldConfiguration: TextFieldConfiguration(
                                  autofocus: false,
                                  style: DefaultTextStyle.of(context).style,
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
                                      borderSide:
                                      BorderSide(color: primaryColor, width: 0.5),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 0.5,
                                      ),
                                    ),
                                    hintText: "Search",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                  ),
                                ),
                                suggestionsCallback: (pattern) async {
                                  List<UniformItemModel> suggestion = [];
                                  await FirebaseFirestore.instance.collection('uniform_items').get().then((QuerySnapshot querySnapshot) {
                                    querySnapshot.docs.forEach((doc) {
                                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                      UniformItemModel model = UniformItemModel.fromMap(data, doc.reference.id);
                                      if ("${model.name}".toLowerCase().contains(pattern.toLowerCase())) {
                                        suggestion.add(model);

                                      }
                                    });
                                  });
                                  return suggestion;
                                },
                                itemBuilder: (context, UniformItemModel suggestion) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage:
                                      NetworkImage(suggestion.image),
                                    ),
                                    title: Text(
                                      "${suggestion.name}",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    subtitle: Text(
                                      "${suggestion.price} EGP",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                },
                                onSuggestionSelected: (UniformItemModel suggestion) {
                                  setState(() {
                                    VariantModel variant=VariantModel(
                                        "",
                                        "",
                                        "",
                                        "",
                                        "",
                                        "",
                                        "",
                                        "",
                                        false,
                                        0
                                    );

                                    _ItemDeliveryModel model=_ItemDeliveryModel(0, suggestion, variant);
                                    list.add(model);
                                  });
                                },
                              ),
                            ),
                          ),
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
                      SizedBox(height: defaultPadding),
                      if(selectedCategory=="All Categories")
                        StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('uniform_items').snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text("Loading");
                          }
                          if(snapshot.data!.size==0){
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

                          return GridView(
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            children: snapshot.data!.docs.map((DocumentSnapshot document) {
                              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                              UniformItemModel item=UniformItemModel.fromMap(data, document.reference.id);
                              return InkWell(
                                onTap: (){
                                  setState(() {
                                    VariantModel variant=VariantModel(
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      "",
                                      false,
                                      0
                                    );
                                    int index=list.length>0?list.length-1:0;
                                    _ItemDeliveryModel model=_ItemDeliveryModel(1, item, variant);
                                    showProductDetail(model);

                                    //list.add(model);
                                  });
                                },
                                child: Card(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(item.image),
                                                  fit: BoxFit.cover
                                              )
                                          ),

                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          children: [
                                            Text(item.name),
                                            SizedBox(height: 5),
                                            Text("${item.price} EGP"),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      )
                      else
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance.collection('uniform_items').where("category",isEqualTo: selectedCategory).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading");
                            }
                            if(snapshot.data!.size==0){
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

                            return GridView(
                              shrinkWrap: true,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                                UniformItemModel item=UniformItemModel.fromMap(data, document.reference.id);
                                return InkWell(
                                  onTap: (){
                                    setState(() {
                                      VariantModel variant=VariantModel(
                                          "",
                                          "",
                                          "",
                                          "",
                                          "",
                                          "",
                                          "",
                                          "",
                                          false,
                                          0
                                      );
                                      _ItemDeliveryModel model=_ItemDeliveryModel(0, item, variant);
                                      list.add(model);
                                    });
                                  },
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(item.image),
                                                    fit: BoxFit.cover
                                                )
                                            ),

                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            children: [
                                              Text(item.name),
                                              SizedBox(height: 5),
                                              Text("${item.price} EGP"),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      if (Responsive.isMobile(context))
                        SizedBox(height: defaultPadding),
                      if (Responsive.isMobile(context)) DeliverySidebar(list),


                    ],
                  ),
                ),
                if (!Responsive.isMobile(context))
                  SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 3,
                    child: DeliverySidebar(list),
                  ),



              ],
            )
          ],
        ),
      ),
    );
  }
  Widget DeliverySidebar(List<_ItemDeliveryModel> items){
    return Container(
      height: MediaQuery.of(context).size.height*0.9,
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child:TypeAheadField(

              textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                style: DefaultTextStyle.of(context).style,
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
                    borderSide:
                    BorderSide(color: primaryColor, width: 0.5),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7.0),
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 0.5,
                    ),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                  floatingLabelBehavior:
                  FloatingLabelBehavior.always,
                ),
              ),
              suggestionsCallback: (pattern) async {
                List<StudentModel> suggestion = [];
                await FirebaseFirestore.instance.collection('students').get().then((QuerySnapshot querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                    StudentModel model = StudentModel.fromMap(data, doc.reference.id);
                    if ("${model.firstName} ${model.lastName}".toLowerCase().contains(pattern.toLowerCase())) {
                      suggestion.add(model);

                    }
                  });
                });
                return suggestion;
              },
              itemBuilder: (context, StudentModel suggestion) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                    NetworkImage(suggestion.photo),
                  ),
                  title: Text(
                    "${suggestion.firstName} ${suggestion.lastName}",
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Text(
                    suggestion.email,
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
              onSuggestionSelected: (StudentModel suggestion) {
                setState(() {
                  stdModel=suggestion;
                });
              },
            ),
          ),
          SizedBox(height: 20,),
          Text("Student",style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),),
          SizedBox(height: 10,),
          stdModel!=null?ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(stdModel!.photo),
            ),
            title: Text(
              "${stdModel!.firstName} ${stdModel!.lastName}",
              style: TextStyle(color: Colors.black),
            ),
            subtitle: Text(
              stdModel!.school,
              style: TextStyle(color: Colors.black),
            ),
          ):Text("Select a student",style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.black),),
          Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            height:MediaQuery.of(context).size.height*0.4,
            child: ListView.builder(
              itemCount: items.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context,int index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            InkWell(
                                onTap: (){
                                  setState(() {
                                    items[index].quantity++;
                                  });

                                },
                                child: Icon(Icons.add,color: primaryColor,)),
                            SizedBox(height: 5,),
                            Text(items[index].quantity.toString(),style: Theme.of(context).textTheme.headline5!.apply(color: Colors.black),),
                            SizedBox(height: 5,),
                            InkWell(
                                onTap:(){
                                  if(items[index].quantity>0){
                                    setState(() {
                                      items[index].quantity--;
                                    });
                                  }
                            },
                                child: Icon(Icons.minimize,color: primaryColor,)),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child:  Column(
                          children: [
                            Text(items[index].item.name,style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    variantSelection(index);
                                  });
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    items[index].variants.id==""?
                                    Text("Select Variant",style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black),)
                                    :
                                    Text(items[index].variants.name,style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black),),
                                    Icon(Icons.arrow_drop_down,color: Colors.grey,)
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text("${items[index].item.price} EGP",style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.black),)
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              items.removeAt(index);
                            });
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.red.shade200,
                            child: Icon(Icons.delete_forever_outlined,color: Colors.red,),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Sub Total",style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),),
              Text(getCount(items).toString(),style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.black),),
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Discount",style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),),
              Text("0",style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.black),),
            ],
          ),
          SizedBox(height: 10,),
          Divider(color: Colors.grey,),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total",style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),),
              Text(getCount(items).toString(),style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.black),),
            ],
          ),
          SizedBox(height: 10,),
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
                onPressed: () {
                  if(stdModel==null){
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.error,
                      text: "Please select a student",
                    );
                  }
                  else{
                    add(stdModel!, items, getCount(items));
                  }

                },
                icon: Icon(Icons.shopping_cart_rounded),
                label: Text("Place Order"),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Future showProductDetail(_ItemDeliveryModel model){
    String image=model.item.image;
    int totalPrice=model.item.price;
    return showDialog(
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
                  width: MediaQuery.of(context).size.width*0.7,
                  height: MediaQuery.of(context).size.height*0.7,
                  child: Row(

                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: model.item.gallery.length,
                            itemBuilder: (BuildContext context,int index){
                              return InkWell(
                                onTap: (){
                                  setState(() {

                                    image=model.item.gallery[index];
                                  });
                                },
                                child: Container(
                                  decoration:BoxDecoration(
                                  ) ,
                                  child: Image.network(model.item.gallery[index],height: 100,fit: BoxFit.cover,),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          child: Image.network(image),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      model.item.name,
                                      style: Theme.of(context).textTheme.headline6!.apply(color: Colors.black),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Product Description",
                                      style: Theme.of(context).textTheme.bodyText2!.apply(color: primaryColor),
                                    ),
                                    Text(
                                      model.item.description,
                                      style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black),
                                    ),
                                    SizedBox(height: 10,),
                                    Text(
                                      "Price",
                                      style: Theme.of(context).textTheme.bodyText2!.apply(color: primaryColor),
                                    ),
                                    Text(
                                      "${model.item.price} EGP",
                                      style: Theme.of(context).textTheme.subtitle1!.apply(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  children: [
                                    Divider(color: Colors.black54,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Quantity",
                                          style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.black),
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap:(){
                                                if(model.quantity>1){
                                                  setState(() {
                                                    model.quantity--;
                                                    totalPrice-=model.item.price;
                                                  });
                                                }
                                              },
                                              child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.blue[100],
                                                  child: Icon(Icons.remove,color: primaryColor,size: 15,)),
                                            ),

                                            SizedBox(width: 20,),
                                            Text(model.quantity.toString(),style: Theme.of(context).textTheme.bodyText1!.apply(color: Colors.black),),
                                            SizedBox(width: 20,),
                                            InkWell(
                                              onTap: (){
                                                setState(() {
                                                  if(model.quantity<model.item.stock){
                                                    model.quantity++;
                                                    totalPrice+=model.item.price;
                                                  }

                                                });

                                              },
                                              child:CircleAvatar(
                                                  backgroundColor: Colors.blue[100],
                                                  radius: 15,
                                                  child: Icon(Icons.add,color: primaryColor,size: 15,)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    Divider(color: Colors.black54,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Total Price",
                                          style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.black),
                                        ),
                                        Text(
                                          "$totalPrice EGP",
                                          style: Theme.of(context).textTheme.bodyText2!.apply(color: Colors.black),
                                        ),
                                      ],
                                    ),

                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton.icon(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.grey,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: defaultPadding * 1.5,
                                          vertical:
                                          defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);

                                      },
                                      icon: Icon(Icons.arrow_back),
                                      label: Text("Back"),
                                    ),
                                    ElevatedButton.icon(
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: defaultPadding * 1.5,
                                          vertical:
                                          defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                                        ),
                                      ),
                                      onPressed: () {
                                        addItemToCart(model);
                                        Navigator.pop(context);

                                      },
                                      icon: Icon(Icons.shopping_cart_rounded),
                                      label: Text("Place Order"),
                                    ),
                                  ],
                                )
                              ),

                            ],
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
    );
  }





}
class _ItemDeliveryModel{
  int quantity;
  UniformItemModel item;
  VariantModel variants;

  _ItemDeliveryModel(this.quantity, this.item, this.variants);
}
