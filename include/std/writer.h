//
// Created by jpoole on 7/7/24.
//

#ifndef CKERN_WRITER_H
#define CKERN_WRITER_H

namespace io {
    class Writer {
    public:
        virtual ~Writer() = default;
        virtual void write(const std::string& data) = 0;
        virtual int close() = 0;
    };
}

#endif //CKERN_WRITER_H
