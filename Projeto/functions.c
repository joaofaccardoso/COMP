#include "structures.h"
#include "functions.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

is_vs_decl_list* insert_vs_decl_list(is_vs_decl_list* head, is_vs_decl* ivd) {
    is_vs_decl_list* ivsdl = (is_vs_decl_list*)malloc(sizeof(is_vs_decl_list));
    is_vs_decl_list* tmp;

    ivsdl->decl = ivd;

    ivd->next = head;
    return ivd;
}

//      STATEMENT INSERT FUNCTION TO BE WRITTEN

is_vs_decl* insert_var_decl(char* type, char* id) {
    is_vs_decl* ivsd = (is_vs_decl*)malloc(sizeof(is_vs_decl));
    is_var_decl* ivd = (is_var_decl*)malloc(sizeof(is_var_decl));

    ivd->type = type;
    ivd->id = id;

    ivsd->wich_decl = d_var;
    ivsd->decl_val.var_decl = ivd;

    return ivsd;
}

is_method_body* insert_method_body(is_vs_decl_list* ivdl) {
    is_method_body* imb = (is_method_body*)malloc(sizeof(is_method_body));

    imb->var_statement_list = ivdl;

    return imb;
}

is_param_decl_list* insert_method_param_list(is_param_decl_list* head, char* type, char* id) {
    is_param_decl_list* ipdl = (is_param_decl_list*)malloc(sizeof(is_param_decl_list));
    ipdl->type = type;
    ipdl->id = id;

    ivd->next = head;
    return ivd;
}

is_method_header* insert_method_header(char* type, char* id, is_param_decl_list* ipdl) {
    is_method_header* imh = (is_method_header*)malloc(sizeof(is_method_header));

    imh->type = type;
    imh->id = id;
    imh->param_list = ipdl;

    return imh;
}

is_mf_decl_list* insert_mf_decl_list(is_mf_decl_list* head, is_mf_decl* imfd) {
    is_mf_decl_list* imfdl = (is_mf_decl_list*)malloc(sizeof(is_mf_decl_list));
    is_mf_decl_list* tmp;

    imfdl->method_field_decl = imfd;
    
    ivd->next = head;
    return ivd;
}

is_mf_decl* insert_method(is_method_header* imh, is_method_body* imb) {
    is_mf_decl* imfd = (is_mf_decl*)malloc(sizeof(is_mf_decl));
    is_method_decl* imd = (is_method_decl*)malloc(sizeof(is_method_decl));

    imd->method_header = imh;
    imd->method_body = imb;

    imfd->wich_decl = d_method;
    imfd->decl_val.method_decl = imd;

    return imfd;
}

is_mf_decl* insert_field(char* type, char* id) {
    is_mf_decl* imfd = (is_mf_decl*)malloc(sizeof(is_mf_decl));
    is_field_decl* ifd = (is_field_decl*)malloc(sizeof(is_field_decl));

    ifd->type = type;
    ifd->id = id;

    imfd->wich_decl = d_field;
    imfd->decl_val.field_decl = ifd;

    return imfd;
}

is_program* insert_program(char* id, is_mf_decl_list* imfdl) {
    is_program* ip = (is_program*)malloc(sizeof(is_program));

    ip->id = id;
    ip->method_field_list = imfdl;

    return ip;
}
