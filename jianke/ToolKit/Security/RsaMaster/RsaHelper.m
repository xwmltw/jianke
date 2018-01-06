//
//  RSA.m
//  My
//
//  Created by ideawu on 15-2-3.
//  Copyright (c) 2015年 ideawu. All rights reserved.
//

#import "RsaHelper.h"
#import <Security/Security.h>
#import <openssl/rsa.h>
#import <UIKit/UIKit.h>
#import "GTMBase64.h"
#import "NetHelper.h"
#import "GTMBase64.h"

@implementation RsaHelper
{
    
}

static NSString* publicStr;
+ (void)setPublicKey:(NSString*)value {
    publicStr = value;
}



static NSData *base64_decode(NSString *str){
	NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
	return data;
}

+ (NSData *)stripPublicKeyHeader:(NSData *)d_key{
	// Skip ASN.1 public key header
	if (d_key == nil) return(nil);
	
	unsigned long len = [d_key length];
	if (!len) return(nil);
	
	unsigned char *c_key = (unsigned char *)[d_key bytes];
	unsigned int  idx    = 0;
	
	if (c_key[idx++] != 0x30) return(nil);
	
	if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
	else idx++;
	
	// PKCS #1 rsaEncryption szOID_RSA_RSA
	static unsigned char seqiod[] =
	{ 0x30,   0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86, 0xf7, 0x0d, 0x01, 0x01,
		0x01, 0x05, 0x00 };
	if (memcmp(&c_key[idx], seqiod, 15)) return(nil);
	
	idx += 15;
	
	if (c_key[idx++] != 0x03) return(nil);
	
	if (c_key[idx] > 0x80) idx += c_key[idx] - 0x80 + 1;
	else idx++;
	
	if (c_key[idx++] != '\0') return(nil);
	
	// Now make a new NSData from this buffer
	return([NSData dataWithBytes:&c_key[idx] length:len - idx]);
}

+ (SecKeyRef)addPublicKey:(NSString *)key{
	NSRange spos = [key rangeOfString:@"-----BEGIN PUBLIC KEY-----"];
	NSRange epos = [key rangeOfString:@"-----END PUBLIC KEY-----"];
	if(spos.location != NSNotFound && epos.location != NSNotFound){
		NSUInteger s = spos.location + spos.length;
		NSUInteger e = epos.location;
		NSRange range = NSMakeRange(s, e-s);
		key = [key substringWithRange:range];
	}
	key = [key stringByReplacingOccurrencesOfString:@"\r" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@"\t" withString:@""];
	key = [key stringByReplacingOccurrencesOfString:@" "  withString:@""];
	
	// This will be base64 encoded, decode it.
	NSData *data = base64_decode(key);
	data = [RsaHelper stripPublicKeyHeader:data];
	if(!data){
		return nil;
	}
	
	NSString *tag = @"what_the_fuck_is_this";
	NSData *d_tag = [NSData dataWithBytes:[tag UTF8String] length:[tag length]];
	
	// Delete any old lingering key with the same tag
	NSMutableDictionary *publicKey = [[NSMutableDictionary alloc] init];
	[publicKey setObject:(__bridge id) kSecClassKey forKey:(__bridge id)kSecClass];
	[publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	[publicKey setObject:d_tag forKey:(__bridge id)kSecAttrApplicationTag];
	SecItemDelete((__bridge CFDictionaryRef)publicKey);
	
	// Add persistent version of the key to system keychain
	[publicKey setObject:data forKey:(__bridge id)kSecValueData];
	[publicKey setObject:(__bridge id) kSecAttrKeyClassPublic forKey:(__bridge id)
	 kSecAttrKeyClass];
	[publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)
	 kSecReturnPersistentRef];
	
	CFTypeRef persistKey = nil;
	OSStatus status = SecItemAdd((__bridge CFDictionaryRef)publicKey, &persistKey);
	if (persistKey != nil){
		CFRelease(persistKey);
	}
	if ((status != noErr) && (status != errSecDuplicateItem)) {
		return nil;
	}

	[publicKey removeObjectForKey:(__bridge id)kSecValueData];
	[publicKey removeObjectForKey:(__bridge id)kSecReturnPersistentRef];
	[publicKey setObject:[NSNumber numberWithBool:YES] forKey:(__bridge id)kSecReturnRef];
	[publicKey setObject:(__bridge id) kSecAttrKeyTypeRSA forKey:(__bridge id)kSecAttrKeyType];
	
	// Now fetch the SecKeyRef version of the key
	SecKeyRef keyRef = nil;
	status = SecItemCopyMatching((__bridge CFDictionaryRef)publicKey, (CFTypeRef *)&keyRef);
	if(status != noErr){
		return nil;
	}
	return keyRef;
}

+ (NSData *)encryptString:(NSString *)str publicKey:(NSString *)pubKey{
	NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
	return [RsaHelper encryptData:data publicKey:pubKey];
}

+ (NSData *)encryptData:(NSData *)data publicKey:(NSString *)pubKey{
    
    pubKey = publicStr;
    
	if(!data || !pubKey){
		return nil;
	}
	SecKeyRef keyRef = [RsaHelper addPublicKey:pubKey];
	if(!keyRef){
		return nil;
	}
	
	const uint8_t *srcbuf = (const uint8_t *)[data bytes];
	size_t srclen = (size_t)data.length;
	
	size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t);
	if(srclen > outlen - 11){
		CFRelease(keyRef);
		return nil;
	}
	void *outbuf = malloc(outlen);
	
	OSStatus status = noErr;
	status = SecKeyEncrypt(keyRef,
						   kSecPaddingPKCS1,
						   srcbuf,
						   srclen,
						   outbuf,
						   &outlen
						   );
	NSData *ret = nil;
	if (status != 0) {
		//NSLog(@"SecKeyEncrypt fail. Error Code: %ld", status);
	}else{
		ret = [NSData dataWithBytes:outbuf length:outlen];
//		ret = base64_encode_data(data);
//        ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
	free(outbuf);
	CFRelease(keyRef);
	return ret;
}

+ (NSData *)decryptData:(NSData *)data publicKey:(NSString *)pubKey{
    
    pubKey = publicStr;
    
    if(!data || !pubKey){
        return nil;
    }
    SecKeyRef keyRef = [RsaHelper addPublicKey:pubKey];
    if(!keyRef){
        return nil;
    }
    
    const uint8_t *srcbuf = (const uint8_t *)[data bytes];
    size_t srclen = (size_t)data.length;
    
    size_t outlen = SecKeyGetBlockSize(keyRef) * sizeof(uint8_t) + 100;

    void *outbuf = malloc(outlen);
    memset(outbuf, 0, outlen);
    
    OSStatus status = noErr;
    status = SecKeyDecrypt(keyRef,
                           kSecPaddingPKCS1,
                           srcbuf,
                           srclen,
                           outbuf,
                           &outlen
                           );
    NSData *ret = nil;
    if (status != 0) {
        //NSLog(@"SecKeyEncrypt fail. Error Code: %ld", status);
    }else{
        ret = [NSData dataWithBytes:outbuf length:outlen];
        //		ret = base64_encode_data(data);
        //        ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    free(outbuf);
    CFRelease(keyRef);
    return ret;
}


// 我们在前面使用openssl生成的public_key.der文件的base64值，用你自己的替换掉这里
#define RSA_KEY_BASE64 @"MIIC5DCCAk2gAwIBAgIJALUk4hrYth9oMA0GCSqGSIb3DQEBBQUAMIGKMQswCQYDVQQGEwJ\
DTjERMA8GA1UECAwIU2hhbmdoYWkxETAPBgNVBAcMCFNoYW5naGFpMQ4wDAYDVQQKDAVCYWl5aTEOMAwGA1UECwwFQmFpeWk\
xEDAOBgNVBAMMB1lvcmsuR3UxIzAhBgkqhkiG9w0BCQEWFGd5cTUzMTk5MjBAZ21haWwuY29tMB4XDTExMTAyNjAyNDUzMlo\
XDTExMTEyNTAyNDUzM1owgYoxCzAJBgNVBAYTAkNOMREwDwYDVQQIDAhTaGFuZ2hhaTERMA8GA1UEBwwIU2hhbmdoYWkxDjA\
MBgNVBAoMBUJhaXlpMQ4wDAYDVQQLDAVCYWl5aTEQMA4GA1UEAwwHWW9yay5HdTEjMCEGCSqGSIb3DQEJARYUZ3lxNTMxOTk\
yMEBnbWFpbC5jb20wgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAK3cKya7oOi8jVMkRGVuNn/SiSS1y5knKLh6t98JukB\
DJZqo30LVPXXL9nHcYXBTulJgzutCOGQxw8ODfAKvXYxmX7QvLwlJRFEzrqzi3eAM2FYtZZeKbgV6PximOwCG6DqaFqd8X0W\
ezP1B2eWKz4kLIuSUKOmt0h3RpIPkatPBAgMBAAGjUDBOMB0GA1UdDgQWBBSIiLi2mehEgi/MwRZOld1mLlhl7TAfBgNVHSM\
EGDAWgBSIiLi2mehEgi/MwRZOld1mLlhl7TAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4GBAB0GUsssoVEDs9vQxk0\
DzNr8pB0idfI+Farl46OZnW5ZwPu3dvSmhQ+yRdh7Ba54JCyvRy0JcWB+fZgO4QorNRbVVbBSuPg6wLzPuasy9TpmaaYaLLK\
Iena6Z60aFWRwhazd6+hIsKTMTExaWjndblEbhAsjdpg6QMsKurs9+izr"

static SecKeyRef _public_key=nil;
+ (SecKeyRef) getPublicKey{ // 从公钥证书文件中获取到公钥的SecKeyRef指针
    if(_public_key == nil){

        NSData *certificateData = [GTMBase64 decodeString:RSA_KEY_BASE64];
        SecCertificateRef myCertificate =  SecCertificateCreateWithData(kCFAllocatorDefault, (__bridge CFDataRef)certificateData);
        SecPolicyRef myPolicy = SecPolicyCreateBasicX509();
        SecTrustRef myTrust;
        OSStatus status = SecTrustCreateWithCertificates(myCertificate,myPolicy,&myTrust);
        SecTrustResultType trustResult;
        if (status == noErr) {
            status = SecTrustEvaluate(myTrust, &trustResult);
        }
        _public_key = SecTrustCopyPublicKey(myTrust);
        CFRelease(myCertificate);
        CFRelease(myPolicy);
        CFRelease(myTrust);
    }
    return _public_key;
}

+ (NSData*) rsaEncryptString:(NSString*) string{
    SecKeyRef key = [self getPublicKey];
    size_t cipherBufferSize = SecKeyGetBlockSize(key);
    uint8_t *cipherBuffer = malloc(cipherBufferSize * sizeof(uint8_t));
    NSData *stringBytes = [string dataUsingEncoding:NSUTF8StringEncoding];
    size_t blockSize = cipherBufferSize - 11;
    size_t blockCount = (size_t)ceil([stringBytes length] / (double)blockSize);
    NSMutableData *encryptedData = [[NSMutableData alloc] init];
    for (int i=0; i<blockCount; i++) {
        size_t bufferSize = MIN(blockSize,[stringBytes length] - i * blockSize);
        NSData *buffer = [stringBytes subdataWithRange:NSMakeRange(i * blockSize, bufferSize)];
        OSStatus status = SecKeyEncrypt(key, kSecPaddingPKCS1, (const uint8_t *)[buffer bytes],
                                        [buffer length], cipherBuffer, &cipherBufferSize);
        if (status == noErr){
            NSData *encryptedBytes = [[NSData alloc] initWithBytes:(const void *)cipherBuffer length:cipherBufferSize];
            [encryptedData appendData:encryptedBytes];
        }else{
            if (cipherBuffer) free(cipherBuffer);
            return nil;
        }
    }
    if (cipherBuffer) free(cipherBuffer);
    //  NSLog(@"Encrypted text (%d bytes): %@", [encryptedData length], [encryptedData description]);
    //  NSLog(@"Encrypted text base64: %@", [Base64 encode:encryptedData]);
    return encryptedData;
}

@end
