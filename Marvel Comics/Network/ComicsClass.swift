//
//  ComicsClass.swift
//  Marvel Comics
//
//  Created by Kato Drake Smith on 01/02/2023.
//

import Foundation
import CryptoKit

final class AllComics: ObservableObject {
    @Published var comics = APIrequest()
    
    init() {
        fetchData()
    }
    
    func fetchData(){
        let ts = String("\(NSDate().timeIntervalSince1970)")                                      // Timestamp since 1970
        let publicKey = "e3b3568badbe60e5a37984a5ce579546"                                        // Provided by Marvel - keep it secure
        let privateKey = "e76d76c04475c769b78e5b509d372b2189120e98"                               // Provided by Marvel - keep it secure
        var hash = ts+privateKey+publicKey                                                        // Hash is constructed by combining timestamp + privateKey + publicKey
        hash = hash.MD5                                                                           // Converting hash to md5 format
        let query = "https://gateway.marvel.com:443/v1/public/comics?format=comic&limit=10"       // Query for random top 10 comics
        let link = query + "&ts=" + ts + "&apikey=" + publicKey + "&hash=" + hash                 // Constructing final link for API call
        guard let url = URL(string: link) else {return}
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data{
                let decoder = JSONDecoder()
                do {
                    let response = try decoder.decode(APIrequest.self, from: data)
                    DispatchQueue.main.async {
                        self.comics = response
                    }
                }
                catch {
                    print(error)
                }
            }
        }.resume()
    }
}


extension String {
    var MD5: String {
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map{ String(format: "%02hhx", $0) }.joined()
    }
}
