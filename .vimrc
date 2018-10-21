set nocompatible "不用vi兼容模式
" Fisa-vim-config

" ============================================================================
" Vim-plug initialization
" Avoid modify this section, unless you are very sure of what you are doing
let mapleader="\<space>"

"""初次安装vim插件管理工具,以及从git上下载插件<<<
let vim_plug_just_installed = 0
let vim_plug_path = expand('~/.vim/autoload/plug.vim')
if !filereadable(vim_plug_path)
  echo "Installing Vim-plug..."
  echo ""
  silent !mkdir -p ~/.vim/autoload
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let vim_plug_just_installed = 1
endif

if !filereadable(expand('~/.vim/autoload/pathogen.vim'))
  echo "Installing pathogen..."
  echo ""
  silent !curl -fLo ~/.vim/autoload/pathogen.vim --create-dirs https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim
endif

" manually load vim-plug the first time
if vim_plug_just_installed
  :execute 'source '.fnameescape(vim_plug_path)
endif

" Obscure hacks done, you can now modify the rest of the .vimrc as you wish :)

" ============================================================================
" Active plugins
" You can disable or add new ones here:

" this needs to be here, so vim-plug knows we are declaring the plugins we
" want to use
if filereadable(vim_plug_path)
  call plug#begin('~/.vim/plugged')
  " 待使用的git插件
  " tpope/vim-unimpaired " 交换上下行
  " python-mode/python-mode " 写python必用插件

  " comment multi-languages
  " Plug 'tyru/caw.vim'
  " Plug 'Shougo/context_filetype.vim'

  " Plug 'mkusher/padawan.vim'
  Plug 'Valloric/YouCompleteMe'
  Plug 'wesQ3/vim-windowswap'
  Plug 'editorconfig/editorconfig-vim'
  Plug 'Olical/vim-enmasse'
  " Plug 'vim-vdebug/vdebug'
  Plug 'chemzqm/wxapp.vim'
  Plug 'othree/xml.vim'

  " Plug 'tobyS/vmustache'
  " Plug 'tobyS/pdv'
  " Plug 'vim-scripts/phpfolding.vim' " terminal color issue; 0 folds created

  Plug 'christoomey/vim-tmux-navigator'
  Plug 'Chiel92/vim-autoformat'
  Plug 'steelsojka/deoplete-flow'
  Plug 'feistiny/php-foldexpr.vim', { 'branch': 'dev'}

  Plug 'stephpy/vim-php-cs-fixer'

  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-easytags'
  " Plug 'prettier/vim-prettier', {
        " \ 'do': 'yarn install',
        " \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'vue', 'json', 'markdown'] }
  " Plug 'posva/vim-vue'
  Plug 'pangloss/vim-javascript'
  Plug 'Shougo/vimproc.vim'
  Plug 'Shougo/unite.vim'

  Plug 'feistiny/vim-php-namespace'

  " git上的插件地址
  Plug 'scrooloose/nerdcommenter' " 代码注释插件
  "Plug 'ervandew/supertab'

  Plug 'kien/ctrlp.vim' " Code and files fuzzy finder

  Plug 'mattn/emmet-vim' " html,css的插件
  Plug 'maksimr/vim-jsbeautify' " html,js,css美化

  Plug 'https://github.com/tpope/vim-fugitive.git' " git插件

  Plug 'dkprice/vim-easygrep' " 全局搜索
  Plug 'othree/eregex.vim' " 上边的插件全局替换时的正则依赖

  Plug 'tpope/vim-repeat'

  Plug 'scrooloose/nerdtree' " 文件目录树

  Plug 'tpope/vim-surround' " 增删改包围

  Plug 'vim-scripts/AutoClose' " )]}等自动闭合
  "Plug 'Townk/vim-autoclose'

  " Plug 'fholgado/minibufexpl.vim' " buffer插件

  Plug 'PotHix/Vimpress' " vim写wordpress博客

  "snippets
  Plug 'honza/vim-snippets'
  Plug 'SirVer/ultisnips'

  Plug 'plasticboy/vim-markdown' " markdown语法高亮
  Plug 'mzlogin/vim-markdown-toc' " markdown生成文章目录
  " Plug 'isnowfy/python-vim-instant-markdown' " markdown实时预览

  Plug 'terryma/vim-expand-region' " visual扩张到上一层

  "snippets
  Plug 'honza/vim-snippets'
  Plug 'SirVer/ultisnips'

  Plug 'vim-scripts/taglist.vim' " tag窗口,方便查看源码结构
  "Plug 'vim-scripts/taglist.vim'
  "Plug 'vim-php/phpctags'
  "Plug 'vim-php/tagbar-phpctags.vim'

  Plug 'vim-scripts/dbext.vim' " vim里运行sql语句

  Plug 'triglav/vim-visual-increment' " 数字列增长

  Plug 'scrooloose/syntastic' " 语法错误检查

  Plug 'junegunn/vim-easy-align' " =号对齐

  call plug#end()
endif

execute pathogen#infect()
call pathogen#helptags()

syntax on "显示语法错误
filetype plugin indent on

if !exists('g:vdebug_options')
  let g:vdebug_options = {}
endif
let g:vdebug_options["ide_key"] = 'vim'
let g:vdebug_options["break_on_open"] = 1
let g:vdebug_options["server"] = '127.0.0.1'
let g:vdebug_options["port"] = 9000

let g:windowswap_map_keys = 0 "prevent default bindings

let g:eregex_default_enable = 0
let g:eregex_forward_delim = "/"
let g:eregex_backward_delim = "?"
nnoremap <leader>/ :call eregex#toggle()<CR>

nnoremap <silent> <leader>yw :call WindowSwap#MarkWindowSwap()<CR>
nnoremap <silent> <leader>pw :call WindowSwap#DoWindowSwap()<CR>
nnoremap <silent> <leader>ww :call WindowSwap#EasyWindowSwap()<CR>"

let g:ycm_key_list_stop_completion = ['<C-l>']
let g:ycm_cache_omnifunc = 0
let g:ycm_semantic_triggers = {}
let g:ycm_semantic_triggers.php =
                        \ ['->', '::', '(', 'use ', 'namespace ', '\']
let g:ycm_auto_trigger = 1
let g:ycm_min_num_of_chars_for_completion=5
let g:ycm_min_num_identifier_candidate_chars = 5
let g:ycm_max_num_identifier_candidates = 10
let g:ycm_max_num_candidates = 20
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1
      \}

let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']
let g:EditorConfig_exec_path = "/usr/bin/editorconfig"

"""初次打开vim,自动安装Plug列表的插件
if vim_plug_just_installed
  echo "Installing Bundles, please ignore key map error messages"
  :PlugInstall
endif

"""支持鼠标
if has('mouse')
  set mouse=a
endif

let g:UltiSnipsEditSplit='tabdo'
let g:UltiSnipsSnippetsDir='UltiSnips'
let g:UltiSnipsSnippetDirectories=[getcwd().'/UltiSnips', $HOME."/configs/UltiSnips", $HOME."/.vim/plugged/wxapp.vim/UltiSnips"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"

" If php-cs-fixer is in $PATH, you don't need to define line below
" let g:php_cs_fixer_path = "php-cs-fixer" " define the path to the php-cs-fixer.phar

" If you use php-cs-fixer version 1.x
" let g:php_cs_fixer_level = "symfony"                   " options: --level (default:symfony)
" let g:php_cs_fixer_config = '/root/configs/.php_cs'        " options: --config
" If you want to define specific fixers:
"let g:php_cs_fixer_fixers_list = "linefeed,short_tag" " options: --fixers
" let g:php_cs_fixer_config_file = '/root/configs/.php_cs'            " options: --config-file
" End of php-cs-fixer version 1 config params

" If you use php-cs-fixer version 2.x
" let g:php_cs_fixer_rules = "@Symfony"          " options: --rules (default:@PSR2)
"let g:php_cs_fixer_cache = ".php_cs.cache" " options: --cache-file
let g:php_cs_fixer_config_file = '/root/configs/.php_cs' " options: --config
" End of php-cs-fixer version 2 config params

let g:php_cs_fixer_php_path = "php"               " Path to PHP
let g:php_cs_fixer_enable_default_mapping = 1     " Enable the mapping by default (<leader>pcd)
let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information.

let g:NERDSpaceDelims=1
let g:NERDDefaultAlign = 'left'
let g:NERDCustomDelimiters={ 'php' : { 'leftAlt': '/**','rightAlt': '*/', 'left' : '//'} }

let g:pdv_template_dir = $HOME ."/.vim/plugged/pdv/templates_snip"
nnoremap <buffer> <C-p> :call pdv#DocumentWithSnip()<CR>

" F1-10 keys strange behavious, https://superuser.com/questions/258986/vim-strange-behaviour-f1-10
" Condition should identify terminal in question so "
" that it won't change anything for terminals without this problem "

if !has("gui_running") && $TERM is "xterm"
  for [key, code] in [["<F1>", "\eOP"],
        \["<F2>", "\eOQ"],
        \["<F3>", "\eOR"],
        \["<F4>", "\eOS"],
        \["<F5>", "\e[15~"],
        \["<F6>", "\e[17~"],
        \["<F7>", "\e[18~"],
        \["<F8>", "\e[19~"],
        \["<F9>", "\e[20~"],
        \["<F10>", "\e[21~"],
        \]
    execute "set" key."=".code
  endfor
endif

set backspace=indent,eol,start "解决vi兼容模式下, insert mode无法删除
set expandtab "有关tab的操作转成空格
set hidden "切换buffer时,原来的buffer撤销记录不清空
set encoding=utf-8
set nobomb "去掉bom
set autoindent
set smartindent
set showcmd
colorscheme desert
set cursorline
highlight CursorLine term=bold cterm=bold guibg=Grey40
set cursorcolumn
highlight CursorColumn term=bold cterm=bold guibg=Grey40
set nocursorline
set nocursorcolumn
fu! ToggleCurline ()
  if &cursorline && &cursorcolumn
    set nocursorline
    set nocursorcolumn
  else
    set cursorline
    set cursorcolumn
  endif
endfunction
nnoremap <silent><leader>cl :call ToggleCurline()<CR>

let g:pdv_template_dir = $HOME ."/.vim/plugged/pdv/templates_snip"
nnoremap <buffer> <C-p> :call pdv#DocumentWithSnip()<CR>

"""根据文件类型做不同设置<<<
" let g:user_emmet_leader_key = '<tab>'
" let g:user_emmet_expandabbr_key = ','
let g:user_emmet_install_global = 0
aug AliasFiletype
  au!
  autocmd BufNewFile,BufRead *.{tpl,htm,html,vue} set filetype=html
  autocmd BufNewFile,BufRead *.{wxss} set filetype=css.wxss
  autocmd BufNewFile,BufRead *.{wxml} set filetype=html.wxml
  autocmd BufNewFile,BufRead *.sh set filetype=sh
  " autocmd BufNewFile,BufRead *.js set filetype=javascript
  " autocmd BufNewFile,BufRead *.php set filetype=php
  " autocmd BufNewFile,BufRead *.py set filetype=python
  autocmd BufNewFile,BufRead *.{conf} set filetype=yaml
aug END
aug EnableEmmet
  au!
  autocmd FileType html,css,vue,php EmmetInstall
aug END
aug FiletypeIndent
  au!
  autocmd FileType html,php,javascript,python,htmldjango,c setlocal shiftwidth=4 tabstop=4 softtabstop=4
  autocmd FileType sh,zsh,yaml,markdown,json,snippets setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent
  autocmd BufWritePost *.py setlocal et autoindent
  autocmd BufWritePost *.lisp setlocal et autoindent
aug END
nnoremap <leader>d2 :setlocal shiftwidth=2 tabstop=2 softtabstop=2<CR>
nnoremap <leader>d4 :setlocal shiftwidth=4 tabstop=4 softtabstop=4<CR>
"""根据文件类型做不同设置

nnoremap <leader>fl :set fdm=indent \| set foldlevel=01
nnoremap N Nzz
nnoremap n nzz

""" html标签首尾跳转<<<
runtime macros/matchit.vim
let b:match_words='\<begin\>:\<end\>'
""" html标签首尾跳转

" let g:phpfold_open=0
" augroup php_folding
  " au!
  " au FileType php setlocal foldlevel=1
" augroup END

set wildmenu " 状态栏上提示所有可用的命令
set noswapfile "不产生备份文件
set hlsearch incsearch "高亮搜索
set number "显示行号
" set relativenumber
set nowrap "不换行
set scrolloff=1 "离屏幕边缘几行开始滚屏

"""关闭当前标签左/右的所有标签
function! TabCloseRight(bang)
  let cur=tabpagenr()
  while cur < tabpagenr('$')
    exe 'tabclose' . a:bang . ' ' . (cur + 1)
  endwhile
endfunction

function! TabCloseLeft(bang)
  while tabpagenr() > 1
    exe 'tabclose' . a:bang . ' 1'
  endwhile
endfunction

command! -bang Tabcloseright call TabCloseRight('<bang>')
command! -bang Tabcloseleft call TabCloseLeft('<bang>')
"""

""" custom func set foldcolumn
fun! s:SideColumnToggle()
  if &number
    set foldcolumn=0
    set number!
  else
    set foldcolumn=1
    set number!
  endif
endf
command! SideColumnToggle call s:SideColumnToggle()
nnoremap tu :SideColumnToggle<cr>
"""

"""
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
nnoremap <leader>df :DiffOrig<cr>
"""

""" swap two split windows
fun! s:SwapCurrentWindowToTarget(...)
  let cur=winnr()
  if a:0 == 2
    " swap other two windows
    exe a:1 . ' windo call WindowSwap#EasyWindowSwap() | ' .
          \ a:2 . 'windo call WindowSwap#EasyWindowSwap() | ' .
          \ cur . 'windo exe "normal xu"'
  elseif a:0 == 1
    " swap the current window to the target
    exe cur . ' windo call WindowSwap#EasyWindowSwap() | ' .
          \ a:1 . 'windo call WindowSwap#EasyWindowSwap() | ' .
          \ a:1 . 'windo exe "normal ' . a:1 . 'ww"'
  endif
endf
command! -nargs=+ SwapTwoWindows call s:SwapCurrentWindowToTarget(<f-args>)
nnoremap <leader>sw :SwapTwoWindows 
"""

""" move(delete) window to the other
fun! MoveCurrentWindowToTarget(split, copy, ...)
  let l:cur_winnr = winnr()
  let l:split_mode = a:split == '' ? 'e' : a:split
  let l:copy_mode = a:copy == '' ? 0 : 1

  " move one to the other
  if a:0 == 2
    let l:from_winnr = a:1
    let l:to_winnr = a:2
    let l:from_bufnr = winbufnr(a:1)

    exe 'normal mZ'
    exe l:to_winnr . 'windo ' . l:split_mode . ' #' . l:from_bufnr
    if l:copy_mode == 0
      exe l:cur_winnr . 'windo exe "normal ' . l:from_winnr . 'c"'
    endif
    exe 'normal `Z'
  elseif a:0 == 1
    let l:to_winnr = a:1
    let l:cur_bufnr = bufnr("%")

    if a:split != ''
      " refresh cur_winnr
      if l:to_winnr == l:cur_winnr
        return
      elseif l:to_winnr < l:cur_winnr
        let l:cur_winnr+=1
      endif
    else
      if l:to_winnr == l:cur_winnr
        return
      endif
    endif

    " move current to the other
    exe 'normal mz'
    exe l:to_winnr . 'windo ' . l:split_mode . ' #' . l:cur_bufnr
    if l:copy_mode == 0
      exe 'normal ' . l:cur_winnr . 'c'
    endif
    exe 'normal `z'
  endif
endf
command! -nargs=+ MoveTwoWindows call MoveCurrentWindowToTarget('', '',  <f-args>)
nnoremap <leader>dw :MoveTwoWindows 
command! -nargs=+ MoveTwoWindowsSplit call MoveCurrentWindowToTarget('sp', '',  <f-args>)
nnoremap <leader>dws :MoveTwoWindowsSplit 
command! -nargs=+ MoveTwoWindowsVerticalSplit call MoveCurrentWindowToTarget('vsp', '', <f-args>)
nnoremap <leader>dwv :MoveTwoWindowsVerticalSplit 
command! -nargs=+ CopyTwoWindows call MoveCurrentWindowToTarget('', 1, <f-args>)
nnoremap <leader>yw :CopyTwoWindows 
command! -nargs=+ CopyTwoWindowsSplit call MoveCurrentWindowToTarget('sp', 1, <f-args>)
nnoremap <leader>yws :CopyTwoWindowsSplit 
command! -nargs=+ CopyTwoWindowsVerticalSplit call MoveCurrentWindowToTarget('vsp', 1, <f-args>)
nnoremap <leader>ywv :CopyTwoWindowsVerticalSplit 
"""

let g:EasyGrepFilesToExclude=".svn,.git,node_modules,vendor,*.log"
nnoremap <silent><leader>sg :call SwitchEasyGrepExclude()<cr>
fun! SwitchEasyGrepExclude()
  let g:is_easygrep_excludes = get(g:, 'is_easygrep_excludes', 1)
  if g:is_easygrep_excludes == 1
    let g:EasyGrepFilesToExclude=""
    let g:is_easygrep_excludes = 0
  elseif g:is_easygrep_excludes == 0
    let g:EasyGrepFilesToExclude=".svn,.git,node_modules,vendor,*.log"
    let g:is_easygrep_excludes = 1
  endif
endf

"""python相关配置
let g:syntastic_python_flake8_args = '--ignore=E501,E401' ",F821' \"忽略pep8每行超过79个字符的错误提示
"""

"""标签操作<<<

"""切换到第几个标签<<<
nnoremap t1 1gt
nnoremap t2 2gt
nnoremap t3 3gt
nnoremap t4 4gt
nnoremap t5 5gt
nnoremap t6 6gt
nnoremap t7 7gt
nnoremap t8 8gt
nnoremap t9 9gt
nnoremap t0 :tablast<CR>
"""切换到第几个标签

" next tab
nnoremap tp :tabp<CR>
" previous tab
nnoremap tn :tabn<CR>
" copy the curent tab to a new one
nnoremap ty :tab split<CR>
" 切换粘贴模式
nnoremap tj :set paste!<CR>
" 关闭右侧标签
nnoremap tL :Tabcloseleft<CR>
" 关闭左边标签
nnoremap tR :Tabcloseright<CR>
" 关闭当前tab
nnoremap tc :tabc<CR> :tabp<CR>
" 移动当前tab到输入序号的位置
nnoremap tm :tabm
" 新标签
nnoremap tw :tabnew
nnoremap <leader>lb :buffers<CR>:b<Space>

nnoremap <leader>af :call AutoFormatCode()<CR>
func! AutoFormatCode()
  let type = &filetype
  echom type
  if type == "php"
    exec "call PhpCsFixerFixFile()"
    " exec "Autoformat"
  else
    exec "Autoformat"
  endif
endfunc
" let g:autoformat_verbosemode=1

"""返回上一个标签<<<
auto tableave * let g:pre_tabpagenr=tabpagenr()
nnoremap <silent> tt :exe "tabn ".g:pre_tabpagenr<CR>
"""返回上一个标签

"""标签操作

"""normal模式的缩进操作
vnoremap > >gv
vnoremap < <gv
"""normal模式的缩进操作

" common config<<<

let g:php_manual_online_search_shortcut = ''

" let g:ale_fixers = {
  " \'javascript': ['prettier','eslint'],
" \}
" let g:ale_fixers = ['prettier','stylelint','eslint']
" let g:ale_completion_enabled = 1
" let g:ale_lint_on_text_changed = 'never'
" let g:ale_lint_on_enter = 0
" let g:ale_lint_on_save = 1
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1
" let g:ale_open_list = 1
" let g:ale_keep_list_window_open = 1
" let g:ale_list_window_size = 5
" nnoremap <leader>p :ALEFix<CR>
" let g:ale_sign_column_always = 1
" nnoremap <silent> <leader>k <Plug>(ale_previous_wrap)
" nnoremap <silent> <leader>j <Plug>(ale_next_wrap)


let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
set foldcolumn=1
augroup javascript_folding
  au!
  au FileType javascript setlocal foldmethod=syntax
  au FileType javascript setlocal foldlevel=99
augroup END

" au BufWrite * :Autoformat

" autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css

" let g:prettier#autoformat = 0
" let g:prettier#quickfix_enabled = 1
" let g:prettier#exec_cmd_async = 1
" let g:prettier#quickfix_enabled = 1
" let g:prettier#quickfix_auto_focus = 1
" autocmd BufWritePre *.js,*.css,*.scss,*.less,*.vue PrettierAsync
" map <leader>p :Prettier<CR>

let g:php_namespace_sort_after_insert = 1
function! IPhpInsertUse()
  call PhpInsertUse()
  call feedkeys('a',  'n')
endfunction
function! IPhpExpandClass()
  call PhpExpandClass()
  call feedkeys('a', 'n')
endfunction
aug php_namespace_mapping
  au!
  autocmd FileType php noremap <leader>u :call PhpInsertUse()<CR>
  autocmd FileType php noremap <leader>x :call PhpExpandClass()<CR>
  autocmd FileType php noremap <leader>s :call PhpSortUse()<CR>
aug END

let &termencoding=&encoding
let @j='Jx'
set fileencodings=utf-8,gbk,ucs-bom,cp936
" set cpoptions+=d
set tags=.tags
let g:easytags_auto_highlight = 0
let g:easytags_dynamic_files = 1
let g:easytags_on_cursorhold = 1
let g:easytags_updatetime_min = 4000
let g:easytags_auto_update = 1
let g:easytags_async = 1
let g:easytags_file = '.tags'
au InsertEnter * :set tags=
au InsertLeave * :set tags=.tags
set term=xterm
" 代码块不使用默认别名, PHP默认是加载JS,HTML的, if的补全会提示PHP和JS的<<<
let g:snipMate = {}
let g:snipMate.no_default_aliases=1
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['html'] = 'html,php'
let g:NERDSpaceDelims=1 " 注释符后加一个空格
" 代码块不使用默认别名, PHP默认是加载JS,HTML的, if的补全会提示PHP和JS的
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
nnoremap <leader>tl :let g:NERDTreeWinPos="left"<cr>
nnoremap <leader>tr :let g:NERDTreeWinPos="right"<cr>
nnoremap <silent> <leader>t :Tlist<cr> " 切换taglist
let Tlist_Use_Right_Window =1 " taglist 右侧显示
xmap ga <Plug>(EasyAlign)
nnoremap ga <Plug>(EasyAlign)
nnoremap <leader>si :set shellcmdflag=-ic<CR>
nnoremap <leader>sc :set shellcmdflag=-c<CR>
nnoremap <leader>w :e!<CR>
nnoremap <leader>tf :NERDTreeFind<CR>
nnoremap <leader>to :NERDTreeFocus<CR>
nnoremap <leader>qn :cn<CR>
nnoremap <leader>qp :cp<CR>
nnoremap <leader>qc :ccl<CR>
nnoremap <leader>qo :copen<CR>
nnoremap <leader>qt :cc
" nnoremap <C-p> <C-w><C-p>
nnoremap <leader>; mpA;<esc>`p
nnoremap <leader>dv :vsplit ~/configs/.vimrc<cr> "编辑.vimrc
nnoremap <leader>sv :source ~/configs/.vimrc<CR><Left> "重新加载.vimrc
nnoremap <leader>lw :se wrap!<CR><Left> "切换是否换行
nnoremap <leader>lt :se list!<CR>
nnoremap <leader>lv :vsp #<CR>
nnoremap <leader>ls :sp #<CR>
nnoremap <leader>bh :h <c-r>=expand("<cword>")<CR><CR>
nnoremap <leader>th :set hlsearch!<CR> "切换高亮显示
nnoremap g= gg=G''zz
nnoremap <leader>c :CtrlPClearCache<cr>
vnoremap / y/<c-r>=escape(@", '\/')<CR><CR>N
vnoremap ? y?<C-R>"<CR>N
vnoremap <leader>/ y/<C-R>=escape(@", '\/~')<CR><CR>Ncgn
vnoremap <leader>? y?<C-R>=escape(@", '\/~')<CR><CR>NcgN
vnoremap <leader>, y:.,$s/<C-R>"/
" 快捷liu调试函数<<<
vnoremap gl yovar_dump(<c-r>");<esc>
vnoremap gL yOvar_dump(<c-r>");<esc>
vnoremap pc c"""<esc>PO""" 
vnoremap pd c . <c-r>" . <esc>
vnoremap pd1 c'.<c-r>".'<esc>
vnoremap pd2 c".<c-r>"."<esc>
vnoremap pd3 c"'".<c-r>"."'"<esc>
vnoremap if yoif (<c-r>") {}<esc>
vnoremap vd yoecho '<c-r>"' <c-r>"<esc>
" 快捷liu调试函数
" 查看所选单词的帮助
vnoremap <leader>hh y:h <c-r>"<cr>
" 查看当前光标处的单词的帮助
nnoremap <leader>hh :h <c-r>=expand("<cword>")<CR><CR>
inoremap <C-H> <C-O>x
inoremap <C-J> <C-O>h
inoremap <C-K> <C-O>l
let g:surround_indent = 0
let g:EasyGrepCommand=1
let g:EasyGrepPerlStyle=1
let g:EasyGrepJumpToMatch=0
" common config

"""分割窗口相关操作<<<
nnoremap w= :resize +5<CR>
nnoremap w- :resize -5<CR>
nnoremap w, :vertical resize -5<CR>
nnoremap w. :vertical resize +5<CR>
"nmap <S-W> <C-W><C-W>
" nnoremap <Leader>pf :!clear;php --rf <C-R>=expand("<cword>")<CR><CR>
"""分割窗口相关操作

"""状态栏配置<<<

"""检测粘贴模式函数<<<
" todo update paste status only in this buffer
function! PasteForStatusline()
  let paste_status = &paste
  if paste_status == 1
    return "[paste]\ "
  else
    return ""
  endif
endfunction
function! EasyGrepExcludeStatusForStatusline()
  if get(g:, 'is_easygrep_excludes', 1) == 0
    return "[g]\ "
  else
    return ""
  endif
endfunction
function! AutoCsFixForStatusline()
  if get(g:, 'is_php_autofix_open', 0) == 1
    return "[fix]\ "
  else
    return ""
  endif
endfunction
"""检测粘贴模式函数
function! StatusLineFileName()
  let pre = ''
  let pat = '://'
  let name = expand('%:~:.')
  if name =~# pat
    let pre = name[:stridx(name, pat) + len(pat)-1] . '...'
    let name = name[stridx(name, pat) + len(pat):]
  endif
  let name = simplify(name)
  let ratio = winwidth(0) / len(name)
  if ratio <= 2 && ratio > 1
    let name = pathshorten(name)
  elseif ratio <= 1
    let name = fnamemodify(name, ':t')
  endif
  return pre . name
endfunction
set laststatus=2
highlight StatusLine cterm=bold ctermfg=yellow ctermbg=blue
" 获取当前路径，将$HOME转化为~
function! CurDir()
  let curdir = substitute(getcwd(), $HOME, "~", "g")
  return curdir
endfunction
set statusline=%{PasteForStatusline()}
set statusline+=%{AutoCsFixForStatusline()}
set statusline+=[w%{winnr()}]\ 
set statusline+=[b%n]\ 
set statusline+=%{StatusLineFileName()}\ 
set statusline+=%=%{EasyGrepExcludeStatusForStatusline()}
set statusline+=%=%l/%L
"""状态栏配置

"""项目文件快捷打开,模糊匹配<<<
" file finder mapping
" let g:ctrlp_by_filename = 1
let g:ctrlp_switch_buffer = 't'
let g:ctrlp_mruf_case_sensitive = 1
let g:ctrlp_show_hidden = 0
fu! ToggleCtrlpShowHiddenFiles ()
  if g:ctrlp_show_hidden
    let g:ctrlp_show_hidden = 0
  else
    let g:ctrlp_show_hidden = 1
  endif
  execute 'CtrlPClearCache'
endfunction
nnoremap <silent><leader>ch :call ToggleCtrlpShowHiddenFiles()<CR>
nnoremap <silent><leader>qe :EnMasse<CR>
let g:ctrlp_map = "<leader>e"
" tags (symbols) in current file finder mapping
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>g :CtrlPBufTag<CR>
" tags (symbols) in all files finder mapping
nnoremap <leader>G :CtrlPBufTagAll<CR>
" general code finder in all files mapping
nnoremap <leader>f :CtrlPLine<CR>
nnoremap <leader>fc :CtrlPLine %<CR>
" recent files finder mapping
nnoremap <leader>m :CtrlPMRUFiles<CR>
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
  execute ':CtrlP' . a:ctrlp_command_end
  call feedkeys(a:search_text)
endfunction
" same as previous mappings, but calling with current word as default text
nnoremap <leader>wg :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
nnoremap <leader>wG :call CtrlPWithSearchText(expand('<cword>'), 'BufTagAll')<CR>
nnoremap <leader>wf :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
nnoremap <leader>we :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nnoremap <leader>pe :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
nnoremap <leader>wm :call CtrlPWithSearchText(expand('<cword>'), 'MRUFiles')<CR>
nnoremap <leader>wc :call CtrlPWithSearchText(expand('<cword>'), 'CmdPalette')<CR>
" don't change working directory
nnoremap <leader>cw :let g:ctrlp_working_path_mode='ra'<cr>
nnoremap <leader>c0 :let g:ctrlp_working_path_mode='0'<cr>
let g:ctrlp_working_path_mode = '0'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules|vendor/(encore|laravel)@!.+)$',
      \ 'file': '\.pyc$\|\.pyo|\.meta$',
      \}
"""项目文件快捷打开,模糊匹配

" nerdtree
let NERDTreeChDIrMode = 2 " CWD changed when root changing
" #open nerdtree when starting with no file
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" #close vim when only nerdtree exists
aug closeNERDTreeFinally
  au!
  au bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
aug END

" Enable omni completion.
aug omnifunc_group
  au!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
aug END

" Enable heavy omni completion.
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplcache_force_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" 新的自动补全的配置, 暂时可用, 以后再整理

"""代码跳转配置<<<
if has("cscope")
  set csprg=/usr/bin/cscope
  set csto=0
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
    " else add database pointed to by environment
  elseif filereadable("/tmp/cscope.out")
    cs add /tmp/cscope.out
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set csverb
endif
nnoremap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nnoremap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-_>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
nnoremap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>
vnoremap css y:cs find s <C-R>"<CR><CR>
vnoremap csg y:cs find g <C-R>"<CR><CR>
vnoremap csc y:cs find c <C-R>"<CR><CR>
vnoremap cst y:cs find t <C-R>"<CR><CR>
vnoremap cse y:cs find e <C-R>"<CR><CR>
vnoremap csf y:cs find f <C-R>"<CR><CR>
vnoremap csi y:cs find i <C-R>"<CR><CR>
vnoremap csd y:cs find d <C-R>"<CR><CR>
"""代码跳转配置

"""debugger.py断点调试相关<<<
nnoremap dn :Dn<CR>
nnoremap du :Up<CR>
nnoremap td :Bp<CR>
let g:debuggerPort = 9010
let g:debuggerMaxDepth = 20
"""debugger.py断点调试相关



"""自定义的函数
nnoremap <Leader>ct :call CscopeToTmp(0)
function! CscopeToTmp(opt, ...)
  if a:0 > 0
    let _name = "-name '*." . a:1 . "'"
  else
    let _name = "-name '*." . &filetype . "'"
  end
  exe '!find $(pwd -P) ' . _name . ' > /tmp/cscope.files ; cd /tmp ; cscope -b '
endfunction

nnoremap <leader>re :%retab<CR>
nnoremap <leader>rm :%s/\r$\n/\r/<CR>

nnoremap <leader>r :call Run()<CR>
func! Run()
  let type = &filetype
  if type == "c" || type == "cpp"
    exec "!gcc % -o %:t:r && ./%:t:r"
  elseif type == 'bash' || type == 'sh'
    exec "!export exec_in_vim=1;clear;echo ;echo ;bash %;unset exec_in_vim"
  elseif type == "python"
    exec "!clear;$(which python) % | less"
  elseif type == "php"
    exec "!clear;$(which php) % | less"
  elseif type == "javascript"
    exec "!clear;node %"
  elseif type == "lisp"
    exec "!clear;clisp %"
  endif
endfunc

nnoremap <C-S> :w<CR>
inoremap <C-S> <ESC>:w<CR>
nnoremap <silent><leader>cf :call SwitchAutoPHPCsFixer()<cr>
fun! SwitchAutoPHPCsFixer()
  if &filetype != 'php'
    return
  endif
  let g:is_php_autofix_open = get(g:, 'is_php_autofix_open', 0)
  if g:is_php_autofix_open == 1
    exe "au! autoPhpCsFxier BufWritePost *.php"
    let g:is_php_autofix_open = 0
    nnoremap <C-S> :w<CR>
    inoremap <C-S> <ESC>:w<CR>
  elseif g:is_php_autofix_open == 0
    aug autoPhpCsFxier
      au!
      " todo, when auto fix, php will lose syntax highlighting
      au BufWritePost *.php silent! call PhpCsFixerFixFile()
    aug END
    let g:is_php_autofix_open = 1
    nnoremap <C-S> :mkview \| w \| e! \| loadview<CR>
    inoremap <C-S> <ESC>:mkview \| w \| e! \| loadview<CR>
  endif
endf

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

nnoremap <leader>d. :call DeleteFileAndCloseBuffer()<CR>
fun! DeleteFileAndCloseBuffer()
  let choice = confirm("Delete file and close buffer?", "&Do it!\n&Nonono", 1)
  if choice == 1 | call delete(expand('%:p')) | bdelete! | endif
endfun

"""自定义abbr<<<
iabbr liu liu(1);
hi Comment ctermfg=darkgray
"""自定义abbr

" MySQL
let g:dbext_default_profile_mysql_local = 'type=MYSQL:user=root:passwd=mysql272jp@:dbname=mysql'

" html,css,js 美化快捷键
nnoremap tf :call JsBeautify()<cr>
aug JsBeautifyGroup
  au!
  autocmd FileType javascript nnoremap <buffer>  tf :call JsBeautify()<cr>
  autocmd FileType json nnoremap <buffer> tf :call JsonBeautify()<cr>
  autocmd FileType jsx nnoremap <buffer> tf :call JsxBeautify()<cr>
  autocmd FileType html nnoremap <buffer> tf :call HtmlBeautify()<cr>
  autocmd FileType css nnoremap <buffer> tf :call CSSBeautify()<cr>
  autocmd FileType javascript vnoremap <buffer>  tf :call RangeJsBeautify()<cr>
  autocmd FileType json vnoremap <buffer> tf :call RangeJsonBeautify()<cr>
  autocmd FileType jsx vnoremap <buffer> tf :call RangeJsxBeautify()<cr>
  autocmd FileType html vnoremap <buffer> tf :call RangeHtmlBeautify()<cr>
  autocmd FileType css vnoremap <buffer> tf :call RangeCSSBeautify()<cr>
aug END

aug FiletypeAutocmd
  au!
  autocmd FileType vim set list
  autocmd FileType * set formatoptions-=cro
  autocmd FileType css,html set iskeyword+=-
aug END
