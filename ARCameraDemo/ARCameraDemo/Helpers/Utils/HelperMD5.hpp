//
//  HelperMD5.hpp
//  TYMapLocationDemo
//
//  Created by innerpeacer on 15/10/12.
//  Copyright © 2015年 innerpeacer. All rights reserved.
//

#ifndef HelperMD5_hpp
#define HelperMD5_hpp

#include <string>
#include <fstream>

typedef unsigned char bbyte;
typedef unsigned int uint32;

using std::string;
using std::ifstream;

namespace Innerpeacer {
    namespace AppDemo {
        class HelperMD5 {
        public:
            HelperMD5();
            HelperMD5(const void *input, size_t length);
            HelperMD5(const string &str);
            HelperMD5(ifstream &in);
            void update(const void *input, size_t length);
            void update(const string &str);
            void update(ifstream &in);
            const bbyte* digest();
            string toString();
            void reset();
        private:
            void update(const bbyte *input, size_t length);
            void final();
            void transform(const bbyte block[64]);
            void encode(const uint32 *input, bbyte *output, size_t length);
            void decode(const bbyte *input, uint32 *output, size_t length);
            string bytesToHexString(const bbyte *input, size_t length);
            
            /* class uncopyable */
            HelperMD5(const HelperMD5&);
            HelperMD5& operator=(const HelperMD5&);
        private:
            uint32 _state[4];    /* state (ABCD) */
            uint32 _count[2];    /* number of bits, modulo 2^64 (low-order word first) */
            bbyte _buffer[64];    /* input buffer */
            bbyte _digest[16];    /* message digest */
            bool _finished;        /* calculate finished ? */
            
            static const bbyte PADDING[64];    /* padding for calculate */
            static const char HEX[16];
            static const size_t BUFFER_SIZE = 1024;
        };

    }
}


#endif /* HelperMD5_hpp */
