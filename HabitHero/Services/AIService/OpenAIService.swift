//
//  GroqService.swift
//  HabitHero
//
//  FREE alternative to OpenAI/Gemini with generous rate limits
//  Get your free API key at: https://console.groq.com/keys
//

import Foundation

final class GroqService {
    
    // MARK: - Singleton
    static let shared = GroqService()
    
    // MARK: - Properties
    private let apiKey = APIKeys.groqKey  // Get free key at https://console.groq.com/keys
    private let baseURL = "https://api.groq.com/openai/v1"
    private let session: URLSession
    
    // Available models (all FREE):
    // - "llama-3.3-70b-versatile"  (Best quality, 30 RPM)
    // - "llama-3.1-8b-instant"     (Fastest, 30 RPM)
    // - "mixtral-8x7b-32768"       (Good balance, 30 RPM)
    // - "gemma2-9b-it"             (Google's Gemma, 30 RPM)
    private let model = "llama-3.3-70b-versatile"
    
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
        
        // Groq uses OpenAI-compatible API format!
        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": "You are a helpful habit coach."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 150
        ]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await session.data(for: request)
        
        // Debug: Print response for troubleshooting
        if let errorString = String(data: data, encoding: .utf8) {
            print("Groq Response: \(errorString)")
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AIError.invalidResponse
        }
        
        // Handle specific error codes
        switch httpResponse.statusCode {
        case 200...299:
            break // Success
        case 429:
            throw AIError.rateLimitExceeded
        case 401, 403:
            throw AIError.invalidAPIKey
        case 400:
            throw AIError.badRequest
        default:
            throw AIError.invalidResponse
        }
        
        // Parse response (OpenAI-compatible format)
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
              let choices = json["choices"] as? [[String: Any]],
              let firstChoice = choices.first,
              let message = firstChoice["message"] as? [String: Any],
              let content = message["content"] as? String else {
            throw AIError.noSuggestion
        }
        
        return content
    }
}

// MARK: - Errors (shared with other services)
enum AIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case noSuggestion
    case networkError
    case rateLimitExceeded
    case invalidAPIKey
    case badRequest
    
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
        case .rateLimitExceeded:
            return "API rate limit exceeded. Please try again later."
        case .invalidAPIKey:
            return "Invalid API key. Please check your configuration."
        case .badRequest:
            return "Bad request. Please check your input."
        }
    }
}

/*
 GROQ FREE TIER BENEFITS:
 ========================
 - 30 requests per minute (RPM)
 - 15,000 tokens per minute
 - NO daily limits!
 - Multiple models available
 - OpenAI-compatible API (easy migration)
 - Extremely fast inference (~300 tokens/sec)
 
 Get your FREE API key:
 https://console.groq.com/keys
 
 Documentation:
 https://console.groq.com/docs/quickstart
 */
