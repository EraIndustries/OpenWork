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

 --Remove bottom bar.
 vim.o.cmdheight=0
 vim.o.laststatus,vim.o.statusline=0,'%#StatusLine#%=%{repeat(\'―\',winwidth(0))}'
 --For "vim.o.laststatus=0" the status line is used as the separator between horizontal splits. Make the status line a horizontal
 --line to clearly separate such splits while making it seem like there is no status line.

--$ Control

 vim.o.shiftwidth=0
 vim.o.copyindent=true

 local function expected_virtualedit() return vim.fn.mode()=='i' and 'none' or 'all' end
 vim.o.virtualedit=expected_virtualedit()
 vim.api.nvim_create_autocmd('ModeChanged',{callback=function() vim.o.virtualedit=expected_virtualedit() end})
 vim.api.nvim_create_autocmd('BufWinLeave',{callback=function(context)vim.schedule(function() return vim.api.nvim_buf_is_valid(context.buf) and vim.bo[context.buf].buflisted and vim.fn.win_findbuf(context.buf)==0 and vim.cmd('bw'..context.buf) end)end})