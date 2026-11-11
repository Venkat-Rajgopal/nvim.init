-- Pixel art for the dashboard (lua/plugins/dashboard.lua).
-- Each character in `rows` is one pixel looked up in `colors`; a space is empty.
-- Two pixel rows share one terminal line: "▀" takes the top pixel as fg and the
-- bottom pixel as bg, so pixels come out square.
local M = {}

-- stylua: ignore start
M.art = {
  moon = {
    accent = "#f5d78e",
    colors = { m = "#f5d78e", w = "#fff6d5", e = "#d9a95b", c = "#e0b86c", s = "#ffffff", d = "#8aadf4" },
    rows = {
      "                 we                 d  ",
      "   d           wwee                dsd ",
      "  dsd        wwwme                  d  ",
      "   d        wwmmee                     ",
      "           wwmmmee                     ",
      "           wmmmmee                     ",
      "          wwmmmme                      ",
      "          wmcmmmee                     ",
      "         wwcccmmee                     ",
      "        dwmmcmmmee                     ",
      "         wmmmmmmme                     ",
      "         wmmmmmmmee            d       ",
      "         wmmmcccmme                    ",
      "         wmmmcccmmee                   ",
      "         wwmmcccmmmee                  ",
      "          wmmmmmmmmmeee           d    ",
      "          wwmmmmmmmmmmeeeee eee  dsd   ",
      "           wmmmmmcmmmmmmeeeeee    d    ",
      "           wwmmmcccmmmmmmmmmmm         ",
      "     d      wwmmmcmmmmmmmmmmm          ",
      "             wwwmmmmmmmmmmmm           ",
      "               wwwmcmmmmmm             ",
      "                 wwwmmmm              d",
    },
  },
  neovim = {
    accent = "#8dc94b",
    colors = { b = "#1fb2ef", B = "#1474c3", t = "#2a7fb8", g = "#4f9f3d", l = "#8dc94b", G = "#5ea732" },
    rows = {
      " tttttt        lllGGGG",
      " btttttt       lllGGGG",
      "bbtttttt       lllGGGG",
      "bbbtttttt      lllGGGG",
      "bbbtttttt      lllGGGG",
      "bbbBtttttt     lllGGGG",
      "bbbBtttttt     lllGGGG",
      "bbbBBtttttt    lllGGGG",
      "bbbBBtttttt    lllGGGG",
      "bbbBBBtttttt   lllGGGG",
      "bbbBBBtttttt   lllGGGG",
      "bbbBBBBtttttt  lllGGGG",
      "bbbBBBBtttttt  lllGGGG",
      "bbbBBBB tttttt lllGGGG",
      "bbbBBBB tttttt lllGGGG",
      "bbbBBBB  gggggglllGGGG",
      "bbbBBBB  gggggglllGGGG",
      "bbbBBBB   ggggggllGGGG",
      "bbbBBBB   ggggggllGGGG",
      "bbbBBBB    gggggglGGGG",
      "bbbBBBB    gggggglGGGG",
      "bbbBBBB     ggggggGGGG",
      "bbbBBBB     ggggggGGGG",
      "bbbBBBB      ggggggGGG",
      "bbbBBBB      ggggggGGG",
      "bbbBBBB       ggggggGG",
      "bbbBBBB       ggggggGG",
      "bbbBBBB        ggggggG",
      "bbbBBBB        gggggg ",
      "bbbBBBB        ggggggG",
    },
  },
  coffee = {
    accent = "#c6a0f6",
    colors = { s = "#7f849c", m = "#c6a0f6", w = "#e2c9ff", k = "#8b6bb8", c = "#6e4a2f", d = "#5b6078" },
    rows = {
      "        s    s    s     ",
      "       s    s    s      ",
      "       s     s    s     ",
      "        s     s    s    ",
      "         s    s   s     ",
      "        s    s   s      ",
      "                        ",
      "   wmmmmmmmmmmmmmmmmk   ",
      "   wccccccccccccccccc   ",
      "   wmmmmmmmmmmmmmmmmkkkk",
      "   wmmmmmmmmmmmmmmmmk  k",
      "   wmmmmmmmmmmmmmmmmk  k",
      "   wmmmmmmmmmmmmmmmmk  k",
      "   wmmmmmmmmmmmmmmmmk  k",
      "   wmmmmmmmmmmmmmmmmkkkk",
      "   wmmmmmmmmmmmmmmmmk   ",
      "    wmmmmmmmmmmmmmmk    ",
      "     kkkkkkkkkkkkkk     ",
      " dddddddddddddddddddddd ",
      "   dddddddddddddddddd   ",
    },
  },
  owl = {
    accent = "#f4c542",
    colors = {
      b = "#8b5e3c", y = "#f4c542", k = "#1e1e2e", w = "#ffffff",
      o = "#f5a97f", l = "#e8cfa6", v = "#a87a52", t = "#5b4636",
    },
    rows = {
      "  bb              bb  ",
      "  bbb            bbb  ",
      "  bbbbbbbbbbbbbbbbbb  ",
      " bbbbbbbbbbbbbbbbbbbb ",
      " bbyyyyybbbbbbyyyyybb ",
      "bbyyyyyyybbbbyyyyyyybb",
      "bbyykkkyybbbbyykkkyybb",
      "bbyykwkyybbbbyykwkyybb",
      "bbyykkkyybbbbyykkkyybb",
      "bbyyyyyyyboobyyyyyyybb",
      " bbyyyyybboobbyyyyybb ",
      " bbbbbbbbbbbbbbbbbbbb ",
      " bbbllllllllllllllbbb ",
      " bbllvlllvllvlllvllbb ",
      "bbbllllllllllllllllbbb",
      "bbblllvllllllllvlllbbb",
      "bbbllllllllllllllllbbb",
      " bbbllvllllllllvllbbb ",
      " bbbllllllllllllllbbb ",
      "  bbbllllllllllllbbb  ",
      "   bbbbbbbbbbbbbbbb   ",
      "    oo oo    oo oo    ",
      "tttttttttttttttttttttt",
      "  tttttttttttttttttt  ",
    },
  },
  cat = {
    accent = "#f5a97f",
    colors = { o = "#f5a97f", O = "#c9784a", w = "#fff6ea", g = "#a6da95", k = "#1e1e2e", p = "#f5bde6" },
    rows = {
      "  o                o  ",
      " ooo              ooo ",
      " opo              opo ",
      " oppo            oppo ",
      " oppoooooo  ooooooppo ",
      "ooooooooooOOoooooooooo",
      "ooooooooooOOoooooooooo",
      "oogggoooooooooooogggoo",
      "oogkgoooooooooooogkgoo",
      "oogkgoooooooooooogkgoo",
      "OooooooooooooooooooooO",
      "ooowwwwwwwppwwwwwwwooo",
      "OoowwwwwwwkkwwwwwwwooO",
      " ooowwwwwkwwkwwwwwooo ",
      "  ooowwwwwwwwwwwwooo  ",
      "   oooooooooooooooo   ",
      "  oooooooooooooooooo  ",
      " oooowwwwwwwwwwwwoooo ",
      " OooowwwwwwwwwwwwoooO ",
      " oooowwwwwwwwwwwwoooo ",
      " oooowwwwwwwwwwwwoooo ",
      " oowwwowwwwwwwwowwwoo ",
    },
  },
  rocket = {
    accent = "#ed8796",
    colors = { w = "#e6e9ef", s = "#a5adcb", r = "#ed8796", R = "#c0606e", b = "#8aadf4", B = "#5b6078", f = "#f5a97f", y = "#eed49f" },
    rows = {
      "         rr         ",
      "        rrrr        ",
      "       rrrrrr       ",
      "      RrrrrrrR      ",
      "      swwwwwws      ",
      "     swwwwwwwws     ",
      "     swwwwwwwws     ",
      "     swwBBBBwws     ",
      "     swBbbbbBws     ",
      "     swBbbbbBws     ",
      "     swwBBBBwws     ",
      "     swwwwwwwws     ",
      "     swwwwwwwws     ",
      "    RswwwwwwwwsR    ",
      "   RrswwRRRRwwsrR   ",
      "  RrrswwRRRRwwsrrR  ",
      "  RrrswwwwwwwwsrrR  ",
      "  Rr  ssssssss  rR  ",
      "       fyyyyf       ",
      "       ffyyff       ",
      "        fyyf        ",
      "         ff         ",
    },
  },
  mushroom = {
    accent = "#ed8796",
    colors = { r = "#ed8796", R = "#b85c6a", w = "#fff6ea", c = "#f4dbd6", C = "#c9a99a", k = "#1e1e2e", p = "#f5bde6", g = "#a6da95", G = "#6f9e5f" },
    rows = {
      "       rrrrrrrr       ",
      "     rrrrrrrrrrrr     ",
      "    rrwwrrrrrrwwrr    ",
      "   rrwwwwrrrrwwwwrr   ",
      "  rrrwwwwrrrrwwwwrrr  ",
      "  rrrrwwrrrrrrwwrrrr  ",
      " rrrrrrrrwwwwrrrrrrrr ",
      " rwwrrrrrwwwwrrrrrwwr ",
      "rwwwwrrrrrrrrrrrrwwwwr",
      "rwwwwrrrrrrrrrrrrwwwwr",
      "RrwwrrrrrrrrrrrrrrwwrR",
      "RRRRRRRRRRRRRRRRRRRRRR",
      "    CccccccccccccC    ",
      "    CckcccccccckcC    ",
      "    CckcccccccckcC    ",
      "    CpccccccccccpC    ",
      "    CccccccccccccC    ",
      "    CccccccccccccC    ",
      "  g CccccccccccccC g  ",
      "gGgGgGgGgGggGgGgGgGgGg",
    },
  },
  mountains = {
    accent = "#8bd5ca",
    colors = { s = "#eff1f5", S = "#b8c0e0", m = "#8087a2", M = "#5b6078", t = "#8bd5ca", T = "#5a9e94", y = "#eed49f", d = "#b7bdf8" },
    rows = {
      "                              yyyy      ",
      "     d                       yyyyyy     ",
      "          s                  yyyyyy     ",
      "         ssS                  yyyy      ",
      "        sssSS        d                  ",
      "       smssSSM                          ",
      "      mmmsmSMMM          s              ",
      "     mmmmmmMMMMM        ssS             ",
      "    mmmmmmmMMMMMM      ssmSS            ",
      "   mmmmmmmmMMMMMMM    smmmMMM           ",
      "  mmmmmmmmmMMMMMMMM  mmmmmMMMM          ",
      " mmmmmmmmmmMMMMMMMMMmmmmmmMMMMM     t   ",
      "mmmmmmmmmmmMMMMMMMMmmmmmmmMMMMMM   ttT  ",
      "mmmmmmmmmmmMMMMMMMmmmmmmmmMMMMMMM  ttT t",
      " t  mmmmmmmMMMMMMmmmmmmmmmMMMMMMMMttttTT",
      "ttT t mmmmmMMMMMmmmmmmmmmmMMMMMMMMttttTT",
      "ttTttTttmmmMMMMttTtt mmmmmMMMMMMtttttttT",
      "tttttttttttttttttttttttttttttttttttttttt",
    },
  },
  fox = {
    accent = "#f5a97f",
    colors = { o = "#f5a97f", O = "#c9784a", w = "#fff6ea", k = "#1e1e2e", n = "#5b3a2e" },
    rows = {
      "n                    n",
      "nn                  nn",
      "oon                noo",
      "owoo              oowo",
      "owwoo            oowwo",
      "oowoooooooooooooooowoo",
      "oooooooooooooooooooooo",
      "oooooooooooooooooooooo",
      "oookkooooooooooookkooo",
      "oookkooooooooooookkooo",
      "woooooooooooooooooooow",
      "wwooooooooooooooooooww",
      "wwwwoooooooooooooowwww",
      " wwwwwoooowwoooowwwww ",
      "  wwwwwwwwwwwwwwwwww  ",
      "   wwwwwwwwwwwwwwww   ",
      "    wwwwwwwwwwwwww    ",
      "     wwwwkkkkwwww     ",
      "      wwwkkkkwww      ",
      "        wwwwww        ",
    },
  },
  cactus = {
    accent = "#a6da95",
    colors = { g = "#a6da95", G = "#6f9e5f", s = "#f4dbd6", p = "#f5bde6", y = "#eed49f", t = "#d9875c", T = "#a8613a" },
    rows = {
      "         pp         ",
      "        pyyp        ",
      "         pp         ",
      "        gggG        ",
      "        gsgG        ",
      "        gggG    gG  ",
      "  gG    gggG   ggG  ",
      "  ggG   gsgG   gsG  ",
      "  gsG   gggG   ggG  ",
      "  ggG   gggG   ggG  ",
      "  ggG   gggG   ggG  ",
      "  gggggggsgG  gggG  ",
      "   ggggggggGgggggG  ",
      "        gggGggGG    ",
      "        gsgG        ",
      "        gggG        ",
      "        gggG        ",
      "     TTTTTTTTTT     ",
      "     ttttttttTT     ",
      "      tttttttT      ",
      "      tttttttT      ",
      "       ttttttT      ",
    },
  },
  bonsai = {
    accent = "#a6da95",
    colors = { l = "#a6da95", L = "#6f9e5f", b = "#a87a52", B = "#6e4a2f", c = "#7dc4e4", C = "#4f8fb0", s = "#5b4636" },
    rows = {
      "         lllll                ",
      "       llllllllL      lll     ",
      "      lllllllllLL   lllllL    ",
      "       lllLLLLLL   llllllLL   ",
      "          bB        lLLLLL    ",
      "   llll    bB         bB      ",
      " lllllllL   bB      bbB       ",
      "lllllllLLL  bbbbbbbbB         ",
      " lLLLLLLL   bbbB              ",
      "     bbB   bbbB               ",
      "       bbbbbbB                ",
      "          bbbB                ",
      "           bbbB               ",
      "           bbbbB              ",
      "          bbbbbB              ",
      "   sssssssssssssssssssssss    ",
      "  CCCCCCCCCCCCCCCCCCCCCCCCC   ",
      "   ccccccccccccccccccccccC    ",
      "    cccccccccccccccccccCC     ",
      "     CC              CC       ",
    },
  },
  alien = {
    accent = "#a6e3a1",
    colors = { g = "#a6e3a1", G = "#5e9e66", k = "#1e1e2e", y = "#eed49f" },
    rows = {
      "      yy                            yy      ",
      "      yy                            yy      ",
      "        gg                        gg        ",
      "        gg                        gg        ",
      "          gg                    gg          ",
      "          gg                    gg          ",
      "        gggggggggggggggggggggggggggg        ",
      "        gggggggggggggggggggggggggggg        ",
      "      gggggggggggggggggggggggggggggggg      ",
      "      gggggggggggggggggggggggggggggggg      ",
      "    ggggkkkkggggggggggggggggggggkkkkgggg    ",
      "    ggggkkkkggggggggggggggggggggkkkkgggg    ",
      "    ggggkkkkggggggggggggggggggggkkkkgggg    ",
      "    ggggkkkkggggggggggggggggggggkkkkgggg    ",
      "  ggggggggggggggggGGGGGGGGgggggggggggggggg  ",
      "  ggggggggggggggggGGGGGGGGgggggggggggggggg  ",
      "gg  gggggggggggggggg    gggggggggggggggg  gg",
      "gg  gggggggggggggggg    gggggggggggggggg  gg",
      "gg  gg            gg    gg            gg  gg",
      "gg  gg            gg    gg            gg  gg",
      "      gggg                        gggg      ",
      "      gggg                        gggg      ",
    },
  },
}
-- stylua: ignore end

M.names = vim.tbl_keys(M.art)
table.sort(M.names)

local defined = {} -- highlight group -> spec, re-applied after :colorscheme clears them

local function hl(top, bottom)
  local name = "InsomniaArt" .. top:sub(2) .. (bottom and bottom:sub(2) or "")
  if not defined[name] then
    defined[name] = { fg = top, bg = bottom }
    vim.api.nvim_set_hl(0, name, defined[name])
  end
  return name
end

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("InsomniaArt", { clear = true }),
  callback = function()
    for name, spec in pairs(defined) do
      vim.api.nvim_set_hl(0, name, spec)
    end
  end,
})

---Render one piece of art as snacks.dashboard text chunks.
---@param name string key of M.art
---@return table[] chunks like { { "▀▀", hl = "..." }, { "\n" }, ... }
function M.render(name)
  local art = M.art[name] or M.art.moon
  local rows, colors = art.rows, art.colors
  local width = 0
  for _, row in ipairs(rows) do
    width = math.max(width, #row)
  end

  local chunks = {}
  local function push(text, group)
    local last = chunks[#chunks]
    if last and last.hl == group and last[1] ~= "\n" then
      last[1] = last[1] .. text -- merge runs of the same colour
    else
      chunks[#chunks + 1] = { text, hl = group }
    end
  end

  for i = 1, #rows, 2 do
    if i > 1 then
      chunks[#chunks + 1] = { "\n" }
    end
    local top, bottom = rows[i], rows[i + 1] or ""
    for col = 1, width do
      local t, b = colors[top:sub(col, col)], colors[bottom:sub(col, col)]
      if t then
        push("▀", hl(t, b))
      elseif b then
        push("▄", hl(b))
      else
        push(" ", nil)
      end
    end
  end
  return chunks
end

return M
