-- ==============================================================================
-- 🐧 PENGUIN PET CHO NEOVIM (Lẹt bẹt Orchestrate in Editor)
-- Chú chim cánh cụt nổi ở góc dưới màn hình Neovim, bước đi lẹt bẹt vui nhộn
-- ==============================================================================

local M = {}

local timer = nil
local buf = nil
local win = nil
local is_running = false

local pet = {
  pos = 3,
  dir = 1,
  min_pos = 1,
  max_pos = 9,
  step_toggle = false,
  state = "walk", -- walk, slide, orchestrate, sleep, look
  ticks = 0,
  sound = "lẹt.. bẹt..",
}

-- Khởi tạo highlight groups đồng bộ với Rose-Pine theme
local function setup_highlights()
  vim.api.nvim_set_hl(0, "PenguinBorder", { fg = "#eb6f92" })  -- Viền hồng Rose
  vim.api.nvim_set_hl(0, "PenguinTitle",  { fg = "#9ccfd8", bold = true }) -- Xanh băng
  vim.api.nvim_set_hl(0, "PenguinSound",  { fg = "#f6c177", bold = true }) -- Cam vàng
  vim.api.nvim_set_hl(0, "PenguinTrack",  { fg = "#e0def4" })
  vim.api.nvim_set_hl(0, "PenguinFoot",   { fg = "#6e6a86" })
end

local function get_win_config()
  local width = 25
  local height = 3
  local row = math.max(1, vim.o.lines - height - 4)
  local col = math.max(1, vim.o.columns - width - 3)

  return {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    focusable = false,
    zindex = 45,
  }
end

local function update_pet_logic()
  pet.step_toggle = not pet.step_toggle

  if pet.ticks > 0 then
    pet.ticks = pet.ticks - 1
  else
    local roll = math.random(1, 100)
    if roll < 55 then
      pet.state = "walk"
      pet.ticks = math.random(5, 12)
      if math.random(1, 10) <= 3 then
        pet.dir = -pet.dir
      end
    elseif roll < 75 then
      pet.state = "orchestrate"
      pet.ticks = math.random(4, 7)
    elseif roll < 86 then
      pet.state = "slide"
      pet.ticks = math.random(3, 5)
    elseif roll < 94 then
      pet.state = "look"
      pet.ticks = math.random(3, 5)
    else
      pet.state = "sleep"
      pet.ticks = math.random(4, 7)
    end
  end

  local icon = "🐧"

  if pet.state == "walk" then
    pet.pos = pet.pos + pet.dir
    if pet.pos >= pet.max_pos then
      pet.pos = pet.max_pos
      pet.dir = -1
    elseif pet.pos <= pet.min_pos then
      pet.pos = pet.min_pos
      pet.dir = 1
    end
    pet.sound = pet.step_toggle and "lẹt.. bẹt.." or "lạch bạch..🐾"
    icon = "🐧"
  elseif pet.state == "slide" then
    pet.pos = pet.pos + (pet.dir * 2)
    if pet.pos >= pet.max_pos then
      pet.pos = pet.max_pos
      pet.dir = -1
    elseif pet.pos <= pet.min_pos then
      pet.pos = pet.min_pos
      pet.dir = 1
    end
    pet.sound = "vèoooo~ ⛷️"
    icon = "⛷️"
  elseif pet.state == "orchestrate" then
    pet.sound = "orchestrating 🪄"
    icon = "🐧"
  elseif pet.state == "look" then
    pet.sound = "nhìn gì á? (•ө•)?"
    icon = "🐧"
  elseif pet.state == "sleep" then
    pet.sound = "khò khò... zZz"
    icon = "💤"
  end

  -- Xây dựng dải track có dấu chân chấm chấm nhẹ
  local track = ""
  for i = 1, pet.max_pos do
    if i == pet.pos then
      track = track .. icon
    elseif pet.dir > 0 and i < pet.pos and (pet.pos - i) <= 3 then
      track = track .. " ·"
    elseif pet.dir < 0 and i > pet.pos and (i - pet.pos) <= 3 then
      track = track .. "· "
    else
      track = track .. "  "
    end
  end

  return track
end

local function render()
  if not win or not vim.api.nvim_win_is_valid(win) then
    return
  end
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local track = update_pet_logic()

  local line1 = " 🐧 Penguin Orchestrate "
  local line2 = " [" .. track .. "]"
  local line3 = " 💬 " .. pet.sound

  -- Cập nhật nội dung buffer
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { line1, line2, line3 })

  -- Áp dụng màu sắc
  vim.api.nvim_buf_clear_namespace(buf, -1, 0, -1)
  local ns = vim.api.nvim_create_namespace("penguin_ns")
  vim.api.nvim_buf_add_highlight(buf, ns, "PenguinTitle", 0, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns, "PenguinTrack", 1, 0, -1)
  vim.api.nvim_buf_add_highlight(buf, ns, "PenguinSound", 2, 0, -1)
end

function M.start()
  if is_running then return end

  setup_highlights()

  -- Tạo buffer tạm (unlisted, scratch)
  buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false

  -- Tạo floating window
  local cfg = get_win_config()
  win = vim.api.nvim_open_win(buf, false, cfg)

  -- Thiết lập thuộc tính window
  vim.wo[win].winhl = "FloatBorder:PenguinBorder,NormalFloat:Normal"
  vim.wo[win].wrap = false
  vim.wo[win].cursorline = false
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false

  is_running = true

  -- Vẽ lần đầu
  render()

  -- Thiết lập timer lặp mỗi 800ms
  local loop = vim.uv or vim.loop
  timer = loop.new_timer()
  timer:start(800, 800, vim.schedule_wrap(function()
    if is_running then
      render()
    end
  end))

  -- Tự động căn lại toạ độ khi đổi kích thước màn hình
  vim.api.nvim_create_autocmd("VimResized", {
    group = vim.api.nvim_create_augroup("PenguinResize", { clear = true }),
    callback = function()
      if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, get_win_config())
      end
    end,
  })
end

function M.stop()
  if not is_running then return end
  is_running = false

  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end

  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
    win = nil
  end

  buf = nil
end

function M.toggle()
  if is_running then
    M.stop()
  else
    M.start()
  end
end

function M.setup(opts)
  opts = opts or {}

  -- Tạo lệnh :PenguinToggle và :Pet
  vim.api.nvim_create_user_command("PenguinToggle", function() M.toggle() end, { desc = "Bật/Tắt Chim cánh cụt lẹt bẹt" })
  vim.api.nvim_create_user_command("Pet", function() M.toggle() end, { desc = "Bật/Tắt Pet" })

  -- Tự động chạy khi mở Neovim nếu được cấu hình (mặc định bật)
  if opts.auto_start ~= false then
    vim.defer_fn(function()
      M.start()
    end, 300)
  end
end

return M
