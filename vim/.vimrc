call plug#begin('~/.vim/plugged')
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'pangloss/vim-javascript'
Plug 'flowtype/vim-flow'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'rust-lang/rust.vim'
call plug#end()

" TextEdit might fail if hidden is not set.
set hidden

set nobackup
set nowritebackup
set noswapfile

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

syntax on
set relativenumber
set sw=2 ts=2 expandtab

nnoremap <c-p> :FZF<cr>
nnoremap <c-l> :Ag<cr>

nmap <silent> gb <Plug>(boc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> <leader>r <Plug>(coc-rename)
nmap <silent> <leader>n <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>p <Plug>(coc-diagnostic-next)

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)

let g:coc_global_extensions = ['coc-flow', 'coc-java', 'coc-rust-analyzer']

autocmd CursorHold * silent call CocActionAsync('highlight')

set mouse=n

" let g:rustfmt_autosave = 1

inoremap <silent><expr> <c-space> coc#refresh()

nmap <silent> ö <Plug>(coc-diagnostic-prev)
nmap <silent> ä <Plug>(coc-diagnostic-next)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:OrganizeImport` command for organize imports of the current buffer.
command! -nargs=0 OrganizeImport :call CocAction('runCommand', 'editor.action.organizeImport')

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
