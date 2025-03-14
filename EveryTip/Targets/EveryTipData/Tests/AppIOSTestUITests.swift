import XCTest
import Foundation

import Alamofire
import RxSwift

@testable import EveryTipDomain
@testable import EveryTipData
final class AppIOSTestUITests: XCTestCase {
    var verfificationCodeRepository: DefaultVerificationCodeRepository!
    var disposeBag: DisposeBag!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
        
        // Given: Mock 세션을 사용하여 DefaultVerificationCodeRepository 초기화
        verfificationCodeRepository = DefaultVerificationCodeRepository(session: MockSession.getMockSession())
    }
    
    override func tearDown() {
        verfificationCodeRepository = nil
        disposeBag = nil
        super.tearDown()
    }

    func test_requestCode_statusCode가_200일경우() {
        // Given: 성공적인 응답을 모의 설정
        let mockData = """
            {
                "statusCode": 200,
                "code": "SUCCESS",
                "message": "Verification code sent successfully"
            }
            """.data(using: .utf8)
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 200,  // statusCode가 200
            httpVersion: nil,
            headerFields: nil
        )
        MockURLProtocol.mockResponse = (data: mockData, response: mockResponse, error: nil)
        
        // When: requestCode 메서드 호출
        let expectation = self.expectation(description: "Request should succeed")
        
        verfificationCodeRepository.requestCode(with: "test@example.com")
            .subscribe(
                onCompleted: {
                    // Then: 요청이 성공했을 때 expectation.fulfill()
                    expectation.fulfill()
                },
                onError: { error in
                    XCTFail("Request should not fail: \(error)")
                }
            ).disposed(by: disposeBag)
        
        // expectation이 fulfill 될 때까지 기다림
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Given-When-Then 패턴을 추가한 두 번째 테스트
    func test_requestCode_statusCode가_400일경우() {
        // Given: statusCode가 400인 응답을 모의 설정 (잘못된 요청)
        let mockData = "{\"code\": \"FAIL\"}".data(using: .utf8)
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 400,  // statusCode가 400 (잘못된 요청)
            httpVersion: nil,
            headerFields: nil
        )
        MockURLProtocol.mockResponse = (data: mockData, response: mockResponse, error: nil)
        
        // When: requestCode 메서드 호출
        let expectation = self.expectation(description: "Request should fail with invalid status code")
        
        verfificationCodeRepository.requestCode(with: "test@example.com")
            .subscribe(
                onCompleted: {
                    // Then: 실패할 경우 expectation.fulfill()
                    XCTFail("Request should fail due to invalid status code")
                },
                onError: { error in
                    // Then: 오류가 발생할 경우 expectation.fulfill()
                    expectation.fulfill()
                    
                    // 오류가 AFError 타입인지 확인하고, 상태 코드가 400인지 확인
                    if let afError = error as? AFError {
                        XCTAssertEqual(afError.responseCode, 400)
                    } else {
                        XCTFail("Unexpected error type")
                    }
                }
            ).disposed(by: disposeBag)
        
        // expectation이 fulfill 될 때까지 기다림
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_checkCode_statusCode가_200일경우() {
        // Given: 성공적인 응답을 모의 설정
        let mockData = """
            {
                "statusCode": 200,
                "code": "SUCCESS",
                "message": "Verification code is valid"
            }
            """.data(using: .utf8)
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 200,  // statusCode가 200 (성공)
            httpVersion: nil,
            headerFields: nil
        )
        MockURLProtocol.mockResponse = (data: mockData, response: mockResponse, error: nil)
        
        // When: checkCode 메서드 호출
        let expectation = self.expectation(description: "Request should succeed")
        
        verfificationCodeRepository.checkCode(with: "validCode123")
            .subscribe(
                onCompleted: {
                    // Then: 요청이 성공했을 때 expectation.fulfill()
                    expectation.fulfill()
                },
                onError: { error in
                    XCTFail("Request should not fail: \(error)")
                }
            ).disposed(by: disposeBag)
        
        // expectation이 fulfill 될 때까지 기다림
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func test_checkCode_statusCode가_400일경우() {
        // Given: statusCode가 400인 응답을 모의 설정 (잘못된 요청)
        let mockData = """
            {
                "statusCode": "400",
                "code": "FAIL",
                "message": "Invalid verification code"
            }
            """.data(using: .utf8)
        
        let mockResponse = HTTPURLResponse(
            url: URL(string: "https://mockurl.com")!,
            statusCode: 400,  // statusCode가 400 (잘못된 요청)
            httpVersion: nil,
            headerFields: nil
        )
        MockURLProtocol.mockResponse = (data: mockData, response: mockResponse, error: nil)
        
        // When: checkCode 메서드 호출
        let expectation = self.expectation(description: "Request should fail with invalid status code")
        
        verfificationCodeRepository.checkCode(with: "invalidCode123")
            .subscribe(
                onCompleted: {
                    // Then: 요청이 실패했을 때 expectation.fulfill()
                    XCTFail("Request should fail due to invalid status code")
                },
                onError: { error in
                    // Then: 실패 시 expectation.fulfill()
                    expectation.fulfill()
                    
                    // 오류가 AFError 타입인지 확인하고, 상태 코드가 400인지 확인
                    if let afError = error as? AFError {
                        XCTAssertEqual(afError.responseCode, 400)
                    } else {
                        XCTFail("Unexpected error type")
                    }
                }
            ).disposed(by: disposeBag)
        
        // expectation이 fulfill 될 때까지 기다림
        waitForExpectations(timeout: 5, handler: nil)
    }
}
