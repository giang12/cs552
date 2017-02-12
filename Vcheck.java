import java.io.*;
import java.util.*;
////////////////////////////////////////////////////////////
//
// Vcheck:
// Simple Verilog scanner for checking for keywords
// and constructs that are not allowed in
// Prof. Wood's Spring-06 CS/ECE 552 class.
//
// Andy Phelps  31 Jan 06
//
// This program checks for:
//    illegal keywords (*many* of them -- see "badWords" below)
//    improper sequence of "always", "@", "case(x)", "endcase"
//    "begin" not associated with case(x)
//    any begin, always, or case(x) statement if
//         constant CASE_OK below is false
//    === or !== or ->
//    a simple gate that has drive strength or delay
//    add, subtract, multiply, divide, modulo inside "assign"
//    shift by an amount that's a variable
//
// Possible future enhancements:
//    Allow a shift by an amount that's a parameter
//    Check that all values used in a case appear in the "always"
//    Check that the module parameter list matches
//      the input/output statements
//
////////////////////////////////////////////////////////////

class VerFile {

  StreamTokenizer st;
  int token;
  public String nextToken;
  String name;

  public VerFile (String name) {
    this.name = name;
    Reader r = null;

    try {
      r = new FileReader(name);
    }
    catch (FileNotFoundException e) {
      System.out.println("Could not open Verilog source file "+name);
      System.exit(-1);
    }

    // Set up stream tokenizer and give it rules for how to classify characters

    st = new StreamTokenizer(r);

    st.resetSyntax();
    st.slashSlashComments(true);
    st.slashStarComments(true);
    st.quoteChar('"');
    //st.quoteChar('\'');
    st.whitespaceChars(0, ' ');
    st.wordChars('A', 'Z');
    st.wordChars('a', 'z');
    st.wordChars('_', '_');
    st.wordChars('$', '$');
    st.wordChars('0', '9');
    st.wordChars('\'', '\'');

    nextToken = getTokenUnbuf();
  }

  
  int lineno() {
    return st.lineno();
  }

  String getToken () {
    String temp = nextToken;
    nextToken = getTokenUnbuf();
    return temp;
  }

  String getTokenUnbuf () {
    String partial = null;
    while (true) {
      try {
        token = st.nextToken();
      }
      catch (IOException ioe) {
        System.out.println("Error reading Verilog source file "+name);
        System.exit(-1);
      }
      if (token == st.TT_EOF) {
        return null;
      }
      char [] firstChar = new char [1];
      firstChar[0] = (char) token;
      if (partial == null) {
        if (token == st.TT_WORD || token == st.TT_NUMBER) {
          return st.sval;
        }
        else if (token == '\'') {
          return "'"+st.sval+"'";
        }
        else if (token == '"') {
          return "\""+st.sval+"\"";
        }
        else {
          if ((token == '<') ||
              (token == '>') ||
              (token == '-') ||
              (token == '&') ||
              (token == '|') ||
              (token == '!') ||
              (token == '='))  {
            partial = new String(firstChar);
            continue;
          }
          else return new String(firstChar);
        }
      }
      else {   // partial non-null
        // These combinations must be done; they can't continue
        if ((partial.equals("<") && token == '=') ||
            (partial.equals(">") && token == '=') ||
            (partial.equals("-") && token == '>') ||
            (partial.equals("&") && token == '&') ||
            (partial.equals("|") && token == '|') ||
            (partial.equals("<<") && token == '<')||
            (partial.equals(">>") && token == '>')||
            (partial.equals("==") && token == '=')||
            (partial.equals("!=") && token == '=')) {
          String tempPartial = partial;
          partial = null;
          return tempPartial + new String(firstChar);
        }
        // These combinations might or might not continue
        else if ((partial.equals("<") && token == '<') ||
                 (partial.equals(">") && token == '>') ||
                 (partial.equals("=") && token == '=') ||
                 (partial.equals("!") && token == '=')) {
          partial += new String(firstChar);
          continue;
        }          
        else {
          String tempPartial = partial;
          partial = null;
          st.pushBack();
          return tempPartial;
        }
      }
    }
  }
}

class Vcheck {

  public static final boolean CASE_OK = true;

  public static void main (String [] argv) {
    if (argv.length != 1) {
      System.out.println("Usage: java Vcheck <filename>");
      System.exit(-1);
    }
    Vcheck vc = new Vcheck(argv[0]);
  }

  Vcheck (String name) {

    // Input file tokenizer
    VerFile vf = new VerFile(name);

    // Make list of primitive gate types in a hashtable
    HashSet gates = new HashSet(10);
    gates.add("and");
    gates.add("nand");
    gates.add("or");
    gates.add("nor");
    gates.add("xor");
    gates.add("xnor");
    gates.add("not");

    // Make list of blacklisted keywords in a hashtable
    HashSet badWords = new HashSet(100);
    badWords.add("===");
    badWords.add("!==");
    badWords.add("->");
    badWords.add("attribute");
    badWords.add("buf");
    badWords.add("bufif0");
    badWords.add("bufif1");
    badWords.add("casez");
    badWords.add("cmos");
    badWords.add("deassign");
    badWords.add("disable");
    badWords.add("edge");
    badWords.add("else");
    badWords.add("endattribute");
    badWords.add("endfunction");
    badWords.add("endprimitive");
    badWords.add("endspecify");
    badWords.add("endtable");
    badWords.add("endtask");
    badWords.add("event");
    badWords.add("for");
    badWords.add("forever");
    badWords.add("fork");
    badWords.add("function");
    badWords.add("highz0");
    badWords.add("highz1");
    badWords.add("if");
    badWords.add("ifnone");
    badWords.add("initial");
    badWords.add("inout");
    badWords.add("integer");
    badWords.add("join");
    badWords.add("medium");
    badWords.add("large");
    badWords.add("macromodule");
    badWords.add("negedge");
    badWords.add("nmos");
    badWords.add("notif0");
    badWords.add("notif1");
    badWords.add("pmos");
    badWords.add("posedge");
    badWords.add("primitive");
    badWords.add("pull0");
    badWords.add("pull1");
    badWords.add("pulldown");
    badWords.add("pullup");
    badWords.add("rcmos");
    badWords.add("real");
    badWords.add("realtime");
    badWords.add("release");
    badWords.add("repeat");
    badWords.add("rnmos");
    badWords.add("rpmos");
    badWords.add("rtran");
    badWords.add("rtranif0");
    badWords.add("rtranif1");
    badWords.add("scalared");
    badWords.add("signed");
    badWords.add("small");
    badWords.add("specify");
    badWords.add("specparam");
    badWords.add("strength");
    badWords.add("strong0");
    badWords.add("strong1");
    badWords.add("supply0");
    badWords.add("supply1");
    badWords.add("table");
    badWords.add("task");
    badWords.add("time");
    badWords.add("tran");
    badWords.add("tranif0");
    badWords.add("tranif1");
    badWords.add("tri");
    badWords.add("tri0");
    badWords.add("tri1");
    badWords.add("triand");
    badWords.add("trior");
    badWords.add("trireg");
    badWords.add("unsigned");
    badWords.add("vectored");
    badWords.add("wait");
    badWords.add("wand");
    badWords.add("weak0");
    badWords.add("weak1");
    badWords.add("while");
    badWords.add("wor");

    // state variables for primitive parsing:
    boolean foundAlways = false;    // Have seen an "always"
    int     alwaysLineno = 0;       // Line number of last "always" statement
    boolean foundCase = false;      // Have seen a case or casex
    boolean foundEndmodule = false; // Have seen endmodule (ie, really to got the end)
    boolean foundAssign = false;    // Inside an "assign" statement
    int     bracketLevel = 0;       // How deep inside nested brackets

    int hashValue = 0;  // Generate a hash of the Verilog input; this demonstrates
                        // that the program was actually run instead of someone
                        // just copying the output

    while (true) {
      String tok = vf.getToken();
      System.out.println("CHERIN: "+tok);
      if (tok == null) break;   // normal end-of-file
      hashValue = (hashValue << 1) ^ (hashValue >>> 31) ^ (int)tok.charAt(0);

      // Look for simple gates:  and, or, not, etc.
      // A simple gate must be followed by an instance name, not a drive strength or delay
      if (gates.contains(tok)) {
        if (vf.nextToken.equals("#")) {
          System.out.println("Line "+vf.lineno()+": Delay specifier not allowed");
        }
        else if (vf.nextToken.equals("(")) {
          System.out.println("Line "+vf.lineno()+": Drive strength specifier not allowed");
        }
      }

      // Keep track of when we're inside assign statements;
      // this is for checks for illegal arithmetic and shift ops.
      // Any semicolon is deemed to end an assign statement.
      if (tok.equals("assign")) {
        foundAssign = true;
      }
      else if (tok.equals(";")) {
        foundAssign = false;
      }

      // Keep track of when we're inside brackets.
      // Arithmetic is OK but only inside brackets.
      if (tok.equals("[")) {
        bracketLevel++;
      }
      else if (tok.equals("]")) {
        bracketLevel--;
      }
      else if (tok.equals("+") ||
               tok.equals("-") ||
               tok.equals("*") ||
               tok.equals("/") ||
               tok.equals("%") ||
               tok.equals("<") ||
               tok.equals(">") ||
               tok.equals("<=")||
               tok.equals(">=")) {
        if (bracketLevel == 0 && foundAssign == true) {
          System.out.println("Line "+vf.lineno()+": Arithmetic inside assign statement: "+tok);
        }
      }

      // Look for word in hash table of blacklisted keywords
      else if (badWords.contains(tok)) {
        System.out.println("Line "+vf.lineno()+": Bad keyword "+tok);
      }

      // Look for "always"; it must be followed by case or casex
      // An "always" must be followed by '@' (but without posedge/negedge)
      if (tok.equals("always")) {
        if (!vf.nextToken.equals("@")) {
          System.out.println("Line "+vf.lineno()+": Expected '@' after 'always'");
        }
        if (!CASE_OK) {
          System.out.println("Line "+vf.lineno()+": 'always' statements not permitted");
        }
        else if (foundAlways) {
          System.out.println("Line "+alwaysLineno+": Always without case(x)");
        }
        if (foundCase) {
          System.out.println("Line "+vf.lineno()+": No endcase before next always");
        }
        foundAlways = true;
        alwaysLineno = vf.lineno();
        foundCase = false;
      }
        
      // Look for shift by a non-constant amount.
      // Danger:  We should allow this if the variable is actually a
      // parameter.
      if (tok.equals(">>") || tok.equals("<<")) {
        char nextChar = vf.nextToken.charAt(0);
        if (Character.isLetter(nextChar)) {
          System.out.println("Line "+vf.lineno()+": appears to be shifting by non-constant value: "+vf.nextToken);
        }
      }

      // Look for case(x); it must follow an always
      else if (tok.equals("case") || tok.equals("casex")) {
        if (!CASE_OK) {
          System.out.println("Line "+vf.lineno()+": '"+tok+"' statements not permitted");
        }
        else if (!foundAlways) {
          System.out.println("Line "+vf.lineno()+": Case(x) without always");
        }
        foundCase = true;
        foundAlways = false;
      }
      else if (tok.equals("endcase")) {
        foundCase = false;
      }

      // 'begin' must be after an always or case
      else if (tok.equals("begin")) {
        if (!CASE_OK) {
          System.out.println("Line "+vf.lineno()+": '"+tok+"' statements not permitted");
        }
        else if (!foundCase && !foundAlways) {
          System.out.println("Line "+vf.lineno()+": begin without always/case");
        }
      }

      // double-check that we get to the end of (at least one) module
      else if (tok.equals("endmodule")) {
        foundEndmodule = true;
        if (foundAlways && CASE_OK) {
          System.out.println("Line "+alwaysLineno+": Always without case(x)");
        }
        foundAlways = false;
      }
    }
    if (!foundEndmodule) {
      System.out.println("Line "+vf.lineno()+": No endmodule found");
    }
    System.out.println("End of file "+name+". Hash = "+hashValue);
  }
}
