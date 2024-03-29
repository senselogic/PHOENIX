/*
    This file is part of the Phoenix distribution.

    https://github.com/senselogic/PHOENIX

    Copyright (C) 2017 Eric Pelzer (ecstatic.coder@gmail.com)

    Phoenix is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, version 3.

    Phoenix is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with Phoenix.  If not, see <http://www.gnu.org/licenses/>.
*/

// -- IMPORTS

import core.stdc.stdlib : exit;
import core.thread;
import std.conv : to;
import std.datetime : Clock, SysTime;
import std.file : dirEntries, exists, mkdirRecurse, readText, timeLastModified, write, SpanMode;
import std.stdio : writeln;
import std.string : endsWith, indexOf, join, lastIndexOf, replace, split, startsWith, stripRight, toUpper;

// -- TYPES

// .. LANGUAGE_TYPE

enum LANGUAGE_TYPE
{
    // -- CONSTANTS

    Html,
    Css,
    Javascript,
    Phoenix
}

// .. TOKEN_TYPE

enum TOKEN_TYPE
{
    // -- CONSTANTS

    None,
    BeginShortComment,
    ShortComment,
    BeginLongComment,
    LongComment,
    EndLongComment,
    RegularExpressionLiteral,
    BeginCharacterLiteral,
    CharacterLiteral,
    EndCharacterLiteral,
    BeginStringLiteral,
    StringLiteral,
    EndStringLiteral,
    BeginTextLiteral,
    TextLiteral,
    EndTextLiteral,
    BeginDeclaration,
    EndDeclaration,
    BeginElement,
    EndElement,
    BeginOpeningTag,
    EndOpeningTag,
    CloseOpeningTag,
    BeginClosingTag,
    EndClosingTag,
    Number,
    Identifier,
    Operator,
    Separator,
    Special
}

class TOKEN
{
    // -- ATTRIBUTES

    string
        Text;
    LANGUAGE_TYPE
        LanguageType;
    TOKEN_TYPE
        Type;
    long
        LineIndex,
        ColumnIndex,
        PriorSpaceCount;

    // -- CONSTRUCTORS

    this(
        string text,
        LANGUAGE_TYPE language_type,
        TOKEN_TYPE token_type
        )
    {
        Text = text;
        LanguageType = language_type;
        Type = token_type;
        LineIndex = 0;
        ColumnIndex = 0;
        PriorSpaceCount = 0;
    }

    // -- INQUIRIES

    bool IsReservedKeyword(
        )
    {
        return
            LanguageType == LANGUAGE_TYPE.Phoenix
            && Type == TOKEN_TYPE.Identifier
            && ( Text == "abstract"
                 || Text == "and"
                 || Text == "array"
                 || Text == "as"
                 || Text == "bool"
                 || Text == "break"
                 || Text == "callable"
                 || Text == "case"
                 || Text == "catch"
                 || Text == "class"
                 || Text == "clone"
                 || Text == "const"
                 || Text == "continue"
                 || Text == "declare"
                 || Text == "default"
                 || Text == "do"
                 || Text == "echo"
                 || Text == "else"
                 || Text == "elseif"
                 || Text == "extends"
                 || Text == "false"
                 || Text == "final"
                 || Text == "finally"
                 || Text == "float"
                 || Text == "for"
                 || Text == "foreach"
                 || Text == "function"
                 || Text == "global"
                 || Text == "goto"
                 || Text == "if"
                 || Text == "implement"
                 || Text == "include"
                 || Text == "include_once"
                 || Text == "instanceof"
                 || Text == "insteadof"
                 || Text == "int"
                 || Text == "interface"
                 || Text == "namespace"
                 || Text == "new"
                 || Text == "null"
                 || Text == "or"
                 || Text == "print"
                 || Text == "private"
                 || Text == "protected"
                 || Text == "public"
                 || Text == "require"
                 || Text == "require_once"
                 || Text == "return"
                 || Text == "static"
                 || Text == "string"
                 || Text == "switch"
                 || Text == "throw"
                 || Text == "trait"
                 || Text == "true"
                 || Text == "try"
                 || Text == "use"
                 || Text == "var"
                 || Text == "while"
                 || Text == "xor"
                 || Text == "yield" );
    }

    // ~~

    bool IsGlobalVariable(
        )
    {
        return
            LanguageType == LANGUAGE_TYPE.Phoenix
            && Type == TOKEN_TYPE.Identifier
            && ( Text == ""
                 || Text == "GLOBALS"
                 || Text == "_COOKIE"
                 || Text == "_ENV"
                 || Text == "_FILES"
                 || Text == "_GET"
                 || Text == "_POST"
                 || Text == "_REQUEST"
                 || Text == "_SERVER"
                 || Text == "_SESSION" );

    }

    // ~~

    bool IsConstant(
        )
    {
        return
            LanguageType == LANGUAGE_TYPE.Phoenix
            && Type == TOKEN_TYPE.Identifier
            && Text.length > 1
            && Text == Text.toUpper();
    }

    // ~~

    bool IsAttributePrefixKeyword(
        )
    {
        return
            LanguageType == LANGUAGE_TYPE.Phoenix
            && Type == TOKEN_TYPE.Identifier
            && ( Text == "const"
                 || Text == "private"
                 || Text == "protected"
                 || Text == "public"
                 || Text == "static" );
    }

    // -- OPERATIONS

    void Clear(
        )
    {
        Text = "";
        Type = TOKEN_TYPE.None;
        LineIndex = 0;
        ColumnIndex = 0;
        PriorSpaceCount = 0;
    }

    // ~~

    void SetMinimumPriorSpaceCount(
        long minimum_prior_space_count
        )
    {
        if ( PriorSpaceCount < minimum_prior_space_count )
        {
            PriorSpaceCount = minimum_prior_space_count;
        }
    }
}

// .. CONTEXT

class CONTEXT
{
    // -- ATTRIBUTES

    LANGUAGE_TYPE
        LanguageType;
    TOKEN_TYPE
        TokenType;

    // -- CONSTRUCTORS

    this(
        LANGUAGE_TYPE language_type
        )
    {
        LanguageType = language_type;
        TokenType = TOKEN_TYPE.None;
    }
}

// .. SCOPE

class SCOPE
{
    bool[ string ]
        IsVariableMap;
    long
        BlockLevel;

    void AddVariable(
        string variable_name
        )
    {
        IsVariableMap[ variable_name ] = true;
    }

    bool HasVariable(
        string variable_name
        )
    {
        return ( variable_name in IsVariableMap ) !is null;
    }
}

// .. CODE

class CODE
{
    // -- ATTRIBUTES

    bool
        IsTemplate;
    long
        LineCharacterIndex,
        CharacterIndex,
        LineIndex,
        TokenCharacterIndex;
    TOKEN[]
        TokenArray;
    TOKEN
        Token;
    long
        TokenIndex;
    bool
        TokenIsSplit;
    CONTEXT
        BaseContext,
        PhoenixContext,
        Context;
    SCOPE[]
        ScopeArray;
    SCOPE
        Scope;

    // -- CONSTRUCTORS

    this(
        bool it_is_template
        )
    {
        IsTemplate = it_is_template;
        LineCharacterIndex = -1;
        CharacterIndex = -1;
        LineIndex = -1;
        TokenCharacterIndex = -1;
        TokenArray = null;
        Token = null;
        TokenIndex = -1;
        TokenIsSplit = false;
        BaseContext = null;
        PhoenixContext = null;
        Context = null;
        Scope = new SCOPE();
        ScopeArray ~= Scope;
    }

    // -- INQUIRIES

    bool IsAlphabeticalCharacter(
        char character
        )
    {
        return
            ( character >= 'a' && character <= 'z' )
            || ( character >= 'A' && character <= 'Z' );
    }

    // ~~

    bool IsNumberCharacter(
        char character,
        char prior_character,
        char next_character
        )
    {
        return
            ( character >= '0' && character <= '9' )
            || ( character >= 'a' && character <= 'z' )
            || ( character >= 'A' && character <= 'Z' )
            || ( character == '.'
                 && prior_character >= '0' && prior_character <= '9'
                 && next_character >= '0' && next_character <= '9' )
            || ( character == '-'
                 && ( prior_character == 'e' || prior_character == 'E' ) );
    }

    // ~~

    bool IsIdentifierCharacter(
        char character
        )
    {
        return
            ( character >= 'a' && character <= 'z' )
            || ( character >= 'A' && character <= 'Z' )
            || ( character >= '0' && character <= '9' )
            || character == '_';
    }

    // ~~

    bool IsSeparatorCharacter(
        char character
        )
    {
        return
            character == '{'
            || character == '}'
            || character == '['
            || character == ']'
            || character == '('
            || character == ')'
            || character == ';'
            || character == ','
            || character == '.'
            || character == ':';
    }

    // ~~

    bool IsOperatorCharacter(
        char character
        )
    {
        return
            character == '='
            || character == '+'
            || character == '-'
            || character == '*'
            || character == '/'
            || character == '%'
            || character == '<'
            || character == '>'
            || character == '~'
            || character == '&'
            || character == '|'
            || character == '^'
            || character == '!'
            || character == '?'
            || character == '@'
            || character == '#'
            || character == '$';
    }

    // ~~

    bool IsLastTokenBeforeRegularExpression()
    {
        TOKEN
            token;

        if ( TokenArray.length == 0 )
        {
            return true;
        }
        else
        {
            token = TokenArray[ TokenArray.length.to!long() - 1 ];

            return
                ( token.Type == TOKEN_TYPE.Separator
                  && token.Text != "]"
                  && token.Text != ")" )
                || token.Type == TOKEN_TYPE.Operator;
        }
    }

    // ~~

    string GetText(
        long first_line_index,
        long first_token_index,
        long post_token_index
        )
    {
        long
            line_index,
            token_index;
        string
            text;
        TOKEN
            token;

        line_index = first_line_index;

        for ( token_index = first_token_index;
              token_index < post_token_index;
              ++token_index )
        {
            token = TokenArray[ token_index ];

            while ( token.LineIndex > line_index )
            {
                text ~= "\n";
                ++line_index;
            }

            foreach ( space_index; 0 .. token.PriorSpaceCount )
            {
                text ~= " ";
            }

            text ~= token.Text;
        }

        text ~= "\n";

        return text;
    }

    // ~~

    string GetText(
        )
    {
        if ( IsTemplate )
        {
            return GetText( 0, 0, TokenArray.length );
        }
        else
        {
            return "<?php " ~ GetText( 0, 0, TokenArray.length );
        }
    }

    // -- OPERATIONS

    void AddToken()
    {
        Token = new TOKEN( "", Context.LanguageType, Context.TokenType );
        Token.LineIndex = LineIndex;
        Token.ColumnIndex = TokenCharacterIndex - LineCharacterIndex;

        TokenArray ~= Token;
        TokenIsSplit = false;
    }

    // ~~

    void BeginToken(
        TOKEN_TYPE token_type
        )
    {
        Token = null;
        Context.TokenType = token_type;
    }

    // ~~

    void AddTokenCharacter(
        char token_character
        )
    {
        if ( Token is null
             || TokenIsSplit )
        {
            AddToken();
        }

        Token.Text ~= token_character;
        ++TokenCharacterIndex;
    }

    // ~~

    void EndToken()
    {
        Token = null;
        Context.TokenType = TOKEN_TYPE.None;
    }

    // ~~

    void SetPriorSpaceCount(
        )
    {
        long
            token_index;
        TOKEN
            prior_token,
            token;

        prior_token = null;

        for ( token_index = 0;
              token_index < TokenArray.length;
              ++token_index )
        {
            token = TokenArray[ token_index ];

            if ( token_index == 0
                 || token.LineIndex > prior_token.LineIndex )
            {
                token.PriorSpaceCount = token.ColumnIndex;
            }
            else
            {
                token.PriorSpaceCount = token.ColumnIndex - prior_token.ColumnIndex - prior_token.Text.length.to!long();
            }

            prior_token = token;
        }
    }

    // ~~

    void Tokenize(
        string file_text
        )
    {
        char
            character,
            character_2,
            character_3,
            character_4,
            character_5,
            character_6,
            character_7,
            character_8,
            character_9,
            prior_character;
        long
            character_count,
            closing_tag_token_index,
            element_count,
            opening_tag_token_index;
        string
            tag_name;

        file_text = file_text.replace( "\t", "    " ).replace( "\r", "" );

        LineCharacterIndex = 0;
        LineIndex = 0;
        TokenArray = null;
        TokenIsSplit = false;

        if ( IsTemplate )
        {
            BaseContext = new CONTEXT( LANGUAGE_TYPE.Html );
            PhoenixContext = new CONTEXT( LANGUAGE_TYPE.Phoenix );
        }
        else
        {
            BaseContext = new CONTEXT( LANGUAGE_TYPE.Phoenix );
            PhoenixContext = null;
        }

        Context = BaseContext;

        EndToken();

        character_count = file_text.length;
        element_count = 0;
        opening_tag_token_index = -1;
        closing_tag_token_index = -1;

        TokenCharacterIndex = 0;

        while ( TokenCharacterIndex < character_count )
        {
            prior_character = ( TokenCharacterIndex - 1 >= 0 ) ? file_text[ TokenCharacterIndex - 1 ] : 0;
            character = file_text[ TokenCharacterIndex ];
            character_2 = ( TokenCharacterIndex + 1 < character_count ) ? file_text[ TokenCharacterIndex + 1 ] : 0;
            character_3 = ( TokenCharacterIndex + 2 < character_count ) ? file_text[ TokenCharacterIndex + 2 ] : 0;
            character_4 = ( TokenCharacterIndex + 3 < character_count ) ? file_text[ TokenCharacterIndex + 3 ] : 0;
            character_5 = ( TokenCharacterIndex + 4 < character_count ) ? file_text[ TokenCharacterIndex + 4 ] : 0;
            character_6 = ( TokenCharacterIndex + 5 < character_count ) ? file_text[ TokenCharacterIndex + 5 ] : 0;
            character_7 = ( TokenCharacterIndex + 6 < character_count ) ? file_text[ TokenCharacterIndex + 6 ] : 0;
            character_8 = ( TokenCharacterIndex + 7 < character_count ) ? file_text[ TokenCharacterIndex + 7 ] : 0;
            character_9 = ( TokenCharacterIndex + 8 < character_count ) ? file_text[ TokenCharacterIndex + 8 ] : 0;

            if ( character == ' '
                 || character == '\n' )
            {
                ++TokenCharacterIndex;

                if ( character == '\n' )
                {
                    if ( Context.TokenType == TOKEN_TYPE.ShortComment
                         || ( ( Context.TokenType == TOKEN_TYPE.CharacterLiteral
                                || Context.TokenType == TOKEN_TYPE.StringLiteral
                                || Context.TokenType == TOKEN_TYPE.TextLiteral )
                              && Context.LanguageType <= LANGUAGE_TYPE.Phoenix )
                         || ( Context.TokenType == TOKEN_TYPE.RegularExpressionLiteral
                              && Context.LanguageType == LANGUAGE_TYPE.Javascript ) )
                    {
                        EndToken();
                    }

                    ++LineIndex;
                    LineCharacterIndex = TokenCharacterIndex;
                }
                else if ( character == ' '
                          && Context.TokenType == TOKEN_TYPE.Identifier )
                {
                    EndToken();
                }

                TokenIsSplit = true;
            }
            else if ( character == '<'
                      && ( character_2 == '?'
                           || character_2 == '%'
                           || character_2 == '#' )
                      && Context.LanguageType != LANGUAGE_TYPE.Phoenix )
            {
                Context = PhoenixContext;

                BeginToken( TOKEN_TYPE.BeginDeclaration );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();
            }
            else if ( Context.TokenType == TOKEN_TYPE.ShortComment )
            {
                AddTokenCharacter( character );
            }
            else if ( Context.TokenType == TOKEN_TYPE.LongComment )
            {
                if ( character == '-'
                     && character_2 == '-'
                     && character_3 == '>'
                     && Context.LanguageType == LANGUAGE_TYPE.Html )
                {
                    BeginToken( TOKEN_TYPE.EndLongComment );
                    AddTokenCharacter( character );
                    AddTokenCharacter( character_2 );
                    AddTokenCharacter( character_3 );
                    EndToken();
                }
                else if ( character == '*'
                          && character_2 == '/'
                          && Context.LanguageType >= LANGUAGE_TYPE.Css )
                {
                    BeginToken( TOKEN_TYPE.EndLongComment );
                    AddTokenCharacter( character );
                    AddTokenCharacter( character_2 );
                    EndToken();
                }
                else
                {
                    AddTokenCharacter( character );
                }
            }
            else if ( Context.TokenType == TOKEN_TYPE.RegularExpressionLiteral )
            {
                AddTokenCharacter( character );

                if ( character == '\\' )
                {
                    AddTokenCharacter( character_2 );
                }
                else if ( character == '/' )
                {
                    EndToken();
                }
            }
            else if ( Context.TokenType == TOKEN_TYPE.CharacterLiteral )
            {
                if ( character == '\'' )
                {
                    BeginToken( TOKEN_TYPE.EndCharacterLiteral );
                    AddTokenCharacter( character );
                    EndToken();
                }
                else if ( character == '\\' )
                {
                    AddTokenCharacter( character );
                    AddTokenCharacter( character_2 );
                }
                else
                {
                    AddTokenCharacter( character );
                }
            }
            else if ( Context.TokenType == TOKEN_TYPE.StringLiteral )
            {
                if ( character == '\"' )
                {
                    BeginToken( TOKEN_TYPE.EndStringLiteral );
                    AddTokenCharacter( character );
                    EndToken();
                }
                else if ( character == '\\' )
                {
                    AddTokenCharacter( character );
                    AddTokenCharacter( character_2 );
                }
                else
                {
                    AddTokenCharacter( character );
                }
            }
            else if ( Context.TokenType == TOKEN_TYPE.TextLiteral )
            {
                if ( character == '`' )
                {
                    BeginToken( TOKEN_TYPE.EndStringLiteral );
                    AddTokenCharacter( character );
                    EndToken();
                }
                else if ( character == '\\' )
                {
                    AddTokenCharacter( character );
                    AddTokenCharacter( character_2 );
                }
                else
                {
                    AddTokenCharacter( character );
                }
            }
            else if ( ( character == '?'
                        || character == '%'
                        || character == '#' )
                      && character_2 == '>'
                      && Context.LanguageType == LANGUAGE_TYPE.Phoenix )
            {
                BeginToken( TOKEN_TYPE.EndDeclaration );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();

                Context = BaseContext;
            }
            else if ( character == '/'
                      && character_2 == '/'
                      && Context.LanguageType >= LANGUAGE_TYPE.Css )
            {
                BeginToken( TOKEN_TYPE.BeginShortComment );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();

                BeginToken( TOKEN_TYPE.ShortComment );
            }
            else if ( character == '<'
                      && character_2 == '!'
                      && character_3 == '-'
                      && character_4 == '-'
                      && Context.LanguageType == LANGUAGE_TYPE.Html )
            {
                BeginToken( TOKEN_TYPE.BeginLongComment );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                AddTokenCharacter( character_3 );
                AddTokenCharacter( character_4 );
                EndToken();

                BeginToken( TOKEN_TYPE.LongComment );
            }
            else if ( character == '/'
                      && character_2 == '*'
                      && Context.LanguageType >= LANGUAGE_TYPE.Css )
            {
                BeginToken( TOKEN_TYPE.BeginLongComment );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();

                BeginToken( TOKEN_TYPE.LongComment );
            }
            else if ( character == '/'
                      && Context.LanguageType == LANGUAGE_TYPE.Javascript
                      && IsLastTokenBeforeRegularExpression() )
            {
                BeginToken( TOKEN_TYPE.RegularExpressionLiteral );
                AddTokenCharacter( character );
            }

            else if ( character == '\''
                      && ( Context.LanguageType >= LANGUAGE_TYPE.Css
                           || opening_tag_token_index != -1 ) )
            {
                BeginToken( TOKEN_TYPE.BeginCharacterLiteral );
                AddTokenCharacter( character );
                EndToken();

                BeginToken( TOKEN_TYPE.CharacterLiteral );
            }
            else if ( character == '\"'
                      && ( Context.LanguageType >= LANGUAGE_TYPE.Css
                           || opening_tag_token_index != -1 ) )
            {
                BeginToken( TOKEN_TYPE.BeginStringLiteral );
                AddTokenCharacter( character );
                EndToken();

                BeginToken( TOKEN_TYPE.StringLiteral );
            }
            else if ( character == '`'
                      && ( Context.LanguageType >= LANGUAGE_TYPE.Css
                           || opening_tag_token_index != -1 ) )
            {
                BeginToken( TOKEN_TYPE.BeginTextLiteral );
                AddTokenCharacter( character );
                EndToken();

                BeginToken( TOKEN_TYPE.TextLiteral );
            }
            else if ( character == '<'
                      && character_2 == '!'
                      && Context.LanguageType == LANGUAGE_TYPE.Html )
            {
                BeginToken( TOKEN_TYPE.BeginElement );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();

                ++element_count;
            }
            else if ( character == '>'
                      && element_count > 0
                      && Context.LanguageType == LANGUAGE_TYPE.Html )
            {
                BeginToken( TOKEN_TYPE.EndElement );
                AddTokenCharacter( character );
                EndToken();

                --element_count;
            }
            else if ( character == '<'
                      && IsAlphabeticalCharacter( character_2 )
                      && Context.LanguageType == LANGUAGE_TYPE.Html
                      && opening_tag_token_index == -1
                      && closing_tag_token_index == -1 )
            {
                BeginToken( TOKEN_TYPE.BeginOpeningTag );
                AddTokenCharacter( character );
                EndToken();

                opening_tag_token_index = TokenArray.length;
            }
            else if ( character == '/'
                      && character_2 == '>'
                      && Context.LanguageType == LANGUAGE_TYPE.Html
                      && opening_tag_token_index != -1 )
            {
                BeginToken( TOKEN_TYPE.CloseOpeningTag );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();

                opening_tag_token_index = -1;
            }
            else if ( character == '>'
                      && Context.LanguageType == LANGUAGE_TYPE.Html
                      && opening_tag_token_index != -1 )
            {
                BeginToken( TOKEN_TYPE.EndOpeningTag );
                AddTokenCharacter( character );
                EndToken();

                tag_name = TokenArray[ opening_tag_token_index ].Text;

                if ( tag_name == "style" )
                {
                    Context.LanguageType = LANGUAGE_TYPE.Css;
                }
                else if ( tag_name == "script" )
                {
                    Context.LanguageType = LANGUAGE_TYPE.Javascript;
                }

                opening_tag_token_index = -1;
            }
            else if ( character == '<'
                      && character_2 == '/'
                      && IsAlphabeticalCharacter( character_3 )
                      && Context.LanguageType == LANGUAGE_TYPE.Html
                      && opening_tag_token_index == -1
                      && closing_tag_token_index == -1 )
            {
                BeginToken( TOKEN_TYPE.BeginClosingTag );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();

                closing_tag_token_index = TokenArray.length;
            }
            else if ( character == '>'
                      && Context.LanguageType == LANGUAGE_TYPE.Html
                      && closing_tag_token_index != -1 )
            {
                BeginToken( TOKEN_TYPE.EndClosingTag );
                AddTokenCharacter( character );
                EndToken();

                closing_tag_token_index = -1;
            }
            else if ( character == '<'
                      && character_2 == '/'
                      && character_3 == 's'
                      && character_4 == 't'
                      && character_5 == 'y'
                      && character_6 == 'l'
                      && character_7 == 'e'
                      && character_8 == '>'
                      && Context.LanguageType == LANGUAGE_TYPE.Css )
            {
                Context.LanguageType = LANGUAGE_TYPE.Html;

                BeginToken( TOKEN_TYPE.BeginClosingTag );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();

                BeginToken( TOKEN_TYPE.Identifier );
                AddTokenCharacter( character_3 );
                AddTokenCharacter( character_4 );
                AddTokenCharacter( character_5 );
                AddTokenCharacter( character_6 );
                AddTokenCharacter( character_7 );
                EndToken();

                BeginToken( TOKEN_TYPE.EndClosingTag );
                AddTokenCharacter( character_8 );
                EndToken();
            }
            else if ( character == '<'
                      && character_2 == '/'
                      && character_3 == 's'
                      && character_4 == 'c'
                      && character_5 == 'r'
                      && character_6 == 'i'
                      && character_7 == 'p'
                      && character_8 == 't'
                      && character_9 == '>'
                      && Context.LanguageType == LANGUAGE_TYPE.Javascript )
            {
                Context.LanguageType = LANGUAGE_TYPE.Html;

                BeginToken( TOKEN_TYPE.BeginClosingTag );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();

                BeginToken( TOKEN_TYPE.Identifier );
                AddTokenCharacter( character_3 );
                AddTokenCharacter( character_4 );
                AddTokenCharacter( character_5 );
                AddTokenCharacter( character_6 );
                AddTokenCharacter( character_7 );
                AddTokenCharacter( character_8 );
                EndToken();

                BeginToken( TOKEN_TYPE.EndClosingTag );
                AddTokenCharacter( character_9 );
                EndToken();
            }
            else if ( IsNumberCharacter( character, prior_character, character_2 )
                      && Context.TokenType == TOKEN_TYPE.Number )
            {
                AddTokenCharacter( character );
            }
            else if ( IsIdentifierCharacter( character )
                      && Context.TokenType == TOKEN_TYPE.Identifier )
            {
                AddTokenCharacter( character );
            }
            else if ( character >= '0' && character <= '9' )
            {
                BeginToken( TOKEN_TYPE.Number );
                AddTokenCharacter( character );
            }
            else if ( IsIdentifierCharacter( character ) )
            {
                BeginToken( TOKEN_TYPE.Identifier );
                AddTokenCharacter( character );
            }
            else if ( IsOperatorCharacter( character ) )
            {
                BeginToken( TOKEN_TYPE.Operator );
                AddTokenCharacter( character );
                EndToken();
            }
            else if ( character == '.'
                      && character_2 == '.' )
            {
                BeginToken( TOKEN_TYPE.Operator );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();
            }
            else if ( character == ':'
                      && character_2 == ':' )
            {
                BeginToken( TOKEN_TYPE.Operator );
                AddTokenCharacter( character );
                AddTokenCharacter( character_2 );
                EndToken();
            }
            else if ( IsSeparatorCharacter( character ) )
            {
                BeginToken( TOKEN_TYPE.Separator );
                AddTokenCharacter( character );
                EndToken();
            }
            else
            {
                BeginToken( TOKEN_TYPE.Special );
                AddTokenCharacter( character );
                EndToken();
            }
        }

        SetPriorSpaceCount();
    }

    // ~~

    void ProcessLocalVariable(
        ref long token_index
        )
    {
        TOKEN
            token;

        TokenArray[ token_index ].Text = "";

        ++token_index;

        if ( token_index < TokenArray.length )
        {
            token = TokenArray[ token_index ];

            if ( token.Type == TOKEN_TYPE.Identifier )
            {
                Scope.AddVariable( token.Text );

                token.Text = "$" ~ token.Text;
            }
        }
    }

    // ~~

    void ProcessStaticVariables(
        ref long token_index
        )
    {
        bool
            it_is_value;
        TOKEN
            token;

        ++token_index;

        it_is_value = false;

        while ( token_index < TokenArray.length )
        {
            token = TokenArray[ token_index ];

            if ( token.Type == TOKEN_TYPE.Identifier
                 && !it_is_value
                 && token_index + 1 < TokenArray.length
                 && ( TokenArray[ token_index + 1 ].Text == "="
                      || TokenArray[ token_index + 1 ].Text == ","
                      || TokenArray[ token_index + 1 ].Text == ";" ) )
            {
                Scope.AddVariable( token.Text );

                token.Text = "$" ~ token.Text;
            }
            else if ( token.Text == "=" )
            {
                it_is_value = true;
            }
            else if ( token.Text == "," )
            {
                it_is_value = false;
            }
            else if ( token.Text == ";" )
            {
                break;
            }
            else
            {
                ProcessToken( token_index );
            }

            ++token_index;
        }
    }

    // ~~

    void ProcessLocalVariables(
        ref long token_index
        )
    {
        TOKEN
            token;

        TokenArray[ token_index ].Text = "";

        if ( token_index > 0
             && TokenArray[ token_index - 1 ].Text == "static" )
        {
            ProcessStaticVariables( token_index );
        }
        else
        {
            ++token_index;

            while ( token_index < TokenArray.length )
            {
                token = TokenArray[ token_index ];

                if ( token.Type == TOKEN_TYPE.Identifier )
                {
                    Scope.AddVariable( token.Text );
                }
                else if ( token.Text == ";" )
                {
                    token.Text = "";

                    break;
                }

                token.Text = "";

                ++token_index;
            }
        }
    }

    // ~~

    void ProcessGlobalVariables(
        ref long token_index
        )
    {
        TOKEN
            token;

        ++token_index;

        while ( token_index < TokenArray.length )
        {
            token = TokenArray[ token_index ];

            if ( token.Type == TOKEN_TYPE.Identifier )
            {
                Scope.AddVariable( token.Text );

                token.Text = "$" ~ token.Text;
            }
            else if ( token.Text == ";" )
            {
                break;
            }

            ++token_index;
        }
    }

    // ~~

    void ProcessClassAttributes(
        ref long token_index
        )
    {
        bool
            it_is_value;
        TOKEN
            token;

        TokenArray[ token_index ].Text = "";

        if ( token_index > 0
             && !TokenArray[ token_index - 1 ].IsAttributePrefixKeyword() )
        {
            TokenArray[ token_index ].Text = "public";
        }

        ++token_index;

        it_is_value = false;

        while ( token_index < TokenArray.length )
        {
            token = TokenArray[ token_index ];

            if ( token.Type == TOKEN_TYPE.Identifier
                 && !it_is_value
                 && token_index + 1 < TokenArray.length
                 && ( TokenArray[ token_index + 1 ].Text == "="
                      || TokenArray[ token_index + 1 ].Text == ","
                      || TokenArray[ token_index + 1 ].Text == ";" ) )
            {
                token.Text = "$" ~ token.Text;
            }
            else if ( token.Text == "=" )
            {
                it_is_value = true;
            }
            else if ( token.Text == "," )
            {
                it_is_value = false;
            }
            else if ( token.Text == ";" )
            {
                break;
            }
            else
            {
                ProcessToken( token_index );
            }

            ++token_index;
        }
    }

    // ~~

    void ProcessParameters(
        ref long token_index
        )
    {
        bool
            it_is_value;
        TOKEN
            token;

        Scope = new SCOPE();
        ScopeArray ~= Scope;

        ++token_index;

        it_is_value = false;

        while ( token_index < TokenArray.length )
        {
            token = TokenArray[ token_index ];

            if ( token.Type == TOKEN_TYPE.Identifier
                 && !it_is_value
                 && token_index + 1 < TokenArray.length
                 && ( TokenArray[ token_index + 1 ].Text == "="
                      || TokenArray[ token_index + 1 ].Text == ","
                      || TokenArray[ token_index + 1 ].Text == ")" ) )
            {
                Scope.AddVariable( token.Text );

                token.Text = "$" ~ token.Text;
            }
            else if ( token.Text == "=" )
            {
                it_is_value = true;
            }
            else if ( token.Text == "," )
            {
                it_is_value = false;
            }
            else if ( token.Text == ")" )
            {
                break;
            }
            else
            {
                ProcessToken( token_index );
            }

            ++token_index;
        }
    }

    // ~~

    void ProcessForeachLoop(
        ref long token_index
        )
    {
        long
            first_token_index,
            last_token_index,
            parenthesis_level,
            semicolon_token_index;
        TOKEN
            token;

        ++token_index;

        first_token_index = token_index;

        if ( token_index < TokenArray.length
             && TokenArray[ token_index ].Text == "(" )
        {
            semicolon_token_index = -1;
            last_token_index = -1;

            parenthesis_level = 0;

            while ( token_index < TokenArray.length )
            {
                token = TokenArray[ token_index ];

                if ( token.Text == "(" )
                {
                    ++parenthesis_level;
                }
                else if ( token.Text == ")" )
                {
                    --parenthesis_level;

                    if ( parenthesis_level == 0 )
                    {
                        break;
                    }
                }
                else if ( token.Text == ";" )
                {
                    semicolon_token_index = token_index;
                }

                ++token_index;
            }

            last_token_index = token_index;

            if ( first_token_index < semicolon_token_index
                 && semicolon_token_index < last_token_index
                 && first_token_index < TokenArray.length
                 && semicolon_token_index < TokenArray.length
                 && last_token_index < TokenArray.length )
            {
                TokenArray[ semicolon_token_index ].Type = TOKEN_TYPE.Identifier;
                TokenArray[ semicolon_token_index ].Text = "as";
                TokenArray[ semicolon_token_index ].SetMinimumPriorSpaceCount( 1 );
                TokenArray[ first_token_index + 1 ].SetMinimumPriorSpaceCount( 1 );

                TokenArray
                    = TokenArray[ 0 .. first_token_index + 1 ]
                      ~ TokenArray[ semicolon_token_index + 1 .. last_token_index ]
                      ~ TokenArray[ semicolon_token_index .. semicolon_token_index + 1 ]
                      ~ TokenArray[ first_token_index + 1 .. semicolon_token_index ]
                      ~ TokenArray[ last_token_index .. $ ];

                for ( token_index = first_token_index;
                      token_index < last_token_index;
                      ++token_index )
                {
                    if ( TokenArray[ token_index ].LineIndex > TokenArray[ token_index + 1 ].LineIndex )
                    {
                        TokenArray[ token_index ].LineIndex = TokenArray[ token_index + 1 ].LineIndex;
                    }
                }
            }
        }

        token_index = first_token_index - 1;
    }

    // ~~

    void ProcessToken(
        ref long token_index
        )
    {
        TOKEN
            token;

        token = TokenArray[ token_index ];

        if ( token.LanguageType == LANGUAGE_TYPE.Phoenix )
        {
            if ( token.Type == TOKEN_TYPE.Identifier )
            {
                if ( token.Text == "var" )
                {
                    ProcessLocalVariable( token_index );
                }
                else if ( token.Text == "local" )
                {
                    ProcessLocalVariables( token_index );
                }
                else if ( token.Text == "global" )
                {
                    ProcessGlobalVariables( token_index );
                }
                else if ( token.Text == "attribute" )
                {
                    ProcessClassAttributes( token_index );
                }
                else if ( token.Text == "catch" )
                {
                    ProcessParameters( token_index );
                }
                else if ( token.Text == "function" )
                {
                    ProcessParameters( token_index );
                }
                else if ( token.Text == "method" )
                {
                    token.Text = "function";

                    ProcessParameters( token_index );
                }
                else if ( token.Text == "foreach" )
                {
                    ProcessForeachLoop( token_index );
                }
                else if ( token.Text == "import" )
                {
                    if ( token_index + 1 < TokenArray.length
                         && TokenArray[ token_index + 1 ].Text == "?" )
                    {
                        token.Text = "include_once __DIR__ . '/' .";
                        TokenArray[ token_index + 1 ].Text = "";
                    }
                    else
                    {
                        token.Text = "require_once __DIR__ . '/' .";
                    }
                }
                else if ( token.Text == "include" )
                {
                    if ( token_index + 1 < TokenArray.length
                         && TokenArray[ token_index + 1 ].Text == "?" )
                    {
                        token.Text = "include __DIR__ . '/' .";
                        TokenArray[ token_index + 1 ].Text = "";
                    }
                    else
                    {
                        token.Text = "require __DIR__ . '/' .";
                    }
                }
                else if ( token.Text == "constructor" )
                {
                    token.Text = "__construct";
                }
                else if ( token.Text == "destructor" )
                {
                    token.Text = "__destruct";
                }
                else if ( token.Text == "this" )
                {
                    token.Text = "$this";
                }
                else if ( !token.IsReservedKeyword()
                          && ( token.IsGlobalVariable()
                               || Scope.HasVariable( token.Text )
                               || ( token_index > 0
                                    && TokenArray[ token_index - 1 ].Text == "::"
                                    && token_index + 1 < TokenArray.length
                                    && TokenArray[ token_index + 1 ].Text != "("
                                    && !token.IsConstant() ) ) )
                {
                    if ( token_index > 0
                         && TokenArray[ token_index - 1 ].Text == "#" )
                    {
                        TokenArray[ token_index - 1 ].Text = "";
                    }
                    else
                    {
                        token.Text = "$" ~ token.Text;
                    }
                }
            }
            else if ( token.Type == TOKEN_TYPE.Operator )
            {
                if ( token.Text == ".." )
                {
                    token.Text = ".";
                }
            }
            else if ( token.Type == TOKEN_TYPE.Separator )
            {
                if ( token.Text == "." )
                {
                    if ( token_index >= 1
                         && TokenArray[ token_index - 1 ].Text != ")"
                         && TokenArray[ token_index - 1 ].Text != "]"
                         && ( TokenArray[ token_index - 1 ].Type != TOKEN_TYPE.Identifier
                              || TokenArray[ token_index - 1 ].IsReservedKeyword() ) )
                    {
                        token.Text = "$this->";
                    }
                    else
                    {
                        token.Text = "->";
                    }
                }
                else if ( token.Text == "{" )
                {
                    ++Scope.BlockLevel;
                }
                else if ( token.Text == "}" )
                {
                    if ( Scope.BlockLevel > 0 )
                    {
                        --Scope.BlockLevel;

                        if ( Scope.BlockLevel == 0
                             && ScopeArray.length > 1 )
                        {
                            ScopeArray = ScopeArray[ 0 .. $ - 1 ];
                            Scope = ScopeArray[ $ - 1 ];
                        }
                    }
                }
            }
            else if ( token.Type == TOKEN_TYPE.BeginDeclaration )
            {
                if ( token.Text == "<?" )
                {
                    token.Text = "<?php";
                }
                else if ( token.Text == "<%" )
                {
                    token.Text = "<?php echo htmlspecialchars(";
                }
                else if ( token.Text == "<#" )
                {
                    token.Text = "<?php echo";

                    if ( token_index + 1 < TokenArray.length
                         && TokenArray[ token_index + 1 ].PriorSpaceCount == 0 )
                    {
                        TokenArray[ token_index + 1 ].PriorSpaceCount = 1;
                    }
                }

            }
            else if ( token.Type == TOKEN_TYPE.EndDeclaration )
            {
                if ( token.Text == "%>" )
                {
                    token.Text = "); ?>";
                }
                else if ( token.Text == "#>" )
                {
                    token.Text = "; ?>";
                    token.PriorSpaceCount = 0;
                }
            }
        }
    }

    // ~~

    void WriteScriptFile(
        long first_token_index,
        long post_token_index,
        string script_file_path
        )
    {
        string
            script_file_text;

        script_file_text = GetText( TokenArray[ first_token_index ].LineIndex, first_token_index + 8, post_token_index - 3 );

        if ( TrimOptionIsEnabled )
        {
            script_file_text = script_file_text.GetTrimmedText() ~ '\n';
        }

        script_file_path.WriteText( script_file_text );
    }

    // ~~

    void CompressScript(
        long first_token_index,
        long post_token_index
        )
    {
        long
            line_index_offset,
            token_index;

        if ( post_token_index < TokenArray.length )
        {
            line_index_offset
                = TokenArray[ post_token_index ].LineIndex
                  - TokenArray[ first_token_index ].LineIndex;

            for ( token_index = post_token_index;
                  token_index < TokenArray.length;
                  ++token_index )
            {
                TokenArray[ token_index ].LineIndex -= line_index_offset;
            }
        }

        TokenArray = TokenArray[ 0 .. first_token_index ] ~ TokenArray[ post_token_index .. $ ];
    }

    // ~~

    void ClearScript(
        long first_token_index,
        long post_token_index
        )
    {
        long
            token_index;

        for ( token_index = first_token_index;
              token_index < post_token_index;
              ++token_index )
        {
            TokenArray[ token_index ].Clear();
        }
    }

    // ~~

    bool ExtractScript(
        long first_token_index,
        string opening_tag_name,
        string script_folder_path,
        string script_file_path
        )
    {
        long
            post_token_index,
            token_index;
        string
            text;

        for ( token_index = first_token_index + 8;
              token_index + 2 < TokenArray.length;
              ++token_index )
        {
            if ( TokenArray[ token_index ].Type == TOKEN_TYPE.BeginClosingTag
                 && TokenArray[ token_index + 1 ].Type == TOKEN_TYPE.Identifier
                 && TokenArray[ token_index + 1 ].Text == opening_tag_name
                 && TokenArray[ token_index + 2 ].Type == TOKEN_TYPE.EndClosingTag )
            {
                post_token_index = token_index + 3;
                WriteScriptFile( first_token_index, post_token_index, script_folder_path ~ script_file_path );

                if ( CompressOptionIsEnabled )
                {
                    CompressScript( first_token_index, post_token_index );
                }
                else
                {
                    ClearScript( first_token_index, post_token_index );
                }

                return true;
            }
        }

        return false;
    }

    // ~~

    void ExtractScripts(
        )
    {
        long
            post_token_index,
            token_index;
        string
            opening_tag_name,
            script_file_path;
        string *
            script_folder_path;

        for ( token_index = 0;
              token_index + 7 < TokenArray.length;
              ++token_index )
        {
            if ( TokenArray[ token_index ].Type == TOKEN_TYPE.BeginOpeningTag
                 && TokenArray[ token_index + 1 ].Type == TOKEN_TYPE.Identifier
                 && TokenArray[ token_index + 2 ].Type == TOKEN_TYPE.Identifier
                 && TokenArray[ token_index + 2 ].Text == "file"
                 && TokenArray[ token_index + 3 ].Type == TOKEN_TYPE.Operator
                 && TokenArray[ token_index + 3 ].Text == "="
                 && TokenArray[ token_index + 4 ].Type == TOKEN_TYPE.BeginStringLiteral
                 && TokenArray[ token_index + 5 ].Type == TOKEN_TYPE.StringLiteral
                 && TokenArray[ token_index + 6 ].Type == TOKEN_TYPE.EndStringLiteral
                 && TokenArray[ token_index + 7 ].Type == TOKEN_TYPE.EndOpeningTag )
            {
                opening_tag_name = TokenArray[ token_index + 1 ].Text;
                script_folder_path = opening_tag_name in ScriptFolderPathMap;
                script_file_path = TokenArray[ token_index + 5 ].Text;

                if ( script_folder_path !is null
                     && ExtractScript( token_index, opening_tag_name, *script_folder_path, script_file_path ) )
                {
                    --token_index;
                }
            }
        }
    }

    // ~~

    void Process(
        )
    {
        long
            token_index;

        for ( token_index = 0;
              token_index < TokenArray.length;
              ++token_index )
        {
            ProcessToken( token_index );
        }

        if ( ExtractOptionIsEnabled )
        {
            ExtractScripts();
        }
    }
}

class FILE
{
    string
        InputPath,
        OutputPath;
    bool
        Exists,
        IsTemplate;

    // ~~

    this(
        string input_file_path,
        string output_file_path
        )
    {
        InputPath = input_file_path;
        OutputPath = output_file_path;
        Exists = true;
        IsTemplate = input_file_path.endsWith( ".pht" );
    }

    // ~~

    string ReadInputFile(
        )
    {
        return InputPath.ReadText();
    }

    // ~~

    void WriteOutputFile(
        string output_file_text
        )
    {
        return OutputPath.WriteText( output_file_text );
    }

    // ~~

    void Process(
        bool modification_time_is_used
        )
    {
        string
            input_file_text,
            output_file_text;
        CODE
            code;

        if ( Exists
             && ( !OutputPath.exists()
                  || !modification_time_is_used
                  || InputPath.timeLastModified() > OutputPath.timeLastModified() ) )
        {
            input_file_text = ReadInputFile();

            code = new CODE( IsTemplate );
            code.Tokenize( input_file_text );
            code.Process();

            WriteOutputFile( code.GetText() );
        }
    }
}

// -- VARIABLES

bool
    CreateOptionIsEnabled,
    ExtractOptionIsEnabled,
    CompressOptionIsEnabled,
    TrimOptionIsEnabled,
    WatchOptionIsEnabled;
long
    PauseDuration;
string
    InputFolderPath,
    OutputFolderPath;
string[ string ]
    ScriptFolderPathMap;
FILE[ string ]
    FileMap;

// -- FUNCTIONS

void PrintError(
    string message
    )
{
    writeln( "*** ERROR : ", message );
}

// ~~

void Abort(
    string message
    )
{
    PrintError( message );

    exit( -1 );
}

// ~~

void Abort(
    string message,
    Exception exception
    )
{
    PrintError( message );
    PrintError( exception.msg );

    exit( -1 );
}

// ~~

string GetTrimmedText(
    string text
    )
{
    long
        first_line_index,
        line_indentation,
        last_line_index,
        minimum_line_indentation;
    string[]
        line_array;

    line_array = text.split( '\n' );

    first_line_index = -1;
    last_line_index = -1;
    minimum_line_indentation = -1;

    foreach ( line_index, ref line; line_array )
    {
        line = line.stripRight();

        if ( line != "" )
        {
            line_indentation = 0;

            while ( line_indentation < line.length
                    && line[ line_indentation ] == ' ' )
            {
                ++line_indentation;
            }

            if ( first_line_index < 0 )
            {
                first_line_index = line_index;
            }

            last_line_index = line_index;

            if ( minimum_line_indentation < 0
                 || line_indentation < minimum_line_indentation )
            {
                minimum_line_indentation = line_indentation;
            }
        }
    }

    if ( minimum_line_indentation < 0 )
    {
        return "";
    }
    else
    {
        foreach ( ref line; line_array )
        {
            if ( line.length > 0 )
            {
                line = line[ minimum_line_indentation .. $ ];
            }
        }

        return line_array[ first_line_index .. last_line_index + 1 ].join( '\n' );
    }
}

// ~~

string GetLogicalPath(
    string path
    )
{
    return path.replace( '\\', '/' );
}

// ~~

string GetFolderPath(
    string file_path
    )
{
    long
        slash_character_index;

    slash_character_index = file_path.lastIndexOf( '/' );

    if ( slash_character_index >= 0 )
    {
        return file_path[ 0 .. slash_character_index + 1 ];
    }
    else
    {
        return "";
    }
}

// ~~

void CreateFolder(
    string folder_path
    )
{
    if ( folder_path != ""
         && folder_path != "/"
         && !folder_path.exists() )
    {
        writeln( "Creating folder : ", folder_path );

        try
        {
            folder_path.mkdirRecurse();
        }
        catch ( Exception exception )
        {
            Abort( "Can't create folder : " ~ folder_path, exception );
        }
    }
}

// ~~

void WriteText(
    string file_path,
    string file_text
    )
{
    if ( CreateOptionIsEnabled )
    {
        CreateFolder( file_path.GetFolderPath() );
    }

    writeln( "Writing file : ", file_path );

    file_text = file_text.stripRight();

    if ( file_text != ""
         && !file_text.endsWith( '\n' ) )
    {
        file_text ~= '\n';
    }

    try
    {
        if ( !file_path.exists()
             || file_path.readText() != file_text )
        {
            file_path.write( file_text );
        }
    }
    catch ( Exception exception )
    {
        Abort( "Can't write file : " ~ file_path, exception );
    }
}

// ~~

string ReadText(
    string file_path
    )
{
    string
        file_text;

    writeln( "Reading file : ", file_path );

    try
    {
        file_text = file_path.readText();
    }
    catch ( Exception exception )
    {
        Abort( "Can't read file : " ~ file_path, exception );
    }

    return file_text;
}

// ~~

void FindFiles(
    string input_folder_path,
    string output_folder_path
    )
{
    string
        input_file_path,
        output_file_path;
    FILE *
        file;

    foreach ( ref old_file; FileMap )
    {
        old_file.Exists = false;
    }

    foreach ( input_folder_entry; dirEntries( input_folder_path, "*.ph?", SpanMode.depth ) )
    {
        if ( input_folder_entry.isFile )
        {
            input_file_path = input_folder_entry.name.GetLogicalPath();

            if ( input_file_path.startsWith( input_folder_path )
                 && ( input_file_path.endsWith( ".phx" )
                      || input_file_path.endsWith( ".pht" ) ) )
            {
                output_file_path
                    = output_folder_path
                      ~ input_file_path[ input_folder_path.length .. $ - 4 ]
                      ~ ".php";

                file = input_file_path in FileMap;

                if ( file is null )
                {
                    FileMap[ input_file_path ] = new FILE( input_file_path, output_file_path );
                }
                else
                {
                    file.Exists = true;
                }
            }
        }
    }
}

// ~~

void ProcessFiles(
    string input_folder_path,
    string output_folder_path,
    bool modification_time_is_used
    )
{
    FindFiles( input_folder_path, output_folder_path );

    foreach ( ref file; FileMap )
    {
        file.Process( modification_time_is_used );
    }
}

// ~~

void WatchFiles(
    string input_folder_path,
    string output_folder_path
    )
{
    ProcessFiles( input_folder_path, output_folder_path, false );

    writeln( "Watching files..." );

    while ( true )
    {
        Thread.sleep( dur!( "msecs" )( PauseDuration ) );

        ProcessFiles( input_folder_path, output_folder_path, true );
    }
}

// ~~

void main(
    string[] argument_array
    )
{
    string
        input_folder_path,
        option,
        output_folder_path;

    argument_array = argument_array[ 1 .. $ ];

    ExtractOptionIsEnabled = false;
    CompressOptionIsEnabled = false;
    TrimOptionIsEnabled = false;
    CreateOptionIsEnabled = false;
    WatchOptionIsEnabled = false;
    PauseDuration = 500;

    while ( argument_array.length >= 1
            && argument_array[ 0 ].startsWith( "--" ) )
    {
        option = argument_array[ 0 ];

        argument_array = argument_array[ 1 .. $ ];

        if ( option == "--extract"
             && argument_array.length >= 2
             && argument_array[ 1 ].GetLogicalPath().endsWith( '/' ) )
        {
            ExtractOptionIsEnabled = true;
            ScriptFolderPathMap[ argument_array[ 0 ] ] = argument_array[ 1 ].GetLogicalPath();

            argument_array = argument_array[ 2 .. $ ];
        }
        else if ( option == "--compress" )
        {
            CompressOptionIsEnabled = true;
        }
        else if ( option == "--trim" )
        {
            TrimOptionIsEnabled = true;
        }
        else if ( option == "--create" )
        {
            CreateOptionIsEnabled = true;
        }
        else if ( option == "--watch" )
        {
            WatchOptionIsEnabled = true;
        }
        else if ( option == "--pause"
                  && argument_array.length >= 1 )
        {
            PauseDuration = argument_array[ 0 ].to!long();

            argument_array = argument_array[ 1 .. $ ];
        }
        else
        {
            PrintError( "Invalid option : " ~ option );
        }
    }

    if ( argument_array.length == 2
         && argument_array[ 0 ].GetLogicalPath().endsWith( '/' )
         && argument_array[ 1 ].GetLogicalPath().endsWith( '/' ) )
    {
        input_folder_path = argument_array[ 0 ].GetLogicalPath();
        output_folder_path = argument_array[ 1 ].GetLogicalPath();

        if ( WatchOptionIsEnabled )
        {
            WatchFiles( input_folder_path, output_folder_path );
        }
        else
        {
            ProcessFiles( input_folder_path, output_folder_path, false );
        }
    }
    else
    {
        writeln( "Usage :" );
        writeln( "    phoenix [options] <INPUT_FOLDER> <OUTPUT_FOLDER>" );
        writeln( "Options :" );
        writeln( "    --extract <tag> <SCRIPT_FOLDER>" );
        writeln( "    --compress" );
        writeln( "    --trim" );
        writeln( "    --create" );
        writeln( "    --watch" );
        writeln( "    --pause 500" );
        writeln( "Examples :" );
        writeln( "    phoenix --extract style STYLE/ --compress --trim --create PHX/ PHP/" );
        writeln( "    phoenix --extract style STYLE/ --compress --trim --create --watch PHX/ PHP/" );

        PrintError( "Invalid arguments : " ~ argument_array.to!string() );
    }
}
