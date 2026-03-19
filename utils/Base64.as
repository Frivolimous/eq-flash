package utils{
    import flash.utils.ByteArray;

    public class Base64 {
        private static const CHARS:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
        public static const ALPHANUMERIC:String = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

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

        public static function encodeByte(bytes:ByteArray):String {
            var result:String = "";
            bytes.position = 0;

            while (bytes.bytesAvailable > 0) {
                // Track how many actual bytes we read in this chunk
                var available:int = bytes.bytesAvailable;
                
                var b1:int = bytes.readUnsignedByte();
                var b2:int = (available > 1) ? bytes.readUnsignedByte() : 0;
                var b3:int = (available > 2) ? bytes.readUnsignedByte() : 0;

                var triplet:int = (b1 << 16) | (b2 << 8) | b3;

                var c1:int = (triplet >> 18) & 0x3F;
                var c2:int = (triplet >> 12) & 0x3F;
                var c3:int = (triplet >> 6) & 0x3F;
                var c4:int = triplet & 0x3F;

                result += CHARS.charAt(c1) + CHARS.charAt(c2);
                
                // Fix: Use the 'available' count from BEFORE reading to determine padding
                result += (available > 1) ? CHARS.charAt(c3) : "=";
                result += (available > 2) ? CHARS.charAt(c4) : "=";
            }

            return result;
        }

        public static function decodeByte(str:String):ByteArray {
            var bytes:ByteArray = new ByteArray();
            
            // 1. Remove whitespace, but DON'T remove '=' yet as it helps identify the end
            str = str.replace(/\s/g, "");

            var i:int = 0;
            while (i < str.length) {
                var s1:String = str.charAt(i++);
                var s2:String = str.charAt(i++);
                var s3:String = str.charAt(i++);
                var s4:String = str.charAt(i++);

                var c1:int = CHARS.indexOf(s1);
                var c2:int = CHARS.indexOf(s2);
                var c3:int = CHARS.indexOf(s3);
                var c4:int = CHARS.indexOf(s4);

                // Shift bits into a 24-bit triplet
                // We use 0 if the character is padding ('=') or not found (-1)
                var v1:int = (c1 != -1) ? c1 : 0;
                var v2:int = (c2 != -1) ? c2 : 0;
                var v3:int = (c3 != -1) ? c3 : 0;
                var v4:int = (c4 != -1) ? c4 : 0;

                var triplet:int = (v1 << 18) | (v2 << 12) | (v3 << 6) | v4;

                // Always write the first byte
                bytes.writeByte((triplet >> 16) & 0xFF);

                // Only write the 2nd and 3rd bytes if they weren't padding
                if (s3 != "=" && c3 != -1) bytes.writeByte((triplet >> 8) & 0xFF);
                if (s4 != "=" && c4 != -1) bytes.writeByte(triplet & 0xFF);
            }

            bytes.position = 0;
            return bytes;
        }

        public static function compressSave(str:String):String {
            // 2. Convert to bytes
            var bytes:ByteArray = new ByteArray();
            bytes.writeUTFBytes(str);

            // 3. Compress (zlib)
            bytes.compress();

            // 4. Base64 encode
            var result:String = encode62(bytes);

            return "["+result+"]";
        }

        public static function decompressSave(str:String):String {
            str=str.substr(1,str.length-2);
            trace(str);
            // 2. Base64 decode
            var bytes:ByteArray = decode62(str);
            // 3. Decompress
            bytes.uncompress();

            // 4. Read JSON
            return bytes.readUTFBytes(bytes.length);
        }

        public static function encode62(bytes:ByteArray):String {
            // 2. Convert to Base62 (Alphanumeric)
            var result:String = "";
            var count:int = bytes.length;
            
            // We process the ByteArray as a large number (BigInt style)
            // or chunk it if it's very large. For manual copy-paste, 
            // chunks of 2-4 bytes are usually best for math stability.
            bytes.position = 0;
            while (bytes.bytesAvailable > 0) {
                var chunk:uint = 0;
                var len:int = Math.min(3, bytes.bytesAvailable);
                
                for (var i:int = 0; i < len; i++) {
                    chunk = (chunk << 8) | bytes.readUnsignedByte();
                }
                
                // Convert this chunk to Base62
                var encodedChunk:String = "";
                while (chunk > 0) {
                    encodedChunk = ALPHANUMERIC.charAt(chunk % 62) + encodedChunk;
                    chunk = Math.floor(chunk / 62);
                }
                
                // Ensure fixed-width padding for the chunk so decoding works
                while (encodedChunk.length < (len == 3 ? 5 : (len == 2 ? 3 : 2))) {
                    encodedChunk = "0" + encodedChunk;
                }
                result += encodedChunk;
            }
            
            return result;
        }

        public static function decode62(str:String):ByteArray {
            var bytes:ByteArray = new ByteArray();
            var i:int = 0;

            // We process the string in the same fixed-width chunks as the encoder
            // 3 bytes -> 5 chars, 2 bytes -> 3 chars, 1 byte -> 2 chars
            while (i < str.length) {
                // Determine how many characters to pull based on remaining string length
                // In a real implementation, you might want to add a small header 
                // to the string to tell the decoder exactly how many bytes are left.
                var chunkStr:String;
                var expectedBytes:int;

                if (i + 5 <= str.length) {
                    chunkStr = str.substr(i, 5);
                    expectedBytes = 3;
                    i += 5;
                } else if (i + 3 <= str.length) {
                    chunkStr = str.substr(i, 3);
                    expectedBytes = 2;
                    i += 3;
                } else {
                    chunkStr = str.substr(i, 2);
                    expectedBytes = 1;
                    i += 2;
                }

                // Convert Base62 chunk string back to a number
                var chunkVal:uint = 0;
                for (var j:int = 0; j < chunkStr.length; j++) {
                    var charIdx:int = ALPHANUMERIC.indexOf(chunkStr.charAt(j));
                    chunkVal = (chunkVal * 62) + charIdx;
                }

                // Write the bytes back (Big Endian order)
                if (expectedBytes >= 3) bytes.writeByte((chunkVal >> 16) & 0xFF);
                if (expectedBytes >= 2) bytes.writeByte((chunkVal >> 8) & 0xFF);
                if (expectedBytes >= 1) bytes.writeByte(chunkVal & 0xFF);
            }

            // IMPORTANT: Move position to 0 before uncompressing
            bytes.position = 0;
            
            return bytes;
        }
    }
}
