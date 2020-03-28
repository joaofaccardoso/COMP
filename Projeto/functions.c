#include "structures.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

is_mf_decl_list* insert_mf_decl_list(is_mf_decl_list* head, is_mf_decl* declaration) {
    is_mf_decl_list* imfdl = (is_mf_decl_list*)malloc(sizeof(is_mf_decl_list));
    is_mf_decl_list* tmp;

    imfdl->method_field_decl = declaration;
    imfdl->next=NULL;

    if(head==NULL) {
        return imfdl;
    }

    for(tmp = head; tmp->next; tmp = tmp->next);
    tmp->next = imfdl;

    return head;
}

is_method_body* insert_method_body() {

}

is_method_header* insert_method_header(char* method_type, char* method_id) {
    is_method_header* imh = (is_method_header*)malloc(sizeof(is_method_header));

    imh->type = method_type;
    imh->id = method_id;

    return imh;
}

is_mf_decl* insert_method(is_method_header* header, is_method_body* body) {
    is_mf_decl* imfd = (is_mf_decl*)malloc(sizeof(is_mf_decl));
    is_method_decl* imd = (is_method_decl*)malloc(sizeof(is_method_decl));

    imd->method_header = header;
    imd->method_body = body;

    imfd->wich_decl = d_method;
    imfd->decl_val.method_decl = imd;

    return imfd;
}

is_mf_decl* insert_field(char* field_type, char* field_id) {
    is_mf_decl* imfd = (is_mf_decl*)malloc(sizeof(is_mf_decl));
    is_field_decl* ifd = (is_field_decl*)malloc(sizeof(is_field_decl));

    ifd->type = field_type;
    ifd->id = field_id;

    imfd->wich_decl = d_field;
    imfd->decl_val.field_decl = ifd;

    return imfd;
}

is_program* insert_program(char* program_id, is_mf_decl_list* program_method_field_list) {
    is_program* ip = (is_program*)malloc(sizeof(is_program));

    ip->id = program_id;
    ip->method_field_list = program_method_field_list;

    return ip;
}
