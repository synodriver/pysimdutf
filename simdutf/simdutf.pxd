# cython: language_level=3
# cython: cdivision=True
# distutils: language=c++
from libc.stdint cimport uint16_t, uint32_t
from libcpp.string cimport string

cdef extern from * nogil:
    const char * SIMDUTF_VERSION
    ctypedef uint16_t char16_t
    ctypedef uint32_t char32_t


cdef extern from "../dep/src/simdutf.cpp" namespace "simdutf" nogil:
    enum encoding_type:
        UTF8     # BOM 0xef 0xbb 0xbf
        UTF16_LE  # BOM 0xff 0xfe
        UTF16_BE   # BOM 0xfe 0xff
        UTF32_LE   # BOM 0xff 0xfe 0x00 0x00
        UTF32_BE  # BOM 0x00 0x00 0xfe 0xff
        Latin1
        unspecified
    enum error_code:
        SUCCESS
        HEADER_BITS  # Any byte must have fewer than 5 header bits.
        TOO_SHORT  # The leading byte must be followed by N-1 continuation bytes, where N is the UTF-8 character length
                    # This is also the error when the input is truncated.
        TOO_LONG     # We either have too many consecutive continuation bytes or the string starts with a continuation byte.
        OVERLONG    # The decoded character must be above U+7F for two-byte characters, U+7FF for three-byte characters,
                    # and U+FFFF for four-byte characters.
        TOO_LARGE    # The decoded character must be less than or equal to U+10FFFF,less than or equal than U+7F for ASCII OR less than equal than U+FF for Latin1
        SURROGATE    # The decoded character must be not be in U+D800...DFFF (UTF-8 or UTF-32) OR
                    # a high surrogate must be followed by a low surrogate and a low surrogate must be preceded by a high surrogate (UTF-16) OR
                    # there must be no surrogate at all (Latin1)
        OTHER         # Not related to validation/transcoding.
    struct result:
        error_code error
        size_t count     # In case of error, indicates the position of the error. In case of success, indicates the number of words validated/written.
        # result() except +
        # result(error_code, size_t) except +

    encoding_type autodetect_encoding(const char * input_, size_t length) noexcept
    int detect_encodings(const char * input, size_t length) noexcept
    bint validate_utf8(const char *buf, size_t len) noexcept
    result validate_utf8_with_errors(const char *buf, size_t len) noexcept
    bint validate_ascii(const char *buf, size_t len) noexcept
    result validate_ascii_with_errors(const char *buf, size_t len) noexcept
    bint validate_utf16(const char16_t *buf, size_t len) noexcept
    bint validate_utf16le(const char16_t *buf, size_t len) noexcept
    bint validate_utf16be(const char16_t *buf, size_t len) noexcept
    result validate_utf16_with_errors(const char16_t *buf, size_t len) noexcept
    result validate_utf16le_with_errors(const char16_t *buf, size_t len) noexcept
    result validate_utf16be_with_errors(const char16_t *buf, size_t len) noexcept
    bint validate_utf32(const char32_t *buf, size_t len) noexcept
    result validate_utf32_with_errors(const char32_t *buf, size_t len) noexcept
    size_t convert_latin1_to_utf8(const char * input, size_t length, char* utf8_output) noexcept
    size_t convert_latin1_to_utf16le(const char * input, size_t length, char16_t* utf16_output) noexcept
    size_t convert_latin1_to_utf16be(const char * input, size_t length, char16_t* utf16_output) noexcept
    size_t convert_latin1_to_utf32(const char * input, size_t length, char32_t* utf32_buffer) noexcept
    size_t convert_utf8_to_latin1(const char * input, size_t length, char* latin1_output) noexcept;
    size_t convert_utf8_to_utf16(const char * input, size_t length, char16_t* utf16_output) noexcept;
    size_t convert_utf8_to_utf16le(const char * input, size_t length, char16_t* utf16_output) noexcept;
    size_t convert_utf8_to_utf16be(const char * input, size_t length, char16_t* utf16_output) noexcept;
    result convert_utf8_to_latin1_with_errors(const char * input, size_t length, char* latin1_output) noexcept;
    result convert_utf8_to_utf16_with_errors(const char * input, size_t length, char16_t* utf16_output) noexcept;
    result convert_utf8_to_utf16le_with_errors(const char * input, size_t length, char16_t* utf16_output) noexcept;
    result convert_utf8_to_utf16be_with_errors(const char * input, size_t length, char16_t* utf16_output) noexcept;
    size_t convert_utf8_to_utf32(const char * input, size_t length, char32_t* utf32_output) noexcept;
    result convert_utf8_to_utf32_with_errors(const char * input, size_t length, char32_t* utf32_output) noexcept;
    size_t convert_valid_utf8_to_latin1(const char * input, size_t length, char* latin1_output) noexcept;
    size_t convert_valid_utf8_to_utf16(const char * input, size_t length, char16_t* utf16_buffer) noexcept;
    size_t convert_valid_utf8_to_utf16le(const char * input, size_t length, char16_t* utf16_buffer) noexcept;
    size_t convert_valid_utf8_to_utf16be(const char * input, size_t length, char16_t* utf16_buffer) noexcept;
    size_t convert_valid_utf8_to_utf32(const char * input, size_t length, char32_t* utf32_buffer) noexcept;
    size_t utf8_length_from_latin1(const char * input, size_t length) noexcept;
    size_t latin1_length_from_utf8(const char * input, size_t length) noexcept;
    size_t utf16_length_from_utf8(const char * input, size_t length) noexcept;
    size_t utf32_length_from_utf8(const char * input, size_t length) noexcept;
    size_t convert_utf16_to_utf8(const char16_t * input, size_t length, char* utf8_buffer) noexcept;
    size_t convert_utf16le_to_latin1(const char16_t * input, size_t length, char* latin1_buffer) noexcept;
    size_t convert_utf16be_to_latin1(const char16_t * input, size_t length, char* latin1_buffer) noexcept;
    size_t convert_utf16le_to_utf8(const char16_t * input, size_t length, char* utf8_buffer) noexcept;
    size_t convert_utf16be_to_utf8(const char16_t * input, size_t length, char* utf8_buffer) noexcept;
    result convert_utf16le_to_latin1_with_errors(const char16_t * input, size_t length, char* latin1_buffer) noexcept;
    result convert_utf16be_to_latin1_with_errors(const char16_t * input, size_t length, char* latin1_buffer) noexcept;
    result convert_utf16_to_utf8_with_errors(const char16_t * input, size_t length, char* utf8_buffer) noexcept;
    result convert_utf16le_to_utf8_with_errors(const char16_t * input, size_t length, char* utf8_buffer) noexcept;
    result convert_utf16be_to_utf8_with_errors(const char16_t * input, size_t length, char* utf8_buffer) noexcept;
    size_t convert_valid_utf16_to_utf8(const char16_t * input, size_t length, char* utf8_buffer) noexcept;
    size_t convert_valid_utf16le_to_latin1(const char16_t * input, size_t length, char* latin1_buffer) noexcept;
    size_t convert_valid_utf16be_to_latin1(const char16_t * input, size_t length, char* latin1_buffer) noexcept;
    size_t convert_valid_utf16be_to_utf8(const char16_t * input, size_t length, char* utf8_buffer) noexcept;
    size_t convert_utf16_to_utf32(const char16_t * input, size_t length, char32_t* utf32_buffer) noexcept;
    size_t convert_utf16le_to_utf32(const char16_t * input, size_t length, char32_t* utf32_buffer) noexcept;
    size_t convert_utf16be_to_utf32(const char16_t * input, size_t length, char32_t* utf32_buffer) noexcept;
    result convert_utf16_to_utf32_with_errors(const char16_t * input, size_t length, char32_t* utf32_buffer) noexcept;
    result convert_utf16le_to_utf32_with_errors(const char16_t * input, size_t length, char32_t* utf32_buffer) noexcept;
    result convert_utf16be_to_utf32_with_errors(const char16_t * input, size_t length, char32_t* utf32_buffer) noexcept;
    size_t convert_valid_utf16_to_utf32(const char16_t * input, size_t length, char32_t* utf32_buffer) noexcept;
    size_t convert_valid_utf16le_to_utf32(const char16_t * input, size_t length, char32_t* utf32_buffer) noexcept;
    size_t convert_valid_utf16be_to_utf32(const char16_t * input, size_t length, char32_t* utf32_buffer) noexcept;
    size_t latin1_length_from_utf16(size_t length) noexcept;
    size_t utf8_length_from_utf16(const char16_t * input, size_t length) noexcept;
    size_t utf8_length_from_utf16le(const char16_t * input, size_t length) noexcept;
    size_t utf8_length_from_utf16be(const char16_t * input, size_t length) noexcept;
    size_t convert_utf32_to_utf8(const char32_t * input, size_t length, char* utf8_buffer) noexcept;
    result convert_utf32_to_utf8_with_errors(const char32_t * input, size_t length, char* utf8_buffer) noexcept;
    size_t convert_valid_utf32_to_utf8(const char32_t * input, size_t length, char* utf8_buffer) noexcept;
    size_t convert_utf32_to_utf16(const char32_t * input, size_t length, char16_t* utf16_buffer) noexcept;
    size_t convert_utf32_to_utf16le(const char32_t * input, size_t length, char16_t* utf16_buffer) noexcept;
    size_t convert_utf32_to_latin1(const char32_t * input, size_t length, char* latin1_buffer) noexcept;
    result convert_utf32_to_latin1_with_errors(const char32_t * input, size_t length, char* latin1_buffer) noexcept;
    size_t convert_valid_utf32_to_latin1(const char32_t * input, size_t length, char* latin1_buffer) noexcept;
    size_t convert_utf32_to_utf16be(const char32_t * input, size_t length, char16_t* utf16_buffer) noexcept;
    result convert_utf32_to_utf16_with_errors(const char32_t * input, size_t length, char16_t* utf16_buffer) noexcept;
    result convert_utf32_to_utf16le_with_errors(const char32_t * input, size_t length, char16_t* utf16_buffer) noexcept;
    result convert_utf32_to_utf16be_with_errors(const char32_t * input, size_t length, char16_t* utf16_buffer) noexcept;
    size_t convert_valid_utf32_to_utf16(const char32_t * input, size_t length, char16_t* utf16_buffer) noexcept;
    size_t convert_valid_utf32_to_utf16le(const char32_t * input, size_t length, char16_t* utf16_buffer) noexcept;
    size_t convert_valid_utf32_to_utf16be(const char32_t * input, size_t length, char16_t* utf16_buffer) noexcept;
    void change_endianness_utf16(const char16_t * input, size_t length, char16_t * output) noexcept;
    size_t utf8_length_from_utf32(const char32_t * input, size_t length) noexcept;
    size_t utf16_length_from_utf32(const char32_t * input, size_t length) noexcept;
    size_t utf32_length_from_utf16(const char16_t * input, size_t length) noexcept;
    size_t utf32_length_from_utf16le(const char16_t * input, size_t length) noexcept;
    size_t utf32_length_from_utf16be(const char16_t * input, size_t length) noexcept;
    size_t count_utf16(const char16_t * input, size_t length) noexcept;
    size_t count_utf16le(const char16_t * input, size_t length) noexcept;
    size_t count_utf16be(const char16_t * input, size_t length) noexcept;
    size_t count_utf8(const char * input, size_t length) noexcept;

    cdef cppclass implementation:
        string name()
        string description()
        bint supported_by_runtime_system()
        encoding_type autodetect_encoding(const char * input, size_t length) noexcept
        int detect_encodings(const char * input, size_t length) noexcept
        uint32_t required_instruction_sets()
        bint validate_utf8(const char *buf, size_t len) noexcept
        result validate_utf8_with_errors(const char *buf, size_t len) noexcept
        bint validate_ascii(const char *buf, size_t len) noexcept
        result validate_ascii_with_errors(const char *buf, size_t len) noexcept
        bint validate_utf16le(const char16_t *buf, size_t len)  noexcept