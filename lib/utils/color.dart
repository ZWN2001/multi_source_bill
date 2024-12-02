import 'dart:math';

import 'package:flutter/material.dart';

class ColorUtil {
  static ColorFilter createColorFilterWithBrightnessAndContrast(
      {double brightness = 0.0, double contrast = 1.0}) {
    return ColorFilter.matrix(<double>[
      contrast,
      0,
      0,
      0,
      brightness,
      0,
      contrast,
      0,
      0,
      brightness,
      0,
      0,
      contrast,
      0,
      brightness,
      0,
      0,
      0,
      contrast,
      0
    ]);
  }

  static List<Color> colorValue = [
    const Color(0xffff1493),
    const Color(0xffffd9e6),
    const Color(0xfffff0f5),
    const Color(0xffff73b3),
    const Color(0xffe63995),
    const Color(0xffcc0080),
    const Color(0xffff69b4),
    const Color(0xffff0da6),
    const Color(0xffff80bf),
    const Color(0xfff400a1),
    const Color(0xffc71585),
    const Color(0xffe68ab8),
    const Color(0xffff66cc),
    const Color(0xffb85798),
    const Color(0xffffb3e6),
    const Color(0xff8b008b),
    const Color(0xffff00ff),
    const Color(0xff800080),
    const Color(0xffda70d6),
    const Color(0xffee82ee),
    const Color(0xffdda0dd),
    const Color(0xffcca3cc),
    const Color(0xffd8bfd8),
    const Color(0xffe6cfe6),
    const Color(0xffba55d3),
    const Color(0xffe680ff),
    const Color(0xffd94dff),
    const Color(0xff7400a1),
    const Color(0xff9400d3),
    const Color(0xff9932cc),
    const Color(0xff4b0080),
    const Color(0xff8a2be2),
    const Color(0xff8b00ff),
    const Color(0xff5000b8),
    const Color(0xffb8a1cf),
    const Color(0xff6633cc),
    const Color(0xff8674a1),
    const Color(0xff9370db),
    const Color(0xff0000cd),
    const Color(0xff00008b),
    const Color(0xff0000ff),
    const Color(0xff000080),
    const Color(0xff6640ff),
    const Color(0xffb399ff),
    const Color(0xff0d33ff),
    const Color(0xff0033ff),
    const Color(0xff191970),
    const Color(0xff5c50e6),
    const Color(0xff7b68ee),
    const Color(0xff6a5acd),
    const Color(0xff483d8b),
    const Color(0xff002fa7),
    const Color(0xffc0c0c0),
    const Color(0xff696969),
    const Color(0xffd3d3d3),
    const Color(0xffffffff),
    const Color(0xff808080),
    const Color(0xfff5f5f5),
    const Color(0xff404040),
    const Color(0xffdcdcdc),
    const Color(0xffa9a9a9),
    const Color(0xff003399),
    const Color(0xff082567),
    const Color(0xff24367d),
    const Color(0xff2a52be),
    const Color(0xffccccff),
    const Color(0xff4169e1),
    const Color(0xff0047ab),
    const Color(0xffe6e6fa),
    const Color(0xfff8f8ff),
    const Color(0xff4d80e6),
    const Color(0xff007fff),
    const Color(0xff004d99),
    const Color(0xff003366),
    const Color(0xff6495ed),
    const Color(0xff1e90ff),
    const Color(0xff5e86c1),
    const Color(0xff00477d),
    const Color(0xff5686bf),
    const Color(0xff003153),
    const Color(0xffb0c4de),
    const Color(0xff4682b4),
    const Color(0xff778899),
    const Color(0xff708090),
    const Color(0xfff0f8ff),
    const Color(0xff87cefa),
    const Color(0xff00bfff),
    const Color(0xff87ceeb),
    const Color(0xff4798b3),
    const Color(0xff7ab8cc),
    const Color(0xffadd8e6),
    const Color(0xff006374),
    const Color(0xff00808c),
    const Color(0xffb0e0e6),
    const Color(0xffafdfe4),
    const Color(0xff5f9ea0),
    const Color(0xffe0ffff),
    const Color(0xff00ced1),
    const Color(0xffafeeee),
    const Color(0xff2f4f4f),
    const Color(0xff008b8b),
    const Color(0xff00ffff),
    const Color(0xff008080),
    const Color(0xff48d1cc),
    const Color(0xff20b2aa),
    const Color(0xff30d5c8),
    const Color(0xff66ffe6),
    const Color(0xff33e6cc),
    const Color(0xff7fffd4),
    const Color(0xff66cdaa),
    const Color(0xff0dbf8c),
    const Color(0xfff5fffa),
    const Color(0xffa6ffcc),
    const Color(0xff00fa9a),
    const Color(0xff00a15c),
    const Color(0xff3cb371),
    const Color(0xff2e8b57),
    const Color(0xff50c878),
    const Color(0xff00ff80),
    const Color(0xff4de680),
    const Color(0xff127436),
    const Color(0xff73e68c),
    const Color(0xfff0fff0),
    const Color(0xff8fbc8f),
    const Color(0xff90ee90),
    const Color(0xff98fb98),
    const Color(0xff16982b),
    const Color(0xff22c32e),
    const Color(0xff36bf36),
    const Color(0xff228b22),
    const Color(0xff32cd32),
    const Color(0xff66ff59),
    const Color(0xff006400),
    const Color(0xff008000),
    const Color(0xff00ff00),
    const Color(0xff66ff00),
    const Color(0xff99ff4d),
    const Color(0xff7cfc00),
    const Color(0xff7fff00),
    const Color(0xff73b839),
    const Color(0xff99e64d),
    const Color(0xff8ce600),
    const Color(0xffadff2f),
    const Color(0xff556b2f),
    const Color(0xff9acd32),
    const Color(0xff6b8e23),
    const Color(0xffccff00),
    const Color(0xff697723),
    const Color(0xfffffff0),
    const Color(0xfff5f5dc),
    const Color(0xffffffe0),
    const Color(0xfffafad2),
    const Color(0xfffffdd0),
    const Color(0xffffff99),
    const Color(0xffcccc4d),
    const Color(0xffffff4d),
    const Color(0xfffffacd),
    const Color(0xffeee8aa),
    const Color(0xff808000),
    const Color(0xffffff00),
    const Color(0xffbdb76b),
    const Color(0xfff0e68c),
    const Color(0xffe6d933),
    const Color(0xfffff8dc),
    const Color(0xffffd700),
    const Color(0xfffffaf0),
    const Color(0xffe6c35c),
    const Color(0xfffdf5e6),
    const Color(0xffe6b800),
    const Color(0xffffcc00),
    const Color(0xfff5deb3),
    const Color(0xffffe5b4),
    const Color(0xffffefd5),
    const Color(0xffffe4b5),
    const Color(0xff4d3900),
    const Color(0xffdaa520),
    const Color(0xffffbf00),
    const Color(0xffffebcd),
    const Color(0xffccb38c),
    const Color(0xffb8860b),
    const Color(0xffffdead),
    const Color(0xfffaebd7),
    const Color(0xffd2b48c),
    const Color(0xffffe4c4),
    const Color(0xffdeb887),
    const Color(0xff996b1f),
    const Color(0xfffaf0e6),
    const Color(0xffffa500),
    const Color(0xffffdab9),
    const Color(0xffff9900),
    const Color(0xffffb366),
    const Color(0xffcd853f),
    const Color(0xff704214),
    const Color(0xfffff5ee),
    const Color(0xffb87333),
    const Color(0xffcc7722),
    const Color(0xfff28500),
    const Color(0xffff8c00),
    const Color(0xfff4a460),
    const Color(0xffa16b47),
    const Color(0xff625b57),
    const Color(0xffe69966),
    const Color(0xff8b4513),
    const Color(0xffd2691e),
    const Color(0xffff7300),
    const Color(0xffff8033),
    const Color(0xffcc5500),
    const Color(0xff4d1f00),
    const Color(0xffa0522d),
    const Color(0xffffa07a),
    const Color(0xffff4d00),
    const Color(0xffff7f50),
    const Color(0xffff4500),
    const Color(0xffe9967a),
    const Color(0xffff8c69),
    const Color(0xffff2400),
    const Color(0xffff0000),
    const Color(0xffe60000),
    const Color(0xff8b0000),
    const Color(0xffff6347),
    const Color(0xffb52524), //sdu_red
    const Color(0xff800000),
    const Color(0xffff4d40),
    const Color(0xffb22222),
    const Color(0xfffa8072),
    const Color(0xffa52a2a),
    const Color(0xffe32636),
    const Color(0xffffe4e1),
    const Color(0xffcd5c5c),
    const Color(0xffdc143c),
    const Color(0xfff08080),
    const Color(0xffbc8f8f),
    const Color(0xffe6c3c3),
    const Color(0xfffffafa),
    const Color(0xff990036),
    const Color(0xffe6005c),
    const Color(0xffde3163),
    const Color(0xffff8099),
    const Color(0xffffb6c1),
    const Color(0xffffb3bf),
    const Color(0xffffc0cb),
    const Color(0xffff007f),
    const Color(0xffdb7093),
    const Color(0xff000000)
  ];

  static List<String> colorName = [
    '深粉红',
    '浅粉红',
    '薰衣草紫红',
    '尖晶石红',
    '山茶红',
    '红宝石色',
    '暖粉红',
    '洋玫瑰红',
    '浅珊瑚红',
    '品红',
    '中青紫红',
    '火鹤红',
    '浅玫瑰红',
    '陈玫红',
    '浅珍珠红',
    '暗洋红',
    '洋红',
    '紫色',
    '兰紫',
    '亮紫',
    '梅红色',
    '铁线莲紫',
    '蓟紫',
    '淡紫丁香色',
    '中兰紫',
    '优品紫红',
    '锦葵紫',
    '三色堇紫',
    '暗紫',
    '暗兰紫',
    '靛色',
    '蓝紫',
    '紫罗兰色',
    '缬草紫',
    '矿紫',
    '紫水晶色',
    '浅灰紫红',
    '中紫红',
    '中蓝',
    '暗蓝',
    '蓝色',
    '藏青',
    '木槿紫',
    '紫丁香色',
    '天青石蓝',
    '极浓海蓝',
    '午夜蓝',
    '紫藤色',
    '中岩蓝',
    '岩蓝',
    '暗岩蓝',
    '国际奇连蓝',
    '银色',
    '昏灰',
    '亮灰色',
    '白色',
    '灰色',
    '白烟色',
    '暗灰色',
    '庚斯博罗灰',
    '暗灰',
    '暗婴儿粉蓝',
    '蓝宝石色',
    '暗矿蓝',
    '蔚蓝',
    '长春花色',
    '品蓝',
    '钴蓝',
    '薰衣草紫',
    '幽灵白',
    '鼠尾草蓝',
    '湛蓝',
    '矿蓝',
    '午夜蓝',
    '矢车菊蓝',
    '道奇蓝',
    '灰丁宁蓝',
    '水手蓝',
    '韦奇伍德瓷蓝',
    '普鲁士蓝',
    '亮钢蓝',
    '钢青色',
    '亮岩灰',
    '岩灰',
    '爱丽丝蓝',
    '亮天蓝',
    '深天蓝',
    '天蓝',
    '萨克斯蓝',
    '灰蓝',
    '亮蓝',
    '浓蓝',
    '孔雀蓝',
    '婴儿粉蓝',
    '水色',
    '军服蓝',
    '亮青',
    '暗绿松石色',
    '灰绿松石色',
    '暗岩灰',
    '暗青',
    '青色',
    '凫绿',
    '中绿松石色',
    '亮海绿',
    '松石绿',
    '水蓝',
    '绿松石蓝',
    '碧蓝',
    '中碧蓝色',
    '青蓝',
    '薄荷奶油色',
    '苍色',
    '中春绿色',
    '孔雀绿',
    '中海绿',
    '海绿',
    '碧绿',
    '春绿',
    '绿松石绿',
    '铬绿',
    '青瓷绿',
    '蜜瓜绿',
    '暗海绿',
    '亮绿',
    '灰绿',
    '薄荷绿',
    '孔雀石绿',
    '常春藤绿',
    '森林绿',
    '柠檬绿',
    '钴绿',
    '暗绿',
    '绿色',
    '鲜绿',
    '明绿',
    '嫩绿',
    '草坪绿',
    '查特酒绿',
    '叶绿',
    '草绿',
    '苹果绿',
    '绿黄',
    '暗橄榄绿',
    '黄绿',
    '橄榄军服绿',
    '亮柠檬绿',
    '苔藓绿',
    '象牙色',
    '米黄',
    '亮黄',
    '亮金菊黄',
    '奶油色',
    '香槟黄',
    '芥末黄',
    '月黄',
    '柠檬绸色',
    '灰金菊色',
    '橄榄色',
    '黄色',
    '暗卡其色',
    '亮卡其色',
    '含羞草黄',
    '玉米丝色',
    '金色',
    '花卉白',
    '茉莉黄',
    '旧蕾丝色',
    '铬黄',
    '橙黄色',
    '小麦色',
    '桃色',
    '蕃木瓜色',
    '鹿皮鞋色',
    '咖啡色',
    '金菊色',
    '琥珀色',
    '杏仁白',
    '灰土色',
    '暗金菊色',
    '那瓦霍白',
    '古董白',
    '日晒色',
    '陶坯黄',
    '硬木色',
    '卡其色',
    '亚麻色',
    '橙色',
    '粉扑桃色',
    '万寿菊黄',
    '蜜橙',
    '秘鲁色',
    '乌贼墨色',
    '海贝色',
    '古铜色',
    '赭色',
    '橘色',
    '暗橙',
    '沙褐',
    '驼色',
    '铁灰色',
    '杏黄',
    '鞍褐',
    '巧克力色',
    '阳橙',
    '热带橙',
    '燃橙色',
    '椰褐',
    '赭黄',
    '亮鲑红',
    '朱红',
    '珊瑚红',
    '橙红',
    '暗鲑红',
    '鲑肉色',
    '腥红',
    '红色',
    '鲜红',
    '暗红',
    '蕃茄红',
    '山大红',
    '栗色',
    '柿子橙',
    '耐火砖红',
    '鲑红',
    '褐色',
    '茜红',
    '雾玫瑰色',
    '印度红',
    '绯红',
    '亮珊瑚色',
    '玫瑰褐',
    '沙棕',
    '雪色',
    '枢机红',
    '胭脂红',
    '樱桃红',
    '浅鲑红',
    '亮粉红',
    '壳黄红',
    '粉红',
    '玫瑰红',
    '灰紫红',
    '黑色'
  ];

  static String nameColor(Color color) {
    int min = 765;
    int pos = 0;
    int red = color.red;
    int green = color.green;
    int blue = color.blue;
    for (int i = 0; i < colorValue.length; i++) {
      Color c = colorValue[i];
      if ((c.red - red).abs() +
              (c.green - green).abs() +
              (c.blue - blue).abs() <
          min) {
        min = (c.red - red).abs() +
            (c.green - green).abs() +
            (c.blue - blue).abs();
        pos = i;
      }
    }
    return colorName[pos];
  }

  static Color getReadableColor(Color color) {
    return ThemeData.estimateBrightnessForColor(color) == Brightness.light
        ? Colors.black
        : Colors.white;
  }

  static Color invertColor(Color color) {
    Color res = const Color(0xff000000);
    int red = color.red;
    int green = color.green;
    int blue = color.blue;

    res = res.withRed(255 - red).withGreen(255 - green).withBlue(255 - blue);

    return res;
  }

  static Color darkenColor(Color color) {
    Color res = const Color(0xff000000);
    int red = color.red;
    int green = color.green;
    int blue = color.blue;

    res = res
        .withRed(red - 50 < 0 ? 0 : red - 50)
        .withGreen(green - 50 < 0 ? 0 : green - 50)
        .withBlue(blue - 50 < 0 ? 0 : blue - 50);

    return res;
  }

  static Color lightenColor(Color color) {
    Color res = const Color(0xff000000);
    int red = color.red;
    int green = color.green;
    int blue = color.blue;

    res = res
        .withRed(red + 50 > 255 ? 255 : red + 50)
        .withGreen(green + 50 > 255 ? 255 : green + 50)
        .withBlue(blue + 50 > 255 ? 255 : blue + 50);

    return res;
  }

  static HSL rgb2hsl(RGB rgb) {
    if (rgb['r'] == null ||
        rgb['r']! < 0 ||
        rgb['r']! > 255 ||
        rgb['g'] == null ||
        rgb['g']! < 0 ||
        rgb['g']! > 255 ||
        rgb['b'] == null ||
        rgb['b']! < 0 ||
        rgb['b']! > 255) {
      throw const FormatException('RGB格式错误');
    }
    int r = rgb['r']!;
    int g = rgb['g']!;
    int b = rgb['b']!;
    double r1 = r / 255;
    double g1 = g / 255;
    double b1 = b / 255;
    double cMax = max(max(r1, g1), b1);
    double cMin = min(min(r1, g1), b1);
    double delta = cMax - cMin;

    double h, l, s;
    if (delta == 0) {
      h = 0;
    } else if (cMax == r1) {
      h = 60 * ((g1 - b1) / delta % 6);
    } else if (cMax == g1) {
      h = 60 * ((b1 - r1) / delta + 2);
    } else if (cMax == b1) {
      h = 60 * ((r1 - g1) / delta + 4);
    } else {
      throw Exception('RGB转HSL中，H错误');
    }

    l = (cMax + cMin) / 2;

    if (delta == 0) {
      s = 0;
    } else {
      s = delta / (1 - (2 * l - 1).abs());
    }

    return {'h': h, 's': s, 'l': l};
  }

  static RGB hsl2rgb(HSL hsl) {
    if (hsl['h'] == null ||
        hsl['h']! < 0 ||
        hsl['h']! >= 360 ||
        hsl['s'] == null ||
        hsl['s']! < 0 ||
        hsl['s']! > 1 ||
        hsl['l'] == null ||
        hsl['l']! < 0 ||
        hsl['l']! > 1) {
      throw const FormatException('HSL格式错误');
    }
    double h = hsl['h']!;
    double s = hsl['s']!;
    double l = hsl['l']!;

    double c = (1 - (2 * l - 1).abs()) * s;
    double x = c * (1 - ((h / 60 % 2 - 1).abs()));
    double m = l - c / 2;

    double r1 = 0, g1 = 0, b1 = 0;
    if (h >= 0 && h < 60) {
      r1 = c;
      g1 = x;
      b1 = 0;
    } else if (h >= 60 && h < 120) {
      r1 = x;
      g1 = c;
      b1 = 0;
    } else if (h >= 120 && h < 180) {
      r1 = 0;
      g1 = c;
      b1 = x;
    } else if (h >= 180 && h < 240) {
      r1 = 0;
      g1 = x;
      b1 = c;
    } else if (h >= 240 && h < 300) {
      r1 = x;
      g1 = 0;
      b1 = c;
    } else if (h >= 300 && h < 360) {
      r1 = c;
      g1 = 0;
      b1 = x;
    }

    return {
      'r': ((r1 + m) * 255).round(),
      'g': ((g1 + m) * 255).round(),
      'b': ((b1 + m) * 255).round()
    };
  }

  static Color parse(String code) {
    if (code.length != 6 && code.length != 8) {
      throw const FormatException('RGB格式错误');
    }
    if (code.length == 6) {
      code = 'FF' + code;
    }
    return Color(int.parse(code, radix: 16));
  }

  static String toARGB(Color color) {
    return color.value.toRadixString(16).toUpperCase();
  }


}

typedef RGB = Map<String, int>;
typedef HSL = Map<String, double>;
