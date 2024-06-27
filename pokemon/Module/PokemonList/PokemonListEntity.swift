// 
//  PokemonListEntity.swift
//  pokemon
//
//  Created by Faza Azizi on 27/06/24.
//

import Foundation

struct PokemonListResponse: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [PokemonListEntity]?
}

struct PokemonListEntity: Codable {
    let name: String?
    let url: String?
}

enum PokemonListType {
    case mypokemon
    case alllistpokemon
}
