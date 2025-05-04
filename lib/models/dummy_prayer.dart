import 'prayer.dart';

class DummyPrayer {
  static List<Map<String, dynamic>> get dummyPrayers => [
        {
          'title': '주님의 기도',
          'content': '하늘에 계신 우리 아버지,\n'
              '아버지의 이름이 거룩히 빛나시며\n'
              '아버지의 나라가 오시며\n'
              '아버지의 뜻이 하늘에서와 같이\n'
              '땅에서도 이루어지소서!\n\n'
              '오늘 저희에게 일용할 양식을 주시고\n'
              '저희에게 잘못한 이를 저희가 용서하오니\n'
              '저희 죄를 용서하시고\n'
              '저희를 유혹에 빠지지 않게 하시고\n'
              '악에서 구하소서.\n'
              '아멘.',
          'isFavorite': false,
          'prayType': '주요기도',
          'prayKey': '주님의기도',
          'version': '1.0',
          'isShow': true,
          'registerDate': DateTime.now().toIso8601String(),
          'modifiedDate': DateTime.now().toIso8601String(),
        },
        {
          'title': '성모송',
          'content': '은총이 가득하신 마리아님, 기뻐하소서!\n'
              '주님께서 함께 계시니 여인 중에 복되시며\n'
              '태중의 아들 예수님 또한 복되시나이다.\n\n'
              '천주의 성모 마리아님,\n'
              '이제와 저희 죽을 때에\n'
              '저희 죄인을 위하여 빌어주소서.\n'
              '아멘.',
          'isFavorite': false,
          'prayType': '주요기도',
          'prayKey': '성모송',
          'version': '1.0',
          'isShow': true,
          'registerDate': DateTime.now().toIso8601String(),
          'modifiedDate': DateTime.now().toIso8601String(),
        },
        {
          'title': '사도신경',
          'content': '전능하신 천주 성부\n'
              '천지의 창조주를 저는 믿나이다.\n'
              '그 외아들 우리 주 예수 그리스도님\n'
              '밑줄 부분에서 모두 깊은 절을 한다.\n'
              '성령으로 인하여 동정 마리아께 잉태되어 나시고\n'
              '본시오 빌라도 통치 아래서 고난을 받으시고\n'
              '십자가에 못 박혀 돌아가시고 묻히셨으며\n'
              '저승에 가시어 사흗날에 죽은 이들 가운데서 부활하시고\n'
              '하늘에 올라 전능하신 천주 성부 오른편에 앉으시며\n'
              '그리로부터 산 이와 죽은 이를 심판하러 오시리라 믿나이다.\n'
              '성령을 믿으며\n'
              '거룩하고 보편된 교회와 모든 성인의 통공을 믿으며\n'
              '죄의 용서와 육신의 부활을 믿으며\n'
              '영원한 삶을 믿나이다.\n'
              '아멘.',
          'isFavorite': true,
          'prayType': '주요기도',
          'prayKey': '사도신경',
          'version': '1.0',
          'isShow': true,
          'registerDate': DateTime.now().toIso8601String(),
          'modifiedDate': DateTime.now().toIso8601String(),
        },
        {
          'title': '영광송',
          'content': '밑줄 부분에서 고개를 숙이며\n'
              '영광이 성부와 성자와 성령께\n'
              '처음과 같이\n'
              '이제와 항상 영원히.\n'
              '아멘.',
          'isFavorite': true,
          'prayType': '주요기도',
          'prayKey': '영광송',
          'version': '1.0',
          'isShow': true,
          'registerDate': DateTime.now().toIso8601String(),
          'modifiedDate': DateTime.now().toIso8601String(),
        },
        {
          'title': '환희의 신비',
          'content': '1단 - 마리아께서 예수님을 잉태하심을 묵상합시다. \n'
              '2단 - 마리아께서 엘리사벳을 찾아보심을 묵상합시다. \n'
              '3단 - 마리아께서 예수님을 낳으심을 묵상합시다. \n'
              '4단 - 마리아께서 예수님을 성전에 바치심을 묵상합시다. \n'
              '5단 - 마리아께서 잃으셨던 예수님을 성전에서 찾으심을 묵상합시다.',
          'isFavorite': false,
          'prayType': '묵주기도',
          'prayKey': '환희의신비',
          'version': '1.0',
          'isShow': true,
          'registerDate': DateTime.now().toIso8601String(),
          'modifiedDate': DateTime.now().toIso8601String(),
        },
        {
          'title': '환희의 신비 1단',
          'content': '마리아께서 예수님을 잉태하심을 묵상합시다. \n',
          'isFavorite': false,
          'prayType': '묵주기도',
          'prayKey': '환희의신비1단',
          'version': '1.0',
          'isShow': false,
          'registerDate': DateTime.now().toIso8601String(),
          'modifiedDate': DateTime.now().toIso8601String(),
        },
        {
          'title': '환희의 신비 2단',
          'content': '마리아께서 엘리사벳을 찾아보심을 묵상합시다. \n',
          'isFavorite': false,
          'prayType': '묵주기도',
          'prayKey': '환희의신비2단',
          'version': '1.0',
          'isShow': false,
          'registerDate': DateTime.now().toIso8601String(),
          'modifiedDate': DateTime.now().toIso8601String(),
        },
        {
          'title': '환희의 신비 3단',
          'content': '마리아께서 예수님을 낳으심을 묵상합시다. \n',
          'isFavorite': false,
          'prayType': '묵주기도',
          'prayKey': '환희의신비3단',
          'version': '1.0',
          'isShow': false,
          'registerDate': DateTime.now().toIso8601String(),
          'modifiedDate': DateTime.now().toIso8601String(),
        },
        {
          'title': '환희의 신비 4단',
          'content': '마리아께서 예수님을 성전에 바치심을 묵상합시다. \n',
          'isFavorite': false,
          'prayType': '묵주기도',
          'prayKey': '환희의신비4단',
          'version': '1.0',
          'isShow': false,
          'registerDate': DateTime.now().toIso8601String(),
          'modifiedDate': DateTime.now().toIso8601String(),
        },
        {
          'title': '환희의 신비 5단',
          'content': '마리아께서 잃으셨던 예수님을 성전에서 찾으심을 묵상합시다. \n',
          'isFavorite': false,
          'prayType': '묵주기도',
          'prayKey': '환희의신비5단',
          'version': '1.0',
          'isShow': false,
          'registerDate': DateTime.now().toIso8601String(),
          'modifiedDate': DateTime.now().toIso8601String(),
        },
      ];
}
