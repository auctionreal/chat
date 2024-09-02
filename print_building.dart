import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PrintBuilding{

  final String auctionId;
  final String buildingId;
  PrintBuilding({required this.auctionId, required this.buildingId});
  List<Map<String, String>> buildingValues = [];

  void printDocument() async {
    final pdf = pw.Document();
    final font =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Cairo-Regular.ttf'));
    final imageBytes = await rootBundle.load('assets/app_icon.png');
    final image = pw.MemoryImage(imageBytes.buffer.asUint8List());
    final data = await fetchCostData();
    Map<String, dynamic>? buildingData = await fetchBuildingData();
    Map<String, dynamic>? auctionData = await fetchAuctionData();
    final studyDate = data?['studyDate'] ?? '';
    await fetchBuildingValues();
    final buildingTabTwo = await fetchBuildingTabTwo();
    
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4, 
        build: (pw.Context context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    height: 70,
                    child: pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Image(
                        image,
                        height: 60, // تعيين ارتفاع الصورة
                        width: 60, // تعيين عرض الصورة
                      ),
                    ),
                  ),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    children: [
                      pw.Text(
                        'أكشن',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                          color: const PdfColor.fromInt(0xFFeb910c),
                        ),
                      ),
                      pw.Text(
                        ' للخدمات العقارية',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          font: font,
                          color: const PdfColor.fromInt(0xFF022653),
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(),
                  pw.Container(
                    color: const PdfColor.fromInt(0xFFbcdde2),
                    height: 30,
                    child: pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        'دراسة عقار',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: font),
                      ),
                    ),
                  ),
                  pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                      children: [
                        pw.Text(
                          ' اسم المزاد : ${auctionData?['name']}',
                          style: pw.TextStyle(
                              font: font),
                        ),
                        pw.Text(
                          'رقم المهمة : ${buildingData?['taskNumber']}',
                          style: pw.TextStyle(
                            font: font,
                          ),
                        ),
            
                        pw.Text(
                          'نوع العقار : ${buildingData?['propertyType']}',
                          style: pw.TextStyle(
                            font: font,
                          ),
                        ),
                      ]),
            
                  ///رقم الصك
                  pw.Table(
                    border:
                        pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FractionColumnWidth(0.14),
                      1: const pw.FractionColumnWidth(0.14),
                      2: const pw.FractionColumnWidth(0.14),
                      3: const pw.FractionColumnWidth(0.14),
                      4: const pw.FractionColumnWidth(0.14),
                      5: const pw.FractionColumnWidth(0.14),
                      6: const pw.FractionColumnWidth(0.16),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            color: PdfColors.grey300, // Background color
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'تاريخ دراسة العقار',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'نوع المبني',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'عمر العقار',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'تاريخ الرخصة',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'رقم الرخصة',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'تاريخ الصك',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'رقم الصك',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                studyDate,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                '${buildingData?['buildingType']}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                '${buildingData?['propertyAge']}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                '${buildingData?['licenseDate']} هـ',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 9,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              )
                              )),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                '${buildingData?['licenseNumber']}',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              ),
                              ),),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                '${buildingData?['instrumentDate']} هـ',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 9,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              )
                              ),),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                              '${buildingData?['instrumentNumber']}',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: PdfColor.fromHex('0B4F5D'),
                              ),
                            ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ///رقم الصك
                  pw.Container(
                    color: const PdfColor.fromInt(0xFFbcdde2),
                    height: 20,
                    child: pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        'البيانات الاساسية للعقار',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: font),
                      ),
                    ),
                  ),
                  pw.SizedBox(
                    height: 2,
                    child: pw.Divider(
                      color: PdfColors.black,
                    ),
                  ),
                  ////////////////////////////////الحدود و الموقع
                  pw.Row(children: [
                    pw.Expanded(
                      child: pw.Container(
                          padding: const pw.EdgeInsets.only(right: 15.0),
                          height: 20,
                          color: PdfColor.fromHex('bcdde2'),
                          child: pw.Align(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              'الموقع',
                              style: pw.TextStyle(
                                font: font,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          )),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                          padding: const pw.EdgeInsets.only(right: 15.0),
                          height: 20,
                          color: PdfColor.fromHex('bcdde2'),
                          child: pw.Align(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              'حدود العقار',
                              style: pw.TextStyle(
                                font: font,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          )),
                    ),
                    pw.Expanded(
                      child: pw.Container(
                          padding: const pw.EdgeInsets.only(right: 40.0),
                          height: 20,
                          color: PdfColor.fromHex('bcdde2'),
                          child: pw.Align(
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              'خدمات البنية التحتية',
                              style: pw.TextStyle(
                                font: font,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          )),
                    ),
                  ]),
                  pw.Row(children: [
                    ////////////////////////////////جدول
                    pw.Expanded(
                      child: pw.Table(
                        border: pw.TableBorder.all(
                            width: 1, color: PdfColors.black),
                        columnWidths: {
                          0: const pw.FractionColumnWidth(0.23),
                          1: const pw.FractionColumnWidth(0.27),
                          2: const pw.FractionColumnWidth(0.175),
                          3: const pw.FractionColumnWidth(0.2),
                          4: const pw.FractionColumnWidth(0.175),
                          // 5: const pw.FractionColumnWidth(0.2),
                        },
                        children: [
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'الكهرباء: ${data?['isElectricity'] ? 'نعم':'لا'}',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 11
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                  '${buildingData?['north']}',
                                  style: pw.TextStyle(
                                    font: font,
                                    fontSize: 10,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'شمالاً',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.center,
                                  child: pw.Text(
                                  '${buildingData?['city']}',
                                  style: pw.TextStyle(
                                    font: font,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'المدينة',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'الماء: ${data?['isWater'] ? 'نعم':'لا'}',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 11
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                  '${buildingData?['south']}',
                                  style: pw.TextStyle(
                                    font: font,
                                    fontSize: 10,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'جنوباً',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.center,
                                  child: pw.Text(
                                  '${buildingData?['district']}',
                                  style: pw.TextStyle(
                                    font: font,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'الحي',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'الاسفلت: ${data?['isAsphalt'] ? 'نعم':'لا'}',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 11
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                  '${buildingData?['east']}',
                                  style: pw.TextStyle(
                                    font: font,
                                    fontSize: 10,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'شرقاً',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.center,
                                  child: pw.Text(
                                  '${buildingData?['plotNumber']}',
                                  style: pw.TextStyle(
                                    font: font,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'رقم المخطط',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'الصرف الصحي: ${data?['isSewageSystem'] ? 'نعم':'لا'}',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 11
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                  '${buildingData?['west']}',
                                  style: pw.TextStyle(
                                    font: font,
                                    fontSize: 10,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'غرباً',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.center,
                                  child: pw.Text(
                                  '${buildingData?['area']} م',
                                  style: pw.TextStyle(
                                    font: font,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'المساحة',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'الشوارع منارة: ${data?['isStreetLights'] ? 'نعم':'لا'}',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 11
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                  '',
                                  style: pw.TextStyle(
                                    font: font,
                                    fontSize: 10,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'نوع التشطيب',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.center,
                                  child: pw.Text(
                                  '${buildingData?['parcelNumber']}',
                                  style: pw.TextStyle(
                                    font: font,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'رقم القطعة',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'الشوارع مرصوفة: ${data?['isPavedRoads'] ? 'نعم':'لا'}',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 10
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                  '',
                                  style: pw.TextStyle(
                                    font: font,
                                    fontSize: 10,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'المنسوب',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.center,
                                  child: pw.Text(
                                  '${buildingData?['blockNumber']}',
                                  style: pw.TextStyle(
                                    font: font,
                                    color: PdfColor.fromHex('0B4F5D'),
                                  ),
                                ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                child: pw.Align(
                                  alignment: pw.Alignment.centerRight,
                                  child: pw.Text(
                                    'رقم البلك',
                                    style: pw.TextStyle(
                                      font: font,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 12
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ///////////////////////////////جدول
                  ]),
                  ////////////////////////////////الحدود و الموقع
                  pw.SizedBox(
                    height: 2,
                    child: pw.Divider(
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Container(
                    color: const PdfColor.fromInt(0xFFbcdde2),
                    height: 20,
                    child: pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        'عناصر الاصل للعقار',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: font),
                      ),
                    ),
                  ),
                  pw.SizedBox(
                    height: 2,
                    child: pw.Divider(
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Row(children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        height: 20,
                        decoration: pw.BoxDecoration(
                          color: const PdfColor.fromInt(0xFFbcdde2),
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF000000),
                            width: 1,
                          ),
                        ),
                        child: pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'مميرات العقار',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, font: font),
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.only(right: 5.0),
                        height: 20,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF000000),
                            width: 1,
                          ),
                        ),
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            data?['propertyFeatures'] ?? '',
                            style: pw.TextStyle(font: font,fontSize: 10),
                            softWrap: true, 
                            maxLines: 3, 
                            overflow: pw.TextOverflow.clip, 
                          ),
                        ),
                      ),
                    ),
                  ]),
                  pw.Row(children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 3),
                        height: 20,
                        decoration: pw.BoxDecoration(
                          color: const PdfColor.fromInt(0xFFbcdde2),
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF000000),
                            width: 1,
                          ),
                        ),
                        child: pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.FittedBox(
                            fit: pw.BoxFit.contain,
                            child: pw.Text(
                            'الاستخدام الحالي للقار',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, font: font),
                          ),
                          )
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.only(right: 5.0),
                        height: 20,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF000000),
                            width: 1,
                          ),
                        ),
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            data?['currentUse'] ?? '',
                            style: pw.TextStyle(font: font,fontSize: 10),
                            softWrap: true, 
                            maxLines: 3, 
                            overflow: pw.TextOverflow.clip, 
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Container(
                        height: 20,
                        padding: const pw.EdgeInsets.symmetric(horizontal: 3),
                        decoration: pw.BoxDecoration(
                          color: const PdfColor.fromInt(0xFFbcdde2),
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF000000),
                            width: 1,
                          ),
                        ),
                        child: pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.FittedBox(
                            fit: pw.BoxFit.contain,
                            child: pw.Text(
                            'الاستخدام الامثل للقار',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, font: font),
                          ),
                          )
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.only(right: 5.0),
                        height: 20,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF000000),
                            width: 1,
                          ),
                        ),
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            data?['optimalUse'] ?? '',
                            style: pw.TextStyle(font: font,fontSize: 10),
                            softWrap: true, 
                            maxLines: 3, 
                            overflow: pw.TextOverflow.clip, 
                          ),
                        ),
                      ),
                    ),
                  ]),
                  ///رقم الصك
                  pw.Table(
                    border:
                        pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FractionColumnWidth(0.2),
                      1: const pw.FractionColumnWidth(0.2),
                      2: const pw.FractionColumnWidth(0.2),
                      3: const pw.FractionColumnWidth(0.2),
                      4: const pw.FractionColumnWidth(0.2),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            color: PdfColors.grey300, 
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'تداخل العقار',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'مطابقة العقار لصك',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'المستحقات على العقار',
                                style: pw.TextStyle(font: font, fontSize: 9),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'الايقافات على العقار',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'القيود علي العقار',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                data?['overlap'] ?? '',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                data?['titleMatch'] ?? '',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                data?['outstandingDebts'] ?? '',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              ),
                              ),),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                data?['liensOnProperty'] ?? '',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              )
                              ),),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                              data?['propertyrestrictions'] ?? '',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: PdfColor.fromHex('0B4F5D'),
                              ),
                            ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ///رقم القيود
                  ///رقم الصك
                  pw.Table(
                    border:
                        pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FractionColumnWidth(0.2),
                      1: const pw.FractionColumnWidth(0.2),
                      2: const pw.FractionColumnWidth(0.2),
                      3: const pw.FractionColumnWidth(0.2),
                      4: const pw.FractionColumnWidth(0.2),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            color: PdfColors.grey300, 
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'شاغلية العقار',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'الجار مبني',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'حال العقار',
                                style: pw.TextStyle(font: font, fontSize: 9),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'الادور المسموح فيها',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'كود البناء بالمنطقة',
                                style: pw.TextStyle(font: font, fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                data?['occupancy'] ?? '',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                data?['builtUpArea'] ?? '',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                data?['propertyCondition'] ?? '',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              ),
                              ),),
                          pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                              child: pw.Align(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                data?['numberOfFloors'] ?? '',
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('0B4F5D'),
                                ),
                              )
                              ),),
                          pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                              data?['codeForArea'] ?? '',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                                color: PdfColor.fromHex('0B4F5D'),
                              ),
                            ),
                            )
                          ),
                        ],
                      ),
                    ],
                  ),
                  // ///رقم الكود المسموح
                  pw.Row(children: [
                    pw.Expanded(
                      flex: 2,
                      child: pw.Container(
                        height: 20,
                        decoration: pw.BoxDecoration(
                          color: const PdfColor.fromInt(0xFFbcdde2),
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF000000),
                            width: 1,
                          ),
                        ),
                        child: pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            'الاستخدام حسب الجهات المختصة',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, font: font),
                          ),
                        ),
                      ),
                    ),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Container(
                        padding: const pw.EdgeInsets.only(right: 5.0),
                        height: 20,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF000000),
                            width: 1,
                          ),
                        ),
                        child: pw.Align(
                          alignment: pw.Alignment.centerRight,
                          child: pw.Text(
                            data?['authorizedLandUse'] ?? '',
                            style: pw.TextStyle(font: font,fontSize: 10),
                            softWrap: true, 
                            maxLines: 3, 
                            overflow: pw.TextOverflow.clip, 
                          ),
                        ),
                      ),
                    ),
                  ]),
                  pw.SizedBox(
                    height: 2,
                    child: pw.Divider(
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Container(
                    color: const PdfColor.fromInt(0xFFbcdde2),
                    height: 20,
                    child: pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        'مكونات العقار',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: font),
                      ),
                    ),
                  ),
                  pw.Table(
                    children: [
                      for (int i = 0; i < buildingValues.length; i += 3)
                        pw.TableRow(
                          children: [
                            for (int j = 2; j >= 0; j--)
                              if (i + j < buildingValues.length)
                                pw.Row(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end, 
                                  children: [
                                    pw.Container(
                                      height: 20,
                                      width: 79,
                                      padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.black,
                                          width: 1,
                                        ),
                                      ),
                                      child: pw.Text(
                                        '${buildingValues[i + j]['name']}',
                                        style: pw.TextStyle(
                                          font: font,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 10
                                        ),
                                        textDirection: pw.TextDirection.rtl, 
                                      ),
                                    ),
                                    pw.Container(
                                      padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                                      height: 20,
                                      width: 78,
                                      decoration: pw.BoxDecoration(
                                        border: pw.Border.all(
                                          color: PdfColors.black,
                                          width: 1,
                                        ),
                                      ),
                                      child: pw.Align(alignment: pw.Alignment.center,
                                      child: pw.Text(
                                        '${buildingValues[i + j]['quantity']}',
                                        style: pw.TextStyle(
                                          color: PdfColor.fromHex('#0B4F5D'),
                                          font: font,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 10
                                        ),
                                        textDirection: pw.TextDirection.rtl,
                                      ),
                                      )
                                    ),
                                  ],
                                )
                              else
                                pw.Row(children: [
                                  pw.Container(
                                  height: 20,
                                  width: 79,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.black,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                pw.Container(
                                  height: 20,
                                  width: 78,
                                  decoration: pw.BoxDecoration(
                                    border: pw.Border.all(
                                      color: PdfColors.black,
                                      width: 1,
                                    ),
                                  ),
                                )
                                ])
                          ],
                        ),
                    ],
                  ),
                  pw.SizedBox(
                    height: 2,
                    child: pw.Divider(
                      color: PdfColors.black,
                    ),
                  ),
                  pw.Container(
                    color: const PdfColor.fromInt(0xFFbcdde2),
                    height: 20,
                    child: pw.Align(
                      alignment: pw.Alignment.center,
                      child: pw.Text(
                        'وصف التشطيبات والاعمال الانشائية',
                        style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold, font: font),
                      ),
                    ),
                  ),
                  ///رقم الصك
                  pw.Table(
                    border:
                        pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FractionColumnWidth(0.33),
                      1: const pw.FractionColumnWidth(0.33),
                      2: const pw.FractionColumnWidth(0.33),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            color: PdfColors.grey300, 
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'اخرى',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  fontWeight: pw.FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'نوع الواجهات',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            color: PdfColors.grey300,
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.center,
                              child: pw.Text(
                                'نوع الارضيات',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Table(
                    border:
                        pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FractionColumnWidth(0.167),
                      1: const pw.FractionColumnWidth(0.167),
                      2: const pw.FractionColumnWidth(0.167),
                      3: const pw.FractionColumnWidth(0.167),
                      4: const pw.FractionColumnWidth(0.167),
                      5: const pw.FractionColumnWidth(0.167),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['adaptationType'] ?? '',
                                style: pw.TextStyle(color: PdfColor.fromHex('#0B4F5D'),
                                  font: font, fontSize: 10,),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'نوع التكيف',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['northUi'] ?? '',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'الشمالية',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['courtyards'] ?? '',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'الاحواش',
                                style: pw.TextStyle(
                                  font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Table(
                    border:
                        pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FractionColumnWidth(0.167),
                      1: const pw.FractionColumnWidth(0.167),
                      2: const pw.FractionColumnWidth(0.167),
                      3: const pw.FractionColumnWidth(0.167),
                      4: const pw.FractionColumnWidth(0.167),
                      5: const pw.FractionColumnWidth(0.167),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['structure'] ?? '',
                                style: pw.TextStyle(color: PdfColor.fromHex('#0B4F5D'),
                                  font: font, fontSize: 10,),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'الهيكل الانشائي',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['southUi'] ?? '',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'الجنوبية',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['reception'] ?? '',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'الاستقبال',
                                style: pw.TextStyle(
                                  font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Table(
                    border:
                        pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FractionColumnWidth(0.167),
                      1: const pw.FractionColumnWidth(0.167),
                      2: const pw.FractionColumnWidth(0.167),
                      3: const pw.FractionColumnWidth(0.167),
                      4: const pw.FractionColumnWidth(0.167),
                      5: const pw.FractionColumnWidth(0.167),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['roofs'] ?? '',
                                style: pw.TextStyle(color: PdfColor.fromHex('#0B4F5D'),
                                  font: font, fontSize: 10,),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'نوع الاسقف',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['eastUi'] ?? '',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'الشرقية',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['entrance'] ?? '',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'المدخل',
                                style: pw.TextStyle(
                                  font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Table(
                    border:
                        pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FractionColumnWidth(0.167),
                      1: const pw.FractionColumnWidth(0.167),
                      2: const pw.FractionColumnWidth(0.167),
                      3: const pw.FractionColumnWidth(0.167),
                      4: const pw.FractionColumnWidth(0.167),
                      5: const pw.FractionColumnWidth(0.167),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['interiorDoors'] ?? '',
                                style: pw.TextStyle(color: PdfColor.fromHex('#0B4F5D'),
                                  font: font, fontSize: 10,),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'الابواب الداخلية',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['westUi'] ?? '',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'الغربية',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['others'] ?? '',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'اخرى',
                                style: pw.TextStyle(
                                  font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Table(
                    border: pw.TableBorder.all(width: 1, color: PdfColors.black),
                    columnWidths: {
                      0: const pw.FractionColumnWidth(0.167),
                      1: const pw.FractionColumnWidth(0.167),
                      2: const pw.FractionColumnWidth(0.167),
                      3: const pw.FractionColumnWidth(0.167),
                      4: const pw.FractionColumnWidth(0.167),
                      5: const pw.FractionColumnWidth(0.167),
                    },
                    children: [
                      pw.TableRow(
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                buildingTabTwo?['exteriorDoors'] ?? '',
                                style: pw.TextStyle(color: PdfColor.fromHex('#0B4F5D'),
                                  font: font, fontSize: 10,),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                'الابواب الخارجية',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                '',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                '',
                                style: pw.TextStyle(font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                '',
                                softWrap: true,
                                overflow: pw.TextOverflow.span,
                                style: pw.TextStyle(
                                  font: font,
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#0B4F5D'),
                                ),
                              ),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 5.0),
                            child: pw.Align(
                              alignment: pw.Alignment.centerRight,
                              child: pw.Text(
                                '',
                                style: pw.TextStyle(
                                  font: font, fontSize: 10,fontWeight: pw.FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
            
                ],
              ),
            ),
          
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<Map<String, dynamic>?> fetchCostData() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('auctions')
        .doc(auctionId)
        .collection('buildData')
        .doc(buildingId)
        .collection('finishesBuildingTabZero')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      return docSnapshot.data();
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchBuildingData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('auctions')
        .doc(auctionId)
        .collection('buildData')
        .doc(buildingId)
        .get();

    if (docSnapshot.exists) {
      return docSnapshot.data();
    } else {
      return null;
    }
  }
  
  Future<Map<String, dynamic>?> fetchBuildingTabTwo() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('auctions')
        .doc(auctionId)
        .collection('buildData')
        .doc(buildingId)
        .collection('finishesBuildingTabTwo')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      return docSnapshot.data();
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchAuctionData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('auctions')
        .doc(auctionId)
        .get();

    if (docSnapshot.exists) {
      return docSnapshot.data();
    } else {
      return null;
    }
  }
  
  Future<void> fetchBuildingValues() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('auctions')
        .doc(auctionId)
        .collection('buildData')
        .doc(buildingId)
        .collection('finishesBuildingTabTwo')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docSnapshot = querySnapshot.docs.first;
      final data = docSnapshot.data();
      if (data.containsKey('componentsData')) {
        final List<dynamic> dynamicList = data['componentsData'];
        final List<Map<String, String>> parsedBuildingValues =
            dynamicList.map((item) => Map<String, String>.from(item)).toList();

          buildingValues = parsedBuildingValues;
      }
    } else {
      log('No documents found.');
    }
  }

}