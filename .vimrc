set nocompatible "不用vi兼容模式
" Fisa-vim-config

" ============================================================================
" Vim-plug initialization
" Avoid modify this section, unless you are very sure of what you are doing
let mapleader=","

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
  Plug 'alvan/vim-php-manual'

  Plug 'christoomey/vim-tmux-navigator'
  Plug 'Chiel92/vim-autoformat'
  Plug 'steelsojka/deoplete-flow'

  Plug 'stephpy/vim-php-cs-fixer'

  Plug 'xolox/vim-misc'
  Plug 'xolox/vim-easytags'
  " Plug 'prettier/vim-prettier', {
        " \ 'do': 'yarn install',
        " \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'vue', 'json', 'markdown'] }
  Plug 'posva/vim-vue'
  Plug 'pangloss/vim-javascript'
  " Plug 'm2mdas/phpcomplete-extended'
  Plug 'Shougo/vimproc.vim'
  Plug 'Shougo/unite.vim'

  Plug 'arnaud-lb/vim-php-namespace'

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

  Plug 'fholgado/minibufexpl.vim' " buffer插件

  Plug 'PotHix/Vimpress' " vim写wordpress博客

  "snippets
  Plug 'honza/vim-snippets'
  Plug 'SirVer/ultisnips'

  Plug 'plasticboy/vim-markdown' " markdown语法高亮
  Plug 'mzlogin/vim-markdown-toc' " markdown生成文章目录
  Plug 'isnowfy/python-vim-instant-markdown' " markdown实时预览

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

  Plug 'https://github.com/terryma/vim-multiple-cursors.git' " vim多点编辑

  Plug 'junegunn/vim-easy-align' " =号对齐

  call plug#end()
endif

execute pathogen#infect()
call pathogen#helptags()

syntax on "显示语法错误
filetype plugin indent on

" php laravel complete
" let g:phpcomplete_index_composer_command='composer'
" autocmd  FileType  php setlocal omnifunc=phpcomplete_extended#CompletePHP
" let g:SuperTabDefaultCompletionType = "<c-x><c-o>"

let g:ycm_key_list_stop_completion = ['<C-y>']
let g:ycm_key_invoke_completion = '<C-z>'
let g:ycm_semantic_triggers = {}
let g:ycm_semantic_triggers.php = 
                        \ ['->', '::', '(', 'use ', 'namespace ', '\']
let g:ycm_auto_trigger = 1
let g:ycm_key_list_select_completion=[]
let g:ycm_key_list_previous_completion=[]
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_filetype_specific_completion_to_disable = {
      \ 'gitcommit': 1
      \}

let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

"""初次打开vim,自动安装Plug列表的插件
if vim_plug_just_installed
  echo "Installing Bundles, please ignore key map error messages"
  :PlugInstall
endif

"""支持鼠标
if has('mouse')
  set mouse=a
endif

let g:UltiSnipsSnippetDirectories=[$HOME."/configs/UltiSnips"]
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"

" If php-cs-fixer is in $PATH, you don't need to define line below
" let g:php_cs_fixer_path = "~/php-cs-fixer.phar" " define the path to the php-cs-fixer.phar

" If you use php-cs-fixer version 1.x
let g:php_cs_fixer_level = "symfony"                   " options: --level (default:symfony)
let g:php_cs_fixer_config = "default"                  " options: --config
" If you want to define specific fixers:
"let g:php_cs_fixer_fixers_list = "linefeed,short_tag" " options: --fixers
"let g:php_cs_fixer_config_file = '.php_cs'            " options: --config-file
" End of php-cs-fixer version 1 config params

" If you use php-cs-fixer version 2.x
let g:php_cs_fixer_rules = "@PSR2"          " options: --rules (default:@PSR2)
"let g:php_cs_fixer_cache = ".php_cs.cache" " options: --cache-file
"let g:php_cs_fixer_config_file = '.php_cs' " options: --config
" End of php-cs-fixer version 2 config params

let g:php_cs_fixer_php_path = "php"               " Path to PHP
let g:php_cs_fixer_enable_default_mapping = 1     " Enable the mapping by default (<leader>pcd)
let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information.


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

"""根据文件类型做不同设置<<<
let g:user_emmet_install_global = 0
au BufNewFile,BufRead *.{tpl,htm} set filetype=html
au BufNewFile,BufRead *.js set filetype=javascript
au BufNewFile,BufRead *.php set filetype=php
au BufNewFile,BufRead *.py set filetype=python
au BufNewFile,BufRead *.{yml,conf} set filetype=yaml
autocmd FileType html,css,vue EmmetInstall
autocmd FileType html,php setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType htmldjango setlocal shiftwidth=4 tabstop=4 softtabstop=4
" autocmd FileType javascript setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd FileType python setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab autoindent
autocmd FileType sh,zsh setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent
autocmd FileType yaml setlocal shiftwidth=2 tabstop=2 softtabstop=2 expandtab autoindent
autocmd BufWritePost *.py setlocal et autoindent
autocmd BufWritePost *.lisp setlocal et autoindent
nmap <leader>d2 :setlocal shiftwidth=2 tabstop=2 softtabstop=2<CR>
nmap <leader>d4 :setlocal shiftwidth=4 tabstop=4 softtabstop=4<CR>
"""根据文件类型做不同设置

"""打开代码折叠<<<
" if has('fdm')
  set fdm=indent
  set foldlevel=99
" endif
"""打开代码折叠

""" html标签首尾跳转<<<
runtime macros/matchit.vim
let b:match_words='\<begin\>:\<end\>'
""" html标签首尾跳转

set wildmenu " 状态栏上提示所有可用的命令
set noswapfile "不产生备份文件
set hlsearch "高亮搜索
set number "显示行号
" set relativenumber
set nowrap "不换行
set so=3 "离屏幕边缘还有3行开始滚屏

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
fun! s:setfoldcolumn(...)
  exe 'set foldcolumn=' . a:1
endf 
command! -nargs=1 SetFoldColumn call s:setfoldcolumn(<f-args>)
nnoremap <leader>tc :SetFoldColumn 0
"""

let g:EasyGrepFilesToExclude=".svn,.git,node_modules,vendor"

"""python相关配置
let g:syntastic_python_flake8_args = '--ignore=E501,E401' ",F821' \"忽略pep8每行超过79个字符的错误提示
"""

"""标签操作<<<

"""切换到第几个标签<<<
map t1 1gt
map t2 2gt
map t3 3gt
map t4 4gt
map t5 5gt
map t6 6gt
map t7 7gt
map t8 8gt
map t9 9gt
map t0 :tablast<CR>
"""切换到第几个标签

" next tab
map tp :tabp<CR>
" previous tab
map tn :tabp<CR>
" copy the curent tab to a new one
map ty :tab split<CR>
" 切换粘贴模式
map tj :set paste!<CR><Left>
" 关闭右侧标签
map tL :Tabcloseleft<CR>
" 关闭左边标签
map tR :Tabcloseright<CR>
" 关闭当前tab
map tc :tabc<CR> :tabp<CR>
" 移动当前tab到输入序号的位置
map tm :tabm
" 新标签
map tw :tabnew
map <F2> :buffers<CR>:b<Space>
map <F3> :Autoformat<CR>
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

"下边执行文件的注释不能放到行后,否则执行结果闪消
"快捷执行当前php文件
map gp :!clear;echo ;php %<CR>
"快捷执行当前python文件
map gy :!clear;echo ;python %<CR>
"快捷执行当前node文件
map gn :!clear;echo ;node %<CR>
"快捷执行当前bash文件
map gb :!export exec_in_vim=1;clear;echo ;echo ;bash %;unset exec_in_vim<CR>
"快捷执行当前lisp文件
map gl :!clear;echo ;clisp %<CR>

" common config<<<
" let g:ale_fixers = {
  " \'javascript': ['prettier','eslint'],
" \}
let g:ale_fixers = ['prettier','stylelint','eslint']
let g:ale_completion_enabled = 1
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_enter = 0
let g:ale_lint_on_save = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 1
let g:ale_list_window_size = 5
nmap <leader>p :ALEFix<CR>
" let g:ale_sign_column_always = 1
nmap <silent> <leader>k <Plug>(ale_previous_wrap)
nmap <silent> <leader>j <Plug>(ale_next_wrap)


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
autocmd FileType php noremap <Leader>s :call PhpSortUse()<CR>
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>
function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php noremap <Leader>x :call PhpExpandClass()<CR>
let &termencoding=&encoding
set fileencodings=utf-8,gbk,ucs-bom,cp936
set tags=.tags
set term=xterm
" 代码块不使用默认别名, PHP默认是加载JS,HTML的, if的补全会提示PHP和JS的<<<
let g:snipMate = {}
let g:snipMate.no_default_aliases=1
let g:snipMate.scope_aliases = {}
let g:snipMate.scope_aliases['html'] = 'html,php'
let g:NERDSpaceDelims=1 " 注释符后加一个空格
" 代码块不使用默认别名, PHP默认是加载JS,HTML的, if的补全会提示PHP和JS的
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
nnoremap <silent> <Leader>t :Tlist<cr> " 切换taglist
let Tlist_Use_Right_Window =1 " taglist 右侧显示
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
nmap <leader>si :set shellcmdflag=-ic<CR>
nmap <leader>sc :set shellcmdflag=-c<CR>
nmap <leader>w :e<CR>
nmap <leader>df :NERDTreeFind<CR>
nnoremap <C-S> :w<CR><Left> "快速保存改动
inoremap <C-S> <ESC>:w<CR><Left> "快速保存改动
nnoremap tu :set nu!<CR> "切换行号显示
nnoremap ,3 :b#<CR> "上一个buffer
nnoremap <leader>dv :vsplit ~/configs/.vimrc<cr> "编辑.vimrc
nnoremap <leader>sv :source ~/configs/.vimrc<CR> "重新加载.vimrc
nnoremap <leader>l :se wrap!<CR> "切换是否换行
nnoremap th :set hlsearch!<CR> "切换高亮显示
nnoremap g= gg=G''zz
nnoremap <space> za
map <leader>c :CtrlPClearCache<cr>
vnoremap // y/<C-R>"<CR> "向后搜索当前的选择
vnoremap ?? y?<C-R>"<CR> "向前搜索当前的选择
" 快捷liu调试函数<<<
vnoremap gl yovar_dump(<c-r>");<esc>
vnoremap gL yOvar_dump(<c-r>");<esc>
vnoremap pc dO"""<esc>PO"""<esc>
" vnoremap cl yo{php liu(<c-r>",on);}<esc>
" vnoremap cL yO{php liu(<c-r>",on);}<esc>
" 快捷liu调试函数
" 查看所选单词的帮助
vnoremap <leader>hh y:h <c-r>"<cr>
" 查看当前光标处的单词的帮助
nnoremap <leader>hh :h <c-r>=expand("<cword>")<CR><CR>
inoremap <C-L> <C-O>x
inoremap <C-J> <C-O>h
inoremap <C-K> <C-O>l
let g:surround_indent = 0
let g:EasyGrepCommand=1
let g:EasyGrepPerlStyle=1
" common config

"""分割窗口相关操作<<<
nnoremap w= :resize +3<CR>
nnoremap w- :resize -3<CR>
nnoremap w, :vertical resize -3<CR>
nnoremap w. :vertical resize +3<CR>
"nmap <S-W> <C-W><C-W>
nnoremap <Leader>pf :!clear;php --rf <C-R>=expand("<cword>")<CR><CR>
"""分割窗口相关操作

"""状态栏配置<<<

"""检测粘贴模式函数<<<
function! PasteForStatusline()
  let paste_status = &paste
  if paste_status == 1
    return " [paste] "
  else
    return ""
  endif
endfunction
"""检测粘贴模式函数

set laststatus=2
highlight StatusLine cterm=bold ctermfg=yellow ctermbg=blue
" 获取当前路径，将$HOME转化为~
function! CurDir()
  let curdir = substitute(getcwd(), $HOME, "~", "g")
  return curdir
endfunction
" set statusline=[%n]\ %f%m%r%h\ \|\ %{PasteForStatusline()}\
"""状态栏配置

"""项目文件快捷打开,模糊匹配<<<
" file finder mapping
let g:ctrlp_map = ',e'
" tags (symbols) in current file finder mapping
nnoremap ,b :CtrlPBuffer<CR>
nnoremap ,g :CtrlPBufTag<CR>
" tags (symbols) in all files finder mapping
nnoremap ,G :CtrlPBufTagAll<CR>
" general code finder in all files mapping
nnoremap ,f :CtrlPLine<CR>
nnoremap ,fc :CtrlPLine %<CR>
" recent files finder mapping
nnoremap ,m :CtrlPMRUFiles<CR>
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
  execute ':CtrlP' . a:ctrlp_command_end
  call feedkeys(a:search_text)
endfunction
" same as previous mappings, but calling with current word as default text
nnoremap ,wg :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
nnoremap ,wG :call CtrlPWithSearchText(expand('<cword>'), 'BufTagAll')<CR>
nnoremap ,wf :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
nnoremap ,we :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nnoremap ,pe :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
nnoremap ,wm :call CtrlPWithSearchText(expand('<cword>'), 'MRUFiles')<CR>
nnoremap ,wc :call CtrlPWithSearchText(expand('<cword>'), 'CmdPalette')<CR>
" don't change working directory
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules|vendor)$',
      \ 'file': '\.pyc$\|\.pyo|\.meta$',
      \}
"""项目文件快捷打开,模糊匹配

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

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


func! Run()
  let type = b:current_syntax
  echom type
  if type == "c" || type == "cpp"
    exec "!./%<"
  elseif type == "bash"
    exec "!clear;/bin/bash %"
  elseif type == "python"
    exec "!clear;$(which python) %"
  elseif type == "php"
    exec "!clear;$(which php) %"
  elseif type == "javascript"
    exec "!clear;node %"
  endif
endfunc

map <Leader>r :call Run()<CR>

"""自定义abbr<<<
iabbr liu liu(1);
hi Comment ctermfg=darkgray
"""自定义abbr

" MySQL
let g:dbext_default_profile_mysql_local = 'type=MYSQL:user=root:passwd=mysql272jp@:dbname=mysql'

" html,css,js 美化快捷键
map tf :call JsBeautify()<cr>
autocmd FileType javascript noremap <buffer>  tf :call JsBeautify()<cr>
autocmd FileType json noremap <buffer> tf :call JsonBeautify()<cr>
autocmd FileType jsx noremap <buffer> tf :call JsxBeautify()<cr>
autocmd FileType html noremap <buffer> tf :call HtmlBeautify()<cr>
autocmd FileType css noremap <buffer> tf :call CSSBeautify()<cr>
autocmd FileType javascript vnoremap <buffer>  tf :call RangeJsBeautify()<cr>
autocmd FileType json vnoremap <buffer> tf :call RangeJsonBeautify()<cr>
autocmd FileType jsx vnoremap <buffer> tf :call RangeJsxBeautify()<cr>
autocmd FileType html vnoremap <buffer> tf :call RangeHtmlBeautify()<cr>
autocmd FileType css vnoremap <buffer> tf :call RangeCSSBeautify()<cr>
