MessageBox(code, ByRef CSCode, ByRef FuncCode, ByRef assembly)
{
    split := StrSplit(code, ",", A_Space)
    assembly := "System.Windows.Forms.dll"
    CSCode := "MsgBox(" ToCSString(split[2]) ");"
    FuncCode := "public static void MsgBox(object outString){System.Windows.Forms.MessageBox.Show(outString.ToString());}"
}

ToCSString(line)
{
    line := Trim(line)
    if (substr(line, 1, 2) = "% ") ;for variables
    {
        return ToCSString(SubStr(line, 3))
    }
    string := StrSplit(line)
    Tokens := Object()
    
    i := 0
    while (true)
    {
        i++
        if (i > string.MaxIndex())
        {
            if (Token != "")
                Tokens.Insert(Token)
            break
        }
        
        if (string[i] = """")
        {
            inLiteral := !inLiteral
            Token := Token """"
            
            if (!inLiteral)
            {
                Tokens.Insert(Token)
                Token := ""
            }
            continue
        }
        
        if (inLiteral)
        {
            Token := Token string[i]
            continue
        }
        
        if (string[i] = "." || (string[i] = A_Space && Token != ""))
        {
            Tokens.Insert(Token)
            Token := ""
        }
        
        Token := Token string[i]
    }
    
    FinalString := ""
    
    Loop, % Tokens.MaxIndex()
        FinalString := (FinalString = "")? Tokens[A_Index] : FinalString " + " Tokens[A_Index]
    return FinalString
    
}

;~ MsgBox, % ToCSString("% ""qwe"" asd ""qweqwe"" asdasd")