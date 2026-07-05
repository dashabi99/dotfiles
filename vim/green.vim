highlight clear
if exists('syntax_on')
      syntax reset

endif
let g:colors_name = 'green'
" General

highlight Normal        gui=NONE cterm=NONE



highlight Conceal       guifg=LightGrey guibg=DarkGrey ctermfg=LightGrey ctermbg=DarkGrey

highlight Cursor        gui=NONE cterm=NONE

highlight lCursor       gui=NONE cterm=NONE

highlight DiffText      guifg=white guibg=#ce104c gui=bold ctermbg=Red cterm=bold

highlight ErrorMsg      guifg=White guibg=Red ctermfg=White ctermbg=DarkRed

highlight IncSearch     gui=reverse cterm=reverse

highlight ModeMsg       gui=bold cterm=bold

highlight NonText       guifg=Grey gui=bold ctermfg=Blue

highlight PmenuSbar     guibg=Grey ctermbg=Grey

highlight StatusLine    guifg=White guibg=#427b58 gui=NONE cterm=bold

highlight StatusLineNC  guifg=White guibg=#5f676a gui=NONE cterm=NONE

highlight TabLineFill   cterm=reverse

highlight TabLineSel    gui=NONE guibg=#427b58 cterm=bold

highlight TermCursor    gui=reverse cterm=reverse

highlight WinBar        gui=bold cterm=bold

highlight WildMenu      guifg=Black guibg=Yellow ctermfg=Black ctermbg=Yellow



highlight! link VertSplit Normal

highlight! link WinSeparator VertSplit

highlight! link WinBarNC WinBar

highlight! link EndOfBuffer NonText

highlight! link LineNrAbove LineNr

highlight! link LineNrBelow LineNr

highlight! link QuickFixLine Search

highlight! link CursorLineSign SignColumn

highlight! link CursorLineFold FoldColumn

highlight! link CurSearch Search

highlight! link PmenuKind Pmenu

highlight! link PmenuKindSel PmenuSel

highlight! link PmenuExtra Pmenu

highlight! link PmenuExtraSel PmenuSel

highlight! link Substitute Search

highlight! link Whitespace NonText

highlight! link MsgSeparator StatusLine

highlight! link NormalFloat Pmenu

highlight! link FloatBorder WinSeparator

highlight! link FloatTitle Title

highlight! link FloatFooter Title


highlight FloatShadow          guibg=Black

highlight FloatShadowThrough   guibg=Black

highlight RedrawDebugNormal    gui=reverse cterm=reverse

highlight RedrawDebugClear     guibg=Yellow ctermbg=Yellow

highlight RedrawDebugComposed  guibg=Green ctermbg=Green

highlight RedrawDebugRecompose guibg=Red ctermbg=Red

highlight Error                guifg=White guibg=DarkRed ctermfg=White ctermbg=Red

highlight Todo                 guifg=Blue guibg=Yellow ctermfg=Black ctermbg=Yellow



highlight! link String Constant

highlight! link Character Constant

highlight! link Number Constant

highlight! link Boolean Constant

highlight! link Float Number

highlight! link Function Identifier

highlight! link Conditional Statement

highlight! link Repeat Statement

highlight! link Label Statement

highlight! link Operator Statement

highlight! link Keyword Statement

highlight! link Exception Statement

highlight! link Include PreProc

highlight! link Define PreProc

highlight! link Macro PreProc

highlight! link PreCondit PreProc

highlight! link StorageClass Type

highlight! link Structure Type

highlight! link Typedef Type

highlight! link Tag Special

highlight! link SpecialChar Special

highlight! link Delimiter Special

highlight! link SpecialComment Special

highlight! link Debug Special



highlight DiagnosticError            guifg=Red ctermfg=1

highlight DiagnosticWarn             guifg=Orange ctermfg=3

highlight DiagnosticInfo             guifg=LightBlue ctermfg=4

highlight DiagnosticHint             guifg=LightGrey ctermfg=7

highlight DiagnosticOk               guifg=LightGreen ctermfg=10

highlight DiagnosticUnderlineError   guisp=Red gui=underline cterm=underline

highlight DiagnosticUnderlineWarn    guisp=Orange gui=underline cterm=underline

highlight DiagnosticUnderlineInfo    guisp=LightBlue gui=underline cterm=underline

highlight DiagnosticUnderlineHint    guisp=LightGrey gui=underline cterm=underline

highlight DiagnosticUnderlineOk      guisp=LightGreen gui=underline cterm=underline

highlight! link DiagnosticVirtualTextError DiagnosticError

highlight! link DiagnosticVirtualTextWarn DiagnosticWarn

highlight! link DiagnosticVirtualTextInfo DiagnosticInfo

highlight! link DiagnosticVirtualTextHint DiagnosticHint

highlight! link DiagnosticVirtualTextOk DiagnosticOk

highlight! link DiagnosticFloatingError DiagnosticError

highlight! link DiagnosticFloatingWarn DiagnosticWarn

highlight! link DiagnosticFloatingInfo DiagnosticInfo

highlight! link DiagnosticFloatingHint DiagnosticHint

highlight! link DiagnosticFloatingOk DiagnosticOk

highlight! link DiagnosticSignError DiagnosticError

highlight! link DiagnosticSignWarn DiagnosticWarn

highlight! link DiagnosticSignInfo DiagnosticInfo

highlight! link DiagnosticSignHint DiagnosticHint

highlight! link DiagnosticSignOk DiagnosticOk

highlight DiagnosticDeprecated       guisp=Red gui=strikethrough cterm=strikethrough



highlight! link DiagnosticUnnecessary Comment

highlight! link LspInlayHint NonText

highlight! link SnippetTabstop Visual



" Treesitter / LSP capture groups

" Vim 9.2 本身不一定使用这些 @xxx 组，silent! 可以避免不支持时报错。

silent! highlight! link @markup.raw Comment

silent! highlight! link @markup.link Identifier

silent! highlight! link @markup.heading Title

silent! highlight! link @markup.link.url Underlined

silent! highlight! link @markup.underline Underlined

silent! highlight! link @comment.todo Todo



silent! highlight! link @comment Comment

silent! highlight! link @punctuation Delimiter



silent! highlight! link @constant Constant

silent! highlight! link @constant.builtin Special

silent! highlight! link @constant.macro Define

silent! highlight! link @keyword.directive Define

silent! highlight! link @string String

silent! highlight! link @string.escape SpecialChar

silent! highlight! link @string.special SpecialChar

silent! highlight! link @character Character

silent! highlight! link @character.special SpecialChar

silent! highlight! link @number Number

silent! highlight! link @boolean Boolean

silent! highlight! link @number.float Float



silent! highlight! link @function Function

silent! highlight! link @function.builtin Special

silent! highlight! link @function.macro Macro

silent! highlight! link @function.method Function

silent! highlight! link @variable.parameter Identifier

silent! highlight! link @variable.parameter.builtin Special

silent! highlight! link @variable.member Identifier

silent! highlight! link @property Identifier

silent! highlight! link @attribute Macro

silent! highlight! link @attribute.builtin Special

silent! highlight! link @constructor Special



silent! highlight! link @keyword.conditional Conditional

silent! highlight! link @keyword.repeat Repeat

silent! highlight! link @keyword.type Structure

silent! highlight! link @label Label

silent! highlight! link @operator Operator

silent! highlight! link @keyword Keyword

silent! highlight! link @keyword.exception Exception



silent! highlight! link @variable Identifier

silent! highlight! link @type Type

silent! highlight! link @type.definition Typedef

silent! highlight! link @module Identifier

silent! highlight! link @keyword.import Include

silent! highlight! link @keyword.directive PreProc

silent! highlight! link @keyword.debug Debug

silent! highlight! link @tag Tag

silent! highlight! link @tag.builtin Special



" LSP semantic tokens

silent! highlight! link @lsp.type.class Structure

silent! highlight! link @lsp.type.comment Comment

silent! highlight! link @lsp.type.decorator Function

silent! highlight! link @lsp.type.enum Structure

silent! highlight! link @lsp.type.enumMember Constant

silent! highlight! link @lsp.type.function Function

silent! highlight! link @lsp.type.interface Structure

silent! highlight! link @lsp.type.macro Macro

silent! highlight! link @lsp.type.method Function

silent! highlight! link @lsp.type.namespace Structure

silent! highlight! link @lsp.type.parameter Identifier

silent! highlight! link @lsp.type.property Identifier

silent! highlight! link @lsp.type.struct Structure

silent! highlight! link @lsp.type.type Type

silent! highlight! link @lsp.type.typeParameter Typedef

silent! highlight! link @lsp.type.variable Identifier



highlight ColorColumn  guibg=#111111 ctermbg=DarkRed

highlight CursorColumn guibg=#2c2e33 ctermbg=DarkGrey

highlight CursorLine   guibg=#2c2e33 cterm=underline

highlight CursorLineNr guifg=White gui=bold ctermfg=White cterm=underline

highlight DiffAdd      guifg=white guibg=Green ctermbg=DarkBlue

highlight DiffChange   guifg=white guibg=#6f3f89 ctermbg=DarkMagenta

highlight DiffDelete   guifg=Blue guibg=DarkCyan gui=bold ctermfg=Blue ctermbg=DarkCyan

highlight Directory    guifg=Cyan ctermfg=LightCyan

highlight FoldColumn   guifg=black ctermfg=Cyan ctermbg=DarkGrey

highlight Folded       guibg=#444444 ctermfg=Cyan ctermbg=DarkGrey

highlight LineNr       guifg=Grey gui=NONE ctermfg=Grey

highlight MatchParen   guibg=DarkCyan ctermbg=DarkCyan

highlight MoreMsg      guifg=SeaGreen gui=bold ctermfg=LightGreen

highlight Pmenu        guibg=#191919 ctermfg=Black ctermbg=Magenta

highlight PmenuSel     guibg=#427b58 ctermfg=DarkGrey ctermbg=Black

highlight PmenuThumb   guibg=White ctermbg=White

highlight Question     guifg=Green gui=bold ctermfg=LightGreen

highlight Search       guifg=Black guibg=Yellow ctermfg=Black ctermbg=Yellow

highlight SignColumn   guifg=Cyan ctermfg=Cyan ctermbg=DarkGrey

highlight SpecialKey   guifg=Cyan ctermfg=LightBlue

highlight SpellBad     guisp=Red gui=undercurl ctermbg=Red

highlight SpellCap     guisp=Blue gui=undercurl ctermbg=Blue

highlight SpellLocal   guisp=Cyan gui=undercurl ctermbg=Cyan

highlight SpellRare    guisp=Magenta gui=undercurl ctermbg=Magenta

highlight TabLine      guibg=black gui=NONE ctermfg=White ctermbg=DarkGrey cterm=underline

highlight Title        guifg=#c85577 gui=bold ctermfg=LightMagenta

highlight Visual       guifg=white guibg=#427b58 ctermfg=Black ctermbg=Grey

highlight WarningMsg   guifg=#e6da00 ctermfg=LightRed

highlight Comment      guifg=Grey ctermfg=Grey

highlight Constant     guifg=#ffff60 ctermfg=Magenta

highlight Special      guifg=Orange ctermfg=LightRed

highlight Identifier   guifg=#ff5577 ctermfg=Cyan cterm=bold

highlight Statement    guifg=#40ffba gui=bold ctermfg=Yellow

highlight PreProc      guifg=#ff80ff ctermfg=LightBlue

highlight Type         guifg=#60ff60 gui=bold ctermfg=LightGreen

highlight Underlined   guifg=#80a0ff gui=underline ctermfg=LightBlue cterm=underline

highlight Ignore       ctermfg=Black
