import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf_example/widgets/basic_app_button.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'config/assets/assets/image_assets.dart';
import 'helper/pdf_content_helper.dart';
import 'model/pdf_text_part_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WillTextDetailsScreen(),));
}

class WillTextDetailsScreen extends StatelessWidget {
  WillTextDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4D7771),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.13,
                  child: SvgPicture.asset(
                    ImageAssets.topShape,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...SamplePdfContentHelper.getSamplePdfText().map(
                          (e) => _buildUiCustomRichText(parts: e),
                        ),
                        _shareAndExport()
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height * 0.13,
                  child: SvgPicture.asset(
                    ImageAssets.bottomShape,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUiCustomRichText({required List<TextPart> parts}) {
    List<List<TextPart>> lines = [];
    List<TextPart> currentLine = [];

    for (var part in parts) {
      if (part.isBullet == true && currentLine.isNotEmpty) {
        lines.add(List.from(currentLine));
        currentLine.clear();
      }
      currentLine.add(part);
    }
    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines.map((lineParts) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              children: [
                if (lineParts.first.isBullet == true)
                  Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.only(top: 7, left: 5, right: 15),
                    decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                  ),
                Expanded(
                  child: Text.rich(
                    textAlign: TextAlign.justify,
                    TextSpan(
                      children: lineParts.map((p) {
                        if (p.isBullet == true && p.text.isEmpty) {
                          return const TextSpan(text: "");
                        }
                        return TextSpan(
                          text: p.text,
                          style: TextStyle(
                            fontSize: p.fontSize ?? (p.isBold ? 14.5 : 14),
                            fontWeight: p.isBold ? FontWeight.bold : FontWeight.normal,
                            fontFamily: 'Lahzeh',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _shareAndExport() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      textDirection: TextDirection.rtl,
      children: [
        const SizedBox(
          height: 10,
        ),
        BasicAppButton(
          height: 50,
          title: 'Share PDF',
          onPressed: () async {
            try {
              final content = SamplePdfContentHelper.getSamplePdfText();

              final pdf = await _generatePdf(texts: content);
              final bytes = await pdf.save();

              final dir = await getTemporaryDirectory();
              final file = File('${dir.path}/SamplePdf.pdf');
              await file.writeAsBytes(bytes);

              await SharePlus.instance.share(ShareParams(
                text: 'SamplePDF Generated by AliAsghar144',
                files: [XFile(file.path)],
              ));
            } catch (e) {
              debugPrint('خطا در اشتراک‌گذاری: $e');
            }
          },
        ),
        const SizedBox(
          height: 20,
        ),
        BasicAppButton(
          height: 50,
          title: 'Save PDF',
          textColor: Colors.white,
          borderSide: const BorderSide(color: Color(0xffA5A79D)),
          onPressed: () async {
            try {

              final content = SamplePdfContentHelper.getSamplePdfText();

              final pdf = await _generatePdf(texts: content);

              await Printing.layoutPdf(
                onLayout: (PdfPageFormat format) async => pdf.save(),
                name: 'SamplePDF.pdf',
              );
            } catch (e) {
              debugPrint('************* ERROR : $e');
            }
          },
        ),
      ],
    );
  }

  pw.Widget _buildWhiteBox(List<pw.Widget> children) {
    return pw.Container(
      width: double.infinity,
      decoration: const pw.BoxDecoration(color: PdfColors.white),
      padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  pw.Widget _buildCustomRichText({required List<TextPart> parts, required pw.Font reg, required pw.Font bld}) {
    List<List<TextPart>> lines = [];
    List<TextPart> currentLine = [];

    for (var part in parts) {
      if (part.isBullet == true && currentLine.isNotEmpty) {
        lines.add(List.from(currentLine));
        currentLine.clear();
      }
      currentLine.add(part);
    }
    if (currentLine.isNotEmpty) {
      lines.add(currentLine);
    }

    return pw.Column(
      children: lines.map((lineParts) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (lineParts.first.isBullet == true)
                pw.Container(
                  width: 5,
                  height: 5,
                  margin: const pw.EdgeInsets.only(top: 6, left: 8, right: 10),
                  decoration: const pw.BoxDecoration(color: PdfColors.black, shape: pw.BoxShape.circle),
                ),
              pw.Expanded(
                child: pw.RichText(
                  text: pw.TextSpan(
                    children: lineParts.map((p) {
                      if (p.isBullet == true && p.text.isEmpty) return const pw.TextSpan(text: "");

                      return pw.TextSpan(
                        text: p.text,
                        style: pw.TextStyle(
                          font: p.isBold ? bld : reg,
                          color: const PdfColor.fromInt(0xff050F2C),
                          fontSize: p.fontSize ?? (p.isBold ? 14 : 13.5),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  _generatePdf({required List<List<TextPart>> texts}) async {
    final fontData = await rootBundle.load("assets/fonts/Lahzeh-FaNum-Regular.ttf");
    final ttfRegular = pw.Font.ttf(fontData);

    final boldData = await rootBundle.load("assets/fonts/Lahzeh-FaNum-Bold.ttf");
    final ttfBold = pw.Font.ttf(boldData);

    final header = await rootBundle.loadString('assets/images/top_shape.svg');

    final footer = await rootBundle.loadString('assets/images/bottom_shape.svg');

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          margin: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          buildBackground: (context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(color: PdfColor.fromHex('#4D7771')),
            );
          },
        ),
        build: (pw.Context context) {
          return [
            pw.SvgImage(svg: header),
            ...texts.map((itemParts) {
              return _buildWhiteBox([_buildCustomRichText(parts: itemParts, reg: ttfRegular, bld: ttfBold)]);
            }),
            _buildWhiteBox([
              pw.SizedBox(height: 50),
            ]),
            pw.SvgImage(svg: footer),
          ];
        },
      ),
    );
    return pdf;
  }
}
