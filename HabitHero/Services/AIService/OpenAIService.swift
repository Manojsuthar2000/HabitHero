//
//  GroqService.swift
//  HabitHero
//
//  FREE alternative to OpenAI/Gemini with generous rate limits
//  Get your free API key at: https://console.groq.com/keys
//

import Foundation

// MARK: - AI Suggestion Model
struct AISuggestion {
    let habitName: String
    let frequency: HabitFrequency
    let duration: String?
    let benefits: String
    let category: HabitCategory
    let icon: String
    
    /// Parse AI response text into structured AISuggestion
    static func parse(from text: String, goal: String) -> AISuggestion? {
        var habitName: String?
        var frequency: HabitFrequency = .daily
        var duration: String?
        var benefits: String?
        
        // Parse the response line by line
        let lines = text.components(separatedBy: "\n")
        
        for line in lines {
            let lowercaseLine = line.lowercased()
            
            if lowercaseLine.contains("habit:") {
                habitName = extractValue(from: line, prefix: "habit:")
            } else if lowercaseLine.contains("frequency:") {
                let freqValue = extractValue(from: line, prefix: "frequency:")?.lowercased() ?? ""
                if freqValue.contains("weekly") {
                    frequency = .weekly
                } else if freqValue.contains("custom") {
                    frequency = .custom
                } else {
                    frequency = .daily
                }
            } else if lowercaseLine.contains("duration:") {
                duration = extractValue(from: line, prefix: "duration:")
            } else if lowercaseLine.contains("benefits:") || lowercaseLine.contains("benefit:") {
                benefits = extractValue(from: line, prefix: lowercaseLine.contains("benefits:") ? "benefits:" : "benefit:")
            }
        }
        
        // If parsing failed, use fallback
        guard let name = habitName, !name.isEmpty else {
            // Fallback: use first meaningful line as habit name
            let fallbackName = lines.first(where: { !$0.trimmingCharacters(in: .whitespaces).isEmpty }) ?? goal
            return AISuggestion(
                habitName: fallbackName.trimmingCharacters(in: .whitespaces),
                frequency: .daily,
                duration: nil,
                benefits: text,
                category: inferCategory(from: goal),
                icon: "sparkles"
            )
        }
        
        return AISuggestion(
            habitName: name,
            frequency: frequency,
            duration: duration,
            benefits: benefits ?? "Build a positive habit to improve your life.",
            category: inferCategory(from: goal + " " + name),
            icon: inferIcon(from: goal + " " + name)
        )
    }
    
    private static func extractValue(from line: String, prefix: String) -> String? {
        guard let range = line.lowercased().range(of: prefix) else { return nil }
        let value = String(line[range.upperBound...]).trimmingCharacters(in: .whitespaces)
        // Remove markdown bold markers if present
        return value.replacingOccurrences(of: "**", with: "").trimmingCharacters(in: .whitespaces)
    }
    
    private static func inferCategory(from text: String) -> HabitCategory {
        let lowercaseText = text.lowercased()
        
        if lowercaseText.contains("exercise") || lowercaseText.contains("workout") || 
           lowercaseText.contains("run") || lowercaseText.contains("gym") ||
           lowercaseText.contains("fitness") || lowercaseText.contains("walk") {
            return .fitness
        } else if lowercaseText.contains("meditat") || lowercaseText.contains("mindful") ||
                  lowercaseText.contains("breath") || lowercaseText.contains("calm") ||
                  lowercaseText.contains("relax") {
            return .mindfulness
        } else if lowercaseText.contains("read") || lowercaseText.contains("learn") ||
                  lowercaseText.contains("study") || lowercaseText.contains("book") ||
                  lowercaseText.contains("course") {
            return .learning
        } else if lowercaseText.contains("health") || lowercaseText.contains("water") ||
                  lowercaseText.contains("sleep") || lowercaseText.contains("diet") ||
                  lowercaseText.contains("eat") || lowercaseText.contains("vitamin") {
            return .health
        } else if lowercaseText.contains("work") || lowercaseText.contains("task") ||
                  lowercaseText.contains("productiv") || lowercaseText.contains("focus") ||
                  lowercaseText.contains("goal") {
            return .productivity
        } else if lowercaseText.contains("friend") || lowercaseText.contains("family") ||
                  lowercaseText.contains("social") || lowercaseText.contains("call") ||
                  lowercaseText.contains("connect") {
            return .social
        } else if lowercaseText.contains("write") || lowercaseText.contains("art") ||
                  lowercaseText.contains("creative") || lowercaseText.contains("paint") ||
                  lowercaseText.contains("music") || lowercaseText.contains("journal") {
            return .creativity
        }
        
        return .other
    }
    
    private static func inferIcon(from text: String) -> String {
        let lowercaseText = text.lowercased()
        
        if lowercaseText.contains("walk") { return "figure.walk" }
        if lowercaseText.contains("run") { return "figure.run" }
        if lowercaseText.contains("exercise") || lowercaseText.contains("workout") { return "dumbbell.fill" }
        if lowercaseText.contains("meditat") { return "leaf.fill" }
        if lowercaseText.contains("read") || lowercaseText.contains("book") { return "book.fill" }
        if lowercaseText.contains("water") || lowercaseText.contains("drink") { return "drop.fill" }
        if lowercaseText.contains("sleep") { return "moon.fill" }
        if lowercaseText.contains("write") || lowercaseText.contains("journal") { return "pencil" }
        if lowercaseText.contains("learn") || lowercaseText.contains("study") { return "graduationcap.fill" }
        if lowercaseText.contains("music") { return "music.note" }
        if lowercaseText.contains("cook") || lowercaseText.contains("eat") { return "fork.knife" }
        if lowercaseText.contains("stretch") || lowercaseText.contains("yoga") { return "figure.yoga" }
        
        return "sparkles"
    }
}

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
    
    /// Generate habit suggestion and return parsed structured data
    func generateHabitSuggestionParsed(for input: String) async throws -> AISuggestion {
        let rawResponse = try await generateHabitSuggestion(for: input)
        
        guard let suggestion = AISuggestion.parse(from: rawResponse, goal: input) else {
            throw AIError.noSuggestion
        }
        
        return suggestion
    }
    
    /// Generate raw habit suggestion text
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
        
        Format your response EXACTLY like this:
        Habit: [specific habit name, keep it short - max 5 words]
        Frequency: [daily or weekly]
        Duration: [time if applicable, e.g., "15 minutes" or "N/A"]
        Benefits: [1-2 sentences about why this helps]
        """
        
        // Groq uses OpenAI-compatible API format!
        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                ["role": "system", "content": "You are a helpful habit coach. Always respond in the exact format requested."],
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 200
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
