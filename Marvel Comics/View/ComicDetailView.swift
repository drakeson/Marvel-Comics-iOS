//
//  ComicDetailView.swift
//  Marvel Comics
//
//  Created by Kato Drake Smith on 01/02/2023.
//

import SwiftUI

struct ComicDetailView: View {
    
    // The sheet is presented first by default
    @State var presentingSheet = true
    
    let comic: Comic
    let imageURL: String
    
    // Appending all authors to a single String
    var allAuthors: String {
        var authors = ""
        for i in 0..<(comic.creators?.items!.count)! {
            authors += (comic.creators?.items![i].name)! + ", "
        }
        authors = String(authors.dropLast(2))
        authors += "."
        if (comic.creators?.items!.count)! == 0 {
            authors = "Anonymous author"
        }
        return authors
    }
    
    var body: some View {
        
        VStack {
            AsyncImage(
                url: URL(string: imageURL),
                content: { image in
                    image
                        .resizable()
                        .scaledToFit()
                },
                placeholder: {
                    ProgressView()
                }
            )
            Text("Thumbnail art for \(comic.title!)")
                .foregroundColor(.gray)
            Spacer()
        }
        .sheet(isPresented: $presentingSheet){
            VStack(alignment: .leading, spacing: 15) {
                Text(comic.title!)
                    .font(.title)
                    .bold()
                Text(allAuthors)
                    .font(.callout)
                    .foregroundColor(.gray)
                Text(comic.description!)
            }
            .padding()
            .presentationDetents([.medium, .large, .fraction(0.3)])
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ComicDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ComicDetailView(comic: Comic(title: "Title of a Marvel Comic", description: "Very long and detailed description about currently selected Marvel comic", creators: APIauthors(items: [APIauthor(name: "Anonymous")])), imageURL: "https://i.annihil.us/u/prod/marvel/i/mg/1/30/56538fd257915/portrait_xlarge.jpg")
    }
}
