//
//  RestClientExtension.swift
//  WhatsNewIOS
//
//  Created by Raj Rao on 6/18/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit

import SalesforceSDKCore
import SwiftUI
import Combine

enum RequestError: Error {
    case request(code: Int, error: Error?)
    case emptyResponse
    case unknown
}

final class AnySubscription: Subscription {
    private let cancellable: Cancellable
    
    init(_ cancel: @escaping () -> Void) {
        cancellable = AnyCancellable(cancel)
    }
    
    func request(_ demand: Subscribers.Demand) {}
    
    func cancel() {
        cancellable.cancel()
    }
}

extension RestClient {
    
    func send(request: RestRequest) -> AnyPublisher<(restResponse: [[String:Any]], rawResponse: URLResponse), RequestError> {
        AnyPublisher<(restResponse: [[String:Any]], rawResponse: URLResponse), RequestError> { subscriber in
              self.send(request: request, onFailure: { (error, urlResponse) in
                DispatchQueue.main.async {
                   subscriber.receive(completion: .failure(.request(code: 500, error: error)))
                }
            }) { (response, urlResponse) in
                DispatchQueue.main.async {
                    if let jsonResponse = response as? [String:Any],
                        let result = jsonResponse ["records"] as? [[String:Any]]  {
                        _ = subscriber.receive((restResponse: result, rawResponse: urlResponse!))
                    } else {
                         subscriber.receive(completion: .failure(.emptyResponse))
                    }
                    subscriber.receive(completion: .finished)
                }
            }
        
         }
    }
    
}
