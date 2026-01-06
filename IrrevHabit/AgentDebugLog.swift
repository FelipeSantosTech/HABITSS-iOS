import Foundation

// #region agent log
enum AgentDebugLog {
    /// Sends a small JSON log payload to the local NDJSON ingest server.
    /// NOTE: This is intended to be used from the iOS Simulator (so `127.0.0.1` reaches the host).
    static func log(
        runId: String,
        hypothesisId: String,
        location: String,
        message: String,
        data: [String: Any] = [:]
    ) {
        var payload: [String: Any] = [
            "sessionId": "debug-session",
            "runId": runId,
            "hypothesisId": hypothesisId,
            "location": location,
            "message": message,
            "data": data,
            "timestamp": Int(Date().timeIntervalSince1970 * 1000)
        ]

        // Ensure JSON-serializable
        if !JSONSerialization.isValidJSONObject(payload) {
            payload["data"] = ["serializationError": true]
        }

        guard let url = URL(string: "http://127.0.0.1:7242/ingest/c22656ab-1e89-4d86-8cae-c6362aedc791") else { return }
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONSerialization.data(withJSONObject: payload, options: [])

        URLSession.shared.dataTask(with: req) { _, _, _ in
            // ignore errors; debug only
        }.resume()
    }
}
// #endregion


