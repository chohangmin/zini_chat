# zini_chat

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

20240826 - 채팅창 나가는 기능 만들기. 그룹채팅 만들기 

시발 로그인할때 계속 데이터베이스에 데이터 적재하는 시간과 화면이 바뀌는 시간이 겹쳐서 에러가 발생한다 슈발
지금 splashScreen을 이용하려 하고 있는데 잘 안됨. 


1. 채팅창 최신순 정렬
2. 친구창 친구도 정렬



2. 없애도 되는 데이터 ex image => null 가능
3. 일단 약간 꾸민 다음에 다음에 할 것들 하나씩 추가
4. 세팅부분 stream으로 변경

기본이미지 여부?!

 if (pickedImageFile != null) { 이건 뭐지?

 그리고 screen은 다 읽어봤으니 widget을 다 읽어보고 
 그 다음에 전체적인 틀 다시 정리하고, 몇몇 수정 사항 정리하고 
 다시 firebase 데이터 구조 정리하면 일단 이 프로젝트는 끝날듯?