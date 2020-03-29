#ifndef STRUCTURES_H
#define STRUCTURES_H

typedef struct _s14 {
    struct _s13* decl;
    struct _s14* next;
} is_vs_decl_list;


typedef enum {d_var, d_statement} d_body;

typedef struct _s13 {
    d_body wich_decl;
    union {
        struct _s11* var_decl;
        struct _s12* statement_decl;
    } decl_val;  
} is_vs_decl;

typedef struct _s12 {

} is_statement;

typedef struct _s11 {
    char* type;
    char* id;
} is_var_decl;

typedef struct _s10 {
    struct _s14* var_statement_list;
} is_method_body;

typedef struct _s9 {
    char* type;
    char* id;
} is_method_param;

typedef struct _s8 {
    struct _s9* param;
    struct _s8* next;
} is_param_decl_list;

typedef struct _s6 {
    char* type;
    char* id;
    struct _s8* param_list;
} is_method_header;

typedef struct _s5 {
    struct _s4* method_field_decl;
    struct _s5* next;
} is_mf_decl_list;

typedef enum {d_method, d_field} decl;

typedef struct _s4 {
    decl wich_decl;
    union {
        struct _s3* method_decl;
        struct _s2* field_decl;
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
    struct _s5* method_field_list;
} is_program;

#endif
