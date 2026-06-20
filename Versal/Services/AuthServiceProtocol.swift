import Foundation

protocol AuthServiceProtocol {
    var isAppLocked: Bool { get }
    var isFaceIDEnabled: Bool { get set }
    func authenticateWithFaceID(reason: String) async throws -> Bool
    func authenticateWithDevicePasscode(reason: String) async throws -> Bool
    func lockFile(_ file: FileItem) async throws
    func unlockFile(_ file: FileItem) async throws -> Bool
}
