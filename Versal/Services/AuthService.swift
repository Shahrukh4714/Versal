import Foundation
import LocalAuthentication

final class AuthService: ObservableObject, AuthServiceProtocol {
    @Published private(set) var isAppLocked: Bool = true
    @Published var isFaceIDEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isFaceIDEnabled, forKey: "isFaceIDEnabled")
        }
    }

    init() {
        self.isFaceIDEnabled = UserDefaults.standard.bool(forKey: "isFaceIDEnabled")
    }

    func authenticateWithFaceID(reason: String) async throws -> Bool {
        let context = LAContext()
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw AuthError.biometricsNotAvailable
        }

        return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
    }

    func authenticateWithDevicePasscode(reason: String) async throws -> Bool {
        let context = LAContext()
        return try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
    }

    func lockFile(_ file: FileItem) async throws {
        // File-level encryption using device key
        let data = try Data(contentsOf: file.url)
        let encrypted = try encrypt(data)
        try encrypted.write(to: file.url, options: .atomic)
    }

    func unlockFile(_ file: FileItem) async throws -> Bool {
        guard try await authenticateWithFaceID(reason: "Unlock \(file.name)") else {
            return false
        }
        let data = try Data(contentsOf: file.url)
        let decrypted = try decrypt(data)
        try decrypted.write(to: file.url, options: .atomic)
        return true
    }

    private func encrypt(_ data: Data) throws -> Data {
        // For V1: simple obfuscation
        // Production would use CommonCrypto
        var bytes = [UInt8](data)
        for i in 0..<bytes.count {
            bytes[i] = bytes[i] ^ 0xAB
        }
        return Data(bytes)
    }

    private func decrypt(_ data: Data) throws -> Data {
        var bytes = [UInt8](data)
        for i in 0..<bytes.count {
            bytes[i] = bytes[i] ^ 0xAB
        }
        return Data(bytes)
    }
}

enum AuthError: Error, LocalizedError {
    case biometricsNotAvailable
    var errorDescription: String? { "Face ID is not available on this device" }
}
