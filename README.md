# BaseCamping App
Naver Map API, 공공 API를 활용한 iOS 캠핑장 검색 어플리케이션.

## Link
+ iOS AppStore: https://apps.apple.com/kr/app/%EB%B2%A0%EC%9D%B4%EC%8A%A4%EC%BA%A0%ED%95%91/id6446268092

## Description
+ 최소 타겟 : iOS 15.0
+ CleanArchitecture + MVVM-C 패턴 적용
+ Realm 사용으로 사용자 정의 캠핑 기록 지도 유지
+ CodeBased UI
+ Unit Test 진행

## Feature
+ 홈 
  + 카테고리별 해당 항목으로 이동 기능
  + 테마별 캠핑장 리스트
  + 축제 / 행사 소식
+ 상세페이지
  + 캠핑장 이미지 캐러셀
  + 전화 연결
  + 홈페이지 연결
  + 관심 캠핑장 등록
  + 캠핑로그 작성
  + 카카오 공유 메시지 활용 정보 전달
  + 해당 캠핑장 관련 정보 제공 - 시설, 문의
  + 해당 캠핑장 위치 및 날씨 제공
  + 해당 캠핑장 관련 SNS 정보 제공
  + 해당 캠핑장 주변 관광정보 제공
  + 캠핑장 이미지 갤러리
+ 검색  
  + 키워드 기반의 검색
  + 검색 필터를 통한 상세 검색 제공
+ 지역정보 
  + 지역 기반 + 카테고리별 탭 검색
  + 관광정보 무한 스크롤 지원
+ 지도
  + 지도 범례에 따른 클러스터링
  + 검색 필터를 통한 상세 검색 제공
  + 캠핑장 선택 시 관련 Info 전달 및 상세 페이지로 이동
+ 마이메뉴
  + 공지사항
  + 관심 캠핑장 확인
  + 캠핑로그 확인
  + 앱 관련 정보
  + Push 알림 설정
  
## Getting Start
+ MVVM+C, Unit Test
+ Realm, GoogleMap, SnapKit, Moya, RxSwift, RxDataSources
+ Kakao - Share
+ FireBase - Messaging, Analytics, Crashytics
+ Third party about View - Kingfisher, Tabman, DropDown, FMPhotoPicker, FSPagerView, TTGTagCollectionView, Cosmos

## Screenshot
<div markdown="1">  
    <div align = "center">
    <img src= "https://user-images.githubusercontent.com/75239459/228717455-fbdcb603-a740-406c-91b3-f978c8b73b2a.png" width="250px"></img>
    <img src="https://user-images.githubusercontent.com/75239459/228717495-b83f5db9-7164-452d-bd73-01a8c7a00ab5.png" width="250px"></img>
    <img src="https://user-images.githubusercontent.com/75239459/228717508-dc32893e-5159-4fbd-bfde-02279c2b7650.png" width="250px"></img>
    <img src="https://user-images.githubusercontent.com/75239459/228717509-9ff863c5-acc4-4894-a473-d2b3fb713928.png" width="250px"></img>
    <img src="https://user-images.githubusercontent.com/75239459/228717511-aef77d4c-8946-418d-a37c-e3953e9ddfe9.png" width="250px"></img>
    <img src="https://user-images.githubusercontent.com/75239459/228717514-a7ebce38-2643-45a0-a2fc-87bd17355dfd.png" width="250px"></img>
    <img src="https://user-images.githubusercontent.com/75239459/228717521-9dd3d74e-7cdf-4569-8ef4-1ac93c8c9505.png" width="250px"></img>
</div>

## Issue & Reflection
### 1. 복잡한 뷰의 구성에 있어서 Compositional Layout 구성
### 2. MultiTarget의 Moya를 통한 Network 호출
### 3. 제네릭을 활용한 DTO
### 4. Reusable View와 관련한 ViewModel 구성
### 5. Clustering의 기본적인 이해
### 6. 메모리 관리
