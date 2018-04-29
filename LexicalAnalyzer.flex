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

"auto"			{ return Parser.AUTO; }
"break"			{ return Parser.BREAK; }
"char"			{ return Parser.CHAR; }
"const"			{ return Parser.CONST; }
"continue"		{ return Parser.CONTINUE; }
"do"			{ return Parser.DO; }
"double"		{ return Parser.DOUBLE; }
"else"			{ return Parser.ELSE; }
"enum"			{ return Parser.ENUM; }
"extern"		{ return Parser.EXTERN; }
"float"			{ return Parser.FLOAT; }
"for"			{ return Parser.FOR; }
"goto"			{ return Parser.GOTO; }
"gosub"			{ return Parser.GOSUB; }
"if"			{ return Parser.IF; }
"int"			{ return Parser.INT; }
"long"			{ return Parser.LONG; }
"register"		{ return Parser.REGISTER; }
"return"		{ return Parser.RETURN; }
"short"			{ return Parser.SHORT; }
"signed"		{ return Parser.SIGNED; }
"sizeof"		{ return Parser.SIZEOF; }
"static"		{ return Parser.STATIC; }
"struct"		{ return Parser.STRUCT; }
"typedef"		{ return Parser.TYPEDEF; }
"union"			{ return Parser.UNION; }
"unsigned"		{ return Parser.UNSIGNED; }
"void"			{ return Parser.VOID; }
"volatile"		{ return Parser.VOLATILE; }

"var"     { return Parser.VAR; }
"str"     { return Parser.STR; }
"sptr"    { return Parser.SPTR; }
"pval"    { return Parser.PVAL; }
"bmscr"   { return Parser.BMSCR; }
"prefstr" { return Parser.PREFSTR; }
"pexinfo" { return Parser.PEXINFO; }
"nullptr" { return Parser.NULLPTR; }
"array"   { return Parser.ARRAY; }

{L}({L}|{D})*		{ yyparser.yylval = new ParserVal(yytext()); return Parser.IDENTIFIER; }

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
"&&"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.AND_OP; }
"||"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.OR_OP; }
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
"&"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.OR_OP; }
"!"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '!'; }
"~"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '~'; }
"-"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '-'; }
"+"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '+'; }
"*"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '*'; }
"/"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '/'; }
"%"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '%'; }
"<"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '<'; }
">"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '>'; }
"^"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '^'; }
"|"			{ yyparser.yylval = new ParserVal(yytext()); return Parser.AND_OP; }
"?"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '?'; }
"#"			{ yyparser.yylval = new ParserVal(yytext()); return (int) '#'; }

{NL}                    { return Parser.NEWLINE; }
{WS}                    { }
.			{ /* ignore bad characters */ }