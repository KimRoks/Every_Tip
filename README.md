# EveryTip

## Tuist

### Tuist 설치
```
$ curl -Ls https://install.tuist.io | bash
```

이하의 작업들은 Project.swift 파일이 위치한 프로젝트 폴더에서 터미널로 진행합니다.

### mise를 통해 tuist 사용, tuist version 4.30.0

```swift
mise use tuist@4.30.0
```

### Tuist 의존성 설치
```swift
$ tuist install
```

### Tuist 프로젝트 생성
```swift
// tuist generate {타겟명}
// tuist generate 또한 가능
```



#### 앱 의존성 그래프
![image](graph.png)

앱 타겟이 Data, Presentation, Domain, Core Layer에 의존하고 있음.

#### Tuist 의존성 그래프 legend
![image](https://github.com/EveryTip/app-iOS-test/assets/73145656/557863f2-7eb1-4990-96f6-93490b6ed0ec)

<br>

## 참고
- [git 작업 컨벤션](GIT_CONVENTION.md)
- [코딩 컨벤션](CODING_CONVENTION.md)
