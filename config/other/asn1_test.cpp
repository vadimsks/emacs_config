#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <functional>

#include <openssl/asn1.h>


#define THROW_IF(c, msg) \
if( c ) throw std::runtime_error( msg )

#define THROW_IF_0(c) THROW_IF( c, #c )

using namespace std;


struct ASNObject
{
    int tag = 0;
    int xclass = 0;
    const unsigned char* pdata = nullptr;
    long len = 0;
    vector<ASNObject> seq;
};

vector<ASNObject> parse_ASN1( const unsigned char* p, size_t length, int indent = 0 )
{
    vector<ASNObject> ret_value;

    string str_indent( indent, ' ' );

    str_indent = str_indent + str_indent + str_indent + str_indent;

    indent ++;

    while( true )
    {
        //int ASN1_get_object(const unsigned char **pp, long *plength, int *ptag,
        //             int *pclass, long omax);

        long len = 0;
        int tag = 0, xclass = 0, ret = 0;

        const unsigned char* op = p;
        unsigned int tag_byte = *p;
        int j = ASN1_get_object( &p, &len, &tag, &xclass, length );
        THROW_IF( (j & 0x80), "Error in decoding" );

        auto hl = p - op;
        THROW_IF_0( hl > length );
        THROW_IF_0( hl <= 0 );

        cout << str_indent << "---------------\n"
             << std::hex
             << str_indent << "tag: " << ( (xclass || (tag > 30)) ? "" : ASN1_tag2str(tag) ) << "( 0x" << tag_byte << " )\n"
             << std::dec
            // << str_indent << "length: " << length << "\n"
             << str_indent << "len: " << len << "\n"
             << std::hex
            // << str_indent << "j: " << j << "\n"
            //<< str_indent << "tag: " << tag << "\n"
             << str_indent << "xclass: " << xclass << "\n"
             << std::dec            
            ;
        
            
        length -= hl;

        THROW_IF_0( (len < 0) || (len > length) );

        if (j & V_ASN1_CONSTRUCTED)
        {
            ASNObject o {
                tag, xclass, p, len,
                parse_ASN1( p, len, indent )
            };

            ret_value.push_back( std::move( o ) );
        }
        else if (xclass != 0) {
            ASNObject o {
                tag, xclass, p, len
            };
            ret_value.push_back( std::move(o) );
        } else {
            ASNObject o {
                tag, xclass, p, len
            };
            ret_value.push_back( std::move(o) );
        }

        p += len;
        length -= len;

        if( length == 0 )
        {
            // cout << str_indent << "Exit\n";
            break;
        }
    }

    return std::move( ret_value );
}

int main( int argc, char** argv )
{
    ASN1_STRING * str = ASN1_STRING_new();

    string filename = argv[1];
    vector<char> buffer;
    size_t length = 0;
    {
        std::cout << "Opening: " << filename << "\n";
    
        auto is = fstream( argv[1],  ios_base::in | ios_base::binary );

        is.seekg (0, is.end);
        length = is.tellg();
        is.seekg (0, is.beg);

        buffer.resize( length );

        is.read ( &buffer[0], length);
        std::cout << "Read bytes: " << is.gcount() << "\n";
    }

    // const unsigned char* p = reinterpret_cast<unsigned char*>(&buffer[0]);

    parse_ASN1( reinterpret_cast<unsigned char*>(&buffer[0]), length );
    

}
