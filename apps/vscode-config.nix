{lib, zsh}: 

{
  settings = {
    files = {
      autoSave = "afterDelay";
      trimFinalNewlines = true;
      insertFinalNewline = true;
      trimTrailingWhitespace = true;
    };

 
    
    files.watcherExclude = {
       "**/.bloop" =  true;
       "**/.metals" = true;
       "**/.ammonite" = true;
       "**/.*cache" = true;
    };

    editor = {
      tabSize = 2;
      rulers = [ 120 ];
      formatOnPaste = true;
      formatOnSave = true;
      lineNumbers = "relative";
      renderControlCharacters = "true";
      renderWhitespace = "boundary";
    };
  };
}
