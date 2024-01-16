
## Git 작업
### repository 설정
- 원본 repository 포크
- 포크 repository 로컬로 클론
- 원본 repository 를 로컬의 upstream 으로 지정한다. (remote에 원본 repository를 추가하며 네이밍을 upstream으로.)
- 로컬의 remote는 포크 repository인 origin과 원본 repository인 upstream 두개로 설정된다.
- 이후 개발 시 upstream과 동기화 하며 개발한다. (fetch from upstream, upstream에서 가져오기)

### 작업 flow
- 원본 repository 에서 **이슈** 를 생성한다.
- 포크 repository 에서 특정 이슈 개발을 위한 **브랜치** 를 생성한다.
- 생성한 브랜치에 작업 **커밋** 을 작성한다.
- 이슈 해결 위한 개발 완료 시, 원본 repository 에 **PR** 요청한다.  (PR 내용에 해당 이슈 링크 및 개발 내용 작성)
- PR 리뷰와 승인 이후 머지한다.
<br>

## 이슈
### 이슈 제목 컨벤션
```swift
[태그] 작업 내용

ex) [Feat] 네트워크 레이어 구현
```

### 이슈 본문
- 이슈 본문에는 유형과 내용을 작성한다.
- 이슈의 유형은 **기능 구현, 오류 수정, 리팩토링** 이 있다.
- 이슈의 내용은 **AS-IS, TO-BE** 로 구성한다.
- AS-IS 에는 개선이 필요한 **현 문제와 상황**을 작성한다.
- TO-BE 에는 **개선 자체 내용**과 개선을 통한 **기대 효과**를 작성한다.
<br>

## 브랜치

### 브랜치 전략
- 원본 repository의 브랜치는 우선 **main, develop, fix** 로 구성한다.
- **main** 브랜치는 배포된 상용 버전과 동일하게 유지한다.
- **develop** 브랜치는 완료된 개발 내용이 쌓이는 브랜치로, 개발 완료 시 PR 을 통해 이 브랜치에 merge 한다.
  - 버전 개발 완료 및 배포 시 main 브랜치에 merge 한다.
- **fix** 브랜치는 상용 버전에서 발견된 오류를 수정하기 위한 브랜치다.
  - 문제가 된 main 브랜치에서 fix 브랜치 생성하여 오류 수정 후, 배포하여 main 브랜치에 merge 한다.
  - fix 작업 내용은 이후 develop 브랜치에도 merge 한다.
### 브랜치명 컨벤션
```swift
브랜치 태그/작업명 또는 설명

ex) feature/createCaterogy, feature/networkProvider
```

#### 브랜치 태그 목록
| *Tag* | *설명* |
| --- | --- |
| **feature** | 새로운 기능 추가 |
| **fix** | 버그를 고친 경우 |
| **refactor** | 코드 리팩토링 |


<br>

### 커밋 제목 컨벤션
```swift
커밋 태그: 이슈 번호 - 작업명 또는 설명

ex) feat: #1 - endpoint type 구현
```
<br>

## PR
### PR 제목 컨벤션
```swift
태그: 이슈 작업 내용

ex) Feat: 네트워크 레이어 구현
```

### PR 본문
- PR 본문에는 관련된 이슈의 번호, 작업 유형, 작업 내용, 유의 및 기타 사항 을 작성한다.
- 이슈의 번호와 작업 유형은 PR 을 통해 해결하고자 하는 이슈의 번호와 유형과 같다.
- 작업 내용은 구현하고 작업한 내역을 리스트로 작성한다.
- 유의 및 기타 사항은 리뷰 중 주의 깊게 봐야할 곳 또는 말하고 싶은 것을 작성한다.
<br>

