///
//  Generated code. Do not modify.
//  source: cashjar.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

class OfferResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OfferResponse', package: const $pb.PackageName('proto'))
    ..aOS(1, 'id')
    ..aOS(2, 'offerUrl')
    ..aOB(3, 'status')
    ..hasRequiredFields = false
  ;

  OfferResponse._() : super();
  factory OfferResponse() => create();
  factory OfferResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OfferResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  OfferResponse clone() => OfferResponse()..mergeFromMessage(this);
  OfferResponse copyWith(void Function(OfferResponse) updates) => super.copyWith((message) => updates(message as OfferResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OfferResponse create() => OfferResponse._();
  OfferResponse createEmptyInstance() => create();
  static $pb.PbList<OfferResponse> createRepeated() => $pb.PbList<OfferResponse>();
  static OfferResponse getDefault() => _defaultInstance ??= create()..freeze();
  static OfferResponse _defaultInstance;

  $core.String get id => $_getS(0, '');
  set id($core.String v) { $_setString(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);

  $core.String get offerUrl => $_getS(1, '');
  set offerUrl($core.String v) { $_setString(1, v); }
  $core.bool hasOfferUrl() => $_has(1);
  void clearOfferUrl() => clearField(2);

  $core.bool get status => $_get(2, false);
  set status($core.bool v) { $_setBool(2, v); }
  $core.bool hasStatus() => $_has(2);
  void clearStatus() => clearField(3);
}

class OfferId extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OfferId', package: const $pb.PackageName('proto'))
    ..aOS(1, 'id')
    ..hasRequiredFields = false
  ;

  OfferId._() : super();
  factory OfferId() => create();
  factory OfferId.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OfferId.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  OfferId clone() => OfferId()..mergeFromMessage(this);
  OfferId copyWith(void Function(OfferId) updates) => super.copyWith((message) => updates(message as OfferId));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OfferId create() => OfferId._();
  OfferId createEmptyInstance() => create();
  static $pb.PbList<OfferId> createRepeated() => $pb.PbList<OfferId>();
  static OfferId getDefault() => _defaultInstance ??= create()..freeze();
  static OfferId _defaultInstance;

  $core.String get id => $_getS(0, '');
  set id($core.String v) { $_setString(0, v); }
  $core.bool hasId() => $_has(0);
  void clearId() => clearField(1);
}

class OfferContext extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OfferContext', package: const $pb.PackageName('proto'))
    ..aOS(1, 'cChatId')
    ..aOS(2, 'clientName')
    ..aOS(3, 'customerId')
    ..aOS(4, 'promotorId')
    ..hasRequiredFields = false
  ;

  OfferContext._() : super();
  factory OfferContext() => create();
  factory OfferContext.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OfferContext.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  OfferContext clone() => OfferContext()..mergeFromMessage(this);
  OfferContext copyWith(void Function(OfferContext) updates) => super.copyWith((message) => updates(message as OfferContext));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static OfferContext create() => OfferContext._();
  OfferContext createEmptyInstance() => create();
  static $pb.PbList<OfferContext> createRepeated() => $pb.PbList<OfferContext>();
  static OfferContext getDefault() => _defaultInstance ??= create()..freeze();
  static OfferContext _defaultInstance;

  $core.String get cChatId => $_getS(0, '');
  set cChatId($core.String v) { $_setString(0, v); }
  $core.bool hasCChatId() => $_has(0);
  void clearCChatId() => clearField(1);

  $core.String get clientName => $_getS(1, '');
  set clientName($core.String v) { $_setString(1, v); }
  $core.bool hasClientName() => $_has(1);
  void clearClientName() => clearField(2);

  $core.String get customerId => $_getS(2, '');
  set customerId($core.String v) { $_setString(2, v); }
  $core.bool hasCustomerId() => $_has(2);
  void clearCustomerId() => clearField(3);

  $core.String get promotorId => $_getS(3, '');
  set promotorId($core.String v) { $_setString(3, v); }
  $core.bool hasPromotorId() => $_has(3);
  void clearPromotorId() => clearField(4);
}

class Offer extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Offer', package: const $pb.PackageName('proto'))
    ..aOS(1, 'imageUrl')
    ..aOS(2, 'name')
    ..aOS(3, 'offerName')
    ..a<$core.double>(4, 'price', $pb.PbFieldType.OF)
    ..aOS(5, 'priceText')
    ..aOS(6, 'ticker')
    ..a<OfferContext>(7, 'offerContext', $pb.PbFieldType.OM, OfferContext.getDefault, OfferContext.create)
    ..aOS(8, 'offerSiteName')
    ..aOS(9, 'id')
    ..hasRequiredFields = false
  ;

  Offer._() : super();
  factory Offer() => create();
  factory Offer.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Offer.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Offer clone() => Offer()..mergeFromMessage(this);
  Offer copyWith(void Function(Offer) updates) => super.copyWith((message) => updates(message as Offer));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Offer create() => Offer._();
  Offer createEmptyInstance() => create();
  static $pb.PbList<Offer> createRepeated() => $pb.PbList<Offer>();
  static Offer getDefault() => _defaultInstance ??= create()..freeze();
  static Offer _defaultInstance;

  $core.String get imageUrl => $_getS(0, '');
  set imageUrl($core.String v) { $_setString(0, v); }
  $core.bool hasImageUrl() => $_has(0);
  void clearImageUrl() => clearField(1);

  $core.String get name => $_getS(1, '');
  set name($core.String v) { $_setString(1, v); }
  $core.bool hasName() => $_has(1);
  void clearName() => clearField(2);

  $core.String get offerName => $_getS(2, '');
  set offerName($core.String v) { $_setString(2, v); }
  $core.bool hasOfferName() => $_has(2);
  void clearOfferName() => clearField(3);

  $core.double get price => $_getN(3);
  set price($core.double v) { $_setFloat(3, v); }
  $core.bool hasPrice() => $_has(3);
  void clearPrice() => clearField(4);

  $core.String get priceText => $_getS(4, '');
  set priceText($core.String v) { $_setString(4, v); }
  $core.bool hasPriceText() => $_has(4);
  void clearPriceText() => clearField(5);

  $core.String get ticker => $_getS(5, '');
  set ticker($core.String v) { $_setString(5, v); }
  $core.bool hasTicker() => $_has(5);
  void clearTicker() => clearField(6);

  OfferContext get offerContext => $_getN(6);
  set offerContext(OfferContext v) { setField(7, v); }
  $core.bool hasOfferContext() => $_has(6);
  void clearOfferContext() => clearField(7);

  $core.String get offerSiteName => $_getS(7, '');
  set offerSiteName($core.String v) { $_setString(7, v); }
  $core.bool hasOfferSiteName() => $_has(7);
  void clearOfferSiteName() => clearField(8);

  $core.String get id => $_getS(8, '');
  set id($core.String v) { $_setString(8, v); }
  $core.bool hasId() => $_has(8);
  void clearId() => clearField(9);
}

