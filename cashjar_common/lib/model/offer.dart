class Context {
  final String customerId;
  final String promotorId;
  final String cChatId;
  final String clientName;

  Context({this.customerId, this.promotorId, this.clientName, this.cChatId});

  Map<String, dynamic> toMap() {
    return {
      'customerId': this.customerId,
      'promotorId': this.promotorId,
      'cChatId': this.cChatId,
      'clientName': this.clientName,
    };
  }

  factory Context.fromMap(Map<String, dynamic> map) {
    return Context(
      customerId: map['customerId'] as String,
      promotorId: map['promotorId'] as String,
      cChatId: map['cChatId'] as String,
      clientName: map['clientName'] as String,
    );
  }
}

class Offer {
  String id;
  String name;
  int price;
  String priceText;
  String description;
  Context context;
  String imageUrl;
  String ticker;
  String offerName;
  String offerSiteName;

  Offer({this.id, this.name, this.price, this.priceText, this.description, this.imageUrl, this.context, this.ticker, this.offerName, this.offerSiteName});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'price': this.price,
      'priceText': this.priceText,
      'description': this.description,
      'imageUrl': this.imageUrl,
      'context': this.context.toMap(),
      'ticker': this.ticker,
      'offerName': this.offerName,
      'offerSiteName': this.offerSiteName,
    };
  }

  factory Offer.fromMap(Map<String, dynamic> map) {
    return Offer(
      id: map['id'] as String,
      name: map['name'],
      price: map['price'],
      priceText: map['priceText'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      context: Context.fromMap(map['context']),
      ticker: map['ticker'],
      offerName: map['offerName'],
      offerSiteName: map['offerSiteName'],
    );
  }
}