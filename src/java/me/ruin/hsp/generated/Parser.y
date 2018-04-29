%{
	import java.io.*;
	import java.util.*;
%}



/* BYACC Declarations */
%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN TYPE_NAME

%token TYPEDEF EXTERN STATIC AUTO REGISTER
%token CHAR SHORT INT LONG SIGNED UNSIGNED FLOAT DOUBLE CONST VOLATILE VOID
%token STRUCT UNION ENUM ELLIPSIS

%token VAR PVAL BMSCR PREFSTR PEXINFO NULLPTR STR SPTR ARRAY GOSUB

%token CASE DEFAULT IF ELSE SWITCH WHILE DO FOR GOTO CONTINUE BREAK RETURN

%token REPEAT LOOP

%token NEWLINE

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%start hsp_source
%%

hsp_source
        : chunk
        | hsp_source chunk
        ;

chunk
        : statement {
    if($1.sval != null) {
      //System.out.println($1.sval);
      curHunk += "\n";

   if(hunkFound) {
     startHunk(hunkName, curHunk);
     curHunk = "";
     hunkName = "";
   } else {
      curHunk += $1.sval;
   }
    }
 }
        | NEWLINE
        |
        ;

macro
       : '#' IDENTIFIER args {
      System.out.println($2.sval);
  switch($3.sval) {
    case "defcfunc":
    case "deffunc":
    default:
      String[] spl = $3.sval.split(",");
      $$ = new ParserVal("}\r\nfun " + $3.sval + "(" + $4.sval + "): Int {");
      break;
  }
 }
        | '#' IDENTIFIER
        ;

args
        : primary_expression args
        | lis
        |
        ;

lis
        : lis ',' type_specifier IDENTIFIER { $$ = new ParserVal($4.sval + ": " + $3.sval + ", " + $1.sval); }
        | lis ',' type_specifier { $$ = new ParserVal("hoge: " + $3.sval + ", " + $1.sval); }
        | type_specifier IDENTIFIER { $$ = new ParserVal($2.sval + ": " + $1.sval); }
        | type_specifier { $$ = new ParserVal("hoge: " + $1.sval); }
        ;

// from c

statement
	: labeled_statement NEWLINE
	| compound_statement NEWLINE
	| expression_statement NEWLINE
	| selection_statement // newline exceptional case
	| iteration_statement NEWLINE
	| jump_statement NEWLINE
        | macro NEWLINE
	;

primary_expression
	: lis
        | CONSTANT
	| STRING_LITERAL
        | IDENTIFIER
        | SWITCH // it's more like a function here
        | CASE
        | WHILE // while(LoopCount < 20)
        | BREAK
	| '(' expression ')' { $$ = new ParserVal("(" + $2.sval + ")"); }
	;

postfix_expression
	: primary_expression
        | REPEAT expression ',' expression { $$ = new ParserVal("for(i in " + $2.sval + " until " + $4.sval + ") {"); }
        | REPEAT expression { $$ = new ParserVal("for(i in 0 until " + $2.sval + ") {"); }
        | REPEAT { $$ = new ParserVal("while(true) {"); }
        | LOOP { $$ = new ParserVal("}"); }
	| postfix_expression '[' expression ']' { $$ = new ParserVal($1.sval + "[" + $2.sval + "]"); }
	| postfix_expression '(' ')' { $$ = new ParserVal($1.sval + "()"); }
        | postfix_expression argument_expression_list {
          switch($2.sval.charAt(0)) {
            case '+':
            case '-':
            case '*':
            case '/':
            case '%':
              $$ = new ParserVal($1.sval + " " + $2.sval );
            break;
            default:
              $$ = new ParserVal($1.sval + "(" + $2.sval + ")" );
              break;
          }
 }
        | postfix_expression '(' argument_expression_list ')' {
          String[] vals = $3.sval.split(", ");

          $$ = new ParserVal($1.sval + "[" + String.join("][", vals) + "]");
          }
	| postfix_expression '.' IDENTIFIER
	| postfix_expression PTR_OP STRING_LITERAL args //var_512->"Navigate" var_1102
        | postfix_expression jump_statement
	| postfix_expression INC_OP
	| postfix_expression DEC_OP
	;

argument_expression_list
        : assignment_expression
	| argument_expression_list ',' assignment_expression { $$ = new ParserVal($1.sval + ", " + $3.sval);}
        | argument_expression_list ','  { $$ = new ParserVal($1.sval + ", null"); } // gmode 6, , , 80
        ;

unary_expression
        : postfix_expression
	| unary_operator cast_expression {
        if ($1.sval.charAt(0) == '-') {
          $$ = new ParserVal($1.sval + $2.sval);
        } else {
          $$ = new ParserVal($1.sval + " " + $2.sval);
        }
        }
	;

unary_operator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

cast_expression
	: unary_expression
	| '(' type_name ')' cast_expression
	;

multiplicative_expression
	: cast_expression
	| multiplicative_expression '*' cast_expression { $$ = new ParserVal($1.sval + " * " + $3.sval); }
	| multiplicative_expression '/' cast_expression { $$ = new ParserVal($1.sval + " / " + $3.sval); }
	| multiplicative_expression '\\' cast_expression { $$ = new ParserVal($1.sval + " \\ " + $3.sval); }
	| multiplicative_expression '%' cast_expression { $$ = new ParserVal($1.sval + " % " + $3.sval); }
	;

additive_expression
	: multiplicative_expression
	| additive_expression '+' multiplicative_expression { $$ = new ParserVal($1.sval + " + " + $3.sval); }
	| additive_expression '-' multiplicative_expression { $$ = new ParserVal($1.sval + " - " + $3.sval); }
	;

shift_expression
	: additive_expression
	| shift_expression LEFT_OP additive_expression
	| shift_expression RIGHT_OP additive_expression
	;

relational_expression
	: shift_expression
	| relational_expression '<' shift_expression { $$ = new ParserVal($1.sval + " < " + $3.sval); }
	| relational_expression '>' shift_expression { $$ = new ParserVal($1.sval + " > " + $3.sval); }
	| relational_expression LE_OP shift_expression { $$ = new ParserVal($1.sval + " <= " + $3.sval); }
	| relational_expression GE_OP shift_expression { $$ = new ParserVal($1.sval + " >= " + $3.sval); }
	;

equality_expression
	: relational_expression
	| equality_expression EQ_OP relational_expression { $$ = new ParserVal($1.sval + " == " + $3.sval); }
	| equality_expression NE_OP relational_expression { $$ = new ParserVal($1.sval + " != " + $3.sval); }
	;

logical_and_expression
	: equality_expression
	| logical_and_expression AND_OP equality_expression { $$ = new ParserVal($1.sval + " && " + $3.sval); }
	;

logical_or_expression
	: logical_and_expression
	| logical_or_expression OR_OP logical_and_expression { $$ = new ParserVal($1.sval + " || " + $3.sval); }
	;

conditional_expression
	: logical_or_expression
	| logical_or_expression '?' expression ':' conditional_expression
	;

assignment_expression
	: conditional_expression
	| unary_expression assignment_operator assignment_expression { $$ = new ParserVal($1.sval + " " + $2.sval + " " + $3.sval); }
	;

assignment_operator
	: '='
	| MUL_ASSIGN { $$ = new ParserVal("*="); }
	| DIV_ASSIGN { $$ = new ParserVal("/="); }
	| MOD_ASSIGN { $$ = new ParserVal("%="); }
	| ADD_ASSIGN { $$ = new ParserVal("+="); }
	| SUB_ASSIGN { $$ = new ParserVal("-="); }
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

expression
	: assignment_expression
	| expression ',' assignment_expression
	;

constant_expression
	: conditional_expression
	;

declaration
	: declaration_specifiers
	| declaration_specifiers init_declarator_list
	;

declaration_specifiers
	: type_specifier
	| type_specifier declaration_specifiers
	| type_qualifier
	| type_qualifier declaration_specifiers
	;

init_declarator_list
	: init_declarator
	| init_declarator_list ',' init_declarator { $$ = new ParserVal($1.sval + ", " + $3.sval); }
	;

init_declarator
	: declarator
	| declarator '=' initializer { $$ = new ParserVal($1.sval + " = " + $3.sval); }
	;

type_specifier
	: VOID
	| CHAR
	| SHORT
	| INT { $$ = new ParserVal("Int"); }
	| LONG { $$ = new ParserVal("Long"); }
	| FLOAT { $$ = new ParserVal("Float"); }
	| DOUBLE { $$ = new ParserVal("Double"); }
	| SIGNED
	| UNSIGNED
	| struct_or_union_specifier
	| enum_specifier
	| TYPE_NAME
        | VAR
        | PVAL
        | BMSCR
        | PREFSTR
        | PEXINFO
        | NULLPTR
        | STR { $$ = new ParserVal("String"); }
        | SPTR
        | ARRAY
	;

struct_or_union_specifier
	: struct_or_union IDENTIFIER '{' struct_declaration_list '}'
	| struct_or_union '{' struct_declaration_list '}'
	| struct_or_union IDENTIFIER
	;

struct_or_union
	: STRUCT
	| UNION
	;

struct_declaration_list
	: struct_declaration
	| struct_declaration_list struct_declaration
	;

struct_declaration
	: specifier_qualifier_list struct_declarator_list
	;

specifier_qualifier_list
	: type_specifier specifier_qualifier_list
	| type_specifier
	| type_qualifier specifier_qualifier_list
	| type_qualifier
	;

struct_declarator_list
	: struct_declarator
	| struct_declarator_list ',' struct_declarator
	;

struct_declarator
	: declarator
	| ':' constant_expression
	| declarator ':' constant_expression
	;

enum_specifier
	: ENUM '{' enumerator_list '}'
	| ENUM IDENTIFIER '{' enumerator_list '}'
	| ENUM IDENTIFIER
	;

enumerator_list
	: enumerator
	| enumerator_list ',' enumerator
	;

enumerator
	: IDENTIFIER
	| IDENTIFIER '=' constant_expression { $$ = new ParserVal($1.sval + " = " + $3.sval); }
	;

type_qualifier
	: CONST
	| VOLATILE
	;

declarator
	: direct_declarator
	;

direct_declarator
	: IDENTIFIER
	| '(' declarator ')' { $$ = new ParserVal("(" + $2.sval + ")"); }
        | direct_declarator '[' constant_expression ']' { $$ = new ParserVal($1.sval + "[" + $3.sval + "]"); }
        | direct_declarator '[' ']' { $$ = new ParserVal($1.sval + "[]"); }
        | direct_declarator '(' parameter_type_list ')' { $$ = new ParserVal($1.sval + "(" + $3.sval + ")"); }
        | direct_declarator '(' identifier_list ')' { $$ = new ParserVal($1.sval + "(" + $3.sval + ")"); }
        | direct_declarator '(' ')' { $$ = new ParserVal($1.sval + "()"); }
	;

type_qualifier_list
	: type_qualifier
	| type_qualifier_list type_qualifier
	;


parameter_type_list
	: parameter_list
	| parameter_list ',' ELLIPSIS { $$ = new ParserVal($1.sval + "..."); }
	;

parameter_list
	: parameter_declaration
	| parameter_list ',' parameter_declaration { $$ = new ParserVal($1.sval + ", " + $3.sval); }
	;

parameter_declaration
	: declaration_specifiers declarator
	| declaration_specifiers abstract_declarator
	| declaration_specifiers
	;

identifier_list
	: IDENTIFIER
	| identifier_list ',' IDENTIFIER { $$ = new ParserVal($1.sval + ", " + $3.sval); }
	;

type_name
	: specifier_qualifier_list
	| specifier_qualifier_list abstract_declarator
	;

abstract_declarator
	: direct_abstract_declarator
	;

direct_abstract_declarator
	: '(' abstract_declarator ')'
	| '[' ']'
	| '[' constant_expression ']'
	| direct_abstract_declarator '[' ']'
	| direct_abstract_declarator '[' constant_expression ']' { $$ = new ParserVal($1.sval + "[" + $3.sval + "]"); }
	| '(' ')'
	| '(' parameter_type_list ')' { $$ = new ParserVal("(" + $2.sval + ")"); }
	| direct_abstract_declarator '(' ')' { $$ = new ParserVal($1.sval + "()"); }
	| direct_abstract_declarator '(' parameter_type_list ')' { $$ = new ParserVal($1.sval + "(" + $3.sval + ")"); }
	;

initializer
	: assignment_expression
	| '{' initializer_list '}' { $$ = new ParserVal(" { " + $2.sval +" } " ); }
	| '{' initializer_list ',' '}' { $$ = new ParserVal(" { " + $2.sval +" } " ); }
	;

initializer_list
	: initializer
	| initializer_list ',' initializer { $$ = new ParserVal($1.sval + ", " + $3.sval); }
	;

// TODO: Return statement right before a label can be converted into a function in some cases?
// TODO: Two labels right next to each other can be consolidated
// TODO: A label followed by a goto is unnecessary indirection
// TODO: What about conditional labels based on gosub/goto?
// TODO: Duplicate hunks based on if they contain return or not and can be reached by both goto and gosub
// TODO: Rewrite all defcfunc with label immediately following to use while(true) and break

labeled_statement
: '*' IDENTIFIER { hunkFound = true; hunkName = $2.sval; $$ = new ParserVal("*" + $2.sval); }
	;

compound_statement
	: '{' NEWLINE '}'
	| '{' NEWLINE statement_list '}' { $$ = $3; }
        | '{' NEWLINE declaration_list '}' { $$ = $3; }
        | '{' NEWLINE declaration_list statement_list '}' { $$ = $3; }
	;

declaration_list
	: declaration { $$ = new ParserVal($1.sval); }
	| declaration_list declaration { $$ = new ParserVal($1.sval + "\r\n" + $2.sval); }
	;

statement_list
        : statement { $$ = new ParserVal($1.sval); }
        | statement_list statement { $$ = new ParserVal($1.sval + "\r\n" + $2.sval); }
	;

expression_statement
	: expression
        | expression jump_statement { $$ = new ParserVal("if (" + $1.sval + ") { " + $2.sval + " } "); }// onerror goto *label_0241
	;

selection_statement
        : IF '(' expression ')' statement %prec LOWER_THAN_ELSE {
          $$ = new ParserVal("if (" + $3.sval + ") {\r\n " + $5.sval + "\r\n}");
        }
        | IF '(' expression ')' statement ELSE statement {
          $$ = new ParserVal("if (" + $3.sval + ") {\r\n " + $5.sval + "\r\n}\r\nelse {\r\n " + $7.sval + ";\r\n}");
        }
        ;

iteration_statement
	: WHILE '(' expression ')' statement
	| DO statement WHILE '(' expression ')'
	| FOR '(' expression_statement expression_statement ')' statement
	| FOR '(' expression_statement expression_statement expression ')' statement
	;

jump_statement
        : GOTO '*' IDENTIFIER { $$ = new ParserVal("*goto " + $3.sval); }
        | GOTO STRING_LITERAL ',' '*' IDENTIFIER { $$ = new ParserVal("goto_button_" + $5.sval + "(" + $2.sval + ")"); } //button goto "refresh", *label_1984
	| GOSUB '*' IDENTIFIER { $$ = new ParserVal("*gosub " + $3.sval); }
	| GOSUB STRING_LITERAL ',' '*' IDENTIFIER { $$ = new ParserVal("gosub_button_" + $5.sval + "(" + $2.sval + ")"); } //button gosub "fill", *label_1997
	| CONTINUE
	| CONTINUE expression { $$ = new ParserVal("continue; //" + $2.sval); }
	| BREAK
	| RETURN
	| RETURN expression { $$ = new ParserVal("*return " + $2.sval); }
	;

%%

        public List<String> hunks = new ArrayList<String>();
boolean hunkFound = false;
String curHunk = "";
String hunkName = "";

public void startHunk(String name, String arg) {
hunks.add(name + "\n" + arg);
hunkFound = false;
}

	// Referencia ao JFlex
	private Yylex lexer;

	/* Interface com o JFlex */
	private int yylex(){
          //System.out.println("ptr: " + stateptr + " ptrmax: " + stateptrmax);
		int yyl_return = -1;
		try {
			yyl_return = lexer.yylex();
		} catch (IOException e) {
			System.err.println("Erro de IO: " + e);
		}
		return yyl_return;
	}

	/* Reporte de erro */
	public void yyerror(String error){
          System.err.println("Error: " + error + " " + lexer.yystate() + " " + lexer.yytext());
        }

        // Interface com o JFlex eh criado no construtor
        public Parser(Reader r, boolean debug){
                yydebug = debug;
		lexer = new Yylex(r, this);
	}

	// Main
	public static void main(String[] args){
		try{
                        boolean debug = args[0].contains("test");
                        Parser yyparser = new Parser(new FileReader(args[0]), debug);
			yyparser.yyparse();
                for(int i = 0; i < yyparser.hunks.size(); i++) {
                  System.out.println(yyparser.hunks.get(i) + "\n===========\n");
                }
			} catch (Exception ex) {
				System.err.println("Error: " + ex);
			}
	}

public class Hunk {
  public List<String> entrances = new ArrayList<>();
  public List<String> exits = new ArrayList<>();
}

public class Entrance {
  String fromLabel;
  boolean isGosub;
  boolean isFallthrough;
}

public class Exit {
  String toLabel;
  boolean isReturn;
  boolean unconditional; // not nested in an if
}
