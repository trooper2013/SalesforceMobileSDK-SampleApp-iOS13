//
//  ContactList.swift
//  WhatsNewIOS
//
//  Created by Raj Rao on 6/7/19.
//  Copyright © 2019 Salesforce. All rights reserved.
//
import Foundation
import SwiftUI
import Combine
import SalesforceSDKCore

struct ContactListView : View {
     @EnvironmentObject var viewModel: ContactListModel
     var body: some View {
        NavigationView {
            List(viewModel.contacts)  { dataItem in
                HStack {
                    Image(systemName: "photo")
                    Text(dataItem.firstName)
                 }
             }
             .navigationBarTitle(Text("Sample App"), displayMode: .inline)
        }
        .onAppear { self.viewModel.fetchContacts() }
    }
}

#if DEBUG
struct ContactList_Previews : PreviewProvider {
    static var previews: some View {
        ContactList()
    }
}
#endif
