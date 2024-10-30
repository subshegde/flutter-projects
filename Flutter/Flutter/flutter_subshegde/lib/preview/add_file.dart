import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_subshegde/preview/preview.dart';
import 'package:flutter_subshegde/universal/components/custom_appbar.dart';
import 'package:flutter_subshegde/universal/constants/app_colors.dart';
import 'package:intl/intl.dart';

class AddFile extends StatefulWidget {
  const AddFile({super.key});

  @override
  State<AddFile> createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  late TextEditingController _formDateController;
  late TextEditingController _toDateController;

  late DateTime _selectedFromDate;
  late DateTime _selectedToDate;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _travellingCostController = TextEditingController();
  final TextEditingController _foodCostController = TextEditingController();
  final TextEditingController _stayingCostController = TextEditingController();
  final TextEditingController _otherCostController = TextEditingController();
  final TextEditingController _grandTotalController = TextEditingController(text: '0.0');

  final TextEditingController _travellingBillController = TextEditingController();
  final TextEditingController _foodBillController = TextEditingController();
  final TextEditingController _stayingBillController = TextEditingController();
  final TextEditingController _otherBillController = TextEditingController();
  bool? isLoading = false;

  @override
  void initState() {
    super.initState();
    _formDateController = TextEditingController();
    _toDateController = TextEditingController();
    _selectedFromDate = DateTime.now();
    _selectedToDate = DateTime.now();
  }

  @override
  void dispose() {
    _grandTotalController.dispose();
    _formDateController.dispose();
    _toDateController.dispose();
    _travellingCostController.dispose();
    _foodCostController.dispose();
    _stayingCostController.dispose();
    _otherCostController.dispose();
    _foodBillController.dispose();
    _travellingBillController.dispose();
    _stayingBillController.dispose();
    _otherBillController.dispose();
    super.dispose();
  }

  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(() {
        fn();
      });
    }
  }

  File? fileTravellingBill;
  File? fileFoodBill;
  File? fileStayingBill;
  File? fileOtherBill;

  Future uploadFile(BuildContext context, String bill) async {
    var dio = Dio();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path ?? '');
      String filename = file.path.split('/').last;
      String path = file.path;


      if (bill == 'travelling_bill') {
        safeSetSate(() {
          fileTravellingBill = file;
          _travellingBillController.text = filename;
        });
      } else if (bill == 'food_bill') {
        safeSetSate(() {
          fileFoodBill = file;
          _foodBillController.text = filename;
        });
      } else if (bill == 'staying_bill') {
        safeSetSate(() {
          fileStayingBill = file;
          _stayingBillController.text = filename;
        });
      } else if (bill == 'other_bill') {
        safeSetSate(() {
          fileOtherBill = file;
          _otherBillController.text = filename;
        });
      }
    }
  }

  void safeSetSate(VoidCallback fn) {
    if (mounted) {
      setState(() {
        fn();
      });
    }
  }

  void calulateGrandTotal() {
    safeSetSate((){
    double travellingCost = _travellingCostController.text.isEmpty ? 0.0 : double.tryParse(_travellingCostController.text)!;
    double foodCost = _foodCostController.text.isEmpty? 0.0 : double.tryParse(_foodCostController.text)!;
    double stayingCost = _stayingCostController.text.isEmpty? 0.0 : double.tryParse(_stayingCostController.text)!;
    double otherCost = _otherCostController.text.isEmpty? 0.0 : double.tryParse(_otherCostController.text)!;
    double grandTotal = otherCost + travellingCost + foodCost + stayingCost;
    _grandTotalController.text = grandTotal.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenSize = MediaQuery.of(context).size;

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          persistentFooterButtons: [
            Container(
              width: screenWidth,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    screenSize.width * 0.00, 0, screenSize.width * 0.00, 0),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(400, 48),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: AppColors.blue,
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
          backgroundColor: AppColors.bg,
          appBar: CustomAppBar(
            title: 'Expenses',
            onLeadingTap: () => Navigator.pop(context),
          ),
          body: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    color: AppColors.bg,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            } else if (value.isNotEmpty) {
                              return null;
                            }
                            return null;
                          },
                          controller: _formDateController,
                          style: const TextStyle(fontSize: 12),
                          onTap: () => _selectFromDate(context),
                          readOnly: true,
                          textCapitalization: TextCapitalization.none,
                          cursorColor: AppColors.black,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: _formDateController.text.isNotEmpty
                                ? 'From Date'
                                : null,
                            hintText: _formDateController.text.isEmpty
                                ? 'From Date'
                                : null,
                            labelStyle: const TextStyle(
                                color: AppColors.black, fontSize: 12),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                  color: AppColors.grey, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                  color: AppColors.blue, width: .5),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                    color: AppColors.whiteShadow, width: .5)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                    color: AppColors.whiteShadow, width: .5)),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            suffixIcon: InkWell(
                              onTap: () => _selectFromDate(context),
                              child: Image.asset(
                                'assets/addfiles/icons/calendar1.png',
                                scale: 3.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _toDateController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            } else if (value.isNotEmpty) {
                              return null;
                            }
                            return null;
                          },
                          style: const TextStyle(fontSize: 12),
                          onTap: () => _selectToDate(context),
                          readOnly: true,
                          textCapitalization: TextCapitalization.none,
                          cursorColor: AppColors.black,
                          obscureText: false,
                          decoration: InputDecoration(
                            labelText: _toDateController.text.isNotEmpty
                                ? 'To Date'
                                : null,
                            hintText: _toDateController.text.isEmpty
                                ? 'To Date'
                                : null,
                            labelStyle: const TextStyle(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                  color: AppColors.grey, width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                    color: AppColors.whiteShadow, width: .5)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                    color: AppColors.whiteShadow, width: .5)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(7),
                              borderSide: const BorderSide(
                                  color: AppColors.blue, width: 0.5),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            suffixIcon: InkWell(
                              onTap: () => _selectToDate(context),
                              child: Image.asset(
                                'assets/addfiles/icons/calendar1.png',
                                scale: 3.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                onChanged: (val){
                                  calulateGrandTotal();
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,5}')),
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: _travellingCostController,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.whiteShadow,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.whiteShadow,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: AppColors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: AppColors.blue,
                                      width: 0.5,
                                    ),
                                  ),
                                  
                                  fillColor: AppColors.white,
                                  filled: true,
                                  labelText: 'Travelling Cost',
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 12),
                                ),
                                cursorColor: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                uploadFile(context, 'travelling_bill');
                              },
                              child: Container(
                                height: 46,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/addfiles/icons/bill.png',
                                        height: 19,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Bill',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_travellingBillController.text.isNotEmpty) ...[
                          const SizedBox(
                            height: 5.0,
                          ),
                          DottedBorder(
                            color: AppColors.grey,
                            dashPattern: const [10, 6],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(7),
                            strokeWidth: 1,
                            child: Container(
                              child: TextFormField(
                                readOnly: true,
                                controller: _travellingBillController,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  border: InputBorder.none,
                                  fillColor: AppColors.white,
                                  filled: true,
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 12),
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>FullScreenImage(file: fileTravellingBill,fileName: _travellingBillController.text,)));
                                        },
                                        icon: Image.asset(
                                          'assets/addfiles/icons/view.png',
                                          scale: 17,
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                        safeSetSate(() {
                                            _travellingBillController.clear();
                                          });
                                        },
                                        icon: Image.asset(
                                          'assets/addfiles/icons/delete.png',
                                          scale: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                cursorColor: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                  onChanged: (val){
                                  calulateGrandTotal();
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,5}')),
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: _foodCostController,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.whiteShadow,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.whiteShadow,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: AppColors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: AppColors.blue,
                                      width: 0.5,
                                    ),
                                  ),
                                  fillColor: AppColors.white,
                                  filled: true,
                                  labelText: 'Food Cost',
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 12),
                                ),
                                cursorColor: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                uploadFile(context, 'food_bill');
                              },
                              child: Container(
                                height: 46,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/addfiles/icons/bill.png',
                                        height: 19,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Bill',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_foodBillController.text.isNotEmpty) ...[
                          const SizedBox(
                            height: 5.0,
                          ),
                          DottedBorder(
                            color: AppColors.grey,
                            dashPattern: const [10, 6],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(7),
                            strokeWidth: 1,
                            child: Container(
                              child: TextFormField(
                                readOnly: true,
                                controller: _foodBillController,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                   suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>FullScreenImage(file: fileFoodBill,fileName: _foodBillController.text,)));
                                        },
                                        icon: Image.asset(
                                          'assets/addfiles/icons/view.png',
                                          scale: 17,
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                        safeSetSate(() {
                                            _foodBillController.clear();
                                          });
                                        },
                                        icon: Image.asset(
                                          'assets/addfiles/icons/delete.png',
                                          scale: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  border: InputBorder.none,
                                  fillColor: AppColors.white,
                                  filled: true,
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 12),
                                ),
                                cursorColor: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                              onChanged: (val){
                                  calulateGrandTotal();
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,5}')),
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: _stayingCostController,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.whiteShadow,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.whiteShadow,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: AppColors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: AppColors.blue,
                                      width: 0.5,
                                    ),
                                  ),
                                  fillColor: AppColors.white,
                                  filled: true,
                                  labelText: 'Staying Cost',
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 12),
                                ),
                                cursorColor: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () {
                                uploadFile(context, 'staying_bill');
                              },
                              child: Container(
                                height: 46,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/addfiles/icons/bill.png',
                                        height: 19,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Bill',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_stayingBillController.text.isNotEmpty) ...[
                          const SizedBox(
                            height: 5.0,
                          ),
                          DottedBorder(
                            color: AppColors.grey,
                            dashPattern: const [10, 6],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(7),
                            strokeWidth: 1,
                            child: Container(
                              child: TextFormField(
                                readOnly: true,
                                controller: _stayingBillController,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                 suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>FullScreenImage(file: fileStayingBill,fileName: _stayingBillController.text,)));
                                        },
                                        icon: Image.asset(
                                          'assets/addfiles/icons/view.png',
                                          scale: 17,
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                        safeSetSate(() {
                                            _stayingBillController.clear();
                                          });
                                        },
                                        icon: Image.asset(
                                          'assets/addfiles/icons/delete.png',
                                          scale: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  border: InputBorder.none,
                                  fillColor: AppColors.white,
                                  filled: true,
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 12),
                                ),
                                cursorColor: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                 onChanged: (val){
                                  calulateGrandTotal();
                                },
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,5}')),
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: _otherCostController,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.whiteShadow,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.whiteShadow,
                                      width: 0.5,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: AppColors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: AppColors.blue,
                                      width: 0.5,
                                    ),
                                  ),
                                  fillColor: AppColors.white,
                                  filled: true,
                                  labelText: 'Other Cost',
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 12),
                                ),
                                cursorColor: AppColors.black,
                              ),
                            ),
                            const SizedBox(width: 4),
                            // uploadFile
                            GestureDetector(
                              onTap: () {
                                uploadFile(context, 'other_bill');
                              },
                              child: Container(
                                height: 46,
                                width: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.blue,
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/addfiles/icons/bill.png',
                                        height: 19,
                                        width: 20,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        'Bill',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_otherBillController.text.isNotEmpty) ...[
                          const SizedBox(
                            height: 5.0,
                          ),
                          DottedBorder(
                            color: AppColors.grey,
                            dashPattern: const [10, 6],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(7),
                            strokeWidth: 1,
                            child: Container(
                              child: TextFormField(
                                readOnly: true,
                                controller: _otherBillController,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  suffixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>FullScreenImage(file: fileOtherBill,fileName: _otherBillController.text,)));
                                        },
                                        icon: Image.asset(
                                          'assets/addfiles/icons/view.png',
                                          scale: 17,
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                        safeSetSate(() {
                                            _otherBillController.clear();
                                          });
                                        },
                                        icon: Image.asset(
                                          'assets/addfiles/icons/delete.png',
                                          scale: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  border: InputBorder.none,
                                  fillColor: AppColors.white,
                                  filled: true,
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 12),
                                ),
                                cursorColor: AppColors.black,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 10.0),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d+\.?\d{0,5}')),
                                ],
                                controller: _grandTotalController,
                                style: const TextStyle(fontSize: 12),
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: AppColors.whiteShadow,
                                        width: .5),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppColors.whiteShadow,
                                      width: .5,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: AppColors.grey,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7),
                                    borderSide: const BorderSide(
                                      color: AppColors.blue,
                                      width: .5,
                                    ),
                                  ),
                                  fillColor: AppColors.white,
                                  filled: true,
                                  enabled: true,
                                  labelText: 'Grand Total',
                                  labelStyle: const TextStyle(
                                      color: AppColors.black, fontSize: 12),
                                ),
                                cursorColor: AppColors.black,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  // for from date
  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFromDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime day) {
        return day.isAfter(DateTime.now().subtract(const Duration(days: 1)));
      },
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light().copyWith(
              primary: AppColors.navyBlue,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedFromDate) {
      setState(() {
        _selectedFromDate = picked;
        _formDateController.text =
            DateFormat('dd-MM-yyyy').format(_selectedFromDate!);
      });

      formKey.currentState!.validate();
    }
  }

  // for from date
  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedToDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime day) {
        return day.isAfter(DateTime.now().subtract(const Duration(days: 1)));
      },
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            colorScheme: const ColorScheme.light().copyWith(
              primary: AppColors.navyBlue,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedToDate) {
      setState(() {
        _selectedToDate = picked;
        _toDateController.text =
            DateFormat('dd-MM-yyyy').format(_selectedToDate!);
      });
      formKey.currentState!.validate();
    }
  }
}
