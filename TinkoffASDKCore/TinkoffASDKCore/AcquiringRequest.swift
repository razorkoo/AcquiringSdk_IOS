//
//  AcquiringRequest.swift
//  TinkoffASDKCore
//
//  Copyright (c) 2020 Tinkoff Bank
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

// MARK: AcquiringRequest

public protocol RequestOperation {
	
	/// Название операции
	var name: String { get }
	
	/// Параметры которые отправляем на сервер в теле запроса
	var parameters: JSONObject? { get set }
	
}


protocol AcquiringRequestOperation: RequestOperation {
	
	func validate() -> Error?
	
	var tokenParamenters: JSONObject? { get }
	
}


public protocol AcquiringRequestTokenParams {
	
	/// Отмечаем параметры которые участвуют в вычислении токена
	/// ключи параметров которые нужны для токена
	var tokenParamsKey: Set<String> { get }
	
	/// значеня параметров котоыре нужны для токена, есть базовая реализация в `AcquiringRequestTokenParams`
	func tokenParams() -> JSONObject
	
}


extension AcquiringRequestTokenParams where Self: RequestOperation {
	// параметры для токена
	public func tokenParams() -> JSONObject {
		if let params = parameters?.filter({ (item) -> Bool in
			return tokenParamsKey.contains(item.key)
		}) {
			return params
		}
		
		return [:]
	}
	
}

// MARK: AcquiringResponse

public protocol ResponseOperation: Codable {
	
	var success: Bool { get }
	var	errorCode: Int { get }
	var errorMessage: String? { get }
	var errorDetails: String? { get }
	var terminalKey: String? { get }
	
}


public class AcquiringResponse: ResponseOperation {
	public var success: Bool
	public var errorCode: Int
	public var errorMessage: String?
	public var errorDetails: String?
	public var terminalKey: String?
	
	enum CodingKeys: String, CodingKey {
		case success = "Success"
		case errorCode = "ErrorCode"
		case errorMessage = "Message"
		case errorDetails = "Details"
		case terminalKey = "TerminalKey"
	}
	
	public required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		success = try container.decode(Bool.self, forKey: .success)
		errorCode = try Int(container.decode(String.self, forKey: .errorCode))!
		errorMessage = try? container.decode(String.self, forKey: .errorMessage)
		errorDetails = try? container.decode(String.self, forKey: .errorDetails)
		terminalKey = try? container.decode(String.self, forKey: .terminalKey)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(success, forKey: .success)
		try	container.encode(errorCode, forKey: .errorCode)
		try? container.encode(errorMessage, forKey: .errorMessage)
		try? container.encode(errorDetails, forKey: .errorDetails)
		try? container.encode(terminalKey, forKey: .terminalKey)
	}
		
}

