vim.api.nvim_create_autocmd('ColorScheme',{callback=function()
 for _,name in ipairs(vim.fn.getcompletion('','highlight')) do vim.api.nvim_set_hl(0,name,{}) end
 vim.o.termguicolors=false

 vim.api.nvim_set_hl(0,'Visual',{ctermbg=14})
 for _,name in ipairs({'Search','IncSearch','CurSearch','Substitute'}) do vim.api.nvim_set_hl(0,name,{ctermbg=11}) end
 vim.api.nvim_set_hl(0,'@comment',{ctermfg=0})
 vim.api.nvim_set_hl(0,'@keyword',{italic=true})
end})
vim.g.colors_name='default' --Set "vim.g.colors_name" to a valid colors-name to ensure "ColorScheme" autocommands are executed on Neovim startup.