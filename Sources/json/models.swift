import Foundation

struct Category: Codable {
    let id: UUID
    let title: String
}       

struct Product: Codable {
    let id: UUID
    let title: String 
    let description: String
    let category: String
    let startingPrice: String
    let imageURL: String
    let discoverURL: String
}   
