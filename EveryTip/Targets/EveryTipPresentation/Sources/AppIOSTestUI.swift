import Foundation

public final class AppIOSTestUI {
    public static func hello() {
        print("Hello, from your UI framework")
        print(infos?["SHARED_CONSTANT"] ?? "shared constant is nil")
        print(infos?["ENVIRONMENT_CONSTANT"] ?? "environment constant is nil")
    }
    
    private static var infos: NSDictionary? {
           guard let path = Bundle.main.path(forResource: "Info", ofType: "plist") else {
               return nil
           }
           return NSDictionary(contentsOfFile: path)
    }
}
