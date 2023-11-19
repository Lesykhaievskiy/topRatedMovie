//
//  CreditsView.swift
//  topRated
//
//  Created by Олексій Гаєвський on 16.11.2023.
//

import SwiftUI

struct CreditsView: View {
    @State var actor: CastMebmer

    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original/\(actor.profile_path ?? "")")) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 125, height: 125)
                        .cornerRadius(16)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .black]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .opacity(0.8)
                            .frame(height: 125)
                            .cornerRadius(16)
                        )
                case .failure:
                    Image("notFound")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 125, height: 125)
                        .cornerRadius(16)
                @unknown default:
                    fatalError()
                }
            }

            Text(actor.name)
                .foregroundColor(.white)
                .font(.caption)
                .fontWeight(.semibold)
                .offset(y: 45)
        }
    }
}




#Preview {
    CreditsView(actor: CastMebmer(name: "Lesyk", profile_path: "/v3flJtQEyczxENi29yJyvnN6LVt.jpg", id: 2, known_for_department: "Acting", department: "Acting"))
}
