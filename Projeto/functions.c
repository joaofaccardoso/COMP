#include "structures.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

is_field_decl* insert_field(char* field_type, char* field_id) {
    is_field_decl* ifd = (is_field_decl*)malloc(sizeof(is_field_decl));

    ifd->type = field_type;
    ifd->id = field_id;

    return ifd;
}

is_method_decl* insert_method(is_method_header* header, is_method_body* body) {
    is_method_decl* imd = (is_method_decl*)malloc(sizeof(is_method_decl));

    imd->method_header = header;
    imd->method_body = body;

    return imd;
}

is_program* insert_program(char* id, ) {

}
