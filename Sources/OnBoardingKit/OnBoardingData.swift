//
//  OnBoardingPages.swift
//  ReusEd
//
//  Created by Ahror Jabborov on 6/7/22.
//

import Foundation


struct Page: Identifiable, Decodable {
    var id: Int
    var image: String
    var title: String
    var description: String
}

struct Pages {
    var introductionPagesData: [Page]
    
    init(name: String) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "json")
        else {
            print(name+" json file not found")
            self.introductionPagesData = []
            return
        }
        
        let data = try? Data(contentsOf: url)
        let pages = try? JSONDecoder().decode([Page].self, from: data!)
        self.introductionPagesData = pages!
    }
}
