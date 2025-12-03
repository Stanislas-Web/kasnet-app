abstract class StringCapital {
  String capitalizeAll({String data});
  String capitalize({String data});
}

@override
String capitalizeAll(String text) {
  try {
    if (text == null || text.isEmpty) {
      return text;
    } else {
      text = text.replaceAll("  ", " ");
      return text.split(' ').map((word) => process(word)).join(' ');
    }
  } catch (e) {
    return text;
  }
}

@override
String capitalize(String text) {
  try {
    if (text == null || text.isEmpty) {
      return text;
    } else {
      text = text.replaceAll("  ", " ");
      return process(text);
    }
  } catch (e) {
    return text;
  }
}

String process(String word) {
  if (word != null && word != "" && word.length >= 2) {
    return word[0].toUpperCase() + word.substring(1);
  } else {
    return word;
  }
}
