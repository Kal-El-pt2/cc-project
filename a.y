%{
    #include<stdio.h>
%}

%token PL MINUS MUL DIV MOD 
%token  EQ GT GTEQ LT LTEQ NTEQ 
%token ASSIGN PLASSIGN MINUSASSIGN MULASSIGN DIVASSIGN MODASSIGN 
%token OB CB COMMA SEMICOLON COB CCB AT COLON APOS DAPOS SOB SCB 
%token PRINT SCAN BEGIN END IF ELSE WHILE FOR DO  VarDecl TO
%token INT CHAR 
%token MAIN PROGRAM 
%token INC DEC
%token SLC MLCO MLCC
%token ID 
%token NL TAB 

%left PL MINUS
%left MUL DIV
%left MOD

%%

file                : BEGIN PROGRAM  VAR_DECLR CODE_SECTION END PROGRAM

BLOCK_STMTS         : BEGIN STMTS END SEMICOLON NL                                      {}
                    ;
STMTS               : ASSIGN_STMT                                                       {}
                    | PRINT_STMT                                                        {}
                    | SCAN_STMT                                                         {}
                    | ARRAY_STMT                                                        {}
                    | LOOP_STMT                                                         {}
                    | CONDITIONAL_STMT                                                  {}
                    ;
VAR_DECLR           : BEGIN VarDecl COLON VAR_DECLARE_STMT END VarDecl NL               {}
                    ;
VAR_DECLARE_FORMAT  : OB ID COMMA TYPE CB SEMICOLON NL VAR_DECLARE_FORMAT               {}
                    | OB ID COMMA TYPE CB SEMICOLON NL                                  {}
                    ;
PRINT_STMT          : PRINTF OB DAPOS STRING_STMT DAPOS COMMA PAR_SUB CB SEMICOLON NL   {}
                    ;
SCAN_STMT           : SCAN OB DAPOS STRING_STMT DAPOS COMMA PAR_SUB CB SEMICOLON NL     {}
                    ;
STRING_STMT         : STRING PARAMETER STRING                                           {}
                    ;
STRING              : STRING PARAMETER STRING                                           {}
                    | STR                                                               {}
                    |/*empty*/                                                          {}
                    ;
PARAMETER           : AT                                                                {}
                    ;
PAR_SUB             : VAL COMMA PAR_SUB                                                 {}
                    | VAL                                                               {}
                    | /*empty*/
                    ;
VAL                 : ID                                                                {}
                    | OB NUM COMMA NUM CB                                               {}
                    ;
STR                 : str                                                               {}
                    ;

ASSIGN_STMT         : ID ASSIGN expr SEMICOLON NL                                       {$1 = $3;}
                    | ID PLASSIGN expr SEMICOLON NL                                     {$1 += $3;}
                    | ID MINUSASSIGN expr SEMICOLON NL                                  {$1 -= $3;}
                    | ID MULASSIGN expr SEMICOLON NL                                    {$1 *= $3;}
                    | ID DIVASSIGN expr SEMICOLON NL                                    {$1 /= $3;}
                    | ID MODASSIGN expr SEMICOLON NL                                    {$1 /= $3;}
                    ;
expr                : expr PL expr                                                      {$$ = $1 + $3;}
                    | expr MINUS expr                                                   {$$ = $1 - $3;}
                    | expr MUL expr                                                     {$$ = $1 * $3;}
                    | expr DIV expr                                                     {$$ = $1 / $3;}
                    | expr MOD expr                                                     {$$ = $1%$3;}                                                                                 
                    ;
LOOP_STMT           : WHILE OB expr CB NL BLOCK_STMTS                                   {}
                    | FOR ASSIGN_STMT TO expr INC VAL DO BLOCK_STMTS                    {}
                    | FOR ASSIGN_STMT TO expr DEC VAL DO BLOCK_STMTS                    {}
                    ;
CONDITIONAL_STMT    : IF expr BEGIN STMTS END SEMICOLON                                 {}
                    | IF expr BEGIN STMTS END SEMICOLON ELSE BEGIN STMTS END SEMICOLON  {}
                    ;
ARRAY_STMT          : OB ID SOB ID SCB COMMA TYPE CB SEMICOLON                          {}              
                    ;

SINGLE_LINE_COMMENT : SLC STR                                                           {}
                    ;
MULTI_LINE_COMMENT  : MLCO STR MLCC                                                     {}
TYPE                : INT                                                               {}
                    | CHAR                                                              {}
                    ;
%%              

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

void yyerror(const char *s){
    fprintf(stderr,"Error: %s\n",s);
    exit(1);
}
int yywrap(){
    return 1;
}