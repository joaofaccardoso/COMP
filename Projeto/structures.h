#ifndef STRUCTURES_H
#define STRUCTURES_H

typedef struct _s10 {
    char* type;
    char* id;
} is_var_decl;

typedef struct _s9 {
    is_var_decl var_decl;
} is_method_body;

typedef struct _s8 {
    char* type;
    char* id;
    struct _s8* next;
} is_param_decl_list;

typedef struct _s7 {
    is_param_decl_list* param_list;
} is_method_params;

typedef struct _s6 {
    char* type;
    char* id;
    is_method_params* method_params;
} is_method_header;

typedef struct _s5 {
    is_mf_decl* method_field_decl;
    struct _s5* next;
} is_mf_decl_list;

typedef enum {d_method, d_field} decl;

typedef struct _s4 {
    decl wich_decl;
    union {
        is_method_decl* method_decl;
        is_field_decl* field_decl;
    } decl_val;
} is_mf_decl;

typedef struct _s3 {
    is_method_header* method_header;
    is_method_body* method_body;
} is_method_decl;

typedef struct _s2 {
    char* type;
    char* id;
} is_field_decl;

typedef struct _s1 {
    char* id;
    is_mf_decl_list* method_field_list;
} is_program;

#endif
