///
//  Generated code. Do not modify.
//  source: cashjar.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core show int, String, List;

import 'package:grpc/service_api.dart' as $grpc;
import 'cashjar.pb.dart' as $0;
export 'cashjar.pb.dart';

class OfferServiceClient extends $grpc.Client {
  static final _$createOffer = $grpc.ClientMethod<$0.Offer, $0.OfferResponse>(
      '/proto.OfferService/CreateOffer',
      ($0.Offer value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OfferResponse.fromBuffer(value));
  static final _$getOffer = $grpc.ClientMethod<$0.OfferId, $0.Offer>(
      '/proto.OfferService/GetOffer',
      ($0.OfferId value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.Offer.fromBuffer(value));
  static final _$updateOffer = $grpc.ClientMethod<$0.Offer, $0.OfferResponse>(
      '/proto.OfferService/UpdateOffer',
      ($0.Offer value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.OfferResponse.fromBuffer(value));

  OfferServiceClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.OfferResponse> createOffer($0.Offer request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$createOffer, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.Offer> getOffer($0.OfferId request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$getOffer, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.OfferResponse> updateOffer($0.Offer request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$updateOffer, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class OfferServiceBase extends $grpc.Service {
  $core.String get $name => 'proto.OfferService';

  OfferServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.Offer, $0.OfferResponse>(
        'CreateOffer',
        createOffer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Offer.fromBuffer(value),
        ($0.OfferResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.OfferId, $0.Offer>(
        'GetOffer',
        getOffer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.OfferId.fromBuffer(value),
        ($0.Offer value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.Offer, $0.OfferResponse>(
        'UpdateOffer',
        updateOffer_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.Offer.fromBuffer(value),
        ($0.OfferResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.OfferResponse> createOffer_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Offer> request) async {
    return createOffer(call, await request);
  }

  $async.Future<$0.Offer> getOffer_Pre(
      $grpc.ServiceCall call, $async.Future<$0.OfferId> request) async {
    return getOffer(call, await request);
  }

  $async.Future<$0.OfferResponse> updateOffer_Pre(
      $grpc.ServiceCall call, $async.Future<$0.Offer> request) async {
    return updateOffer(call, await request);
  }

  $async.Future<$0.OfferResponse> createOffer(
      $grpc.ServiceCall call, $0.Offer request);
  $async.Future<$0.Offer> getOffer($grpc.ServiceCall call, $0.OfferId request);
  $async.Future<$0.OfferResponse> updateOffer(
      $grpc.ServiceCall call, $0.Offer request);
}
