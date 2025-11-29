//
//  OpenAIService.swift
//  HabitHero
//
//  Created by Manoj Suthar on 29/11/25.
//

import Foundation

final class OpenAIService {
    
    // MARK: - Singleton
    static let shared = OpenAIService()
    
    // MARK: - Properties
    private let apiKey = APIKeys.openAIKey
    private let baseURL = "https://api.openai.com/v1"
    private let session: URLSession
    
    // MARK: - Init
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        self.session = URLSession(configuration: config)
    }
    
    // MARK: - Methods
    func generateHabitSuggestion(for input: String) async throws -> String {
        let endpoint = "\(baseURL)/chat/completions"
        guard let url = URL(string: endpoint) else {
            throw AIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = """
        Generate a specific, actionable habit suggestion based on the user's goal: "\(input)".
        The habit should be:
        - Clear and measurable
        - Achievable daily or weekly
        - Related to their goal
        - Include a brief explanation of benefits
        
        Format: 
        Habit: [specific habit]
        Frequency: [daily/weekly]
        Duration: [time if applicable]
        Benefits: [1-2 sentences]
        """
        
        let requestBody = OpenAIRequest(
            model: "gpt-3.5-turbo",
            messages: [
                Message(role: "system", content: "You are a helpful habit coach."),
                Message(role: "user", content: prompt)
            ],
            temperature: 0.7,
            maxTokens: 150
        )
        
        request.httpBody = try JSONEncoder().encode(requestBody)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AIError.invalidResponse
        }
        
        let openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        guard let suggestion = openAIResponse.choices.first?.message.content else {
            throw AIError.noSuggestion
        }
        
        return suggestion
    }
}

// MARK: - Models
struct OpenAIRequest: Codable {
    let model: String
    let messages: [Message]
    let temperature: Double
    let maxTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case model, messages, temperature
        case maxTokens = "max_tokens"
    }
}

struct Message: Codable {
    let role: String
    let content: String
}

struct OpenAIResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

// MARK: - Errors
enum AIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case noSuggestion
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from AI service"
        case .noSuggestion:
            return "Could not generate suggestion"
        case .networkError:
            return "Network connection error. Please check your internet."
        }
    }
}
