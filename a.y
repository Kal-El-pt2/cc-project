%{
    #include<stdio.h>
%}

%token PL MINUS MUL DIV MOD 
%token  EQ GT GTEQ LT LTEQ NTEQ 
%token ASSIGN ADDASSIGN MINUSASSIGN MULASSIGN DIVASSIGN MODASSIGN 
%token OB CB COMMA SEMICOLON COB CCB AT COLON APOS DAPOS SOB SCB 
%token PRINT SCAN BEGIN END IF ELSE WHILE FOR DO  
%token INT CHAR 
%token MAIN PROGRAM 
%token INC DEC
%token ID 
%token NL TAB 

%%

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