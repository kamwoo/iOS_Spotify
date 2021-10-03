# iOS_Spotify
### ![스포티파치아이콘 (2)](https://user-images.githubusercontent.com/61308364/135743292-21beb2dd-ab38-44c6-a913-13da1a4cc41f.jpeg) Spotify API를 활용한 음원 스트리밍 ios앱
[![SDWebImage](https://img.shields.io/badge/Library-SDWebImage-green)]()
[![Firebase](https://img.shields.io/badge/Framwork-Firebase-red)]()
[![Appirator](https://img.shields.io/badge/Library-Appirater-orange)]()
[![Swift](https://img.shields.io/badge/Swift-5-blue)]()

---

### 설명
Swift로 작성된 Spofity Api를 이용한 음악 스트리밍 앱으로 스포티파이에서 제공하는 최신 앨범 전체재생, 추천 플레이리스트를 사용할 수 있습니다.  
메인 페이지 Home에서 최신 앨범, 추천 플레이리스트, 추천 트랙을 바로 플레이 할 수 있고, Search 페이지에서 장르별로 정리된 플레이리스트를 찾을 수 있습니다. 제목 또는 앨범, 아티스트를 검색을 통해 관련된 아티스트 정보, 플레이리스트, 트랙을 찾을 수 있습니다.  
라이브러리 페이지를 통해 사용자의 플레이리스트 및 앨범을 를 만들어 사용할 수 있습니다.

---
### 개발
Swift 바닐라 코드로 작성  
Firebase 사용자의 이메일, 비밀번호, 개인정보, 플레이리스트 저장  
Mvvm Table 또는 Collection ViewCell에서 발생한 이벤트를 protocol Delegate를 사용하여 ViewContoroller에서 이벤트 처리  
OAuth 앱이 실행되고 WelocomeViewController로 처음 Scene으로 나타나면서 로그인 캐시확인 및 Spoify로그인을 통해 사용자 토큰 처리

---
### 사용 화면
![메인화면](https://user-images.githubusercontent.com/61308364/135742244-88d98656-8f77-4654-a98f-e70e14b17e38.gif) ![ezgif com-gif-maker](https://user-images.githubusercontent.com/61308364/135742446-de256cf6-4eed-47ce-9f69-79d49951ac70.gif) ![ezgif com-gif-maker (1)](https://user-images.githubusercontent.com/61308364/135742487-ff7acc6f-9c24-4d25-bb08-dd9c4b0f4d7a.gif) 
![ezgif com-gif-maker (2)](https://user-images.githubusercontent.com/61308364/135742618-5f3cb30a-710e-489f-8ff7-f878cf73c95a.gif) ![Simulator Screen Shot - iPhone 12 - 2021-10-03 at 16 36 13](https://user-images.githubusercontent.com/61308364/135745002-e6c7ed70-6204-4ea9-b555-3fd013c308ec.png) ![Simulator Screen Shot - iPhone 12 - 2021-10-03 at 16 37 56](https://user-images.githubusercontent.com/61308364/135745014-4797a330-e14f-4c10-b593-ce5cd5a66ee0.png)
