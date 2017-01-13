module Main exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Char
import String
import Task
import Animation


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate
        (model.inputStyle :: model.entryStyles)


type alias Model =
    { input : String
    , entries : List Entry
    , isInputOn : Bool
    , inputStyle : Animation.State
    , entryStyles : List Animation.State
    }


type alias Entry =
    { isNew : Bool
    , letter : Char
    , word : String
    }


init : ( Model, Cmd Msg )
init =
    { input = ""
    , entries = []
    , isInputOn = False
    , inputStyle = initInputStyle
    , entryStyles = []
    }
        ! []


type Msg
    = NoOp
    | Animate Animation.Msg
    | UpdateInput String
    | AnimateInput


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            model ! []

        Animate msg ->
            { model
                | inputStyle = Animation.update msg model.inputStyle
                , entryStyles = List.map (Animation.update msg) model.entryStyles
            }
                ! []

        UpdateInput input ->
            let
                inputChars =
                    String.toList input

                entries =
                    makeEntries inputChars model.entries

                entryStyles =
                    initNewEntryStyles entries model.entryStyles

                newEntryCount =
                    List.length (List.filter .isNew entries)
            in
                { model
                    | input = input
                    , entries = entries
                    , entryStyles = entryStyles
                }
                    ! [ makeCmd AnimateInput ]

        AnimateInput ->
            let
                newModel =
                    if not model.isInputOn then
                        { model
                            | isInputOn = True
                            , inputStyle = animateInput model.inputStyle
                        }
                    else
                        model
            in
                { newModel
                    | entryStyles = List.map animateEntry model.entryStyles
                }
                    ! []


makeEntries : List Char -> List Entry -> List Entry
makeEntries chars entries =
    case ( chars, entries ) of
        ( c :: cs, { isNew, letter, word } :: es ) ->
            if c == letter then
                Entry False letter word :: makeEntries cs es
            else
                Entry True c (toPhonetic c) :: makeEntries cs entries

        ( c :: cs, [] ) ->
            Entry True c (toPhonetic c) :: makeEntries cs []

        ( [], _ ) ->
            []


toPhonetic : Char -> String
toPhonetic c =
    case withoutAccent (Char.toLower c) of
        'a' ->
            "alpha"

        'b' ->
            "bravo"

        'c' ->
            "charlie"

        'd' ->
            "delta"

        'e' ->
            "echo"

        'f' ->
            "foxtrot"

        'g' ->
            "golf"

        'h' ->
            "hotel"

        'i' ->
            "india"

        'j' ->
            "juliett"

        'k' ->
            "kilo"

        'l' ->
            "lima"

        'm' ->
            "mike"

        'n' ->
            "november"

        'o' ->
            "oscar"

        'p' ->
            "papa"

        'q' ->
            "quebec"

        'r' ->
            "romeo"

        's' ->
            "sierra"

        't' ->
            "tango"

        'u' ->
            "uniform"

        'v' ->
            "victor"

        'w' ->
            "whiskey"

        'x' ->
            "x-ray"

        'y' ->
            "yankee"

        'z' ->
            "zulu"

        '1' ->
            "one"

        '2' ->
            "two"

        '3' ->
            "three"

        '4' ->
            "four"

        '5' ->
            "five"

        '6' ->
            "six"

        '7' ->
            "seven"

        '8' ->
            "eight"

        '9' ->
            "nine"

        '0' ->
            "zero"

        ' ' ->
            "space"

        '!' ->
            "exclamation mark"

        '"' ->
            "double quotes"

        '#' ->
            "hashtag"

        '$' ->
            "dollar"

        '%' ->
            "percent"

        '&' ->
            "ampersand"

        '\'' ->
            "single quote"

        '(' ->
            "opening parenthesis"

        ')' ->
            "closing parenthesis"

        '*' ->
            "asterisk"

        '+' ->
            "plus"

        ',' ->
            "comma"

        '-' ->
            "minus/hyphen"

        '.' ->
            "period"

        '/' ->
            "slash"

        ':' ->
            "colon"

        ';' ->
            "semicolon"

        '<' ->
            "less than"

        '=' ->
            "equals"

        '>' ->
            "greater than"

        '?' ->
            "question mark"

        '@' ->
            "at"

        '[' ->
            "opening bracket"

        '\\' ->
            "backslash"

        ']' ->
            "closing bracket"

        '^' ->
            "caret"

        '_' ->
            "underscore"

        '`' ->
            "grave accent"

        '{' ->
            "opening brace"

        '|' ->
            "vertical bar"

        '}' ->
            "closing brace"

        '~' ->
            "tilde"

        '¢' ->
            "cent"

        '£' ->
            "british pound"

        '€' ->
            "euro"

        '¥' ->
            "yen"

        'ƒ' ->
            "dutch florin"

        'ß' ->
            "sierra/sharp S"

        _ ->
            toString c


withoutAccent : Char -> Char
withoutAccent c =
    case c of
        'à' ->
            'a'

        'á' ->
            'a'

        'â' ->
            'a'

        'ã' ->
            'a'

        'ä' ->
            'a'

        'å' ->
            'a'

        'ą' ->
            'a'

        'č' ->
            'c'

        'ç' ->
            'c'

        'ć' ->
            'c'

        'ď' ->
            'd'

        'è' ->
            'e'

        'é' ->
            'e'

        'ê' ->
            'e'

        'ë' ->
            'e'

        'ě' ->
            'e'

        'ę' ->
            'e'

        'ì' ->
            'i'

        'í' ->
            'i'

        'î' ->
            'i'

        'ï' ->
            'i'

        'ĺ' ->
            'l'

        'ľ' ->
            'l'

        'ł' ->
            'l'

        'ň' ->
            'n'

        'ń' ->
            'n'

        'ñ' ->
            'n'

        'ò' ->
            'o'

        'ó' ->
            'o'

        'ô' ->
            'o'

        'õ' ->
            'o'

        'ö' ->
            'o'

        'ø' ->
            'o'

        'ő' ->
            'o'

        'ŕ' ->
            'r'

        'ř' ->
            'r'

        'š' ->
            's'

        'ś' ->
            's'

        'ť' ->
            't'

        'ù' ->
            'u'

        'ú' ->
            'u'

        'û' ->
            'u'

        'ü' ->
            'u'

        'ů' ->
            'u'

        'ý' ->
            'y'

        'ÿ' ->
            'y'

        'ž' ->
            'z'

        'ź' ->
            'z'

        'ż' ->
            'z'

        _ ->
            c


makeCmd : msg -> Cmd msg
makeCmd msg =
    Task.perform identity (Task.succeed msg)


initInputStyle : Animation.State
initInputStyle =
    Animation.style
        [ Animation.custom "flex" 1.0 "" ]


initNewEntryStyles : List Entry -> List Animation.State -> List Animation.State
initNewEntryStyles entries cssStyles =
    case ( entries, cssStyles ) of
        ( { isNew, letter, word } :: es, c :: cs ) ->
            if isNew then
                initEntryStyle :: initNewEntryStyles es cssStyles
            else
                c :: initNewEntryStyles es cs

        ( { isNew, letter, word } :: es, [] ) ->
            if isNew then
                initEntryStyle :: initNewEntryStyles es []
            else
                []

        ( _, _ ) ->
            []


initEntryStyle : Animation.State
initEntryStyle =
    Animation.style
        [ Animation.opacity 0.0 ]


animateInput : Animation.State -> Animation.State
animateInput cssStyle =
    Animation.interrupt
        [ Animation.to
            [ Animation.custom "flex" 0.2 "" ]
        ]
        cssStyle


animateEntry : Animation.State -> Animation.State
animateEntry cssStyle =
    Animation.interrupt
        [ Animation.to
            [ Animation.opacity 1.0 ]
        ]
        cssStyle


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div
            (Animation.render model.inputStyle
                ++ [ class "input" ]
            )
            [ input
                [ class "input-box"
                , autofocus True
                , onInput (\s -> UpdateInput s)
                ]
                []
            ]
        , div
            [ class "results" ]
            (List.map2 viewEntry model.entries model.entryStyles)
        ]


viewEntry : Entry -> Animation.State -> Html Msg
viewEntry entry cssStyle =
    div
        (Animation.render cssStyle
            ++ [ class "result" ]
        )
        [ div
            [ class "letter-box" ]
            [ div
                [ class "letter" ]
                [ text (String.fromChar entry.letter) ]
            ]
        , div
            [ class "word-box" ]
            [ div
                [ class "word" ]
                [ text entry.word ]
            ]
        ]
