--$ Render

 vim.api.nvim_create_autocmd('ColorScheme',{callback=function()
  for _,name in ipairs(vim.fn.getcompletion('','highlight')) do vim.api.nvim_set_hl(0,name,{}) end
  vim.o.termguicolors=false

  vim.api.nvim_set_hl(0,'Visual',{ctermbg=14})
  for _,name in ipairs({'Search','IncSearch','CurSearch','Substitute'}) do vim.api.nvim_set_hl(0,name,{ctermbg=11}) end
  for _,name in ipairs({'Whitespace','NonText'}) do vim.api.nvim_set_hl(0,name,{ctermfg=7}) end
  vim.api.nvim_set_hl(0,'@comment',{ctermfg=0})
  vim.api.nvim_set_hl(0,'@keyword',{italic=true})
 end})
 vim.g.colors_name='default' --Set "vim.g.colors_name" to a valid colors-name to ensure "ColorScheme" autocommands are executed on Neovim startup.

 vim.o.list,vim.o.listchars,vim.o.fillchars=true,'tab:│ ,trail:•,extends:▶︎,precedes:◀︎','eob: '

 vim.o.wrap=false

 vim.o.tabstop=1

--$ Control

 vim.o.shiftwidth=0
 vim.o.copyindent=true