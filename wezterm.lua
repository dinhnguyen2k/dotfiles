local wezterm = require("wezterm")
local act = wezterm.action

local trigger_lunch_popup = nil

local config = wezterm.config_builder()

-- 1. Cấu hình tự động vào WSL Ubuntu và thư mục cogain-core
config.wsl_domains = {
  {
    name = 'WSL:Ubuntu',
    distribution = 'Ubuntu',
    default_cwd = '/home/nguyentd/cogain/cogain-core',
  },
}
config.default_domain = 'WSL:Ubuntu'
config.default_cwd = '/home/nguyentd/cogain/cogain-core'

-- 2. Font chữ & Kích thước (Nét Medium sắc nét & Giãn dòng thoáng)
config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
config.font_size = 11.0
config.line_height = 1.25

config.window_padding = {
  left = 12,
  right = 12,
  top = 10,
  bottom = 10,
}

-- 3. Hiệu ứng Con trỏ mượt mà (Smooth Cursor FX - Tối ưu Breathing & 120 FPS)
-- Lưu ý: WezTerm chưa hỗ trợ hiệu ứng lướt toạ độ (gliding/trail) trong shell, 
-- nhưng cấu hình này mang lại hiệu ứng chớp tắt dạng thở (breathing fade) mượt nhất ở 120Hz.
config.default_cursor_style = "BlinkingBar"
config.cursor_thickness = "2.5px"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "EaseInOut"
config.cursor_blink_ease_out = "EaseInOut"

-- 4. Hình nền & Lớp phủ tối (Dark Overlay) tăng tương phản chữ
config.background = {
  {
    source = {
      File = wezterm.home_dir .. "/bg_nguyentd_blur.png", -- Dùng ảnh đã xử lý Gaussian blur
    },
    hsb = {
      brightness = 0.08, -- Độ sáng vừa vặn (blur nhẹ sigma 5)
      saturation = 0.75,
    },
  },
  {
    source = {
      Color = "#191724",
    },
    opacity = 0.76, -- Lớp phủ tối giúp chữ nổi bật, không bị lóa và cực kỳ dễ đọc
  },
}

config.color_scheme = "rose-pine-moon"
config.max_fps = 120
config.animation_fps = 120
config.win32_system_backdrop = "Acrylic"
config.window_background_opacity = 0.85

-- Cấu hình cuộn trang mượt mà
config.enable_scroll_bar = true
config.scrollback_lines = 10000
config.bypass_mouse_reporting_modifiers = "SHIFT"

-- Tích hợp thanh Toolbar
config.window_decorations = "INTEGRATED_BUTTONS | RESIZE"
config.window_frame = {
  font = wezterm.font("JetBrains Mono", { weight = "Bold" }),
  font_size = 9.5,
  active_titlebar_bg = "none",
  inactive_titlebar_bg = "none",
}

-- Hiệu ứng Visual Bell chớp dịu khi chuyển tab/trạng thái
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 50,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 150,
}

-- 5. 🎨 ĐƯỜNG VIỀN NEON & MÀU SẮC NỔI BẬT
config.colors = {
  foreground = "#f8f8fc",     -- Chữ trắng sáng rõ 100%
  split = "#eb6f92",         -- Đường viền hồng Rose Neon nổi bật ô active
  cursor_bg = "#eb6f92",     -- Màu con trỏ hồng rose nổi bật
  cursor_fg = "#191724",     -- Màu chữ khi con trỏ đè lên
  cursor_border = "#eb6f92", -- Viền con trỏ
  visual_bell = "#2a283e",   -- Màu chớp tím dịu mắt
  tab_bar = {
    background = "none",      -- Trong suốt 100%, lộ hình nền blur và acrylic
    active_tab = {
      bg_color = "none",
      fg_color = "#f8f8fc",
    },
    inactive_tab = {
      bg_color = "none",
      fg_color = "#6e6a86",
    },
    inactive_tab_hover = {
      bg_color = "none",
      fg_color = "#e0def4",
    },
    new_tab = {
      bg_color = "none",
      fg_color = "#908caa",
    },
    new_tab_hover = {
      bg_color = "none",
      fg_color = "#e0def4",
    },
  },
}

-- 6. ✨ SIÊU TƯƠNG PHẢN (FOCUS SPOTLIGHT): Ô PHỤ SẼ CHÌM SÂU & ĐEN TRẮNG HOÀN TOÀN
config.inactive_pane_hsb = {
  saturation = 0.0,   -- Tắt 100% màu của ô phụ (thành đen trắng)
  brightness = 0.22,  -- Hạ độ sáng ô phụ xuống còn 22% (chìm hẳn xuống làm ô active nổi bật)
}

-- 7. 🚀 THANH TRẠNG THÁI NGANG DƯỚI CÙNG (BOTTOM STATUSLINE FULL-WIDTH)
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 45

-- 8. Phím tắt Leader (Ctrl + Space)
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }
-- =========================================================
-- ✨ SMOOTH PANE FOCUS TRANSITION
-- Fake hiệu ứng focus "trượt/kéo" từ pane cũ sang pane mới
-- =========================================================

local pane_anim_generation = {}

local function smooth_pane_switch(direction)
  return wezterm.action_callback(function(window, pane)
    local win_id = tostring(window:window_id())

    -- Hủy animation cũ nếu spam phím chuyển pane
    pane_anim_generation[win_id] =
      (pane_anim_generation[win_id] or 0) + 1

    local generation = pane_anim_generation[win_id]

    -- Pane vừa rời focus chưa chìm xuống ngay
    local overrides = window:get_config_overrides() or {}

    overrides.inactive_pane_hsb = {
      saturation = 0.45,
      brightness = 0.68,
    }

    window:set_config_overrides(overrides)

    -- Chuyển focus
    window:perform_action(
      act.ActivatePaneDirection(direction),
      pane
    )

    -- Ease-out pane cũ -> chìm dần
    local frames = {
      { 0.025, 0.58, 0.32 },
      { 0.055, 0.46, 0.20 },
      { 0.090, 0.34, 0.08 },
      { 0.135, 0.22, 0.00 },
    }

    for _, frame in ipairs(frames) do
      wezterm.time.call_after(frame[1], function()
        -- Nếu user đã chuyển pane tiếp thì bỏ animation cũ
        if pane_anim_generation[win_id] ~= generation then
          return
        end

        local current =
          window:get_config_overrides() or {}

        current.inactive_pane_hsb = {
          brightness = frame[2],
          saturation = frame[3],
        }

        window:set_config_overrides(current)
      end)
    end
  end)
end

-- =========================================================
-- 📋 CẤU HÌNH BỘ ĐỆM & SAO CHÉP (SMART COPY & CLIPBOARD)
-- =========================================================
local copy_mode_selecting = false

local function activate_copy_mode()
  return wezterm.action_callback(function(window, pane)
    copy_mode_selecting = false
    window:perform_action(act.ActivateCopyMode, pane)
  end)
end

local function shift_move(direction)
  return wezterm.action_callback(function(window, pane)
    if not copy_mode_selecting then
      copy_mode_selecting = true
      window:perform_action(act.CopyMode { SetSelectionMode = "Cell" }, pane)
    end
    window:perform_action(act.CopyMode(direction), pane)
  end)
end

local function copy_and_close()
  return wezterm.action_callback(function(window, pane)
    copy_mode_selecting = false
    window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
    window:perform_action(act.CopyMode("Close"), pane)
  end)
end

local function close_copy_mode()
  return wezterm.action_callback(function(window, pane)
    copy_mode_selecting = false
    window:perform_action(act.CopyMode("Close"), pane)
  end)
end

config.keys = {
  -- Cuộn trang (Scrollback)
  { key = "UpArrow", mods = "SHIFT", action = act.ScrollByLine(-3) },
  { key = "DownArrow", mods = "SHIFT", action = act.ScrollByLine(3) },
  { key = "PageUp", mods = "SHIFT", action = act.ScrollByPage(-1) },
  { key = "PageDown", mods = "SHIFT", action = act.ScrollByPage(1) },
  { key = "PageUp", mods = "NONE", action = act.ScrollByPage(-1) },
  { key = "PageDown", mods = "NONE", action = act.ScrollByPage(1) },
  { key = "x", mods = "CTRL|SHIFT", action = activate_copy_mode() },
  { key = "[", mods = "LEADER", action = activate_copy_mode() },
  { key = "Space", mods = "CTRL|SHIFT", action = act.QuickSelect },

  -- Nạp lại cấu hình: Ctrl + Shift + R hoặc Leader + r (Ctrl + Space rồi r)
  { key = "r", mods = "LEADER", action = act.ReloadConfiguration },
  { key = "r", mods = "CTRL|SHIFT", action = act.ReloadConfiguration },

  -- Test popup cơm trưa ngay lập tức: Leader + l (Ctrl + Space rồi bấm l)
  {
    key = "l",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      trigger_lunch_popup()
    end),
  },

  -- Nhấn phím Space ngay sau Leader để gửi trực tiếp Ctrl + Space vào Terminal (dùng cho Neovim AutoComplete)
  { key = "Space", mods = "LEADER|CTRL", action = act.SendKey({ key = "Space", mods = "CTRL" }) },
  { key = "Space", mods = "LEADER", action = act.SendKey({ key = "Space", mods = "CTRL" }) },

  -- Xóa nhanh 1 từ phía trước (Ctrl + Backspace)
  { key = "Backspace", mods = "CTRL", action = act.SendKey({ key = "w", mods = "CTRL" }) },

  -- Sao chép thông minh (Ctrl + C): Bôi đen -> copy vào Clipboard, không bôi đen -> gửi Ctrl + C (ngắt lệnh / SIGINT)
  {
    key = "c",
    mods = "CTRL",
    action = wezterm.action_callback(function(window, pane)
      local sel = window:get_selection_text_for_pane(pane)
      if sel and sel ~= "" then
        window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act.SendKey({ key = "c", mods = "CTRL" }), pane)
      end
    end),
  },
  -- Phím copy chuẩn của Terminal (Ctrl + Shift + C)
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("ClipboardAndPrimarySelection") },

  -- Dán từ Clipboard (Ctrl + V)
  { key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },

  -- Quản lý Tab
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
  { key = "Tab", mods = "CTRL", action = act.ActivateTabRelative(1) },
  { key = "Tab", mods = "CTRL|SHIFT", action = act.ActivateTabRelative(-1) },

  -- Chia màn hình
  { key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "s", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  -- Xem tiến trình CPU / RAM nhanh: Ctrl + a rồi bấm t để mở top
  { key = "t", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain", args = { "top" } }) },
  -- Mở sân khấu Chim cánh cụt lẹt bẹt mini: Leader + P (Ctrl + Space rồi Shift + P)
  { key = "P", mods = "LEADER", action = act.SplitPane({ direction = "Down", size = { Cells = 8 }, command = { args = { "penguin" } } }) },



  -- Zoom toàn màn hình 1 ô: Ctrl + a rồi bấm z
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

  -- Di chuyển giữa các ô: Ctrl + a rồi bấm mũi tên hoặc h,j,k,l
  -- ✨ Smooth pane navigation
{ key = "LeftArrow",  mods = "LEADER", action = smooth_pane_switch("Left") },
{ key = "RightArrow", mods = "LEADER", action = smooth_pane_switch("Right") },
{ key = "UpArrow",    mods = "LEADER", action = smooth_pane_switch("Up") },
{ key = "DownArrow",  mods = "LEADER", action = smooth_pane_switch("Down") },

{ key = "h", mods = "LEADER", action = smooth_pane_switch("Left") },
{ key = "l", mods = "LEADER", action = smooth_pane_switch("Right") },
{ key = "k", mods = "LEADER", action = smooth_pane_switch("Up") },
{ key = "j", mods = "LEADER", action = smooth_pane_switch("Down") },

  -- Kéo giãn ô: Alt + Mũi tên
  { key = "LeftArrow", mods = "ALT", action = act.AdjustPaneSize({ "Left", 3 }) },
  { key = "RightArrow", mods = "ALT", action = act.AdjustPaneSize({ "Right", 3 }) },
  { key = "UpArrow", mods = "ALT", action = act.AdjustPaneSize({ "Up", 3 }) },
  { key = "DownArrow", mods = "ALT", action = act.AdjustPaneSize({ "Down", 3 }) },
}

-- Cấu hình cuộn chuột trong chế độ TUI (Vim, Less, Claude CLI)
config.alternate_buffer_wheel_scroll_speed = 3

-- Logic chuột: Giữ nguyên cuộn chuột, bôi đen tự copy, chuột phải là paste
config.mouse_bindings = {
  -- Bắt buộc phải có để cuộn chuột hoạt động
  {
    event = { Down = { streak = 1, button = { WheelUp = 1 } } },
    mods = "NONE",
    action = act.ScrollByCurrentEventWheelDelta,
  },
  {
    event = { Down = { streak = 1, button = { WheelDown = 1 } } },
    mods = "NONE",
    action = act.ScrollByCurrentEventWheelDelta,
  },
  -- Bôi đen (kéo chuột 1 lần) là tự động copy vào Clipboard
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("ClipboardAndPrimarySelection"),
  },
  -- Nhấp đúp chuột (chọn 1 từ) là tự động copy vào Clipboard
  {
    event = { Up = { streak = 2, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("ClipboardAndPrimarySelection"),
  },
  -- Nhấp 3 lần chuột (chọn cả dòng) là tự động copy vào Clipboard
  {
    event = { Up = { streak = 3, button = "Left" } },
    mods = "NONE",
    action = act.CompleteSelection("ClipboardAndPrimarySelection"),
  },
  -- Mở liên kết (URL / Link) khi giữ Ctrl và click chuột trái
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CTRL",
    action = act.OpenLinkAtMouseCursor,
  },
  -- Chuột phải là paste từ Clipboard
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.PasteFrom("Clipboard"),
  },
}

for i = 1, 9 do
  table.insert(config.keys, { key = tostring(i), mods = "LEADER", action = act.ActivateTab(i - 1) })
  table.insert(config.keys, { key = tostring(i), mods = "ALT", action = act.ActivateTab(i - 1) })
end

-- ================= 🎨 ROSE-PINE MOON CAPSULE / PILL STATUS BAR (0% LAG) =================
config.status_update_interval = 1000

local function read_json_file(filename)
  local home = wezterm.home_dir or ""
  local candidates = {
    home .. "/" .. filename,
    home .. "\\" .. filename,
    "C:/Users/dinhn/" .. filename,
    "/home/nguyentd/" .. filename,
  }
  for _, path in ipairs(candidates) do
    local f = io.open(path, "r")
    if f then
      local content = f:read("*all")
      f:close()
      if content and content ~= "" then
        local ok, data = pcall(wezterm.json_parse, content)
        if ok and data then
          return data
        end
      end
    end
  end
  return nil
end

local function make_solid_pill(icon, text, bg_color)
  return {
    { Background = { Color = "none" } },
    { Foreground = { Color = bg_color } },
    { Text = "" },
    { Background = { Color = bg_color } },
    { Foreground = { Color = "#191724" } },
    { Attribute = { Intensity = "Bold" } },
    { Text = icon .. " " .. text },
    { Background = { Color = "none" } },
    { Foreground = { Color = bg_color } },
    { Text = "" },
    "ResetAttributes",
    { Background = { Color = "none" } },
    { Foreground = { Color = "none" } },
    { Text = " " },
  }
end

local function append_elements(dest, src)
  for _, item in ipairs(src) do
    table.insert(dest, item)
  end
end

local function clean_tab_title(tab)
  local title = tab.active_pane.title
  if not title or title == "" then
    return "tab " .. (tab.tab_index + 1)
  end

  local proc = tab.active_pane.foreground_process_name
  if proc and proc ~= "" then
    local proc_name = proc:match("([^/\\]+)$")
    if proc_name and proc_name ~= "" and proc_name ~= "zsh" and proc_name ~= "bash" and proc_name ~= "init" then
      return proc_name
    end
  end

  title = title:gsub("^file://[^/]*", "")
  local short = title:match("📁%s*([^%s]+)")
  if short then
    return short
  end

  local last = title:match("([^/]+)$")
  if last and #last > 0 and #last <= 20 then
    return last
  end

  return title:sub(1, 18)
end

-- Hiển thị trực tiếp Repo & Branch trên từng Tab dạng Segmented Capsule (y hệt ảnh template)
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = clean_tab_title(tab)

  local active_num_bg = "#fab387"   -- Peach / Apricot (badge number)
  local active_txt_bg = "#2a273f"   -- Dark surface
  local inactive_num_bg = hover and "#c6d0f5" or "#b4befe" -- Lavender / Blue (badge number)
  local inactive_txt_bg = hover and "#2d2a45" or "#232136" -- Muted surface

  if tab.is_active then
    return {
      { Background = { Color = "none" } },
      { Foreground = { Color = active_num_bg } },
      { Text = "" },
      { Background = { Color = active_num_bg } },
      { Foreground = { Color = "#191724" } },
      { Attribute = { Intensity = "Bold" } },
      { Text = " " .. (tab.tab_index + 1) .. " " },
      { Background = { Color = active_txt_bg } },
      { Foreground = { Color = "#f8f8fc" } },
      { Attribute = { Intensity = "Normal" } },
      { Text = " " .. title .. " " },
      { Background = { Color = "none" } },
      { Foreground = { Color = active_txt_bg } },
      { Text = "" },
      "ResetAttributes",
      { Background = { Color = "none" } },
      { Foreground = { Color = "none" } },
      { Text = " " },
    }
  else
    return {
      { Background = { Color = "none" } },
      { Foreground = { Color = inactive_num_bg } },
      { Text = "" },
      { Background = { Color = inactive_num_bg } },
      { Foreground = { Color = "#191724" } },
      { Attribute = { Intensity = "Bold" } },
      { Text = " " .. (tab.tab_index + 1) .. " " },
      { Background = { Color = inactive_txt_bg } },
      { Foreground = { Color = "#908caa" } },
      { Attribute = { Intensity = "Normal" } },
      { Text = " " .. title .. " " },
      { Background = { Color = "none" } },
      { Foreground = { Color = inactive_txt_bg } },
      { Text = "" },
      "ResetAttributes",
      { Background = { Color = "none" } },
      { Foreground = { Color = "none" } },
      { Text = " " },
    }
  end
end)

-- 🍱 CẤU HÌNH NHẮC NHỞ CƠM TRƯA (FUNNY MODE)
local lunch_quotes = {
  "Bug không tự hết nhưng đói thì run tay đấy! Dậy ăn cơm 🍚",
  "Code cả đời chứ không ai nhịn ăn được cả đời, đi ăn thôi sếp! 🍱",
  "CẢNH BÁO: Tụt đường huyết cấp độ 5! Cần nạp tinh bột khẩn cấp ⚠️",
  "Cơm sườn 35k đang vẫy gọi, git stash rồi đứng dậy ngay! 🥩",
  "Hôm nay ăn gì? Nghĩ lâu là hết chỗ ngồi đấy bro 🍜",
  "Fix bug có thể đợi, dạ dày thì không! 🏃‍♂️💨",
}
local food_icons = { "🍱", "🍜", "🥩", "🍕", "🍗", "🍲", "🍛", "🧋" }
local last_lunch_notified_key = nil

trigger_lunch_popup = function()
  local script_path = "C:\\Users\\dinhn\\.config\\wezterm\\lunch_popup.ps1"
  local ps_exe = "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe"
  wezterm.background_child_process({
    ps_exe,
    "-NoProfile",
    "-WindowStyle",
    "Hidden",
    "-ExecutionPolicy",
    "Bypass",
    "-File",
    script_path,
  })
end

-- =========================================================
-- 🐧 CHIM CÁNH CỤT LẸT BẸT TRÊN THANH STATUS WEZTERM
-- Chạy ngẫu nhiên, để lại dấu chấm chấm chân nhẹ nhàng vui vẻ
-- =========================================================
local penguin_pet = {
  pos = 3,
  dir = 1,
  min_pos = 1,
  max_pos = 7,
  step_toggle = false,
  state = "walk",
  state_ticks = 0,
}

local function render_wezterm_penguin()
  penguin_pet.step_toggle = not penguin_pet.step_toggle

  if penguin_pet.state_ticks > 0 then
    penguin_pet.state_ticks = penguin_pet.state_ticks - 1
  else
    local roll = math.random(1, 100)
    if roll < 55 then
      penguin_pet.state = "walk"
      penguin_pet.state_ticks = math.random(6, 12)
      if math.random(1, 10) <= 3 then
        penguin_pet.dir = -penguin_pet.dir
      end
    elseif roll < 75 then
      penguin_pet.state = "orchestrate"
      penguin_pet.state_ticks = math.random(4, 7)
    elseif roll < 86 then
      penguin_pet.state = "slide"
      penguin_pet.state_ticks = math.random(3, 5)
    elseif roll < 94 then
      penguin_pet.state = "look"
      penguin_pet.state_ticks = math.random(3, 5)
    else
      penguin_pet.state = "sleep"
      penguin_pet.state_ticks = math.random(4, 7)
    end
  end

  local sound = ""
  local icon = "🐧"

  if penguin_pet.state == "walk" then
    penguin_pet.pos = penguin_pet.pos + penguin_pet.dir
    if penguin_pet.pos >= penguin_pet.max_pos then
      penguin_pet.pos = penguin_pet.max_pos
      penguin_pet.dir = -1
    elseif penguin_pet.pos <= penguin_pet.min_pos then
      penguin_pet.pos = penguin_pet.min_pos
      penguin_pet.dir = 1
    end
    sound = penguin_pet.step_toggle and "lẹt..         " or "..bẹt         "
    icon = "🐧"
  elseif penguin_pet.state == "slide" then
    penguin_pet.pos = penguin_pet.pos + (penguin_pet.dir * 2)
    if penguin_pet.pos >= penguin_pet.max_pos then
      penguin_pet.pos = penguin_pet.max_pos
      penguin_pet.dir = -1
    elseif penguin_pet.pos <= penguin_pet.min_pos then
      penguin_pet.pos = penguin_pet.min_pos
      penguin_pet.dir = 1
    end
    sound = "vèoo ⛷️       "
    icon = "⛷️"
  elseif penguin_pet.state == "orchestrate" then
    sound = "orchestrate 🪄"
    icon = "🐧"
  elseif penguin_pet.state == "look" then
    sound = "(•ө•)?        "
    icon = "🐧"
  elseif penguin_pet.state == "sleep" then
    sound = "zZz..         "
    icon = "💤"
  end

  local track = ""
  for i = 1, penguin_pet.max_pos do
    if i == penguin_pet.pos then
      track = track .. icon
    elseif penguin_pet.dir > 0 and i < penguin_pet.pos and (penguin_pet.pos - i) <= 2 then
      track = track .. "·"
    elseif penguin_pet.dir < 0 and i > penguin_pet.pos and (i - penguin_pet.pos) <= 2 then
      track = track .. "·"
    else
      track = track .. " "
    end
  end

  return track, sound
end

local function update_status_bar(window, pane)
  local today = wezterm.strftime("%Y-%m-%d")
  local hour = tonumber(wezterm.strftime("%H"))
  local min = tonumber(wezterm.strftime("%M"))
  local sec = tonumber(wezterm.strftime("%S")) or 0

  -- ⏰ Kích hoạt đúng 12h trưa hàng ngày (12:00:00 - 12:59:59)
  local is_lunch_time = (hour == 12)

  local notify_key = today .. "-12h"
  -- BẮN POPUP & NOTIFICATION KHI ĐẾN GIỜ (chỉ nổ 1 lần)
  if is_lunch_time and last_lunch_notified_key ~= notify_key then
    last_lunch_notified_key = notify_key
    math.randomseed(os.time())
    local quote = lunch_quotes[math.random(#lunch_quotes)]

    -- 1. Bắn toast notification
    window:toast_notification("🚨 CÒI BÁO ĐỘNG ĐÓI BỤNG", quote, nil, 8000)

    -- 2. Hộp thoại modal nổ ra giữa màn hình có nút "Xác nhận" và "Close"
    trigger_lunch_popup()
  end

  -- 1. LEFT STATUS: Chế độ động (COPY MODE / LEADER / Thường)
  local left_elems = {}
  local key_table = window:active_key_table()

  if key_table == "copy_mode" then
    -- Đèn báo COPY MODE màu vàng pastel rực rỡ
    table.insert(left_elems, { Background = { Color = "none" } })
    table.insert(left_elems, { Foreground = { Color = "#eed49f" } })
    table.insert(left_elems, { Text = " " })
    table.insert(left_elems, { Background = { Color = "#eed49f" } })
    table.insert(left_elems, { Foreground = { Color = "#191724" } })
    table.insert(left_elems, { Attribute = { Intensity = "Bold" } })
    table.insert(left_elems, { Text = " 📋 COPY MODE | Shift+Mũi tên hoặc v: bôi đen | Enter/y/Ctrl+C: copy | Esc: thoát " })
    table.insert(left_elems, { Background = { Color = "none" } })
    table.insert(left_elems, { Foreground = { Color = "#eed49f" } })
    table.insert(left_elems, { Text = " " })
    table.insert(left_elems, "ResetAttributes")
  elseif window:leader_is_active() then
    -- Đèn báo LEADER màu hồng pastel rực rỡ
    table.insert(left_elems, { Background = { Color = "none" } })
    table.insert(left_elems, { Foreground = { Color = "#eb6f92" } })
    table.insert(left_elems, { Text = " " })
    table.insert(left_elems, { Background = { Color = "#eb6f92" } })
    table.insert(left_elems, { Foreground = { Color = "#191724" } })
    table.insert(left_elems, { Attribute = { Intensity = "Bold" } })
    table.insert(left_elems, { Text = " 🚀 LEADER " })
    table.insert(left_elems, { Background = { Color = "none" } })
    table.insert(left_elems, { Foreground = { Color = "#eb6f92" } })
    table.insert(left_elems, { Text = " " })
    table.insert(left_elems, "ResetAttributes")
  else
    table.insert(left_elems, { Background = { Color = "none" } })
    table.insert(left_elems, { Foreground = { Color = "#a6da95" } })
    table.insert(left_elems, { Text = " " })
    table.insert(left_elems, { Background = { Color = "#a6da95" } })
    table.insert(left_elems, { Foreground = { Color = "#191724" } })
    table.insert(left_elems, { Attribute = { Intensity = "Bold" } })
    table.insert(left_elems, { Text = " cogain " })
    table.insert(left_elems, { Background = { Color = "none" } })
    table.insert(left_elems, { Foreground = { Color = "#a6da95" } })
    table.insert(left_elems, { Text = " " })
    table.insert(left_elems, "ResetAttributes")

    -- 🐧 Chú chim cánh cụt lẹt bẹt chạy trên thanh trạng thái
    local p_track, p_sound = render_wezterm_penguin()
    table.insert(left_elems, { Background = { Color = "none" } })
    table.insert(left_elems, { Foreground = { Color = "#9ccfd8" } })
    table.insert(left_elems, { Text = "" })
    table.insert(left_elems, { Background = { Color = "#9ccfd8" } })
    table.insert(left_elems, { Foreground = { Color = "#191724" } })
    table.insert(left_elems, { Attribute = { Intensity = "Bold" } })
    table.insert(left_elems, { Text = " " .. p_track .. " " })
    table.insert(left_elems, { Background = { Color = "#232136" } })
    table.insert(left_elems, { Foreground = { Color = "#f6c177" } })
    table.insert(left_elems, { Attribute = { Intensity = "Bold" } })
    table.insert(left_elems, { Text = " " .. p_sound .. " " })
    table.insert(left_elems, { Background = { Color = "none" } })
    table.insert(left_elems, { Foreground = { Color = "#232136" } })
    table.insert(left_elems, { Text = " " })
    table.insert(left_elems, "ResetAttributes")
  end

  if window.set_left_status then
    local ok_left, left_fmt = pcall(wezterm.format, left_elems)
    if ok_left then
      pcall(function() window:set_left_status(left_fmt) end)
    end
  end

  -- 2. RIGHT STATUS: Text username + solid pastel pills y hệt ảnh mẫu
  local right_elems = {}

  -- Tên người dùng nguyentd 🚀 (nền trong suốt)
  table.insert(right_elems, { Background = { Color = "none" } })
  table.insert(right_elems, { Foreground = { Color = "#e0def4" } })
  table.insert(right_elems, { Attribute = { Intensity = "Bold" } })
  table.insert(right_elems, { Text = "nguyentd 🚀  " })
  table.insert(right_elems, "ResetAttributes")

  -- 🍱 Pill cảnh báo cơm trưa nhảy múa vui nhộn
  if is_lunch_time then
    local current_icon = food_icons[(sec % #food_icons) + 1]
    local alert_text = (sec % 2 == 0) and " ĐI ĂN CƠM THÔI! " or " ĐÓI QUÁ RỒI BRO! "

    table.insert(right_elems, { Background = { Color = "none" } })
    table.insert(right_elems, { Foreground = { Color = "#e06c75" } })
    table.insert(right_elems, { Text = "" })
    table.insert(right_elems, { Background = { Color = "#e06c75" } })
    table.insert(right_elems, { Foreground = { Color = "#191724" } })
    table.insert(right_elems, { Attribute = { Intensity = "Bold" } })
    table.insert(right_elems, { Text = current_icon .. " " })
    table.insert(right_elems, { Background = { Color = "#282c34" } })
    table.insert(right_elems, { Foreground = { Color = "#e5c07b" } })
    table.insert(right_elems, { Attribute = { Intensity = "Bold" } })
    table.insert(right_elems, { Text = alert_text })
    table.insert(right_elems, { Background = { Color = "none" } })
    table.insert(right_elems, { Foreground = { Color = "#282c34" } })
    table.insert(right_elems, { Text = " " })
    table.insert(right_elems, "ResetAttributes")
  end

  -- Git Branch Pill (nếu có)
  local user_vars = pane:get_user_vars() or {}
  local branch_name = user_vars.git_branch
  if not branch_name or branch_name == "" then
    local t = pane:get_title() or ""
    branch_name = t:match("%s*([^%s]+)") or t:match("%s*([^%s]+)")
  end
  if branch_name and branch_name ~= "" then
    append_elements(right_elems, make_solid_pill("", branch_name, "#ebbcba"))
  end

  -- System Stats (CPU, RAM) từ background watcher
  local sys = read_json_file(".sys_stats.json")
  if sys then
    -- CPU Pill (vàng pastel như ảnh mẫu)
    if sys.cpu_pct then
      append_elements(right_elems, make_solid_pill("", string.format("%.1f%%", sys.cpu_pct), "#eed49f"))
    end
    -- RAM Pill (xanh mint pastel như ảnh mẫu)
    if sys.mem_pct then
      append_elements(right_elems, make_solid_pill("󰍛", string.format("%d%%", sys.mem_pct), "#a6da95"))
    end
  end

  -- Đồng hồ (lavender pastel như ảnh mẫu)
  local time_str = wezterm.strftime("%H:%M")
  append_elements(right_elems, make_solid_pill("", time_str, "#b4befe"))


  if window.set_right_status then
    local ok_right, right_fmt = pcall(wezterm.format, right_elems)
    if ok_right then
      pcall(function() window:set_right_status(right_fmt) end)
    else
      wezterm.log_error("Failed to format right status: " .. tostring(right_fmt))
    end
  end
end

wezterm.on("update-status", update_status_bar)
wezterm.on("update-right-status", update_status_bar)

-- =========================================================
-- 🌟 KEY TABLES: CẤU HÌNH COPY MODE (BÔI ĐEN VÀ COPY VÀO CLIPBOARD)
-- =========================================================
local copy_mode = wezterm.gui.default_key_tables().copy_mode

-- Hỗ trợ Shift + Mũi tên: Tự động kích hoạt chọn ở lần bấm đầu và kéo dài vùng bôi đen liên tục
table.insert(copy_mode, { key = "LeftArrow", mods = "SHIFT", action = shift_move("MoveLeft") })
table.insert(copy_mode, { key = "RightArrow", mods = "SHIFT", action = shift_move("MoveRight") })
table.insert(copy_mode, { key = "UpArrow", mods = "SHIFT", action = shift_move("MoveUp") })
table.insert(copy_mode, { key = "DownArrow", mods = "SHIFT", action = shift_move("MoveDown") })

-- Bôi đen nhanh cả trang với Shift + PageUp / PageDown
table.insert(copy_mode, { key = "PageUp", mods = "SHIFT", action = shift_move({ MoveByPage = -0.5 }) })
table.insert(copy_mode, { key = "PageDown", mods = "SHIFT", action = shift_move({ MoveByPage = 0.5 }) })

-- Bắt đầu vùng chọn bằng v hoặc Space (như Vim / mặc định WezTerm)
table.insert(copy_mode, {
  key = "v",
  mods = "NONE",
  action = wezterm.action_callback(function(window, pane)
    copy_mode_selecting = true
    window:perform_action(act.CopyMode { SetSelectionMode = "Cell" }, pane)
  end),
})
table.insert(copy_mode, {
  key = "Space",
  mods = "NONE",
  action = wezterm.action_callback(function(window, pane)
    copy_mode_selecting = true
    window:perform_action(act.CopyMode { SetSelectionMode = "Cell" }, pane)
  end),
})

-- Phím tắt copy vào Clipboard: Enter, y hoặc Ctrl + C đều copy và thoát
table.insert(copy_mode, { key = "Enter", mods = "NONE", action = copy_and_close() })
table.insert(copy_mode, { key = "y", mods = "NONE", action = copy_and_close() })
table.insert(copy_mode, { key = "c", mods = "CTRL", action = copy_and_close() })

-- Phím tắt thoát Copy Mode mà không copy: Esc hoặc q
table.insert(copy_mode, { key = "Escape", mods = "NONE", action = close_copy_mode() })
table.insert(copy_mode, { key = "q", mods = "NONE", action = close_copy_mode() })

config.key_tables = {
  copy_mode = copy_mode,
}

return config
