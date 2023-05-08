//
//  DetailView.swift
//  Demo
//
//  Created by Ramamoorthy on 08/05/23.
//

import SwiftUI

struct DetailView: View {
    
    var userList: [PersonData]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        
        NavigationView {
            List(userList) { user in
                UserCardView(user: user)
            }
             .toolbar {
               ToolbarItem(placement: .cancellationAction) {
                   Button(Constants.Titles.close, role: .cancel) {
                       dismiss()
                   }
               }
             }
           }
    }
    
    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct UserCardView: View {
    
    var user: PersonData
    
    var body: some View {
        VStack {
            
            CardView
        }
    }
    
    private var CardView: some View {
        
        VStack {
            HStack {
                Image(systemName: Constants.Icons.personFill)
                
                    .padding(.leading,10)
                    .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 0)
                VStack {
                    Text(user.name)
                        .font(Font.system(size: 18,weight: .semibold))
                        .foregroundColor(Color.black)
                        .frame(maxWidth: .infinity,alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.top,10)
            .padding(.bottom,10)
            
        }
        
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        
    }
    
    
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(userList: [])
    }
}
