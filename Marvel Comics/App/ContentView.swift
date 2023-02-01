//
//  ContentView.swift
//  Marvel Comics
//
//  Created by Kato Drake Smith on 01/02/2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var allComics = AllComics()
    @State var searchedTitle = ""
    var searchResults: [Comic] {
        if searchedTitle.isEmpty {
            return (allComics.comics.data?.results)!
        }else{
            return (allComics.comics.data?.results?.filter { ($0.title?.localizedCaseInsensitiveContains(searchedTitle))!})!
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(searchResults) { comic in
                    NavigationLink(destination: ComicDetailView(comic: comic, imageURL: comic.thumbnail?.linkDetail ?? "")){
                        HStack(){
                            AsyncImage(
                                url: URL(string: comic.thumbnail?.link ?? ""),
                                content: { image in
                                    image.resizable()
                                        .scaledToFit()
                                        .frame(height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                },
                                placeholder: {ProgressView()}
                            )
                            VStack(alignment: .leading){
                                Text(comic.title ?? "No title")
                                    .font(.title3)
                                    .lineLimit(2)
                                    .bold()
                                Text("written by \(((comic.creators?.items!.isEmpty)! ? "anonymous" : comic.creators?.items![0].name)!)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text((comic.description!.isEmpty ? "No description" : comic.description)!)
                                Spacer()
                            }
                            .padding(10)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 200)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(10)
                    .shadow(radius: 5)
                    }
                    .foregroundColor(.black)
                }
            }
            .navigationTitle("Marvel Comics")
            .searchable(text: $searchedTitle, prompt: "Search your comic's title")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
