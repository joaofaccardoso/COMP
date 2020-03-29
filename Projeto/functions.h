#include "structures.h"

is_vs_decl_list* insert_vs_decl_list(is_vs_decl_list* head, is_vs_decl* ivd);
is_vs_decl* insert_var_decl(char* type, char* id);
is_method_body* insert_method_body(is_vs_decl_list* ivdl);
is_method_param* insert_method_param(char* type, char* id);
is_param_decl_list* insert_method_param_list(is_param_decl_list* head, is_method_param* imp);
is_method_header* insert_method_header(char* type, char* id, is_param_decl_list* ipdl);
is_mf_decl_list* insert_mf_decl_list(is_mf_decl_list* head, is_mf_decl* imfd);
is_mf_decl* insert_method(is_method_header* imh, is_method_body* imb);
is_mf_decl* insert_field(char* type, char* id);
is_program* insert_program(char* id, is_mf_decl_list* imfdl);