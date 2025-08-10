/* =======================================================
 *
 * Created by anele on 26/07/2025.
 *
 * @anele_ace
 *
 * =======================================================
 */

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:moola_mate/utils/utils.dart';
import 'package:moola_mate/widgets/widgets.dart';
import 'package:moola_mate/services/services.dart';
import 'package:flutter/services.dart' show rootBundle;

class WalletScreen extends StatefulWidget {

  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  final DateTime now = DateTime.now();
  bool isIphoneSeDevice = DeviceConfig().isIphoneSE;
  final ExpenseAppService expenseService = ExpenseAppService();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  String? varsity;
  List<dynamic> itemListApi = <dynamic>[];

  List<Map<String, dynamic>> allTimeCategories = <Map<String, dynamic>>[];
  double grandTotal = 0.0;

  Future<void> loadJson() async {
    final String response = await rootBundle.loadString('assets/data/expense_categories.json');
    final dynamic data = json.decode(response);
    setState(() {
      itemListApi = data;
    });
  }


  String _getCategoryName(String? categoryId) {
    final dynamic category = itemListApi.firstWhere(
          (dynamic e) => e['id'] == categoryId,
      orElse: () => <String, String>{'description': 'Unknown'},
    );
    return category['description'];
  }


  void _clearTextField() {
    _nameController.clear();
    _costController.clear();
    _dateController.clear();
  }


  void _saveExpense(Map<String, dynamic> data) async {
    await expenseService.insertExpense(
      name: data['name'],
      date: data['date'],
      categoryId: data['category'],
      cost: double.tryParse(data['cost']) ?? 0.0,
      categoryName: _getCategoryName(data['category']),
    );

    _clearTextField();
  }


  String formatAmount(double amount) {
    if (amount > 100000) {
      return 'Limit Reached \n Get Premium';
    }
    final NumberFormat formatter = NumberFormat.currency(
      locale: 'en_ZA',
      symbol: 'R ',
      decimalDigits: 2,
    );
    return formatter.format(amount);
  }


  Future<void> _loadWalletExpenses() async {
    final Map<String, dynamic> result = await expenseService.getCategoriesByTotal();

    setState(() {
      allTimeCategories = result['categories'];
      grandTotal = result['grandTotal'];
    });
  }

  @override
  void initState() {
    super.initState();
    loadJson();
    _loadWalletExpenses();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _costController.dispose();
    _dateController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    final bool isLimitReached = grandTotal > 100000;

    return SingleChildScrollView(
      child: Column(
       children: <Widget>[
      
         Stack(
             clipBehavior: Clip.none,
             children: <Widget>[
               // Curved Header
               ClipPath(
                   clipper: BottomCurveWallet(),
                   child: Container(
                     height: isIphoneSeDevice ? 170 : 200, width: screen.width,
                     decoration: BoxDecoration(
                         image: DecorationImage(
                           fit: BoxFit.cover,
                           alignment: Alignment.topRight,
                           image: AssetImage('assets/images/circles.png'),
                         ),
                         gradient: LinearGradient(
                             begin: Alignment.topLeft,
                             end: Alignment.bottomRight,
                             colors: <Color>[Color(0xFF429690), Color(0xFF2A7C76)]
                         )
                     ),
                     child: Container(),
                   )
               ),
      
               Positioned(
                   top: isIphoneSeDevice ? 30: 50,
                   left: 0, right: 0,
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 18.0),
                     child: Row(
                       children: <Widget>[
                         Container(),
                         Spacer(),
                         Text(
                             'Wallet',
                             style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)
                         ),
                         Spacer(),
                         Container(
                           width: 40, height: 40,
                           decoration: BoxDecoration(
                             color: Color(0XFFffffff).withValues(alpha: 0.6),
                             borderRadius: BorderRadius.circular(40),
                           ),
                           child: Center(child: Icon(Icons.notification_add, size: 20, color: Color(0XFFffffff),),),
                         ),
                       ],
                     ),
                   )
               ),

               //
               Positioned(
                 top: screen.height * 0.12,
                 child: Container(
                   width: screen.width, height: 73,
                   decoration: BoxDecoration(
                     color: Colors.white,
                     borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(50),
                       topRight: Radius.circular(50),
                     ),
                   ),
                   child: Column(
                     children: <Widget>[
                       Spacer(),
                       Text(
                         textAlign: TextAlign.center,
                         'All Time Total',
                         style: TextStyle(color: Color(0XFF666666), fontSize: 16),
                       ),
                     ],
                   )
                 ),
               ),
             ]
         ),
      
         Text(
           textAlign: TextAlign.center,
           formatAmount(grandTotal),
           style: TextStyle(fontSize: 30, color: isLimitReached ? Colors.orange : Color(0XFF222222), fontWeight: FontWeight.w800),
         ),
         SizedBox(height: 20),
      
         SizedBox(
           width: 240, height: 85,
           child: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
               Column(
                 children: <Widget>[
                   GestureDetector(
                     onTap: () async {
                       if (isLimitReached) {
                         _showMyDialog();
                         return;
                       }

                       final result = await showModalBottomSheet(
                           isDismissible: false,
                           isScrollControlled: true,
                           backgroundColor: Colors.transparent,
                           context: context,
                           builder: (BuildContext context) {
                             return ExpenseBottomSheet(
                               formKey: _formKey,
                               itemNameController: _nameController,
                               itemCostController: _costController,
                               itemDateController: _dateController,
                               itemListApi: itemListApi,
                               varsity: varsity,
                               onCategoryChanged: (String? val) {
                                 setState(() => varsity = val);
                               },
                             );
                           }
                       );

                       if (result != null) {
                         _saveExpense(result);
                       }

                     },
                     child: Container(
                       width: 60, height: 60,
                       decoration: BoxDecoration(
                           //color: Color(0XFF549994),
                         border: Border.all(color: Color(0XFF549994)),
                         borderRadius: BorderRadius.circular(60)
                       ),
                       child: Center(child: Icon(Icons.add, color: Color(0XFF549994)),),
                     ),
                   ),
                   Spacer(),
                   Text('Add')
                 ],
               ),

               /*
               Column(
                 children: <Widget>[
                   Container(
                     width: 60, height: 60,
                     decoration: BoxDecoration(
                       //color: Color(0XFF549994),
                         border: Border.all(color: Color(0XFF549994)),
                         borderRadius: BorderRadius.circular(60)
                     ),
                     child: Center(child: Icon(Icons.payment, color: Color(0XFF549994)),),
                   ),
                   Spacer(),
                   Text('Pay')
                 ],
               ),
      
               Column(
                 children: [
                   Container(
                     width: 60, height: 60,
                     decoration: BoxDecoration(
                         border: Border.all(color: Color(0XFF549994)),
                         borderRadius: BorderRadius.circular(60)
                     ),
                     child: Center(child: Icon(Icons.send, color: Color(0XFF549994)),),
                   ),
                   Spacer(),
                   Text('Send')
                 ],
               ),
               */
             ],
           ),
         ),
         SizedBox(height: 30),


         DefaultTabController(
             length: 2,
             child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: <Widget>[
                   Container(
                     margin: EdgeInsets.symmetric(horizontal: 10),
                     decoration: BoxDecoration(color: Color(0XFFF4F6F6), borderRadius: BorderRadius.circular(48)),
                     child: TabBar(
                       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 6),
                         indicator: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(48)
                         ),
                         indicatorColor: Colors.transparent,
                         labelStyle: TextStyle(fontSize: 14, color: Color(0XFF666666)),
                         tabs: <Widget>[Tab(text: 'Most Spend Category'),Tab(text: 'Upcoming Bills'),]
                     ),
                   ),
                   SizedBox(height: 20),
      
                   Container(
                       //color: Colors.red,
                       //margin: const EdgeInsets.symmetric(horizontal: 10,),
                       margin: EdgeInsets.zero,
                       height: 270,
                       child: TabBarView(
                           children: <Widget>[
      
                             // Transactions Content
                             allTimeCategories == null
                                 ? Center(child: CircularProgressIndicator())
                                 : allTimeCategories.isEmpty
                                 ? Center(child: Text('No transactions yet', style: TextStyle(color: Colors.grey, fontSize: 16)))
                                 : ListView.builder(
                               itemCount: allTimeCategories.length,
                               padding: EdgeInsets.zero,
                               itemBuilder: (BuildContext context, int index) {
                                 final Map<String, dynamic> category = allTimeCategories[index];
                                 return Column(
                                     children: <Widget>[
                                       ListTile(
                                         leading: Container(
                                           width: 50, height: 50,
                                           decoration: BoxDecoration(color: Color(0XFFF0F6F5), borderRadius: BorderRadius.circular(8)),
                                         ),
                                         title: Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: <Widget>[
                                             Text(category['categoryName'], style: TextStyle(color: Colors.black, fontSize: 16),),
                                             //Text('Today', style: TextStyle(color: Color(0XFF666666), fontSize: 13),),
                                           ],
                                         ),
                                         trailing: Text('R ${category['total']}'),
                                       )
                                     ]
                                 );
                               },
                             ),
      
      
                             // Bills Content
                              SizedBox( height: 40, child: Column(
                                children: <Widget>[
                                  SizedBox(height: 20),
                                  Text('Contact'),
                                  Text('hello@acemedia.co.za'),
                                ],
                              )),
                           ]
                       )
                   ),
      
                 ]
             )
         ),

       ],
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eish Ja! neh...'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Looks like you need a premium account.'),
                SizedBox(height: 10),
                Text('Askies neh! Contact aceMedia'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}


class BottomCurveWallet extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);

    // Create the curve
    path.quadraticBezierTo(
      size.width / 2, size.height,
      size.width, size.height - 50,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
