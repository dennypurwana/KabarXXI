//
//  ObservableType+Decodable.swift
//  Moya-Decodable
//
//  Created by 高健 on 2017/9/25.
//

import Foundation
import RxSwift
import Moya
#if !COCOAPODS
  import Moya_Decodable
#endif

public extension ObservableType where E == Moya.Response {
  
  public func map<T: Decodable>(
    to type: T.Type,
    dataDecodingStategy: JSONDecoder.DataDecodingStrategy = .base64,
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
    nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw
  ) -> Observable<T> {
    return map {
      try $0.map(
        to: type,
        dataDecodingStategy: dataDecodingStategy,
        dateDecodingStrategy: dateDecodingStrategy,
        nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy
      )
    }
  }
  
}

