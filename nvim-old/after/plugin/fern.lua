local Remap = require("gabrielmartins.keymap")
local nnoremap = Remap.nnoremap

nnoremap("<C-b>", ":Fern . -reveal=%<CR>")

vim.cmd([[
    function! s:init_fern() abort
        nmap <buffer> H <Plug>(fern-action-open:split)
        nmap <buffer> V <Plug>(fern-action-open:vsplit)
        map <buffer> R <Plug>(fern-action-rename)
        map <buffer> M <Plug>(fern-action-move)
        map <buffer> C <Plug>(fern-action-copy)
        map <buffer> T <Plug>(fern-action-new-file)
        map <buffer> D <Plug>(fern-action-new-dir)
        map <buffer> I <Plug>(fern-action-hidden:toggle)
        map <buffer> dd <Plug>(fern-action-trash)
        map <buffer> <leader> <Plug>(fern-action-mark)
    endfunction

    augroup fern-custom
      autocmd! *
      autocmd FileType fern call s:init_fern()
    augroup END
]])

vim.g["fern#renderer"] = "nerdfont"

