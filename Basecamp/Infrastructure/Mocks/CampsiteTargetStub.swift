//
//  CampsiteTargetStub.swift
//  Basecamp
//
//  Created by Sang hun Lee on 2022/12/19.
//

import Foundation

extension CampsiteTarget {
  func stubData(_ target: CampsiteTarget) -> Data {
    switch self {
    case .getCampsite, .getCampsiteByLocation, .getCampsiteByKeyword, .getCampsiteImage:
      return Data(
        """
        {
        "response": {
        "header": {
        "resultCode": "0000",
        "resultMsg": "OK"
        },
        "body": {
        "items": {
        "item": [
        {
        "contentId": "4",
        "facltNm": "(주)디노담양힐링파크 지점",
        "lineIntro": "담양 힐링파크에서 일상 속 쌓인 스트레스를 풀어보자",
        "intro": "담양군 봉산면 기곡리에 위치한 힐링파크 담양점은 도심과 떨어져 조용히 숲과 자연에서 자유로이 쉴수 있는 힐링파크다. 이곳은 기존 봉산관광농원이라는 이름으로 1998년 농림부 1등급 판정을 받은 시설로 어느 휴양지에서도 느끼지 못했던 색다른 휴식과 즐거움을 동시에 느낄 수 있다.  담양 힐링파크는 대한민국에서 둘째가라면 서러울 정도로 많은 편의시설을 자랑하고 있는데 책을 좋아하는 사람이라면 누구든 이용 가능한 실내 독서실과 저수지낚시터가 있다. 또한 족구, 배드민턴 등 함께 뛰며 게임할 수 있는 족구장이 있으며 배드민턴은 무료 대여중이다. 이밖에도 주말 행복한 하루를 밤하늘을 보며 마감할 수 있는 주말 폭죽서비스가 있다.  이곳은 ‘동물의 왕국’이라고 해도 과언이 아닐 정도로 다양한 동물들과 시간을 보낼 수 있는데 미니동물원에서는 토끼에게 먹이도 주고 만져보며 교감할 수 있다. 그리고 담양곤충체험관이 있어 자연, 곤충과 친해질 수 있으며 이용료는 무료다. 반려동물이 출입이 가능하므로 자신의 반려동물과도 추억을 쌓을 수 있다.",
        "allar": "2500",
        "insrncAt": "Y",
        "trsagntNo": "2016-000004호",
        "bizrno": "171-29-00619",
        "facltDivNm": "민간",
        "mangeDivNm": "직영",
        "mgcDiv": "",
        "manageSttus": "운영",
        "hvofBgnde": "",
        "hvofEnddle": "",
        "featureNm": "물놀이시설 잘 갖추어짐 실내 놀이방 실내 독서방  카라반 2동 글램핑 시설이 좋은편",
        "induty": "일반야영장,카라반,글램핑",
        "lctCl": "호수",
        "doNm": "전라남도",
        "sigunguNm": "담양군",
        "zipcode": "57371",
        "addr1": "전남 담양군 봉산면 탄금길 9-26",
        "addr2": "",
        "mapX": "126.9609528",
        "mapY": "35.2714369",
        "direction": "",
        "tel": "061-383-5155",
        "homepage": "https://healingpark.modoo.at/",
        "resveUrl": "https://healingpark.modoo.at/",
        "resveCl": "전화",
        "manageNmpr": "2",
        "gnrlSiteCo": "2",
        "autoSiteCo": "0",
        "glampSiteCo": "22",
        "caravSiteCo": "2",
        "indvdlCaravSiteCo": "0",
        "sitedStnc": "0",
        "siteMg1Width": "4",
        "siteMg2Width": "6",
        "siteMg3Width": "0",
        "siteMg1Vrticl": "6",
        "siteMg2Vrticl": "7",
        "siteMg3Vrticl": "0",
        "siteMg1Co": "13",
        "siteMg2Co": "11",
        "siteMg3Co": "0",
        "siteBottomCl1": "0",
        "siteBottomCl2": "0",
        "siteBottomCl3": "24",
        "siteBottomCl4": "0",
        "siteBottomCl5": "0",
        "tooltip": "",
        "glampInnerFclty": "침대,에어컨,냉장고,유무선인터넷,난방기구,취사도구,내부화장실",
        "caravInnerFclty": "침대,TV,에어컨,냉장고,유무선인터넷,난방기구,취사도구,내부화장실",
        "prmisnDe": "2016-10-27",
        "operPdCl": "봄,여름,가을,겨울",
        "operDeCl": "평일+주말",
        "trlerAcmpnyAt": "N",
        "caravAcmpnyAt": "N",
        "toiletCo": "4",
        "swrmCo": "3",
        "wtrplCo": "2",
        "brazierCl": "개별",
        "sbrsCl": "전기,무선인터넷,장작판매,온수,트렘폴린,물놀이장,놀이터,산책로,운동시설,마트.편의점",
        "sbrsEtc": "",
        "posblFcltyCl": "운동장,강/물놀이,농어촌체험시설",
        "posblFcltyEtc": "",
        "clturEventAt": "N",
        "clturEvent": "",
        "exprnProgrmAt": "Y",
        "exprnProgrm": "금붕어잡기체험",
        "extshrCo": "20",
        "frprvtWrppCo": "2",
        "frprvtSandCo": "1",
        "fireSensorCo": "24",
        "themaEnvrnCl": "낚시,여름물놀이",
        "eqpmnLendCl": "",
        "animalCmgCl": "불가능",
        "tourEraCl": "",
        "firstImageUrl": "https://gocamping.or.kr/upload/camp/4/thumb/thumb_720_4548WQ5JCsRSkbHrBAaZylrQ.jpg",
        "createdtime": "2022-08-01 23:17:22",
        "modifiedtime": "2022-08-01 23:17:22"
        }
        ]
        },
        "numOfRows": 1,
        "pageNo": 1,
        "totalCount": 3307
        }
        }
        }
        """.utf8
      )
    }
  }
}
