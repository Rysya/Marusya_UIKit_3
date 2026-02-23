import Foundation

enum AuthorizationError: Error {
    case emptyLogin
    case emptyPassword
    case wrongEmail
    case wrongPassword
    case notValidPassword
    case unknownUser
}

//MARK: Проверка авторизации

final class AuthorizationService {
    
    func isValidUser(login: String, password: String) throws {
        guard !login.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthorizationError.emptyLogin
        }
        guard isValidEmail(login) else {
            throw AuthorizationError.wrongEmail
        }
        guard let savedUser = loadUser(),
              login == savedUser.email else {
            throw AuthorizationError.unknownUser
        }
        guard !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AuthorizationError.emptyPassword
        }
        guard password.count >= 6 else {
            throw AuthorizationError.notValidPassword
        }
        guard password == savedUser.password else {
            throw AuthorizationError.wrongPassword
        }
    }
    
    private func loadUser() -> User? {
        guard let url = Bundle.main.url(forResource: "config", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        let decoder = JSONDecoder()
        return try? decoder.decode(User.self, from: data)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let regex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex)
                .evaluate(with: email)
    }
}
