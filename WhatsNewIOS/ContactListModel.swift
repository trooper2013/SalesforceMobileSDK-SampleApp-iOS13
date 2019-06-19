//
//  ContactsModel.swift
//  WhatsNewIOS
//
//  Created by Raj Rao on 6/18/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//

import UIKit
import SalesforceSDKCore
import SwiftUI
import Combine

struct Contact :  Hashable, Identifiable, Decodable  {
    let id: UUID = UUID()
    let firstName: String
}

class ContactListModel: BindableObject {
    
    var didChange = PassthroughSubject<ContactListModel, Never>()
   
    private(set) var contacts = [Contact]() {
        didSet {
            didChange.send(self)
        }
    }

    func fetchContacts() {
        let request = RestClient.shared.request(forQuery: "SELECT Name FROM User LIMIT 10")
        let assign = Subscribers.Assign(object: self, keyPath: \.contacts)
        RestClient.shared.send(request: request)
                         .map ({  // transform to Contact array
                                 $0.restResponse.map { (item) -> Contact in
                                    Contact(firstName: item["Name"] as! String)
                                }
                         })
                        .replaceError(with: [])
                        .receive(subscriber: assign)
    }

}
