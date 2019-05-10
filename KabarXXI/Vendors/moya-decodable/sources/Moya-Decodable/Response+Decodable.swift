//
//  Response+Decodable.swift
//  Moya-Decodable
//
//  Created by 高健 on 2017/9/25.
//

import Foundation
import Moya

public extension Response {
  
  public func map<T: Decodable>(
    to type: T.Type,
    dataDecodingStategy: JSONDecoder.DataDecodingStrategy = .base64,
    dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
    nonConformingFloatDecodingStrategy: JSONDecoder.NonConformingFloatDecodingStrategy = .throw
  ) throws -> T {
    let decoder = JSONDecoder()
    decoder.dataDecodingStrategy = dataDecodingStategy
    decoder.dateDecodingStrategy = dateDecodingStrategy
    decoder.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
    return try decoder.decode(type, from: data)
  }
  
}
