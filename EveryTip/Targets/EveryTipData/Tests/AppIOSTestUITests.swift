import Foundation
import XCTest
import RxSwift
import Alamofire

@testable import EveryTipData
@testable import EveryTipDomain

final class AppIOSTestUITests: XCTestCase {
    private var disposeBag: DisposeBag!
    private var verificationCodeRepository: DefaultVerificationCodeRepository!
    private var mockSession: Session!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        
        // Given: MockSession을 사용하도록 설정
        mockSession = MockSession.getMockSession()
        verificationCodeRepository = DefaultVerificationCodeRepository(session: mockSession)
    }
    
    override func tearDown() {
        // 테스트 종료 후 리소스 해제
        disposeBag = nil
        verificationCodeRepository = nil
        mockSession = nil
        super.tearDown()
    }
    
    func test_requestEmailCode_Success() {
        let expectation = self.expectation(description: "이메일 코드 요청 성공")
        
        // Given: Mock 응답 데이터 설정
        let jsonString = """
            {
                "statusCode": 200,
                "code": "123456",
                "message": "인증 코드가 발송되었습니다."
            }
            """
        let data = jsonString.data(using: .utf8)
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://mock.api.com/email/code")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        MockURLProtocol.mockResponse = (data: data, response: mockResponse, error: nil)
        
        var result: VerificationCodeResponse?
        var error: Error?
        
        // When: 이메일 코드 요청 API 호출
        verificationCodeRepository.requestCode(with: "test@example.com")
            .subscribe { response in
                result = response
                expectation.fulfill()
            } onFailure: { err in
                error = err
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        
        waitForExpectations(timeout: 5)
        
        // Then: 응답 데이터가 정상적으로 매핑되고, 오류가 발생하지 않는지 검증
        XCTAssertNotNil(result)
        
        XCTAssertEqual(result?.code, "123456")
        XCTAssertEqual(result?.message, "인증 코드가 발송되었습니다.")
        XCTAssertNil(error)
    }
    
    func test_checkVerificationCode_Success() {
        let expectation = self.expectation(description: "인증 코드 확인 성공")

        // Given: Mock 응답 데이터 설정
        let jsonString = """
            {
                "statusCode": 200,
                "message": "인증 코드가 확인되었습니다."
            }
            """
        let data = jsonString.data(using: .utf8)

        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://mock.api.com/verify/code")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        MockURLProtocol.mockResponse = (data: data, response: mockResponse, error: nil)

        var result: Data?
        var error: Error?

        // When: 인증 코드 확인 API 호출
        verificationCodeRepository.checkCode(with: "123456")
            .subscribe { response in
                result = response
                expectation.fulfill()
            } onFailure: { err in
                error = err
                expectation.fulfill()
            }
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 5)

        // Then: 응답 데이터가 정상적으로 매핑되고, 오류가 발생하지 않는지 검증
        XCTAssertNotNil(result)
        XCTAssertNil(error)

        // 디코딩하여 응답 메시지가 예상한 값인지 확인
        if let result = result,
           let json = try? JSONSerialization.jsonObject(with: result, options: []) as? [String: Any] {
            XCTAssertEqual(json["message"] as? String, "인증 코드가 확인되었습니다.")
        } else {
            XCTFail("디코딩 실패")
        }
    }  
}
