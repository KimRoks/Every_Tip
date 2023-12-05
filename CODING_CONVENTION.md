## 코딩 컨벤션
### General


- 모듈 임포트는 알파벳 순으로 정렬합니다. 내장 프레임워크를 먼저 임포트하고, 빈 줄로 구분하여 서드파티 프레임워크를 임포트합니다.
```swift
// Good
import UIkit

import RxCocoa
import RxSwift

// Bad
import RxSwift
import UIKit
import RxCocoa
```

- 최대 가로 길이는 100자 제한, 글자수 초과시 개행합니다.
  - Xcode의 **Preferences → Text Editing → Display의 'Page guide at column'** 옵션을 활성화하고 100자로 설정하면 편리합니다.
- 불필요한 괄호는 사용x, 괄호는 필요할 때만 사용합니다.
- 2개 이상의 데이터를 반환할 때는 튜플보다는 struct 고려, 튜플 사용시 각각의 필드에 이름을 붙이는것을 권장합니다.
- mutable을 보장해야 하는 경우가 아니라면 let을 통해 상수 사용합니다.
- 상속이 발생하지 않는 클래스에는 항상 `final` 키워드로 선언합니다.
- 빈 줄에는 공백이 포함되지 않도록 합니다.

<br>

### Naming
---
- lowerCamelCase: 함수, 메소드, 변수, 상수, 열거형 내 case 등에 사용
- UpperCamelCase: 클래스, 구조체, 열거형, Extension 등에 사용

<br>

### Code Layout
---
- 들여쓰기는 4개의 space를 사용
  - 레퍼런스의 스타일 가이드들은 2개의 Spaces를 사용하고 있으나, 가독성을 위해 4개로 사용하며 들여쓰기 자체를 줄이도록 합니다.
  - Xcode의 **Preferences → Text Editing → Indentation의 'Prefer Indent Using', 'Tab Width', 'Indent Width'** 옵션을 확인합니다.

- 콜론(:) 을 쓸 떄에는 콜론의 오른쪽에만 공백을 사용

```swift
// Good
let example: [String: String]

// Bad
let example: [String:String]
```
- 리턴 타입이 없는 경우 클로저는 () 대신 Void 사용, 함수는 생략합니다.
```swift
// Good
let completion: (() -> Void)?

// Bad
let completion: (() -> ())?
let completion: ((Void) -> (Void))?
```

- Closure 정의시 파라미터에는 괄호를 사용하지 않습니다.
```swift

// Good
{ operation, responseObject in
  // doSomething()
}

// Bad
{ (operation, responseObject) in
  // doSomething()
}
```

- 타입을 명시하여 타입 추론을 지양합니다.
```swift
// Good
let titleLabel: UILabel = .init()

// Bad
let titleLabel = UILabel()
```
- 함수 정의 및 호출 코드가 최대 길이를 초과하는 경우, 파라미터 이름을 기준으로 개행합니다.
```swift
func collectionView(
  _ collectionView: UICollectionView,
  cellForItemAt indexPath: IndexPath
) -> UICollectionViewCell {
  // doSomething()
}

func animationController(
  forPresented presented: UIViewController,
  presenting: UIViewController,
  source: UIViewController
) -> UIViewControllerAnimatedTransitioning? {
  // doSomething()
}
```

- 파라미터에 클로저가 2개 이상일 경우에는 반드시 내려쓰기합니다.
```swift
UIView.animate(
  withDuration: 0.25,
  animations: {
    // doSomething()
  },
  completion: { finished in
    // doSomething()
  }
)
```

- 기타 개행 예시
  - 더 많고 다양한 개행 예시는 Reference - 구글 스타일 가이드를 참고합니다.
```swift
public func index<Elements: Collection, Element>(
  of element: Element,
  in collection: Elements
) -> Elements.Index?
where
  Elements.Element == Element,
  Element: Equatable
{  // GOOD.
  for current in elements {
    // ...
  }
}

public func index<
  Elements: Collection,
  Element
>(
  of element: Element,
  in collection: Elements
) -> Elements.Index?
where
  Elements.Element == Element,
  Element: Equatable
{  // GOOD.
  for current in elements {
    // ...
  }
}

class MyContainer<BaseCollection>:
  MyContainerSuperclass,
  MyContainerProtocol,
  SomeoneElsesContainerProtocol,
  SomeFrameworkContainerProtocol
where
  BaseCollection: Collection,
  BaseCollection.Element: Equatable,
  BaseCollection.Element: SomeOtherProtocolOnlyUsedToForceLineWrapping
{
  // ...
}

if aBooleanValueReturnedByAVeryLongOptionalThing() &&
   aDifferentBooleanValueReturnedByAVeryLongOptionalThing() &&
   yetAnotherBooleanValueThatContributesToTheWrapping() {
  doSomething()
}

if aBooleanValueReturnedByAVeryLongOptionalThing() &&
   aDifferentBooleanValueReturnedByAVeryLongOptionalThing() &&
   yetAnotherBooleanValueThatContributesToTheWrapping()
{
  doSomething()
}

if let value = aValueReturnedByAVeryLongOptionalThing(),
   let value2 = aDifferentValueReturnedByAVeryLongOptionalThing() {
  doSomething()
}

if let value = aValueReturnedByAVeryLongOptionalThing(),
   let value2 = aDifferentValueReturnedByAVeryLongOptionalThingThatForcesTheBraceToBeWrapped()
{
  doSomething()
}

guard let value = aValueReturnedByAVeryLongOptionalThing(),
      let value2 = aDifferentValueReturnedByAVeryLongOptionalThing() else {
  doSomething()
}

guard let value = aValueReturnedByAVeryLongOptionalThing(),
      let value2 = aDifferentValueReturnedByAVeryLongOptionalThing()
else {
  doSomething()
}

for element in collection
    where element.happensToHaveAVeryLongPropertyNameThatYouNeedToCheck {
  doSomething()
}
```

<br>

### Comment
---
- `// MARK`: 연관된 코드 그룹핑, 해당 그룹에 대한 설명 명시합니다.
- `// TODO`: 추가적으로 할 일을 명시합니다.
- `///` 를 사용하여 문서화에 사용되는 주석 작성을 지향합니다.

<br>

### Reference
---
- [Swift API Design GuideLines](https://www.swift.org/documentation/api-design-guidelines/)
- [StyleShare - Swift Style Guide](https://github.com/StyleShare/swift-style-guide)
- [Raywernderlich - Swift Style Guide](https://github.com/raywenderlich/swift-style-guide)
- [Google - Swift Style Guide - line wrapping](https://google.github.io/swift/#line-wrapping)
