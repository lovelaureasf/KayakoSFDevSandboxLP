public class RandomString{
    public static String generateRandomString(Integer len) {
        final String chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        
        String randStr = '';
        while (randStr.length() < len) {
           Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
           randStr += chars.substring(idx, idx+1);
        }
        
        String one = randStr.subString(0,126);
        String two = randStr.subString(127,253);
        
        randStr = one+' '+two;
        
        return randStr; 
    }
}