import java.io.*;

%%

%byaccj

%{

	// Armazena uma referencia para o parser
	private Parser yyparser;

	// Construtor recebendo o parser como parametro adicional
	public Yylex(Reader r, Parser yyparser){
		this(r);
		this.yyparser = yyparser;
	}
                private void count() {
                System.out.println("Get:" + yyline + ":" + yycolumn + " { " + yytext() + " } {" + yystate() + "}");
        }
        private void comment() {}
        public int check_type() { return Parser.IDENTIFIER; }

%}

NL = \n | \r | \r\n
WS = [ \t\v\f]

D=[0-9]
L=[a-zA-Z_]
H=[a-fA-F0-9]
E=[Ee][+-]?{D}+
FS=(f|F|l|L)
IS=(u|U|l|L)*
Comment   =";".*{NL}


%%

{Comment}			{  }

"auto"			{ count(); return Parser.AUTO; }
"break"			{ count(); return Parser.BREAK; }
"char"			{ count(); return Parser.CHAR; }
"const"			{ count(); return Parser.CONST; }
"continue"		{ count(); return Parser.CONTINUE; }
"do"			{ count(); return Parser.DO; }
"double"		{ count(); return Parser.DOUBLE; }
"else"			{ count(); return Parser.ELSE; }
"enum"			{ count(); return Parser.ENUM; }
"extern"		{ count(); return Parser.EXTERN; }
"float"			{ count(); return Parser.FLOAT; }
"for"			{ count(); return Parser.FOR; }
"goto"			{ count(); return Parser.GOTO; }
"gosub"			{ count(); return Parser.GOSUB; }
"if"			{ count(); return Parser.IF; }
"int"			{ count(); return Parser.INT; }
"long"			{ count(); return Parser.LONG; }
"register"		{ count(); return Parser.REGISTER; }
"return"		{ count(); return Parser.RETURN; }
"short"			{ count(); return Parser.SHORT; }
"signed"		{ count(); return Parser.SIGNED; }
"sizeof"		{ count(); return Parser.SIZEOF; }
"static"		{ count(); return Parser.STATIC; }
"struct"		{ count(); return Parser.STRUCT; }
"typedef"		{ count(); return Parser.TYPEDEF; }
"union"			{ count(); return Parser.UNION; }
"unsigned"		{ count(); return Parser.UNSIGNED; }
"void"			{ count(); return Parser.VOID; }
"volatile"		{ count(); return Parser.VOLATILE; }

"var"     { count(); return Parser.VAR; }
"str"     { count(); return Parser.STR; }
"sptr"    { count(); return Parser.SPTR; }
"pval"    { count(); return Parser.PVAL; }
"bmscr"   { count(); return Parser.BMSCR; }
"prefstr" { count(); return Parser.PREFSTR; }
"pexinfo" { count(); return Parser.PEXINFO; }
"nullptr" { count(); return Parser.NULLPTR; }
"array"   { count(); return Parser.ARRAY; }

{L}({L}|{D})*		{ count(); return Parser.IDENTIFIER; }

0[xX]{H}+{IS}?		{ count(); return Parser.CONSTANT; }
0{D}+{IS}?		{ count(); return Parser.CONSTANT; }
{D}+{IS}?		{ count(); return Parser.CONSTANT; }
L?'(\\.|[^\\'])+'	{ count(); return Parser.CONSTANT; }

{D}+{E}{FS}?		{ count(); return Parser.CONSTANT; }
{D}*"."{D}+({E})?{FS}?	{ count(); return Parser.CONSTANT; }
{D}+"."{D}*({E})?{FS}?	{ count(); return Parser.CONSTANT; }

L?\"(\\.|[^\\\"])*\"	{ count(); return Parser.STRING_LITERAL; }

"..."			{ count(); return Parser.ELLIPSIS; }
">>="			{ count(); return Parser.RIGHT_ASSIGN; }
"<<="			{ count(); return Parser.LEFT_ASSIGN; }
"+="			{ count(); return Parser.ADD_ASSIGN; }
"-="			{ count(); return Parser.SUB_ASSIGN; }
"*="			{ count(); return Parser.MUL_ASSIGN; }
"/="			{ count(); return Parser.DIV_ASSIGN; }
"%="			{ count(); return Parser.MOD_ASSIGN; }
"&="			{ count(); return Parser.AND_ASSIGN; }
"^="			{ count(); return Parser.XOR_ASSIGN; }
"|="			{ count(); return Parser.OR_ASSIGN; }
">>"			{ count(); return Parser.RIGHT_OP; }
"<<"			{ count(); return Parser.LEFT_OP; }
"++"			{ count(); return Parser.INC_OP; }
"--"			{ count(); return Parser.DEC_OP; }
"->"			{ count(); return Parser.PTR_OP; }
"&&"			{ count(); return Parser.AND_OP; }
"||"			{ count(); return Parser.OR_OP; }
"<="			{ count(); return Parser.LE_OP; }
">="			{ count(); return Parser.GE_OP; }
"=="			{ count(); return Parser.EQ_OP; }
"!="			{ count(); return Parser.NE_OP; }
("{"|"<%")		{ count(); return (int) '{'; }
("}"|"%>")		{ count(); return (int) '}'; }
","			{ count(); return (int) ','; }
":"			{ count(); return (int) ':'; }
"="			{ count(); return (int) '='; }
"("			{ count(); return (int) '('; }
")"			{ count(); return (int) ')'; }
("["|"<:")		{ count(); return (int) '['; }
("]"|":>")		{ count(); return (int) ']'; }
"."			{ count(); return (int) '.'; }
"&"			{ count(); return Parser.OR_OP; }
"!"			{ count(); return (int) '!'; }
"~"			{ count(); return (int) '~'; }
"-"			{ count(); return (int) '-'; }
"+"			{ count(); return (int) '+'; }
"*"			{ count(); return (int) '*'; }
"/"			{ count(); return (int) '/'; }
"%"			{ count(); return (int) '%'; }
"<"			{ count(); return (int) '<'; }
">"			{ count(); return (int) '>'; }
"^"			{ count(); return (int) '^'; }
"|"			{ count(); return Parser.AND_OP; }
"?"			{ count(); return (int) '?'; }
"#"			{ count(); return (int) '#'; }

{NL}                    { count(); return Parser.NEWLINE; }
{WS}                    { count(); }
.			{ /* ignore bad characters */ }