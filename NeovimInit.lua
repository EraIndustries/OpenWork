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

 local all_keymap_modes={'n','i','c','v','o','t'}
 vim.keymap.set(all_keymap_modes,'<d-s>',function()
  if vim.bo.buftype~='' or not vim.bo.modifiable or vim.bo.readonly or vim.api.nvim_buf_get_name(0)=='' then return end
  vim.cmd('W')
 end)
 vim.keymap.set(all_keymap_modes,'<d-w>','<cmd>q<cr>')

 vim.o.shiftwidth=0
 vim.o.copyindent=true

 local function expected_virtualedit() return vim.fn.mode()=='i' and 'none' or 'all' end
 vim.o.virtualedit=expected_virtualedit()
 vim.api.nvim_create_autocmd('ModeChanged',{callback=function() vim.o.virtualedit=expected_virtualedit() end})
 vim.api.nvim_create_autocmd('BufWinLeave',{callback=function(context)vim.schedule(function() return vim.api.nvim_buf_is_valid(context.buf) and vim.bo[context.buf].buflisted and vim.fn.win_findbuf(context.buf)==0 and vim.cmd('bw'..context.buf) end)end})

 vim.o.loadplugins=false
 vim.cmd('filetype plugin off | filetype indent off')
 local function treesit(buffer)
  local filetype=vim.bo[buffer].filetype
  if not filetype then return end
  local language=vim.treesitter.language.get_lang(filetype)
  if not language or not vim.treesitter.language.add(language) then return end
  vim.treesitter.start(buffer,language)
 end
 vim.api.nvim_create_autocmd('FileType',{callback=function(context) treesit(context.buf) end})

 vim.o.fixeol=false
 local compactor=vim.api.nvim_create_namespace('Era.OpenWork.Neovim.Compactor')
 local function compact(buffer)
  for _,window in ipairs(vim.fn.getbufinfo(buffer)[1].windows) do
   local line_rank,column=unpack(vim.api.nvim_win_get_cursor(window)); local line_text=vim.api.nvim_buf_get_lines(buffer,line_rank-1,line_rank,true)[1]
   if line_text:sub(column+1,column+1):match('%s') then
    while 1<column and line_text:sub(column,column):match('%s') do column=column-1 end
   end
   vim.api.nvim_buf_set_extmark(buffer,compactor,line_rank-1,column,{id=window,right_gravity=false})
  end
  vim.bo[buffer].eol=vim.bo[buffer].fixeol
  vim.cmd([[
   let nonblank_front=nextnonblank(1) | if 1<nonblank_front | silent execute '1,'.(nonblank_front-1).'delete_' | endif
   let rear=line('$') | let nonblank_rear=prevnonblank(rear) | if nonblank_rear<rear | silent execute (nonblank_rear+1).',$delete_' | endif
   keepjumps %s/\v\S\s\zs\s+\ze\S|^\s*\n(\s*\n)+|\s+$/\=submatch(1)==#''?'':"\n"/ge
  ]])
  for _,window in ipairs(vim.fn.getbufinfo(buffer)[1].windows) do
   local line,column=unpack(vim.api.nvim_buf_get_extmark_by_id(buffer,compactor,window,{}))
   if vim.api.nvim_buf_line_count(buffer)==line then vim.api.nvim_win_set_cursor(window,{line,#vim.api.nvim_buf_get_lines(buffer,line-1,line,true)[1]})
   else vim.api.nvim_win_set_cursor(window,{line+1,column})
   end
   vim.api.nvim_buf_del_extmark(buffer,compactor,window)
  end
 end
 local function alias_command(aliases,command) for _,alias in ipairs(aliases) do vim.cmd(string.format([[cnoreabbrev <expr> %s getcmdtype()==#':'&&getcmdline()==#'%s'?'%s':'%s']],alias,alias,command,alias)) end end
 vim.api.nvim_create_user_command('W',function(context)
  compact(vim.api.nvim_get_current_buf())
  if not context.bang and not vim.bo.modified then return end
  vim.cmd('w'..(context.bang and '!' or ''))
 end,{bang=true})
 alias_command({'w','write','up','update'},'W')
 vim.api.nvim_create_user_command('Wq',function(context)
  vim.cmd('W'..(context.bang and '!' or ''))
  vim.cmd('q'..(context.bang and '!' or ''))
 end,{bang=true})
 alias_command({'wq','x'},'Wq')
 vim.keymap.set('n','ZZ',':Wq<CR>',{noremap=true,silent=true})