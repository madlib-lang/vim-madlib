if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "madlib"

syntax sync fromstart
syntax case match

setlocal foldmethod=indent
setlocal foldignore=

syntax keyword madImport           import
       \   skipwhite skipempty 
highlight link madImport           Keyword

syntax keyword madPrelude          AssertionError Error ErrorWithMessage Wish Set Just Nothing Left Right String Boolean Integer Float
highlight link madPrelude          Type

syntax region  madParens
           \   start=+(+
           \   end=+)+
           \   contains=@madExpression,madComma,madSpread
           \   extend
           \   fold
           \   skipwhite skipempty
           \   nextgroup=madFatArrow,madFunctionCall,madDot,@madOperators
highlight link madParens           Statement 


syntax keyword madReturn           return 
           \   nextgroup=@madExpression
highlight link madReturn           Keyword

syntax keyword madBoolean          true false
highlight link madBoolean          Boolean

syntax match   madType             "\<[A-Z][a-zA-Z0-9_']*\>"
highlight link madType             Structure

syntax match   madTypeDef          "::"
highlight link madTypeDef          Special

syntax match   madTypeSig
      \   "^\s*\([a-zA-Z0-9_']*\(,\s*[_a-z][a-zA-Z0-9_']*#\?\)*\_s\+::\_s\)"
      \   contains=madIdentifier,madSkinnyArrow,madType,madParens,madTypeDef
highlight link madTypeSig          Typedef 

syntax match   madSeparator        "[,;]"
highlight link madSeparator        Noise

syntax match   madAssignment       "="
highlight link madAssignment       Operator

syntax match   madAssignmentColon  ":"
highlight link madAssignmentColon  Operator

syntax match   madFatArrow         "=>"
highlight link madFatArrow         Operator

syntax match   madSkinnyArrow      "->"
highlight link madSkinnyArrow      Operator

syntax keyword madMagicPlaceholder $
           \   nextgroup=madParens,madComma
highlight link madMagicPlaceholder PreProc

syntax match   madComma            +,+ contained
highlight link madComma            Operator

syntax match   madLogicalAnd       +&&+ contained
highlight link madLogicalAnd       Conditional

syntax match   madLogicalOr        +||+ contained
highlight link madLogicalOr        Conditional

syntax match   madOperators        "[-!$&\*\+<=>\?\\|.:\/]\+\|<_\>"
highlight link madOperators        Operator

syntax keyword madPipe             pipe
highlight link madPipe             Function 

syntax keyword madWhere            where
highlight link madWhere            Structure

syntax region  madParens
           \   matchgroup=madDelimiter
           \   start="(" end=")" 
           \   contains=TOP,@madTypeSig,@Spell,@madExpression
highlight link madParens           Statement 

" syntax match   madConstructor      "\<\K\k*\>\%(\_s*<)"
" highlight link madConstructor      StorageClass

" syntax match   madFunctionCall     "\<\<[a-z][a-zA-Z0-9_']*\>\>\((.{-})\)"
syntax match   madFunctionCall     +\<\K\k*\>\%(\_s*<\%(\_[^&|)]\{-1,}\%([&|]\_[^&|)]\{-1,}\)*\)>\)\?\%(\_s*\%(?\.\)\?\_s*(\)\@=+
           \   contains=madImport,@madExpression,madObject,madComma,madMagicPlaceholder,madNoBind
           \   skipwhite
           \   skipempty
           \   nextgroup=madFunctionCallArgs
highlight link madFunctionCall     Function

syntax region  madFunctionCallArgs
           \   matchgroup=madFunctionParens
           \   start=+(+
           \   end=+)+
           \   contained
           \   contains=@madExpression,madComma,madSpread,madNoBind,madMagicPlaceholder,madComment,madBlockComment
           \   skipwhite
           \   skipempty
           \   nextgroup=madAccessor,madFunctionCallArgs,madDot,madOptionalOperator,@madOperators

syntax keyword madExport           export
highlight link madExport           Underlined

syntax keyword madNoBind           _
           \   nextgroup=madParens,madOperators,madComma
highlight link madNoBind           Ignore 

syntax region  madFence start="#-" end="-#"
highlight link madFence            Define

syntax region  madBlockComment
           \   start="/\*" end="\*/"
           \   contains=madTodo,@Spell
highlight link madBlockComment     Comment

syntax match   madComment          "\v\/\/.*$"
highlight link madComment          Comment

" STRINGS & REGULAR EXPRESSIONS
syntax region  madTemplateExpression
           \   contained
           \   matchgroup=madTemplateBraces
           \   start=+${+
           \   end=+}+
           \   contains=@madExpression
           \   keepend

syntax region  madString
           \   start=+\z(["']\)+
           \   skip=+\\\%(\z1\|$\)+
           \   end=+\z1+
           \   end=+$+
           \   contains=madSpecial
           \   extend
highlight link madString           String


syntax match   madTemplateStringTag +\<\K\k*\>\%(\_s*`\)\@=+ skipwhite skipempty nextgroup=madTemplateString
syntax region  madTemplateString start=+`+ skip=+\\\\\|\\`\|\\\n+ end=+`+ contains=madTemplateExpression,@Spell skipwhite skipempty nextgroup=madAccessor,madDot,@madOperators
syntax region  madTemplateExpression matchgroup=madTemplateBrace start=+\%([^\\]\%(\\\\\)*\)\@<=${+ end=+}+ contained contains=@madExpression

syntax match   madNumber           "\v<\-?\d*\.?\d+>"
highlight link madNumber           Number

" Object
syntax region  madObject
           \   matchgroup=madObjectBraces
           \   start=+{+
           \   end=+}+
           \   contained
           \   contains=madComment,madIdentifier,madObjectKey,madObjectKeyString,madMethod,madComputed,madMethodType,madComma,madSpread,madExpression
           \   skipwhite
           \   skipempty
syntax match   madObjectKey +\<\k\+\>\ze\s*:+ contained skipwhite skipempty nextgroup=madAssignmentColon
syntax region  madObjectKeyString start=+\z(["']\)+ skip=+\\\\\|\\\z1\|\\\n+ end=+\z1+ contained contains=@Spell skipwhite skipempty nextgroup=madAssignmentColon

syntax keyword madWhere            where
           \   nextgroup=madWhereBlock
highlight link madWhere            Label 

" syntax region  madWhereBlock       
"            \   start="{" end="}"
"            \   matchgroup=madWhereBraces
"            \   contains=TOP,@Spell,madConstructor,madFatArrow,@madExpression
"            \   nextgroup=madParens,madComma


syntax cluster   madTop
             \   contains=madBlock,madParen,madImport,madExport,madComment,madIdentifier,madString,madTempalteString,madTemplateStringTag,madNumber,madArray,madReturn,madFunction,madFunctionCall,madWhere
syntax cluster   madExpression
             \   contains=madComment,madString,madTemplateString,madTemplateStringTag,madNumber,madArray,madObject,madIdentifier,madParens
