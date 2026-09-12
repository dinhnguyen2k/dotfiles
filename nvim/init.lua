-- ==============================================================================
-- 🚀 Leader Key: Phím SPACE (công thái học, bấm cực nhanh)
-- Bắt buộc đặt trước khi gọi lazy.nvim
-- ==============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Plugin manager: lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- 🎨 Theme Rose-Pine Moon (Đồng bộ tuyệt đối với WezTerm của bạn)
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    lazy = false,
    priority = 1000,
    config = function()
      require('rose-pine').setup({
        variant = 'moon',
        dark_variant = 'moon',
      })
      vim.cmd('colorscheme rose-pine')
    end,
  },

  -- ⌨️ Which-Key: Hiện menu gợi ý phím tắt khi ấn phím Space (<leader>)
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  -- 🔣 Web Devicons cho render-markdown và code block
  { 'nvim-tree/nvim-web-devicons', lazy = true },

  -- 🌳 Treesitter: Highlight cú pháp & Parser cho Markdown
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { 'markdown', 'markdown_inline', 'bash', 'lua', 'json', 'yaml', 'c_sharp' },
        highlight = { enable = true },
      })
    end,
  },

  -- 📝 Render Markdown trực quan ngay trong Neovim buffer
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'quarto' },
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    opts = {
      heading = { enabled = true },
      code = { enabled = true, style = 'full' },
      bullet = { enabled = true },
      checkbox = { enabled = true },
      table = { enabled = true },
    },
  },

  -- 🌠 Smear Cursor: Hiệu ứng con trỏ chuột trượt biến biến (Smear / Morphing trail)
  {
    'sphamba/smear-cursor.nvim',
    event = 'VeryLazy',
    opts = {
      stiffness = 0.8,               -- Tốc độ lướt tới vị trí mới (nhanh và dứt khoát)
      trailing_stiffness = 0.5,      -- Độ dẻo vệt kéo đuôi biến hình
      distance_stop_animating = 0.5,
      cursor_color = '#eb6f92',      -- Đồng bộ màu hồng Rose Neon với con trỏ WezTerm
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      smear_insert_mode = true,
    },
  },

  -- 🔍 FZF-Lua: Tìm kiếm file & text siêu tốc (style kunkka19xx + đồng bộ fn zsh)
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local fzf = require('fzf-lua')
      local default_cmd = os.getenv("FZF_DEFAULT_COMMAND")
        or "rg --files --hidden --no-ignore --glob '!.git' --glob '!node_modules' --glob '!bin' --glob '!obj' --glob '!.dotnet' --glob '!.cache' --glob '!dist' --glob '!.turbo'"

      fzf.setup({
        multiprocess = false,
        winopts = {
          height = 0.85,
          width = 0.90,
          preview = {
            layout = 'horizontal',
          },
        },
        fzf_colors = {
          true,
          bg = '-1',
          gutter = '-1',
        },
        keymap = {
          fzf = { ['ctrl-q'] = 'select-all+accept' },
        },
        files = {
          cmd = default_cmd,
          cwd_prompt = false,
          prompt = '🔍 Files> ',
          multiprocess = false,
          git_icons = false,
        },
        grep = {
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!.git' -g '!node_modules' -g '!bin' -g '!obj' -e",
          prompt = '🔍 Grep> ',
          multiprocess = false,
        },
      })
    end,
  },

  -- 🌲 Neo-tree: Cây thư mục sidebar bên cạnh editor (chuẩn template kunkka19xx)
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    opts = {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
      },
      window = {
        width = 32,
        position = 'left',
      },
    },
  },
})

-- ==============================================================================
-- ⚙️ Cấu hình Editor & Hiển thị
-- ==============================================================================
vim.opt.termguicolors = true   -- Kích hoạt TrueColor 24-bit
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ruler = true

-- Tự động gập theo heading trong Markdown
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.foldmethod = 'syntax'
    vim.opt_local.foldlevel = 99
  end,
})

-- ==============================================================================
-- ⚡ Bộ phím tắt <leader> tối ưu (Bấm Space + ...)
-- ==============================================================================
local map = vim.keymap.set

-- Markdown & Đọc tài liệu
map('n', '<leader>m', '<cmd>RenderMarkdown toggle<CR>', { desc = 'Toggle Render Markdown' })

-- 🔍 Tìm kiếm File & Nội dung (FZF-Lua style kunkka19xx + đồng bộ fn zsh)
map('n', '<leader>ff', function() require('fzf-lua').files() end, { desc = 'Find Files (Tìm file đồng bộ fn)' })
map('n', '<leader>fg', function() require('fzf-lua').live_grep() end, { desc = 'Live Grep (Tìm từ trong code)' })
map('n', '<leader>fG', function()
  require('fzf-lua').live_grep({
    rg_opts = "--hidden --no-ignore --glob '!.git/*' --column --line-number --no-heading --color=always -e",
  })
end, { desc = 'Live Grep (bao gồm file ẩn/ignored)' })
map('n', '<leader>fb', function() require('fzf-lua').buffers() end, { desc = 'Buffers (File đang mở)' })
map('n', '<leader>pf', function() require('fzf-lua').git_files() end, { desc = 'Find Git Files' })
map('n', '<leader>fh', function() require('fzf-lua').help_tags() end, { desc = 'Help Tags' })
map('n', '<leader>fr', function() require('fzf-lua').resume() end, { desc = 'Resume search gần nhất' })
map('n', '<leader>fs', function()
  local input = vim.fn.input('Grep For > ')
  if input and #input > 0 then
    require('fzf-lua').grep({ search = input })
  end
end, { desc = 'FZF grep with input (kunkka style)' })
map('n', '<leader>fl', function()
  require('fzf-lua').files({ cwd = vim.fn.expand('%:p:h'), prompt = '🔍 Files (thư mục hiện tại)> ' })
end, { desc = 'Find Files thư mục hiện tại' })

-- Quản lý File & Cây thư mục (Sidebar Neo-tree)
map('n', '<leader>e', '<cmd>Neotree toggle reveal<CR>', { desc = 'Toggle Cây thư mục (Sidebar Tree)' })
map('n', '<leader>o', '<cmd>Neotree focus<CR>', { desc = 'Focus vào Cây thư mục' })
map('n', '<leader>bn', '<cmd>bnext<CR>', { desc = 'File kế tiếp (Buffer Next)' })
map('n', '<leader>bp', '<cmd>bprev<CR>', { desc = 'File trước đó (Buffer Prev)' })
map('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Đóng file hiện tại (Buffer Delete)' })

-- Khám phá & Soi bộ não Treesitter
map('n', '<leader>ti', '<cmd>InspectTree<CR>', { desc = 'Mở Cây cú pháp Treesitter AST' })
map('n', '<leader>i', '<cmd>Inspect<CR>', { desc = 'Soi token cú pháp Treesitter' })

-- Hiệu ứng Con trỏ trượt biến biến
map('n', '<leader>sc', '<cmd>SmearCursorToggle<CR>', { desc = 'Bật/Tắt Con trỏ trượt biến biến' })

-- Tiện ích thao tác nhanh
map('n', '<leader>w', '<cmd>w<CR>', { desc = 'Lưu file nhanh' })
map('n', '<leader>q', '<cmd>q<CR>', { desc = 'Thoát' })
map('n', '<leader>h', '<cmd>nohlsearch<CR>', { desc = 'Tắt highlight tìm kiếm' })

-- Toggle số dòng (Space + n hoặc F2)
local function toggle_numbers()
  local nu = vim.opt.number:get()
  vim.opt.number = not nu
  vim.opt.relativenumber = not nu
end
map('n', '<leader>n', toggle_numbers, { desc = 'Toggle line numbers' })
map('n', '<F2>', toggle_numbers, { desc = 'Toggle line numbers' })

-- 🐧 Chim cánh cụt Pet (giữ nguyên phím cũ)
require('penguin_pet').setup({ auto_start = true })
map('n', '<leader>pp', '<cmd>PenguinToggle<CR>', { desc = 'Bật/Tắt Chim cánh cụt Pet' })
