#Include, CLR.ahk
#Include, CompileFunctions.ahk

AHKCode =
(LTrim
    qwe := "asd"
    MsgBox, `% qwe
    MsgBox, `% "mb"
)




;~ CLR_Start()

;~ cSharp =
;~ (
;~ )
 
;~ FileName := A_ScriptDir "\HelloWorld.exe"
;~ CLR_CompileC#( cSharp, "System.dll",, FileName ) 
 
;~ Run % FileName

FileName := "qwe.exe"
Compile(AHKCode, FileName)
Run % FileName

Compile(AHKCode, FileName)
{
    CSCode := ""
    FuncCode := ""
    assembly := ""
    
    FinalCode =
    (LTrim
    class Program
    {
        public static void Main()
        {
    )
    Loop, Parse, AHKCode, `n
    {
        AHKtoCS(A_LoopField, CSCode, FuncCode, assembly)
        ;~ MsgBox, % A_LoopField "`n" CSCode "`n" FuncCode "`n" assembly
    }
    
    FinalCode := FinalCode "`n" CSCode "`n}`n" FuncCode "`n}"
    MsgBox, % FinalCode
    CLR_CompileC#(FinalCode, assembly,, FileName)
}

AHKtoCS(code, ByRef CSCode, ByRef FuncCode, ByRef assembly)
{
    _CSCode := ""
    _FuncCode := ""
    _assembly := ""
    
    if (InStr(code, ":="))
    {
        left := Trim(SubStr(code, 1, InStr(code, ":=") - 1)), right := Trim(SubStr(code, InStr(code, ":=") + 2))
        _CSCode := "object " left " = " ToCSString(right) ";"
        CSCode := (CSCode = "")? _CSCode : CSCode "`n" _CSCode
    }
    else if (RegExMatch(code, "(\w+),", OutVar)) ;command
    {
        Func(Dictionary(OutVar1)).Call(code, _CSCode, _FuncCode, _assembly)
        CSCode := (CSCode = "")? _CSCode : CSCode "`n" _CSCode
        FuncCode := NoRepeatAdd(FuncCode, _FuncCode)
        assembly := NoRepeatAdd(assembly, _assembly, "|")
    }
}

NoRepeatAdd(Block, code, Delimit := "`n")
{
    if (InStr(Block, code))
        return Block
    if (Block = "")
        return code
    return Block Delimit code
}

Dictionary(fAHK)
{
    if (fAHK = "MsgBox")
        return, "MessageBox"
}