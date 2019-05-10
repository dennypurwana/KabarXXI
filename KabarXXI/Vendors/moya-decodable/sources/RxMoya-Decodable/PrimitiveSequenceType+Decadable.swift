//
//  PrimitiveSequenceType+Decadable.swift
//  Moya-DecodablePackageDescription
//
//  Created by 高健 on 2017/9/25.
//

import Foundation
import RxSwift
import Moya
#if !COCOAPODS
  import Moya_Decodable
#endif

public extension PrimitiveSequenceType where TraitType == SingleTrait, ElementType == Moya.Response {
  public func map<T: Decodable>(
    to type: T.Type,
    dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
    nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw
  ) -> PrimitiveSequence<TraitType, T> {
    return map {
      try $0.map(
        to: type,
        dataDecodingStategy: dataDecodingStrategy,
        dateDecodingStrategy: dateDecodingStrategy,
        nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy
      )
    }
  }
}

public extension PrimitiveSequenceType where TraitType == MaybeTrait, ElementType == Moya.Response {
  public func map<T: Decodable>(
    to type: T.Type,
    dataDecodingStrategy: JSONDecoder.DataDecodingStrategy = .base64,
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
    nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw
    ) -> PrimitiveSequence<TraitType, T> {
    return map {
      try $0.map(
        to: type,
        dataDecodingStategy: dataDecodingStrategy,
        dateDecodingStrategy: dateDecodingStrategy,
        nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy
      )
    }
  }
}
