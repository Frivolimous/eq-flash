package utils{
  public class Base64 {
      private static const CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

      public static function encode(data:String):String {
          var out:Array = [];
          var i:int = 0;
          while (i < data.length) {
              var c1:int = data.charCodeAt(i++) & 0xff;
              if (i == data.length) {
                  out.push(CHARS.charAt(c1 >> 2), CHARS.charAt((c1 & 0x3) << 4), "==");
                  break;
              }
              var c2:int = data.charCodeAt(i++);
              if (i == data.length) {
                  out.push(CHARS.charAt(c1 >> 2), CHARS.charAt(((c1 & 0x3) << 4) | ((c2 & 0xf0) >> 4)), CHARS.charAt((c2 & 0xf) << 2), "=");
                  break;
              }
              var c3:int = data.charCodeAt(i++);
              out.push(CHARS.charAt(c1 >> 2), CHARS.charAt(((c1 & 0x3) << 4) | ((c2 & 0xf0) >> 4)), CHARS.charAt(((c2 & 0xf) << 2) | ((c3 & 0xc0) >> 6)), CHARS.charAt(c3 & 0x3f));
          }
          return out.join("");
      }

      public static function decode(data:String):String {
          var out:Array = [];
          var i:int = 0;
          while (i < data.length) {
              var c1:int = CHARS.indexOf(data.charAt(i++));
              var c2:int = CHARS.indexOf(data.charAt(i++));
              var c3:int = CHARS.indexOf(data.charAt(i++));
              var c4:int = CHARS.indexOf(data.charAt(i++));
              var r1:int = (c1 << 2) | (c2 >> 4);
              var r2:int = ((c2 & 0xf) << 4) | (c3 >> 2);
              var r3:int = ((c3 & 0x3) << 6) | c4;
              out.push(String.fromCharCode(r1));
              if (c3 != 64) out.push(String.fromCharCode(r2));
              if (c4 != 64) out.push(String.fromCharCode(r3));
          }
          return out.join("");
      }
  }
}