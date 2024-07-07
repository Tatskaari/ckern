//
// Created by jpoole on 7/6/24.
//

#ifndef CKERN_STRING_H
#define CKERN_STRING_H

namespace String {
    struct String {
        char* str;
        int len;
    };

    String new_string(char* str);
}



#endif //CKERN_STRING_H
