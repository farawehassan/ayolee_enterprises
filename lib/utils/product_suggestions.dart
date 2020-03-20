
class AvailableProducts {

  static List<String> getSuggestions(String query, List<String> products) {
    List<String> matches = List();
    print(products);
    matches.addAll(products);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

}