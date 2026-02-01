
class TextPart {
  final String text;
  final bool isBold;
  final bool? isBullet;
  final double? fontSize;

  TextPart(this.text, {this.fontSize, this.isBold = false, this.isBullet});
}
