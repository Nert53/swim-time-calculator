String replaceSpecialChars(String text) {
  return text
      .replaceAll('á', 'a')
      .replaceAll('é', 'e')
      .replaceAll('í', 'i')
      .replaceAll('ú', 'u')
      .replaceAll('ů', 'u')
      .replaceAll('ý', 'y')
      .replaceAll('š', 's')
      .replaceAll('č', 'c')
      .replaceAll('ř', 'r')
      .replaceAll('ž', 'z')
      .replaceAll('ť', 't')
      .replaceAll('ď', 'd')
      .replaceAll('ň', 'n');
}
