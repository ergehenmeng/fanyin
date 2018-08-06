package com.fanyin.utils;

import com.fanyin.enums.ErrorCodeEnum;
import com.fanyin.exception.ParameterException;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * @author 王艳兵
 * @date 2018/8/6 15:17
 */
public class Sha256Util {

    private static final Logger LOGGER = LoggerFactory.getLogger(Sha256Util.class);

    /**
     * sha256加密
     * @param message 待加密字符串
     * @return 加密后的字符串
     */
    public static String sha256(String message){
        try {
            MessageDigest instance = MessageDigest.getInstance("SHA-256");
            instance.update(message.getBytes());
            byte[] digest = instance.digest();
            return ByteUtil.byteArrayToHex(digest);
        } catch (NoSuchAlgorithmException e) {
            LOGGER.error("sha256加密异常",e);
            throw new ParameterException(ErrorCodeEnum.SHA_256_ERROR);
        }
    }

    /**
     * sha256Hmac加密 秘钥是字符串本身
     * @param message 带加密字符串
     * @return 加密后的字符串
     */
    public static String sha256Hmac(String message){
        try {
            Mac instance = Mac.getInstance("HmacSHA256");
            SecretKey secretKey = new SecretKeySpec(message.getBytes(),"HmacSHA256");
            instance.init(secretKey);
            byte[] bytes = instance.doFinal(message.getBytes());
            return ByteUtil.byteArrayToHex(bytes);
        } catch (Exception e) {
            LOGGER.error("HmacSHA256加密异常",e);
            throw new ParameterException(ErrorCodeEnum.SHA_256_ERROR);
        }
    }
}
