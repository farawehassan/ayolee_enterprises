
class AvailableProducts {
  static final List<String> availableProducts = [
    "Pepsi",
    "Bigi",
    "Lacasera",
    "Chapman",
    "60cl Coke pet",
    "35cl Coke pet",
    "Limca",
    "Zero coke",
    "Bottle water",
    "Big Eva water",
    "Small Eva water",
    "Dispenser water",
    "Malta Can",
    "Maltina pet",
    "Amstel Can",
    "Amstel pet",
    "Dudu Yoghurt",
    "Yugo Yoghurt",
    "Cway Nutri-Milk",
    "Small Cway Nutri-Milk",
    "Nutri-Yo",
    "Viju Chocolate",
    "Dudu Juice",
    "Dudu Milk",
    "85cl 5Alive Pulpy",
    "35cl 5Alive Pulpy",
    "5alive Juice",
    "Chi Exotic 1L",
    "Chi Exotic 500ml",
    "Chi Exotic 150ml",
    "Hollandia 1L",
    "Hollandia 500ml",
    "Hollandia 100ml",
    "Chivita 1L",
    "Active 1L",
    "Active 315ml",
    "Happy Hour 1L",
    "Happy Hour 315ml",
    "Happy Hour 150ml",
    "Ice Tea 1L",
    "Ice Tea 500ml",
    "Ice Tea 315ml",
    "Boost Carton",
    "Frooty"
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(availableProducts);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}