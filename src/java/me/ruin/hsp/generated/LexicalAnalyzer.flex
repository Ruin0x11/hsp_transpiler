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
                //System.out.println("Get:" + yyline + ":" + yycolumn + " { " + yytext() + " } {" + yystate() + "}");
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

"auto"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.AUTO; }
"break"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.BREAK; }
"char"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.CHAR; }
"const"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.CONST; }
"continue"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.CONTINUE; }
"do"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.DO; }
"double"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.DOUBLE; }
"else"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.ELSE; }
"enum"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.ENUM; }
"extern"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.EXTERN; }
"float"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.FLOAT; }
"for"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.FOR; }
"goto"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.GOTO; }
"gosub"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.GOSUB; }
"if"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.IF; }
"int"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.INT; }
"long"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.LONG; }
"register"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.REGISTER; }
"return"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.RETURN; }
"short"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.SHORT; }
"signed"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.SIGNED; }
"sizeof"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.SIZEOF; }
"static"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.STATIC; }
"struct"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.STRUCT; }
"typedef"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.TYPEDEF; }
"union"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.UNION; }
"unsigned"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.UNSIGNED; }
"void"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.VOID; }
"volatile"		{ yyparser.yylval = new ParserVal(yytext()); return Parser.VOLATILE; }

"var"     { return Parser.VAR; }
"str"     { return Parser.STR; }
"sptr"    { return Parser.SPTR; }
"pval"    { return Parser.PVAL; }
"bmscr"   { return Parser.BMSCR; }
"prefstr" { return Parser.PREFSTR; }
"pexinfo" { return Parser.PEXINFO; }
"nullptr" { return Parser.NULLPTR; }
"array"   { return Parser.ARRAY; }

"repeat"   { return Parser.REPEAT; }
"loop"   { return Parser.LOOP; }

{L}({L}|{D})*		{ count(); yyparser.yylval = new ParserVal(yytext()); return Parser.IDENTIFIER; }

0[xX]{H}+{IS}?		{ yyparser.yylval = new ParserVal(yytext()); return Parser.CONSTANT; }
0{D}+{IS}?		{ yyparser.yylval = new ParserVal(yytext()); return Parser.CONSTANT; }
{D}+{IS}?		{ yyparser.yylval = new ParserVal(yytext()); return Parser.CONSTANT; }
L?'(\\.|[^\\'])+'	{ yyparser.yylval = new ParserVal(yytext()); return Parser.CONSTANT; }

{D}+{E}{FS}?		{ yyparser.yylval = new ParserVal(yytext()); return Parser.CONSTANT; }
{D}*"."{D}+({E})?{FS}?	{yyparser.yylval = new ParserVal(yytext()); return Parser.CONSTANT; }
{D}+"."{D}*({E})?{FS}?	{yyparser.yylval = new ParserVal(yytext()); return Parser.CONSTANT; }

L?\"(\\.|[^\\\"])*\"	{
        yyparser.yylval = new ParserVal(yytext());
                return Parser.STRING_LITERAL;
        }

"..."			{ yyparser.yylval = new ParserVal(yytext()); return Parser.ELLIPSIS; }
">>="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.RIGHT_ASSIGN; }
"<<="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.LEFT_ASSIGN; }
"+="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.ADD_ASSIGN; }
"-="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.SUB_ASSIGN; }
"*="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.MUL_ASSIGN; }
"/="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.DIV_ASSIGN; }
"%="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.MOD_ASSIGN; }
"&="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.AND_ASSIGN; }
"^="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.XOR_ASSIGN; }
"|="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.OR_ASSIGN; }
">>"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.RIGHT_OP; }
"<<"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.LEFT_OP; }
"++"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.INC_OP; }
"--"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.DEC_OP; }
"->"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.PTR_OP; }
"<="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.LE_OP; }
">="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.GE_OP; }
"=="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.EQ_OP; }
"!="			{ yyparser.yylval = new ParserVal(yytext()); return Parser.NE_OP; }
("{"|"<%")		{ yyparser.yylval = new ParserVal(yytext()); return (int) '{'; }
("}"|"%>")		{ yyparser.yylval = new ParserVal(yytext()); return (int) '}'; }
","			{ yyparser.yylval = new ParserVal(yytext()); return (int) ','; }
":"			{ yyparser.yylval = new ParserVal(yytext()); return (int) ':'; }
"="			{ yyparser.yylval = new ParserVal(yytext()); return (int) '='; }
"("			{ yyparser.yylval = new ParserVal(yytext()); return (int) '('; }
")"			{ yyparser.yylval = new ParserVal(yytext()); return (int) ')'; }
("["|"<:")		{ yyparser.yylval = new ParserVal(yytext()); return (int) '['; }
("]"|":>")		{ yyparser.yylval = new ParserVal(yytext()); return (int) ']'; }
"."			{ yyparser.yylval = new ParserVal(yytext()); return (int) '.'; }
"&"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.AND_OP; }
"!"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '!'; }
"~"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '~'; }
"-"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '-'; }
"+"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '+'; }
"*"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '*'; }
"/"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '/'; }
"\\"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '\\'; }
"%"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '%'; }
"<"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '<'; }
">"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '>'; }
"^"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '^'; }
"|"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.OR_OP; }
"?"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '?'; }
"#"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '#'; }

{NL}                    { return Parser.NEWLINE; }
{WS}                    { }
.			{ /* ignore bad characters */ }