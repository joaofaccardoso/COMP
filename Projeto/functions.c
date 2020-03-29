#include "structures.h"
#include "functions.h"
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

is_vs_decl_list* insert_vs_decl_list(is_vs_decl_list* head, is_vs_decl* declaration) {
    is_vs_decl_list* ivsdl = (is_vs_decl_list*)malloc(sizeof(is_vs_decl_list));
    is_vs_decl_list* tmp;

    ivsdl->decl = declaration;
    ivsdl->next = NULL;

    if (head==NULL) {
        return ivsdl;
    }

    for(tmp=head; tmp->next; tmp=tmp->next);
    tmp->next = ivsdl;

    return head;
}

//      STATEMENT INSERT FUNCTION TO BE WRITTEN

is_vs_decl* insert_var_decl(char* var_type, char* var_id) {
    is_vs_decl* ivsd = (is_vs_decl*)malloc(sizeof(is_vs_decl));
    is_var_decl* ivd = (is_var_decl*)malloc(sizeof(is_var_decl));

    ivd->type = var_type;
    ivd->id = var_id;

    ivsd->wich_decl = d_var;
    ivsd->decl_val.var_decl = ivd;

    return ivsd;
}

is_method_body* insert_method_body(is_vs_decl_list* list) {
    is_method_body* imb = (is_method_body*)malloc(sizeof(is_method_body));

    imb->var_statement_list = list;

    return imb;
}

is_method_param* insert_method_param(char* param_type, char* param_id) {
    is_method_param* imp = (is_method_param*)malloc(sizeof(is_method_param));

    imp->type = param_type;
    imp->id = param_id;

    return imp;
}

is_param_decl_list* insert_method_param_list(is_param_decl_list* head, is_method_param* method_param) {
    is_param_decl_list* ipdl = (is_param_decl_list*)malloc(sizeof(is_param_decl_list));
    is_param_decl_list* tmp;

    ipdl->param = method_param;
    ipdl->next = NULL;

    if (head==NULL) {
        return ipdl;
    }

    for(tmp=head; tmp->next; tmp=tmp->next);
    tmp->next = ipdl;

    return head;
}

is_method_header* insert_method_header(char* method_type, char* method_id, is_param_decl_list* method_params) {
    is_method_header* imh = (is_method_header*)malloc(sizeof(is_method_header));

    imh->type = method_type;
    imh->id = method_id;
    imh->param_list = method_params;

    return imh;
}

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
