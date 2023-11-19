//
//  MoviewViewModel.swift
//  topRated
//
//  Created by Олексій Гаєвський on 17.11.2023.
//

import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var movieDetails: MovieDetails?
    @Published var movieCredits: MovieCredits?

    private var cancellables: Set<AnyCancellable> = []

    func fetchData() {
        APICaller.shared.fetchDataPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching movie data: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] movies in
                self?.movies = movies
                if let firstMovie = movies.first {
                    self?.fetchMovieDetails(movie: firstMovie)
                }
            })
            .store(in: &cancellables)
    }

    func fetchMovieDetails(movie: Movie) {
        APICaller.shared.fetchMovieDetailsPublisher(movie: movie)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching movie details: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] details in
                self?.movieDetails = details
                self?.fetchMovieCredits(id: movie.id)
            })
            .store(in: &cancellables)
    }

    func fetchMovieCredits(id: Int) {
        APICaller.shared.fetchMovieCreditsPublisher(id: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching movie credits: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] credits in
                self?.movieCredits = credits
            })
            .store(in: &cancellables)
    }
    
    

    func convertTime(minutes: Int) -> String{
           return "\(minutes/60)h \(minutes % 60)m"
       }
       
       
       
       
        func extractYear(from dateString: String) -> String {
               let components = dateString.components(separatedBy: "-")
               if components.count >= 1 {
                   return components[0]
               } else {
                   return "N/A"
               }
           }
    
    
       
       func formattedCountries(_ countries: [Countries]) -> String{
           let countriesName = countries.map{$0.name}
           return countriesName.joined(separator: ",")
       }
       
       
    
        func formattedGenres(_ genres: [Genre]) -> String {
               let genreNames = genres.map { $0.name }
               return genreNames.joined(separator: ", ")
           }
    
       
       func languageName(for code: String, spokenLanguage: [SpokenLanguage]) -> String?{
               for language in spokenLanguage {
                   if language.iso_639_1 == code{
                       return language.english_name
                   }
               }
           return nil
       }
    
}
