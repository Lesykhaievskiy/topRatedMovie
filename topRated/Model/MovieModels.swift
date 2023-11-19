//
//  Movie.swift
//  topRated
//
//  Created by Олексій Гаєвський on 15.11.2023.
//

import Foundation

struct TopRatedMovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable {
    let id: Int
}

struct Genre: Codable {
    let name: String
}

struct Countries: Codable {
    let name: String
}

struct MovieDetails: Codable {
    let backdrop_path: String
    let original_title: String
    let release_date: String
    let genres: [Genre]
    let runtime: Int
    let overview: String
    let original_language: String
    let production_countries: [Countries]
    let spoken_languages: [SpokenLanguage]
}

struct MovieCredits: Codable {
    let cast: [CastMebmer]
    let crew: [CastMebmer]

    func getActors() -> [CastMebmer] {
        return cast.filter { $0.known_for_department == "Acting" }
    }

    func getDirectors() -> [CastMebmer] {
        return crew.filter { $0.department == "Directing" }
    }
}

struct CastMebmer: Codable {
    let name: String
    let profile_path: String?
    let id: Int
    let known_for_department: String
    let department: String?
}

struct SpokenLanguage: Codable {
    let iso_639_1: String
    let english_name: String
}
