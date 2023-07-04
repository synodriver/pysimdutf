# cython: language_level=3
# cython: cdivision=True
# distutils: language=c++
from libc.stdint cimport uint8_t, uint16_t, uint32_t
from simdutf cimport simdutf

cpdef inline str version():
    return (<bytes> simdutf.SIMDUTF_VERSION).decode()

UTF8 = simdutf.UTF8
UTF16_LE = simdutf.UTF16_LE  # BOM 0xff 0xfe
UTF16_BE = simdutf.UTF16_BE  # BOM 0xfe 0xff
UTF32_LE = simdutf.UTF32_LE  # BOM 0xff 0xfe 0x00 0x00
UTF32_BE = simdutf.UTF32_BE  # BOM 0x00 0x00 0xfe 0xff
Latin1 = simdutf.Latin1
unspecified = simdutf.unspecified


SUCCESS        = simdutf.SUCCESS
HEADER_BITS    = simdutf.HEADER_BITS
TOO_SHORT      = simdutf.TOO_SHORT
TOO_LONG       = simdutf.TOO_LONG
OVERLONG       = simdutf.OVERLONG
TOO_LARGE      = simdutf.TOO_LARGE
SURROGATE      = simdutf.SURROGATE
OTHER          = simdutf.OTHER


cpdef inline int  autodetect_encoding(const uint8_t[::1] data):
    with nogil:
        return simdutf.autodetect_encoding(<const char *>&data[0], <size_t>data.shape[0])

cpdef inline int detect_encodings(const uint8_t[::1] data):
    with nogil:
        return simdutf.detect_encodings(<const char *> &data[0], <size_t> data.shape[0])

cpdef inline bint validate_utf8(const uint8_t[::1] data):
    with nogil:
        return simdutf.validate_utf8(<const char *> &data[0], <size_t> data.shape[0])


cpdef inline tuple validate_utf8_with_errors(const uint8_t[::1] data):
    cdef simdutf.result r
    with nogil:
        r = simdutf.validate_utf8_with_errors(<const char *> &data[0], <size_t> data.shape[0])
    return r.error, r.count

cpdef inline bint validate_ascii(const uint8_t[::1] data):
    with nogil:
        return simdutf.validate_ascii(<const char *> &data[0], <size_t> data.shape[0])

cpdef inline tuple validate_ascii_with_errors(const uint8_t[::1] data):
    cdef simdutf.result r
    with nogil:
        r = simdutf.validate_ascii_with_errors(<const char *> &data[0], <size_t> data.shape[0])
    return r.error, r.count

cpdef inline bint validate_utf16(const uint8_t[::1] data):
    with nogil:
        return simdutf.validate_utf16(<const simdutf.char16_t *> &data[0], <size_t> data.shape[0] / 2)

cpdef inline bint validate_utf16le(const uint8_t[::1] data):
    with nogil:
        return simdutf.validate_utf16le(<const simdutf.char16_t *> &data[0], <size_t> data.shape[0] / 2)

cpdef inline bint validate_utf16be(const uint8_t[::1] data):
    with nogil:
        return simdutf.validate_utf16be(<const simdutf.char16_t *> &data[0], <size_t> data.shape[0] / 2)

cpdef inline tuple validate_utf16_with_errors(const uint8_t[::1] data):
    cdef simdutf.result r
    with nogil:
        r = simdutf.validate_utf16_with_errors(<const simdutf.char16_t *> &data[0], <size_t> data.shape[0] / 2)
    return r.error, r.count

cpdef inline tuple validate_utf16le_with_errors(const uint8_t[::1] data):
    cdef simdutf.result r
    with nogil:
        r = simdutf.validate_utf16le_with_errors(<const simdutf.char16_t *> &data[0], <size_t> data.shape[0] / 2)
    return r.error, r.count

cpdef inline tuple validate_utf16be_with_errors(const uint8_t[::1] data):
    cdef simdutf.result r
    with nogil:
        r = simdutf.validate_utf16be_with_errors(<const simdutf.char16_t *> &data[0], <size_t> data.shape[0] / 2)
    return r.error, r.count


cpdef inline bint validate_utf32(const uint8_t[::1] data):
    with nogil:
        return simdutf.validate_utf32(<const simdutf.char32_t *> &data[0], <size_t> data.shape[0] / 4)

cpdef inline tuple validate_utf32_with_errors(const uint8_t[::1] data):
    cdef simdutf.result r
    with nogil:
        r = simdutf.validate_utf32_with_errors(<const simdutf.char32_t *> &data[0], <size_t> data.shape[0] / 4)
    return r.error, r.count
# cpdef inline size_t convert_latin1_to_utf8(const uint8_t[::1] data, uint8_t[::1] buffer):
#     with nogil:
#         return simdutf.convert_latin1_to_utf8(<const char *> &data[0], <size_t> data.shape[0], <char*>&buffer[0])

cpdef inline size_t convert_latin1_to_utf16le(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_latin1_to_utf16le(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])

cpdef inline size_t convert_latin1_to_utf16be(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_latin1_to_utf16be(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])

# cpdef inline size_t convert_latin1_to_utf32(const uint8_t[::1] data, uint8_t[::1] buffer):
#     with nogil:
#         return simdutf.convert_latin1_to_utf32(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char32_t*>&buffer[0])


# cpdef inline size_t convert_utf8_to_latin1(const uint8_t[::1] data, uint8_t[::1] buffer):
#     with nogil:
#         return simdutf.convert_utf8_to_latin1(<const char *> &data[0], <size_t> data.shape[0], <char*>&buffer[0])

cpdef inline size_t convert_utf8_to_utf16(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_utf8_to_utf16(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])

cpdef inline size_t convert_utf8_to_utf16le(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_utf8_to_utf16le(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])

cpdef inline size_t convert_utf8_to_utf16be(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_utf8_to_utf16be(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])

# cpdef inline size_t convert_utf8_to_latin1_with_errors(const uint8_t[::1] data, uint8_t[::1] buffer):
#     cdef simdutf.result r
#     with nogil:
#         r = simdutf.convert_utf8_to_latin1_with_errors(<const char *> &data[0], <size_t> data.shape[0], <char*>&buffer[0])
#     return r.error, r.count


cpdef inline tuple convert_utf8_to_utf16_with_errors(const uint8_t[::1] data, uint8_t[::1] buffer):
    cdef simdutf.result r
    with nogil:
        r = simdutf.convert_utf8_to_utf16_with_errors(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])
    return r.error, r.count

cpdef inline tuple convert_utf8_to_utf16le_with_errors(const uint8_t[::1] data, uint8_t[::1] buffer):
    cdef simdutf.result r
    with nogil:
        r = simdutf.convert_utf8_to_utf16le_with_errors(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])
    return r.error, r.count


cpdef inline tuple convert_utf8_to_utf16be_with_errors(const uint8_t[::1] data, uint8_t[::1] buffer):
    cdef simdutf.result r
    with nogil:
        r = simdutf.convert_utf8_to_utf16be_with_errors(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])
    return r.error, r.count

cpdef inline size_t convert_utf8_to_utf32(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_utf8_to_utf32(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char32_t*>&buffer[0])

cpdef inline tuple convert_utf8_to_utf32_with_errors(const uint8_t[::1] data, uint8_t[::1] buffer):
    cdef simdutf.result r
    with nogil:
        r = simdutf.convert_utf8_to_utf32_with_errors(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char32_t*>&buffer[0])
    return r.error, r.count

# cpdef inline size_t convert_valid_utf8_to_latin1(const uint8_t[::1] data, uint8_t[::1] buffer):
#     with nogil:
#         return simdutf.convert_valid_utf8_to_latin1(<const char *> &data[0], <size_t> data.shape[0], <char*>&buffer[0])

cpdef inline size_t convert_valid_utf8_to_utf16(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_valid_utf8_to_utf16(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])

cpdef inline size_t convert_valid_utf8_to_utf16le(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_valid_utf8_to_utf16le(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])

cpdef inline size_t convert_valid_utf8_to_utf16be(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_valid_utf8_to_utf16be(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char16_t*>&buffer[0])

cpdef inline size_t convert_valid_utf8_to_utf32(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_valid_utf8_to_utf32(<const char *> &data[0], <size_t> data.shape[0], <simdutf.char32_t*>&buffer[0])

# cpdef inline size_t utf8_length_from_latin1(const uint8_t[::1] data):
#     with nogil:
#         return simdutf.utf8_length_from_latin1(<const char *> &data[0], <size_t> data.shape[0])


# cpdef inline size_t latin1_length_from_utf8(const uint8_t[::1] data):
#     with nogil:
#         return simdutf.latin1_length_from_utf8(<const char *> &data[0], <size_t> data.shape[0])


cpdef inline size_t utf16_length_from_utf8(const uint8_t[::1] data):
    with nogil:
        return simdutf.utf16_length_from_utf8(<const char *> &data[0], <size_t> data.shape[0])

cpdef inline size_t utf32_length_from_utf8(const uint8_t[::1] data):
    with nogil:
        return simdutf.utf32_length_from_utf8(<const char *> &data[0], <size_t> data.shape[0])


cpdef inline size_t convert_utf16_to_utf8(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_utf16_to_utf8(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])


cpdef inline size_t convert_utf16le_to_latin1(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_utf16le_to_latin1(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])

cpdef inline size_t convert_utf16be_to_latin1(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_utf16be_to_latin1(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])

cpdef inline size_t convert_utf16le_to_utf8(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_utf16le_to_utf8(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])

cpdef inline size_t convert_utf16be_to_utf8(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_utf16be_to_utf8(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])

cpdef inline tuple convert_utf16le_to_latin1_with_errors(const uint8_t[::1] data, uint8_t[::1] buffer):
    cdef simdutf.result r
    with nogil:
        r = simdutf.convert_utf16le_to_latin1_with_errors(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])
    return r.error, r.count

cpdef inline tuple convert_utf16be_to_latin1_with_errors(const uint8_t[::1] data, uint8_t[::1] buffer):
    cdef simdutf.result r
    with nogil:
        r = simdutf.convert_utf16be_to_latin1_with_errors(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])
    return r.error, r.count

cpdef inline tuple convert_utf16_to_utf8_with_errors(const uint8_t[::1] data, uint8_t[::1] buffer):
    cdef simdutf.result r
    with nogil:
        r = simdutf.convert_utf16_to_utf8_with_errors(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])
    return r.error, r.count


cpdef inline tuple convert_utf16le_to_utf8_with_errors(const uint8_t[::1] data, uint8_t[::1] buffer):
    cdef simdutf.result r
    with nogil:
        r = simdutf.convert_utf16le_to_utf8_with_errors(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])
    return r.error, r.count

cpdef inline tuple convert_utf16be_to_utf8_with_errors(const uint8_t[::1] data, uint8_t[::1] buffer):
    cdef simdutf.result r
    with nogil:
        r = simdutf.convert_utf16be_to_utf8_with_errors(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])
    return r.error, r.count


cpdef inline size_t convert_valid_utf16_to_utf8(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_valid_utf16_to_utf8(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])


# cpdef inline size_t convert_valid_utf16le_to_latin1(const uint8_t[::1] data, uint8_t[::1] buffer):
#     with nogil:
#         return simdutf.convert_valid_utf16le_to_latin1(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])

#
# cpdef inline size_t convert_valid_utf16be_to_latin1(const uint8_t[::1] data, uint8_t[::1] buffer):
#     with nogil:
#         return simdutf.convert_valid_utf16be_to_latin1(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])

cpdef inline size_t convert_valid_utf16be_to_utf8(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_valid_utf16be_to_utf8(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <char*>&buffer[0])


cpdef inline size_t convert_utf16_to_utf32(const uint8_t[::1] data, uint8_t[::1] buffer):
    with nogil:
        return simdutf.convert_utf16_to_utf32(<const simdutf.char16_t*> &data[0], <size_t> data.shape[0]/2, <simdutf.char32_t*>&buffer[0])
