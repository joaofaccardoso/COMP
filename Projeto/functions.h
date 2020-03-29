#include "structures.h"

is_vs_decl_list* insert_vs_decl_list(is_vs_decl_list* head, is_vs_decl* declaration);
is_vs_decl* insert_var_decl(char* var_type, char* var_id);
is_method_body* insert_method_body(is_vs_decl_list* list);
is_method_param* insert_method_param(char* param_type, char* param_id);
is_param_decl_list* insert_method_param_list(is_param_decl_list* head, is_method_param* method_param);
is_method_header* insert_method_header(char* method_type, char* method_id, is_param_decl_list* method_params);
is_mf_decl_list* insert_mf_decl_list(is_mf_decl_list* head, is_mf_decl* declaration);
is_mf_decl* insert_method(is_method_header* header, is_method_body* body);
is_mf_decl* insert_field(char* field_type, char* field_id);
is_program* insert_program(char* program_id, is_mf_decl_list* program_method_field_list);