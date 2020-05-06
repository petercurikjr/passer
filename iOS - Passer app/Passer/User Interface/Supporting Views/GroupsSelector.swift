//
//  GroupsSelector.swift
//  Passer
//
//  Created by Peter Čuřík Jr. on 02/05/2020.
//  Copyright © 2020 Peter Čuřík Jr. All rights reserved.
//

import SwiftUI

struct GroupsSelector: View {
    
    let groupName: String
    let count: Int
    let color1: String
    let color2: String
    let emoji: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(LinearGradient(gradient: Gradient(colors: [Color(color1),Color(color2)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            
            VStack(alignment: .trailing) {
                HStack {
                    Text(emoji)
                    Spacer()
                    Text(String(count))
                }.padding(.horizontal).padding(.vertical, 10).font(.body)
                
                Text(groupName)
                    .font(.headline).padding(.horizontal)
            }
        }.frame(width: 150, height: 80)
    }
}

struct GroupsSelector_Previews: PreviewProvider {
    static var previews: some View {
        GroupsSelector(groupName: "Example", count: 34, color1: "gray1", color2: "gray2", emoji: "👤")
            .previewLayout(.fixed(width: 250, height: 150))
    }
}
