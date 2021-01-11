//
//  PaymentCardRequests.swift
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

// MARK: Список карт

public struct InitGetCardListData: Codable {
	
	public var customerKey: String
	
	public enum CodingKeys: String, CodingKey {
		case customerKey = "CustomerKey"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		customerKey = try container.decode(String.self, forKey: .customerKey)
	}
	
	public init(customerKey: String) {
		self.customerKey = customerKey
	}
	
}

final public class CardListRequest: RequestOperation, AcquiringRequestTokenParams {
	
	// MARK: RequestOperation
	
	public var name = "GetCardList"
	
	public var parameters: JSONObject?
	
	// MARK: AcquiringRequestTokenParams
	
	///
	/// отмечаем параметры которые участвуют в вычислении `token`
	public var tokenParamsKey: Set<String> = [InitGetCardListData.CodingKeys.customerKey.rawValue]
	
	///
	/// - Parameter requestData: `InitGetCardListData`
	public init(data: InitGetCardListData) {
		if let json = try? data.encode2JSONObject() {
			self.parameters = json
		}
	}
	
}

public struct CardListResponse: ResponseOperation {
	
	public var success: Bool = true
	public var errorCode: Int = 0
	public var errorMessage: String?
	public var errorDetails: String?
	public var terminalKey: String?
	public var cards: [PaymentCard]
	
	private enum CodingKeys: String, CodingKey {
		case success = "Success"
		case errorCode = "ErrorCode"
		case errorMessage = "Message"
		case errorDetails = "Details"
		case terminalKey = "TerminalKey"
		case cards = "Cards"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		success = try container.decode(Bool.self, forKey: .success)
		errorCode = try container.decode(Int.self, forKey: .errorCode)
		errorMessage = try? container.decode(String.self, forKey: .errorMessage)
		errorDetails = try? container.decode(String.self, forKey: .errorDetails)
		terminalKey = try? container.decode(String.self, forKey: .terminalKey)
		//
		cards = try container.decode([PaymentCard].self, forKey: .cards)
	}
	
	public init(from decoder: Decoder, cardsList: [PaymentCard]) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		success = try container.decode(Bool.self, forKey: .success)
		errorCode = try container.decode(Int.self, forKey: .errorCode)
		errorMessage = try? container.decode(String.self, forKey: .errorMessage)
		errorDetails = try? container.decode(String.self, forKey: .errorDetails)
		terminalKey = try? container.decode(String.self, forKey: .terminalKey)
		//
		cards = cardsList
	}
	
}


// MARK: Добавит карту

public struct InitAddCardData: Codable {
	
	public var checkType: String
	public var customerKey: String
	
	public enum CodingKeys: String, CodingKey {
		case checkType = "CheckType"
		case customerKey = "CustomerKey"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		checkType = try container.decode(String.self, forKey: .checkType)
		customerKey = try container.decode(String.self, forKey: .customerKey)
	}
	
	public init(with checkType: String, customerKey: String) {
		self.checkType = checkType
		self.customerKey = customerKey
	}
	
}


final public class InitAddCardRequest: RequestOperation, AcquiringRequestTokenParams {
	
	// MARK: RequestOperation
	
	public var name = "AddCard"
	
	public var parameters: JSONObject?
	
	// MARK: AcquiringRequestTokenParams
	
	///
	/// отмечаем параметры которые участвуют в вычислении `token`
	public var tokenParamsKey: Set<String> = [InitAddCardData.CodingKeys.checkType.rawValue,
											  InitAddCardData.CodingKeys.customerKey.rawValue]
	
	///
	/// - Parameter requestData: `InitAddCardData`
	public init(requestData: InitAddCardData) {
		if let json = try? requestData.encode2JSONObject() {
			self.parameters = json
		}
	}
	
}


public struct InitAddCardResponse: ResponseOperation {
	
	public var success: Bool
	public var errorCode: Int
	public var errorMessage: String?
	public var errorDetails: String?
	public var terminalKey: String?
	//
	var requestKey: String
	
	private enum CodingKeys: String, CodingKey {
		case success = "Success"
		case errorCode = "ErrorCode"
		case errorMessage = "Message"
		case errorDetails = "Details"
		case terminalKey = "TerminalKey"
		//
		case requestKey = "RequestKey"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		success = try container.decode(Bool.self, forKey: .success)
		errorCode = try Int(container.decode(String.self, forKey: .errorCode))!
		errorMessage = try? container.decode(String.self, forKey: .errorMessage)
		errorDetails = try? container.decode(String.self, forKey: .errorDetails)
		terminalKey = try? container.decode(String.self, forKey: .terminalKey)
		//
		requestKey = try container.decode(String.self, forKey: .requestKey)
	}
	
}


public struct FinishAddCardData: Codable {
	
	var cardNumber: String
	var expDate: String
	var cvv: String
	//
	var requestKey: String
	
	enum CodingKeys: String, CodingKey {
		case cardNumber = "PAN"
		case expDate = "ExpDate"
		case cvv = "CVV"
		//
		case requestKey = "RequestKey"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cardNumber = try container.decode(String.self, forKey: .cardNumber)
		expDate = try container.decode(String.self, forKey: .expDate)
		cvv = try container.decode(String.self, forKey: .cvv)
		requestKey = try container.decode(String.self, forKey: .requestKey)
	}
	
	public init(cardNumber: String, expDate: String, cvv: String, requestKey: String) {
		self.cardNumber = cardNumber
		self.expDate = expDate
		self.cvv = cvv
		self.requestKey = requestKey
	}
	
	func cardData() -> String {
		return "\(CodingKeys.cardNumber.rawValue)=\(cardNumber);\(CodingKeys.expDate.rawValue)=\(expDate);\(CodingKeys.cvv.rawValue)=\(cvv)"
	}
	
}


class FinishAddCardRequest: AcquiringRequestTokenParams, RequestOperation {
	
	// MARK: RequestOperation
	
	var name = "AttachCard"
	
	var parameters: JSONObject?
	
	// MARK: AcquiringRequestTokenParams
	
	///
	/// отмечаем параметры которые участвуют в вычислении `token`
	var tokenParamsKey: Set<String> = [FinishAddCardData.CodingKeys.requestKey.rawValue,
									   PaymentFinishRequestData.CodingKeys.cardData.rawValue]
	
	///
	/// - Parameter requestData: `FinishAddCardData`
	init(requestData: FinishAddCardData) {
		self.parameters = [:]
		self.parameters?.updateValue(requestData.cardData(), forKey: PaymentFinishRequestData.CodingKeys.cardData.rawValue)
		self.parameters?.updateValue(requestData.requestKey, forKey: FinishAddCardData.CodingKeys.requestKey.rawValue)
	}
	
}


public enum AddCardFinishResponseStatus {
	
	/// Требуется подтверждение 3DS v1.0
	case needConfirmation3DS(Confirmation3DSData)
	
	/// Требуется подтверждение 3DS v2.0
	case needConfirmation3DSACS(Confirmation3DSDataACS)
	
	/// Требуется подтвержить оплату указать сумму из смс для `requestKey`
	case needConfirmationRandomAmount(String)
	
	/// Успешная оплата
	case done(AddCardStatusResponse)
	
	/// что-то пошло не так
	case unknown
	
}


public struct FinishAddCardResponse: ResponseOperation {
	
	public var success: Bool
	public var errorCode: Int
	public var errorMessage: String?
	public var errorDetails: String?
	public var terminalKey: String?
	public var paymentStatus: PaymentStatus
	public var responseStatus: AddCardFinishResponseStatus
	//
	var cardId: String?
	
	private enum CodingKeys: String, CodingKey {
		case success = "Success"
		case errorCode = "ErrorCode"
		case errorMessage = "Message"
		case errorDetails = "Details"
		case terminalKey = "TerminalKey"
		case paymentStatus = "Status"
		//
		case requestKey = "RequestKey"
		case cardId = "CardId"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		success = try container.decode(Bool.self, forKey: .success)
		errorCode = try Int(container.decode(String.self, forKey: .errorCode))!
		errorMessage = try? container.decode(String.self, forKey: .errorMessage)
		errorDetails = try? container.decode(String.self, forKey: .errorDetails)
		terminalKey = try? container.decode(String.self, forKey: .terminalKey)
		
		paymentStatus = .unknown
		if let statusValue = try? container.decode(String.self, forKey: .paymentStatus) {
			paymentStatus = PaymentStatus.init(rawValue: statusValue)
		}
		
		responseStatus = .unknown
		switch paymentStatus {
			case .checking3ds, .hold3ds:
				if let confirmation3DS = try? Confirmation3DSData.init(from: decoder) {
					responseStatus = .needConfirmation3DS(confirmation3DS)
				} else if let confirmation3DSACS = try? Confirmation3DSDataACS.init(from: decoder) {
					responseStatus = .needConfirmation3DSACS(confirmation3DSACS)
				}
			
			case .loop:
				let requestKey = try container.decode(String.self, forKey: .requestKey)
				responseStatus = .needConfirmationRandomAmount(requestKey)
			
			case .authorized, .confirmed, .checked3ds:
				if let finishStatus = try? AddCardStatusResponse.init(from: decoder) {
					responseStatus = .done(finishStatus)
				}
			
			default:
				if let finishStatus = try? AddCardStatusResponse.init(from: decoder) {
					responseStatus = .done(finishStatus)
				}
		}
		
		//
		cardId = try? container.decode(String.self, forKey: .cardId)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(success, forKey: .success)
		try	container.encode(errorCode, forKey: .errorCode)
		try? container.encode(errorMessage, forKey: .errorMessage)
		try? container.encode(errorDetails, forKey: .errorDetails)
		try? container.encode(terminalKey, forKey: .terminalKey)
		
		switch responseStatus {
			case .needConfirmation3DS(let confirm3DSData):
				try confirm3DSData.encode(to: encoder)
			case .needConfirmationRandomAmount(let confirmRandomAmountData):
				try confirmRandomAmountData.encode(to: encoder)
			case .done(let responseStatus):
				try responseStatus.encode(to: encoder)
			default:
				break
		}
		//
		try? container.encode(cardId, forKey: .cardId)
	}//encode
	
}//FinishAddCardResponse

public struct AddCardStatusResponse: ResponseOperation {
	
	public var success: Bool
	public var errorCode: Int
	public var errorMessage: String?
	public var errorDetails: String?
	public var terminalKey: String?
	//
	public var requestKey: String?
	public var cardId: String?
	
	private enum CodingKeys: String, CodingKey {
		case success = "Success"
		case errorCode = "ErrorCode"
		case errorMessage = "Message"
		case errorDetails = "Details"
		case terminalKey = "TerminalKey"
		//
		case requestKey = "RequestKey"
		case cardId = "CardId"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		success = try container.decode(Bool.self, forKey: .success)
		errorCode = try Int(container.decode(String.self, forKey: .errorCode))!
		errorMessage = try? container.decode(String.self, forKey: .errorMessage)
		errorDetails = try? container.decode(String.self, forKey: .errorDetails)
		terminalKey = try? container.decode(String.self, forKey: .terminalKey)
		//
		requestKey? = try container.decode(String.self, forKey: .requestKey)
		cardId = try? container.decode(String.self, forKey: .cardId)
	}
	
	public init(success: Bool, errorCode: Int) {
		self.success = success
		self.errorCode = errorCode
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(success, forKey: .success)
		try	container.encode(errorCode, forKey: .errorCode)
		try? container.encode(errorMessage, forKey: .errorMessage)
		try? container.encode(errorDetails, forKey: .errorDetails)
		//
		try? container.encode(terminalKey, forKey: .terminalKey)
		try? container.encode(cardId, forKey: .cardId)
	}
	
}//AddCardStatusResponse


// MARK: Удалить карту

public struct InitDeactivateCardData: Codable {
	
	public var cardId: String
	public var customerKey: String
	
	public enum CodingKeys: String, CodingKey {
		case cardId = "CardId"
		case customerKey = "CustomerKey"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		cardId = try container.decode(String.self, forKey: .cardId)
		customerKey = try container.decode(String.self, forKey: .customerKey)
	}
	
	public init(cardId: String, customerKey: String) {
		self.cardId = cardId
		self.customerKey = customerKey
	}
	
}


final public class InitDeactivateCardRequest: RequestOperation, AcquiringRequestTokenParams {
	
	// MARK: RequestOperation
	
	public var name = "RemoveCard"
	
	public var parameters: JSONObject?
	
	// MARK: AcquiringRequestTokenParams
	
	///
	/// отмечаем параметры которые участвуют в вычислении `token`
	public var tokenParamsKey: Set<String> = [InitDeactivateCardData.CodingKeys.cardId.rawValue,
											  InitDeactivateCardData.CodingKeys.customerKey.rawValue]
	
	///
	/// - Parameter requestData: `InitDeactivateCardData`
	public init(requestData: InitDeactivateCardData) {
		if let json = try? requestData.encode2JSONObject() {
			self.parameters = json
		}
	}
	
}
