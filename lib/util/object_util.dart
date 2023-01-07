/// Object Util.
class ObjectUtil {
  /// Returns true if the string is null or 0-length.
  static bool isEmptyString(String str) {
    return str == null || str.isEmpty;
  }

  /// Returns true if the list is null or 0-length.
  static bool isEmptyList(List list) {
    return list == null || list.isEmpty;
  }

  /// Returns true if there is no key/value pair in the map.
  static bool isEmptyMap(Map map) {
    return map == null || map.isEmpty;
  }

  /// Returns true  String or List or Map is empty.
  static bool isEmpty(Object object) {
    if (object == null) return true;
    if (object is String && object.isEmpty) {
      return true;
    } else if (object is List && object.isEmpty) {
      return true;
    } else if (object is Map && object.isEmpty) {
      return true;
    }
    return false;
  }

  /// Returns true String or List or Map is not empty.
  static bool isNotEmpty(Object object) {
    return !isEmpty(object);
  }

  static bool isNot0orEmpty(Object object) {
    return !isEmpty(object) && object != '0';
  }

  /// Returns true Two List Is Equal.
  static bool equalTwoList(List listA, List listB) {
    if (listA == listB) return true;
    if (listA == null || listB == null) return false;
    int length = listA.length;
    if (length != listB.length) return false;
    for (int i = 0; i < length; i++) {
      if (!listA.contains(listB[i])) {
        return false;
      }
    }
    return true;
  }

  /// Returns true Two Map Is Equal.note Map<String, dynamic> is LinkedHashMap & like Map<String, (String,num)>
  static bool equalTwoMap(
      Map<String, dynamic> mapA, Map<String, dynamic> mapB) {
    if (mapA == mapB) return true;
    if (mapA == null || mapB == null) return false;
    if (mapA.length != mapB.length) return false;
    for (int i = 0; i < mapA.keys.length; i++) {
      var key = mapA.keys.elementAt(i);
      //两个map的key不同或者value不同
      if (key != mapB.keys.elementAt(i) || mapA[key] != mapB[key]) {
        return false;
      }
    }
    return true;
  }

  /// get length.
  static int getLength(Object value) {
    if (value == null) return 0;
    if (value is String) {
      return value.length;
    } else if (value is List) {
      return value.length;
    } else if (value is Map) {
      return value.length;
    } else {
      return 0;
    }
  }

  static bool verifyGesturePasswords(
      List<int> originalPasswords, List<int> repeatPasswords) {
    bool isCorrect = true;
    if (originalPasswords.length == repeatPasswords.length) {
      for (int i = 0; i < originalPasswords.length; i++) {
        if (originalPasswords[i] != repeatPasswords[i]) {
          isCorrect = false;
          break;
        }
      }
    } else {
      isCorrect = false;
    }
    return isCorrect;
  }
}
