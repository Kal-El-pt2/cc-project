%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
int yylex(void);
extern FILE* yyin;
%}

%union {
    int ival;
    char* sval;
    struct ASTNode* ast;
}

/* Tokens */
%token BEGIN_KEY END PROGRAM VARDECL INT CHAR
%token IF ELSE WHILE FOR DO TO INC DEC MAIN
%token PRINT SCAN
%token <sval> ID STRCONST
%token <ival> INTCONST CHARCONST
%token ASSIGNOP ADDOP SUBOP MULOP DIVOP MODOP RELOP
%token LPAREN RPAREN LBRACKET RBRACKET COMMA SEMICOLON COLON
%token INDEX

/* Operator precedence and associativity - crucial for avoiding conflicts */
%left RELOP
%left ADDOP SUBOP
%left MULOP DIVOP MODOP
%nonassoc UMINUS
%nonassoc LOWER_THAN_ELSE  /* This solves the dangling else problem */
%nonassoc ELSE

%%

program
    : BEGIN_KEY PROGRAM COLON var_decl_block stmt_block END PROGRAM
      { printf("Successfully parsed !!!\n"); }
    ;

var_decl_block
    : BEGIN_KEY VARDECL COLON varlist END VARDECL
    ;

varlist
    : varlist var_decl
    | var_decl
    ;

var_decl
    : LPAREN ID COMMA type RPAREN SEMICOLON
    | LPAREN ID LBRACKET INTCONST RBRACKET COMMA type RPAREN SEMICOLON
    | LPAREN ID LBRACKET INDEX RBRACKET COMMA type RPAREN SEMICOLON
    ;

type
    : INT
    | CHAR
    ;

stmt_block
    : stmt_block statement
    | statement
    ;

statement
    : assign_stmt
    | io_stmt
    | cond_stmt
    | loop_stmt
    | block
    ;

assign_stmt
    : ID ASSIGNOP expr SEMICOLON
    ;

io_stmt
    : print_stmt
    | scan_stmt
    ;

print_stmt
    : PRINT LPAREN STRCONST RPAREN SEMICOLON
    | PRINT LPAREN STRCONST COMMA print_args RPAREN SEMICOLON
    ;

print_args
    : expr
    | expr COMMA print_args
    ;

scan_stmt
    : SCAN LPAREN scan_fmt COMMA scan_args RPAREN SEMICOLON
    ;

scan_fmt
    : STRCONST
    ;

scan_args
    : ID
    | ID COMMA scan_args
    ;

/* Using precedence to resolve the dangling else problem */
cond_stmt
    : IF LPAREN expr RPAREN block SEMICOLON %prec LOWER_THAN_ELSE
    | IF LPAREN expr RPAREN block ELSE block SEMICOLON
    ;

loop_stmt
    : WHILE LPAREN expr RPAREN DO block SEMICOLON
    | for_stmt
    ;

for_stmt
    : FOR ID ASSIGNOP expr TO expr INC expr DO block SEMICOLON
    | FOR ID ASSIGNOP expr TO expr DEC expr DO block SEMICOLON
    ;

block
    : BEGIN_KEY stmt_block END
    ;

expr
    : expr ADDOP expr
    | expr SUBOP expr
    | expr MULOP expr
    | expr DIVOP expr
    | expr MODOP expr
    | expr RELOP expr
    | LPAREN expr RPAREN
    | ID
    | INTCONST
    | CHARCONST
    | SUBOP expr %prec UMINUS  /* Unary minus with higher precedence */
    ;

%%

void yyerror(const char *s) {
    printf("Syntax error !!!\n");
    fprintf(stderr,"Error : %s",s);
    exit(1);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <input file>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Error opening file");
        return 1;
    }

    yyparse();
    fclose(yyin);
    return 0;
}