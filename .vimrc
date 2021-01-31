" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=90 foldmarker={,} foldlevel=0 foldmethod=marker nospell:
"
"         _    _ _______ _______             _
"        | |  | |__   __|__   __|    __   __(_)_ __ ___
"        | |__| |  | |     | |  _____\ \ / /| | '_ ` _ \
"        |  __  | _| |    _| | |_____|\ V / | | | | | | |
"        | |  | |\ \ |   \ \ |         \_/  |_|_| |_| |_|
"        |_|  |_| \__/    \__/
"
"
"   This is the personal .vimrc file of HEJunJie.
"
"   Copyright 2018 HEJunJie
"
"   Licensed under the Apache License, Version 2.0 (the "License");
"   you may not use this file except in compliance with the License.
"   You may obtain a copy of the License at
"
"       http://www.apache.org/licenses/LICENSE-2.0
"
"   Unless required by applicable law or agreed to in writing, software
"   distributed under the License is distributed on an "AS IS" BASIS,
"   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
"   See the License for the specific language governing permissions and
"   limitations under the License.
" }

" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
            set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME

            " Be nice and check for multi_byte even if the config requires
            " multi_byte support most of the time
            if has("multi_byte")
                " Windows cmd.exe still uses cp850. If Windows ever moved to
                " Powershell as the primary terminal, this would be utf-8
                set termencoding=cp850
                " Let Vim use utf-8 internally, because many scripts require this
                set encoding=utf-8
                setglobal fileencoding=utf-8
                " Windows has traditionally used cp1252, so it's probably wise to
                " fallback into cp1252 instead of eg. iso-8859-15.
                " Newer Windows files might contain utf-8 or utf-16 LE so we might
                " want to try them first.
                set fileencodings=ucs-bom,utf-8,gb2312,cp936,gb18030,big5,euc-jp,euc-kr,utf-16le,cp1252,iso-8859-15
            endif
        endif
    " }

" }

" Use bundles config {

    if filereadable(expand("~/.vimrc.plugged"))
        source ~/.vimrc.plugged
    endif

    "if filereadable(expand("~/.vimrc.bundles"))
    "    source ~/.vimrc.bundles
    "endif

" }

" General {

    set background=dark     " Assume a dark background

    filetype plugin indent on   " Automatically detect file types
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8        " Specify the encoding of the script

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else                   " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Most prefer to automatically switch to the current file directory when a new buffer is opened;
    " to prevent this behavior, add the following to .vimrc
    " let g:no_autochdir = 1
    if !exists('g:no_autochdir')
        " Always switch to the current file directory
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
    endif

    set nospell                         " Spell checking off
    "set autowrite                       " Automatically write a file when leaving a modified buffer
    "set virtualedit=onemore             " Allow for cursor beyond last character
    set shortmess+=filmnxoOtT           " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set history=1000                    " Store a ton of history (default is 20)
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    autocmd FileType gitcommit autocmd! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc
    " let g:no_restore_cursor = 1
    if !exists('g:no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.before.local file:
        "   let g:spf13_no_views = 1
        if !exists('g:spf13_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }

" }

" Vim UI {

    if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
        let g:solarized_termcolors=256
        let g:solarized_termtrans=1
        let g:solarized_contrast="normal"
        let g:solarized_visibility="normal"
        let g:solarized_italic=0
        colors solarized             " Load a colorscheme
    endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line
    "set cursorcolumn                " Highlight current column

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        set statusline+=%{fugitive#statusline()} " Git Hotness
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    "set cindent
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks

    " Remove trailing whitespaces and ^M chars To disable the stripping of whitespace, add the following to .vimrc file:
    " let s:keep_trailing_whitespace = 1
    autocmd FileType c,cpp,python,java,go,php,javascript,puppet,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('s:keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    autocmd BufWritePre *.md call StripTrailingWhitespace()

    autocmd FileType haskell,ruby setlocal expandtab shiftwidth=2 softtabstop=2

" }

" Key Mappings {

    "Buffer List
    nnoremap <silent> [b :bprevious<CR>
    nnoremap <silent> ]b :bnext<CR>
    nnoremap <silent> [B :bfirst<CR>
    nnoremap <silent> ]B :blast<CR>

    "Location List
    nnoremap <silent> [l :lprevious<CR>
    nnoremap <silent> ]l :lnext<CR>
    nnoremap <silent> [L :lfirst<CR>
    nnoremap <silent> ]L :llast<CR>
    nnoremap <leader>lc :lclose<CR>

    "Quickfix List
    nnoremap <silent> [c :cprevious<CR>
    nnoremap <silent> ]c :cnext<CR>
    nnoremap <silent> [C :cfirst<CR>
    nnoremap <silent> ]C :clast<CR>
    nnoremap <leader>cc :cclose<CR>

    " The default leader is '\', but many people prefer ',' as it's in a standard location.
    let mapleader = ','
    let maplocalleader = '_'

    " ,键是反转方向查找上次的字符查找命令, ,键映射成<leader>键, 补充映射 \ 到 ,
    noremap \ ,

    " The mappings for editing and applying the Vim configuration.
    let s:edit_config_mapping = '<leader>se'
    let s:apply_config_mapping = '<leader>sa'

    " Easier moving in tabs and windows,<Bar> replace |
    "map <C-J> <C-W>j<C-W>_
    "map <C-K> <C-W>k<C-W>_
    "map <C-L> <C-W>l<C-w><Bar>
    "map <C-H> <C-W>h<C-w><Bar>
    map <C-J> <C-W>j
    map <C-K> <C-W>k
    map <C-L> <C-W>l
    map <C-H> <C-W>h

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current search results.
    "nmap <silent> <leader>/ :nohlsearch<CR>
    nmap <silent> <leader>/ :set invhlsearch<CR>

    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{}( .*\|$)<CR>

    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h

    " Allow using the repeat operator with a visual selection (!)
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Map <Leader>ff to display all lines with keyword under cursor and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

" }

" GUI Settings {

    if has('gui_running')
        set guioptions-=m  " 隐藏菜单栏
        set guioptions-=T  " 隐藏工具栏
        "set guioptions-=L " 隐藏左侧滚动条
        "set guioptions-=r " 隐藏右侧滚动条
        "set guioptions-=b " 隐藏底部滚动条
        "set showtabline=0 " 隐藏Tab栏

        nnoremap <C-F1> :if &go=~#'m'<Bar>set go-=m<Bar>else<Bar>set go+=m<Bar>endif<CR>
        nnoremap <C-F2> :if &go=~#'T'<Bar>set go-=T<Bar>else<Bar>set go+=T<Bar>endif<CR>
        nnoremap <C-F3> :if &go=~#'r'<Bar>set go-=r<Bar>else<Bar>set go+=r<Bar>endif<CR>

        set lines=40      " 40 lines of text instead of 24
        set columns=100   " 100 columns of text

        if LINUX()
            set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
        elseif OSX()
            set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
        elseif WINDOWS()
            "set guifont=DejaVu_Sans_Mono_for_Powerline:h13:cANSI
            "set guifont=Droid_Sans_Mono_Dotted:h13:cANSI
            " set guifont=Droid_Sans_Mono_slashed:h13:cANSI
            set guifont=Consolas_for_Powerline:h13
            ":cANSI
        endif

    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Plugins {

    " Ctags {
        set tags=./tags;/,~/.vimtags

        "设置工程路径
        "set path+=F:\u-boot-1.1.6\**

        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-e> <plug>NERDTreeTabsToggle<CR>

            let NERDTreeShowBookmarks=1 "显示Bookmarks
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0  "可以改变Vim的CWD
            let NERDTreeQuitOnOpen=0 "打开文件后自动关闭
            let NERDTreeMouseMode=2  "鼠标模式:目录单击,文件双击
            let NERDTreeShowHidden=1 "显示隐藏文件
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0

            "显示增强
            let NERDChristmasTree=1
            "自动调整焦点
            let NERDTreeAutoCenter=1
            "高亮显示当前文件或目录
            let NERDTreeHighlightCursorline=1
            "显示文件
            let NERDTreeShowFiles=1
            "显示行号
            let NERDTreeShowLineNumbers=1
            "不显示'Bookmarks' label 'Press ? for help'
            "let NERDTreeMinimalUI=1
            "窗口位置
            "let NERDTreeWinPos="left"
            "窗口宽度
            "let NERDTreeWinSize=30
            "文件夹层次符号
            "let g:NERDTreeDirArrowExpandable = '▸'
            "let g:NERDTreeDirArrowCollapsible = '▾'
        endif
    " }

    " TagBar {
        if isdirectory(expand("~/.vim/bundle/tagbar/"))
            "打开或关闭tagbar
            nnoremap <silent> <leader>tt :TagbarToggle<CR>

            "跳转到Tagbar
            nnoremap <silent> <leader>tj :TagbarOpen fj<CR>

            "设置Tagbar窗口宽度
            let g:tagbar_width=30

            "自动聚焦
            let g:tagbar_autofocus=1

            "let g:winManagerWindowLayout = "BufExplorer|FileExplorer|TagList"
            let g:winManagerWindowLayout='FileExplorer|TagList'
            nmap wm :WMToggle<cr>
        endif
    "}

    " UndoTree {
        if isdirectory(expand("~/.vim/bundle/undotree/"))
            nnoremap <Leader>u :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }

    " Sessionman {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
            nmap <leader>sl :SessionList<CR>
            nmap <leader>ss :SessionSave<CR>
            nmap <leader>sc :SessionClose<CR>
        endif
    " }

    " delimitMate {
        if isdirectory(expand("~/.vim/bundle/delimitMate/"))
            "设置换行后自动扩展
            let delimitMate_expand_cr = 1

            "设置(I)变成( I )
            let delimitMate_expand_space = 1

            "autocmd VimEnter * imap <silent> <expr> <TAB> delimitMate#ShouldJump() ? delimitMate#JumpAny() : "\<C-r>=UltiSnips#ExpandSnippetOrJump()\<CR>"
            "autocmd VimEnter * inoremap <S-TAB> <S-TAB>
        endif
    "}

    " Rainbow {
        if isdirectory(expand("~/.vim/bundle/rainbow/"))
            "if you want to enable it later via :RainbowToggle
            let g:rainbow_active = 1
        endif
    "}

    " DoxygenToolkit.vim {
        if isdirectory(expand("~/.vim/bundle/DoxygenToolkit.vim/"))
            let g:DoxygenToolkit_authorName="poiler@163.com"
        endif
    "}

    " Nerdcommenter{
        if isdirectory(expand("~/.vim/bundle/nerdcommenter/"))
            " 默认情况下在注释分隔符后面添加空格
            let g:NERDSpaceDelims = 1

            " 允许对空行进行注释和取消注释
            "let g:NERDCommentEmptyLines = 1
        endif
    "}

    " Tabular {
        if isdirectory(expand("~/.vim/bundle/tabular"))
            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        endif
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        if isdirectory(expand("~/.vim/bundle/vim-airline/"))
            let g:airline_powerline_fonts=1

            " if !exists('g:airline_symbols')
                " let g:airline_symbols = {}
            " endif
            " let g:airline_left_sep = ''
            " let g:airline_left_alt_sep = ''
            " let g:airline_right_sep = ''
            " let g:airline_right_alt_sep = ''
            " let g:airline_symbols.branch = ''
            " let g:airline_symbols.readonly = ''"🔒
            " let g:airline_symbols.linenr = '☰'
            " let g:airline_symbols.maxlinenr = ''
            " let g:airline_symbols.whitespace = 'Ξ'

            " let g:airline#extensions#tabline#enabled = 1
            " let g:airline#extensions#tabline#buffer_nr_show = 1
            " let g:airline#extensions#tabline#buffer_idx_mode = 1
            " nmap <leader>1 <Plug>AirlineSelectTab1
            " nmap <leader>2 <Plug>AirlineSelectTab2
            " nmap <leader>3 <Plug>AirlineSelectTab3
            " nmap <leader>4 <Plug>AirlineSelectTab4
            " nmap <leader>5 <Plug>AirlineSelectTab5
            " nmap <leader>6 <Plug>AirlineSelectTab6
            " nmap <leader>7 <Plug>AirlineSelectTab7
            " nmap <leader>8 <Plug>AirlineSelectTab8
            " nmap <leader>9 <Plug>AirlineSelectTab9
            " nmap <leader>- <Plug>AirlineSelectPrevTab
            " nmap <leader>+ <Plug>AirlineSelectNextTab
        endif

        if isdirectory(expand("~/.vim/bundle/vim-airline-themes/"))
            if !exists('g:airline_theme')
                "let g:airline_theme = 'powerlineish'
                "let g:airline_theme = 'solarized'
                let g:airline_theme = 'onedark'
            endif
            if !exists('g:airline_powerline_fonts')
                " Use the default set of separators with a few customizations
                let g:airline_left_sep='›'  " Slightly fancier than '>'
                let g:airline_right_sep='‹' " Slightly fancier than '<'
            endif
        endif
    " }

    " ctrlp {
        if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
            let g:ctrlp_working_path_mode = 'ra'
            nnoremap <silent> <D-t> :CtrlP<CR>
            nnoremap <silent> <D-r> :CtrlPMRU<CR>
            let g:ctrlp_custom_ignore = {
                \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

            if executable('ag')
                let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
            elseif executable('ack-grep')
                let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
            elseif executable('ack')
                let s:ctrlp_fallback = 'ack %s --nocolor -f'
            " On Windows use "dir" as fallback command.
            elseif WINDOWS()
                let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
            else
                let s:ctrlp_fallback = 'find %s -type f'
            endif
            if exists("g:ctrlp_user_command")
                unlet g:ctrlp_user_command
            endif
            let g:ctrlp_user_command = {
                \ 'types': {
                    \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                    \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                \ },
                \ 'fallback': s:ctrlp_fallback
            \ }

            if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
                " CtrlP extensions
                let g:ctrlp_extensions = ['funky']

                "funky
                nnoremap <Leader>fu :CtrlPFunky<Cr>
            endif
        endif
    "}

    " Fugitive {
        if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
        endif
    "}

    " YouCompleteMe {
        if isdirectory(expand("~/.vim/bundle/YouCompleteMe/"))
            let g:ycm_auto_trigger=1

            "全局模版文件所在的路径
            let g:ycm_global_ycm_extra_conf = $HOME.'/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'

            "关闭载入配置文件提示
            let g:ycm_confirm_extra_conf = 0

            "是否启用YCM的诊断功能 default: 1
            let g:ycm_show_diagnostics_ui = 1

            " YCM检测时的错误及警告的符号标志
            let g:ycm_error_symbol = '✗'
            let g:ycm_warning_symbol = '⚠'

            " 开启YCM基于标签补全的引擎
            let g:ycm_collect_identifiers_from_tags_files = 1

            " 语法关键字补全
            let g:ycm_seed_identifiers_with_syntax=1

            " 禁止缓存匹配项,每次都重新生成匹配项
            let g:ycm_cache_omnifunc=0

            " 在注释中也能补全
            let g:ycm_complete_in_comments = 1

            " 关闭YCM
            nnoremap <leader>y :let g:ycm_auto_trigger=0<CR>
            " 打开YCM
            nnoremap <leader>Y :let g:ycm_auto_trigger=1<CR>

            " remap Ultisnips for compatibility for YCM
            let g:UltiSnipsExpandTrigger = '<C-j>'
            let g:UltiSnipsJumpForwardTrigger = '<C-j>'
            let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
            "let g:UltiSnipsSnippetDirectories=$HOME.'/.vim/bundle/vim-snippets/snippets'

            " Enable omni completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

            " For snippet_complete marker.
            if !exists("g:spf13_no_conceal")
                if has('conceal')
                    set conceallevel=2 concealcursor=i
                endif
            endif

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
            set completeopt-=preview
        endif
    " }

    " Syntastic {
        if isdirectory(expand("~/.vim/bundle/syntastic/"))
            "打开当前文件的错误或警告列表
            nmap <leader>e :Errors<CR>

            "关闭当前文件的错误或警告列表
            nmap <leader>lc :lclose<CR>

            "打开错误列表后移到上一个或下一个错误位置
            nmap <leader>n :lnext<CR>
            nmap <leader>p :lprevious<CR>

            "打开文件时Syntastic插件自动高亮显示错误
            let g:syntastic_check_on_open = 0

            "保存文件时Syntastic插件自动高亮显示错误
            let g:syntastic_check_on_wq = 1

            "保存或打开文件时让光标跳转到检测到的第一个问题处
            let g:syntastic_auto_jump = 1

            "在修复错误之后自动更新它的底部描述
            let g:syntastic_always_populate_loc_list = 1

            "值为1:检测到错误自动打开错误列表,没有错误时自动关闭列表
            "值为2:检测到错误不会打开错误列表,没有错误时自动关闭列表
            let g:syntastic_auto_loc_list = 1

            "代码检测的规范选择
            "let g:syntastic_cpp_checkers = ['clang_check'] "default: gcc
            "let g:syntastic_c_checkers = ['ClangCheck']
            "let g:syntastic_python_checkers = ['flake8']

            "让syntastic支持C++11
            "let g:syntastic_cpp_compiler = 'clang++'
            "let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
            let g:syntastic_cpp_checkers = ['gcc']
            let g:syntastic_cpp_compiler = 'gcc'
            let g:syntastic_cpp_compiler_options = '-std=c++11'

            set statusline+=%#warningmsg#
            set statusline+=%{SyntasticStatuslineFlag()}
            set statusline+=%*

            let g:syntastic_error_symbol = '✗'
            let g:syntastic_warning_symbol = '⚠'
            let g:syntastic_style_error_symbol = '✗'
            let g:syntastic_style_warning_symbol = '⚠'
        endif
    " }

    " python-mode {
        if isdirectory(expand("~/.vim/bundle/python-mode"))
            " Disable whole plugin if python support not present
            if !has('python') && !has('python3')
                let g:pymode = 0
            endif

            " 插件的警告，1关闭
            let g:pymode_warnings = 1

            " 当保存时删除无用的空格
            let g:pymode_trim_whitespaces = 1

            " 是否使用默认的python设置
            let g:pymode_options = 0

            " 使用python3
            let g:pymode_python = 'python3'

            " 使用PEP8风格的缩进
            let g:pymode_indent = 1

            " 代码折叠，0不折叠
            let g:pymode_folding = 0

            " 使用python-mode运行python代码
            let g:pymode_run = 1

            "代码检查
            let g:pymode_lint_checkers = ['pyflakes']

            " 不使用代码重构,代码完成,代码辅助
            let g:pymode_rope = 0
        endif
    " }

    " markdown-preview.vim {
        " 设置 chrome 浏览器的路径（或是启动 chrome（或其他现代浏览器）的命令）
        " 如果设置了该参数, g:mkdp_browserfunc 将被忽略
        let g:mkdp_path_to_chrome = ""

        " 调用vim函数打开浏览器, 参数为要打开的url
        let g:mkdp_browserfunc = 'MKDP_browserfunc_default'

        " 设置为 1 可以在打开 markdown 文件的时候自动打开浏览器预览，只在打开markdown 文件的时候打开一次
        let g:mkdp_auto_start = 0

        " 设置为 1 在编辑 markdown 的时候检查预览窗口是否已经打开，否则自动打开预览窗口
        let g:mkdp_auto_open = 0

        " 在切换 buffer 的时候自动关闭预览窗口，设置为 0 则在切换 buffer 的时候不自动关闭预览窗口
        let g:mkdp_auto_close = 1

        " 设置为 1 则只有在保存文件，或退出插入模式的时候更新预览，默认为 0，实时更新预览
        let g:mkdp_refresh_slow = 0

        " 设置为 1 则所有文件都可以使用 MarkdownPreview 进行预览，默认只有markdown文件可以使用改命令
        let g:mkdp_command_for_global = 0

        nmap <silent> <F8> <Plug>MarkdownPreview        " 普通模式
        imap <silent> <F8> <Plug>MarkdownPreview        " 插入模式
        nmap <silent> <c-F8> <Plug>MarkdownPreviewStop  " 普通模式
        imap <silent> <c-F8> <Plug>MarkdownPreviewStop  " 插入模式
    " }
" }

" Functions {

    " Allow to trigger background {
        function! ToggleBG()
            let s:tbg = &background
            " Inversion
            if s:tbg == "dark"
                set background=light
            else
                set background=dark
            endif
        endfunction
        noremap <leader>bg :call ToggleBG()<CR>
   " }

    " Initialize directories {
        function! InitializeDirectories()
            let parent = $HOME
            let prefix = 'vim'
            let dir_list = {
                        \ 'backup': 'backupdir',
                        \ 'views': 'viewdir',
                        \ 'swap': 'directory' }

            if has('persistent_undo')
                let dir_list['undo'] = 'undodir'
            endif

            let common_dir = parent . '/.' . prefix

            for [dirname, settingname] in items(dir_list)
                let directory = common_dir . dirname . '/'
                if exists("*mkdir")
                    if !isdirectory(directory)
                        call mkdir(directory)
                    endif
                endif
                if !isdirectory(directory)
                    echo "Warning: Unable to create backup directory: " . directory
                    echo "Try: mkdir -p " . directory
                else
                    let directory = substitute(directory, " ", "\\\\ ", "g")
                    exec "set " . settingname . "=" . directory
                endif
            endfor
        endfunction
        call InitializeDirectories()
    " }

    " Initialize NERDTree as needed {
        function! NERDTreeInitAsNeeded()
            redir => bufoutput
            buffers!
            redir END
            let idx = stridx(bufoutput, "NERD_tree")
            if idx > -1
                NERDTreeMirror
                NERDTreeFind
                wincmd l
            endif
        endfunction
    " }

    " Strip whitespace {
        function! StripTrailingWhitespace()
            " Preparation: save last search, and cursor position.
            let _s=@/
            let l = line(".")
            let c = col(".")
            " do the business:
            %s/\s\+$//e
            " clean up: restore previous search history, and cursor position
            let @/=_s
            call cursor(l, c)
        endfunction
    " }

    " VimConfig {
        function! s:ExpandFilenameAndExecute(command, file)
            execute a:command . " " . expand(a:file, ":p")
        endfunction

        function! s:EditVimConfig()
            call <SID>ExpandFilenameAndExecute("edit", "~/.vimrc.bundles")
            call <SID>ExpandFilenameAndExecute("edit", "~/.vimrc")
            execute bufwinnr(".vimrc") . "wincmd w"
        endfunction

        execute "noremap " . s:edit_config_mapping " :call <SID>EditVimConfig()<CR>"
        execute "noremap " . s:apply_config_mapping . " :source ~/.vimrc<CR>"
    " }

" }

" C C++ 编译、连接、运行配置 {

    " F9 一键保存、编译、连接存并运行
    map <F9> :call Run()<CR>
    imap <F9> <ESC>:call Run()<CR>

    " Ctrl + F9 一键保存并编译
    map <c-F9> :call Compile()<CR>
    imap <c-F9> <ESC>:call Compile()<CR>

    " Ctrl + F10 一键保存并连接
    map <c-F10> :call Link()<CR>
    imap <c-F10> <ESC>:call Link()<CR>

    if(has("win32") || has("win64"))
        let g:iswindows = 1
    else
        let g:iswindows = 0
    endif

    if has("gui_running")
        let g:isGUI = 1
    else
        let g:isGUI = 0
    endif

    let s:LastShellReturn_C = 0
    let s:LastShellReturn_L = 0
    let s:ShowWarning = 1
    let s:Obj_Extension = '.o'
    let s:Exe_Extension = '.exe'
    let s:Sou_Error = 0

    let s:windows_CFlags = 'gcc\ -fexec-charset=utf-8\ -finput-charset=utf-8\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
    let s:linux_CFlags = 'gcc\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'

    let s:windows_CPPFlags = 'g++\ -fexec-charset=utf-8\ -finput-charset=utf-8\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'
    let s:linux_CPPFlags = 'g++\ -Wall\ -g\ -O0\ -c\ %\ -o\ %<.o'

    func! Compile()
        exe ":ccl"
        exe ":update"
        if expand("%:e") == "c" || expand("%:e") == "cpp" || expand("%:e") == "cxx"
            let s:Sou_Error = 0
            let s:LastShellReturn_C = 0
            let Sou = expand("%:p")
            let Obj = expand("%:p:r").s:Obj_Extension
            let Obj_Name = expand("%:p:t:r").s:Obj_Extension
            let v:statusmsg = ''
            if !filereadable(Obj) || (filereadable(Obj) && (getftime(Obj) < getftime(Sou)))
                redraw!
                if expand("%:e") == "c"
                    if g:iswindows
                        exe ":setlocal makeprg=".s:windows_CFlags
                    else
                        exe ":setlocal makeprg=".s:linux_CFlags
                    endif
                    echohl WarningMsg | echo " compiling..."
                    silent make
                elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                    if g:iswindows
                        exe ":setlocal makeprg=".s:windows_CPPFlags
                    else
                        exe ":setlocal makeprg=".s:linux_CPPFlags
                    endif
                    echohl WarningMsg | echo " compiling...cpp"
                    silent make
                endif
                redraw!
                if v:shell_error != 0
                    let s:LastShellReturn_C = v:shell_error
                endif
                if g:iswindows
                    if s:LastShellReturn_C != 0
                        exe ":bo cope"
                        echohl WarningMsg | echo " compilation failed"
                    else
                        if s:ShowWarning
                            exe ":bo cw"
                        endif
                        echohl WarningMsg | echo " compilation successful"
                    endif
                else
                    if empty(v:statusmsg)
                        echohl WarningMsg | echo " compilation successful"
                    else
                        exe ":bo cope"
                    endif
                endif
            else
                echohl WarningMsg | echo ""Obj_Name"is up to date"
            endif
        else
            let s:Sou_Error = 1
            echohl WarningMsg | echo " please choose the correct source file"
        endif
        exe ":setlocal makeprg=make"
    endfunc

    func! Link()
        call Compile()
        if s:Sou_Error || s:LastShellReturn_C != 0
            return
        endif
        let s:LastShellReturn_L = 0
        let Sou = expand("%:p")
        let Obj = expand("%:p:r").s:Obj_Extension
        if g:iswindows
            let Exe = expand("%:p:r").s:Exe_Extension
            let Exe_Name = expand("%:p:t:r").s:Exe_Extension
        else
            let Exe = expand("%:p:r")
            let Exe_Name = expand("%:p:t:r")
        endif
        let v:statusmsg = ''
        if filereadable(Obj) && (getftime(Obj) >= getftime(Sou))
            redraw!
            if !executable(Exe) || (executable(Exe) && getftime(Exe) < getftime(Obj))
                if expand("%:e") == "c"
                    setlocal makeprg=gcc\ -o\ %<\ %<.o
                    echohl WarningMsg | echo " linking..."
                    silent make
                elseif expand("%:e") == "cpp" || expand("%:e") == "cxx"
                    setlocal makeprg=g++\ -o\ %<\ %<.o
                    echohl WarningMsg | echo " linking..."
                    silent make
                endif
                redraw!
                if v:shell_error != 0
                    let s:LastShellReturn_L = v:shell_error
                endif
                if g:iswindows
                    if s:LastShellReturn_L != 0
                        exe ":bo cope"
                        echohl WarningMsg | echo " linking failed"
                    else
                        if s:ShowWarning
                            exe ":bo cw"
                        endif
                        echohl WarningMsg | echo " linking successful"
                    endif
                else
                    if empty(v:statusmsg)
                        echohl WarningMsg | echo " linking successful"
                    else
                        exe ":bo cope"
                    endif
                endif
            else
                echohl WarningMsg | echo ""Exe_Name"is up to date"
            endif
        endif
        setlocal makeprg=make
    endfunc

    func! Run()
        let s:ShowWarning = 0
        call Link()
        let s:ShowWarning = 1
        if s:Sou_Error || s:LastShellReturn_C != 0 || s:LastShellReturn_L != 0
            return
        endif
        let Sou = expand("%:p")
        let Obj = expand("%:p:r").s:Obj_Extension
        if g:iswindows
            let Exe = expand("%:p:r").s:Exe_Extension
        else
            let Exe = expand("%:p:r")
        endif
        if executable(Exe) && getftime(Exe) >= getftime(Obj) && getftime(Obj) >= getftime(Sou)
            redraw!
            echohl WarningMsg | echo " running..."
            if g:iswindows
                exe ":!%<.exe"
            else
                if g:isGUI
                    exe ":!gnome-terminal -e ./%<"
                else
                    exe ":!./%<"
                endif
            endif
            redraw!
            echohl WarningMsg | echo " running finish"
        endif
    endfunc
" }

" 运行当前python脚本 {

    nmap <F7> :! python %<CR>

    "开启对不规范的Python语法的警告提示
    " let python_highlight_all = 1

    "如果觉得警告太多，也可以分别打开各个开关
    let python_no_builtin_highlight = 1
    let python_no_doctest_code_highlight = 1
    let python_no_doctest_highlight = 1
    let python_no_exception_highlight = 1
    let python_no_number_highlight = 1
    let python_space_error_highlight = 1

" }

