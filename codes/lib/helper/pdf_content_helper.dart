import 'package:pdf_example/model/pdf_text_part_model.dart';

class SamplePdfContentHelper {
  static List<List<TextPart>> getSamplePdfText({
    bool forPrint = false,
  }) {
    return [
      [
        TextPart("This document is a sample PDF generated using "),
        TextPart("TextPart", isBold: true),
        TextPart(
          " objects. It demonstrates how to build rich, styled text content for PDF generation in Flutter.",
        ),
      ],

      [
        TextPart("1) Personal Information", isBold: true),
        TextPart(
          "This section can be used to display personal or general information such as name, title, or description.",
        ),
      ],

      [
        TextPart("", isBullet: true),
        TextPart("Full Name: "),
        TextPart("John Doe", isBold: true),
      ],
      [
        TextPart("", isBullet: true),
        TextPart("Document Title: "),
        TextPart("Sample PDF Template", isBold: true),
      ],

      [
        TextPart("2) Description", isBold: true),
        TextPart(
          "This paragraph is a simple description explaining the purpose of the document. "
              "You can mix normal text with bold or styled parts to create readable and flexible layouts.",
        ),
      ],

      [
        TextPart("", isBullet: true),
        TextPart("Supports bold text"),
      ],
      [
        TextPart("", isBullet: true),
        TextPart("Supports bullet lists"),
      ],
      [
        TextPart("", isBullet: true),
        TextPart("Supports multi-line sections"),
      ],

      [
        TextPart("3) Notes", isBold: true),
        TextPart(
          "This template is intentionally simple and generic so it can be reused for invoices, reports, letters, or any custom PDF content.",
        ),
      ],
      [
        TextPart("AliAsghar144 (;", isBold: true),
      ],
    ];
  }
}
