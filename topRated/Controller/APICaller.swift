import Foundation
import Combine

struct Constants {
    static let apiKey = "36fdaebac0d35030cc4401e678abaa57"
    static let baseURL = "https://api.themoviedb.org/"
}

enum ApiError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()

    func fetchDataPublisher() -> AnyPublisher<[Movie], Error> {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/top_rated?api_key=\(Constants.apiKey)&language=en-US&page=1") else {
            return Fail(error: ApiError.failedToGetData).eraseToAnyPublisher()
        }

        return fetchDataPublisher(from: url, responseType: TopRatedMovieResponse.self)
            .map(\.results)
            .eraseToAnyPublisher()
    }

    func fetchMovieDetailsPublisher(movie: Movie) -> AnyPublisher<MovieDetails, Error> {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/\(movie.id)?api_key=\(Constants.apiKey)&language=en-US") else {
            return Fail(error: ApiError.failedToGetData).eraseToAnyPublisher()
        }

        return fetchDataPublisher(from: url, responseType: MovieDetails.self)
            .eraseToAnyPublisher()
    }

    func fetchMovieCreditsPublisher(id: Int) -> AnyPublisher<MovieCredits, Error> {
        guard let url = URL(string: "\(Constants.baseURL)/3/movie/\(id)/credits?api_key=\(Constants.apiKey)&language=en-US") else {
            return Fail(error: ApiError.failedToGetData).eraseToAnyPublisher()
        }

        return fetchDataPublisher(from: url, responseType: MovieCredits.self)
            .eraseToAnyPublisher()
    }

    private func fetchDataPublisher<T>(from url: URL, responseType: T.Type) -> AnyPublisher<T, Error> where T: Decodable {
        return URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .map(\.data)
            .decode(type: responseType, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
