# CarrotMarket-Clone
당근마켓 클론 어플. 당근마켓에 있는 기능들을 최대한 구현하였고, 추가로 있으면 좋을만한 기능을 추가해 봤다. Firebase을 이용하여 로그인, 회원가입 그리고 실제로 데이터를 저장 불러오기가 가능하다.





로그인 & 회원가입             |  물건 보기          |  지도로 매물 보기     | 채팅
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://user-images.githubusercontent.com/48948578/126030688-06be7f62-d87c-4489-94a6-71ff655e321c.gif"  width="200" height="300" align="left"> |<img src="https://user-images.githubusercontent.com/48948578/126030699-8e8dc34a-6c47-40cd-bc71-fd816ebf5af6.gif"  width="200" height="300" align="left"> |<img src="https://user-images.githubusercontent.com/48948578/126030711-8c5f0f18-9ecf-424a-9160-b31bc1d8bc72.gif"  width="200" height="300" align="left"> |<img src="https://user-images.githubusercontent.com/48948578/126030716-8f827161-313a-4ac8-aad9-e6e679b7c617.gif"  width="200" height="300" align="left">


# Contents
+ [Installation](#Installation)
+ [How CarrotMarket-Clone is made](#How-CarrotMarket-Clone-is-made)



***
### Installation (편의를 위해 api key 발급 받지 않고 사용할 수 있게 했습니다.)
1. 프로젝트를 다운한다.
> + 프로젝트 zip파일 다운하기.
2. 필요한 API 키 발급받기. :
> + Kakao Map API.   https://apis.map.kakao.com/
3. Pods install하기.
> + add pods 
>>+ pod 'Firebase/Auth'
>>+ pod 'Firebase/Firestore'
>>+ pod 'Firebase/Storage'
>>+ pod 'Alamofire', '~> 5.4'
>>+ pod 'Floaty', '~> 4.2.0' 
> + pod install

4. xcworkspace로 프로젝트를 연다. 


***
### How CarrotMarket-Clone is made
1. Data Structure
 + ItemData - 매물을 저장할때 필요한 정보들
 >+ title, location, price, content, x, y, postUser 등의 정보들을 저장


 + documentResponse - 주소를 검색했을시 리턴으로 받는 객체 저장.
 >+ documents - Document의 array
 >>+ address - Address객체
 >>>+ Address - 주소 이름
 >>+ x - 지도에서의 좌표
 >>+ y - 지도에서의 좌표
 >+ meta - 검색된 주소의 meta data.
 >>+ pageable_count - 검색된 주소의 페이지 개수
 >>+ total_count - 검색된 주소의 개수
 
 + MessageModel - 채팅 할때 주고 받는 

2. Data Flow 
 + ItemData Flow
  > 1) UploadViewController에서 사용자가 새로운 중고 물품을 등록하려고 할 시 중고품의 필요한 정보들을 기입한 후 save 버튼을 누르면 새로운 객체에 필요한 정보들이 firebase에 저장된다.
  > 2) 이 후 ListTableViewController에서 firebase에 저장된 data들을 정보 load한 후, 각 매물마다 itemData객체를 생성한다.
  > 3) itemData객체들이 생성되면, 이 객체들을 이용하여 tableview의 data source로 사용한다.
  
 + documentResponse Flow
  > 1) UploadTableViewController에서 사용자가 주소를 선택하고 싶을시 사용된다. 주소를 검색하시오 버튼을 누르면 LocationSearchViewController 로 이동된다.
  > 2) 그 후 주소를 검색하면, 도로명 주소 API의 결과로 json data가 리턴되는데 그 데이터를 documentResponse객체로 변환한 후, 필요한 data들이 저장된다.
 

3. APIs and Libraries
 + Kakao Map API - 추가 기능으로써 판매되는 물건의 위치를 지도에 표시하기 위하여 사용함.
 + Firebase - 어플의 회원가입 및 로그인, 데이터 저장에 사용함. 
 + Alamofire - http request 데이터 통신을 효율적으로 하기 위해 사용함.
 + Floaty - 어플의 기본화면에서 floating button을 구현하기 위해 사용했음.
 + 도로명 주소 API - 사용자가 위치를 검색하면 알맞는 주소를 찾기 위해 사용함.


### Firebase usage













Firestore Storage             |  Firestore data collection          |  Firestore chat collection
:-------------------------:|:-------------------------:|:-------------------------:
<img src="https://user-images.githubusercontent.com/48948578/126030055-4461ca21-cfcf-4db5-b27f-1f3c2eed8426.png"  width="400" height="200" align="left">  |  <img src="https://user-images.githubusercontent.com/48948578/126030059-af797815-69c3-432d-b1c1-aee393c93b82.png"  width="400" height="200" align="left">  | <img src="https://user-images.githubusercontent.com/48948578/126030060-9e72a2d1-cb8f-4535-8b00-92f830362b8b.png"  width="400" height="200" align="left">



+ 사용자 로그인, 회원가입
 > 1) Firebase Auth 기능을 이용하여 로그인 및 회원가입 기능을 구현했음.
+ 매물 저장 
 > 1) Firebase Firestore 기능을 이용하여 매물들의 기본 정보들을 저장했음.
 > 2) Firebase Storage 기능을 이용하여 매물들의 이미지 정보들을 저장했음.
 > 3) 각 매물마다의 매물의 이름으로 Storage에 폴더명이 정해지며, 그 폴더에 사진들이 저장된다.
+ 채팅
 > 1)  Firebase Firestore 기능을 이용하여 사용자들간 채팅 기능을 구현함.
 > 2)  room collection의 채팅을 하는 두 유저의 이름과 구매하려는 제품의 제목으로 document가 생성된다.
 > 3)  각 document에는 제품 제목, 채팅을 하는 상대 그리고 자신의 데이터가 필드로 저장된다.
 > 4)  둘의 채팅 내용은 message라는 collection에 저장된다.
 
 
 

        
        

 

