-- https://github.com/jonniek/mpv-filenavigator

local utils = require("mp.utils")
local mpopts = require("mp.options")
local assdraw = require("mp.assdraw")

ON_WINDOWS = (package.config:sub(1,1) ~= "/")
WINDOWS_ROOTDIR = false
WINDOWS_ROOT_DESC = "Select drive"
SEPARATOR_WINDOWS = "\\"

SEPARATOR = "/"

local windows_user = ON_WINDOWS and os.getenv("USERPROFILE"):gsub(SEPARATOR, SEPARATOR_WINDOWS)..SEPARATOR_WINDOWS or nil

local settings = {
  --navigation keybinds override arrowkeys and enter when activating navigation menu, false means keys are always actíve
  dynamic_binds = true,
  navigator_mainkey = "Alt+d", --the key to bring up navigator's menu, can be bound on input.conf aswell

  --dynamic binds, should not be bound in input.conf unless dynamic binds is false
  key_navup = "UP",
  key_navdown = "DOWN",
  key_action = "ENTER",
  key_navclose = "ESC",

  --fallback if no file is open, should be a string that points to a path in your system
  defaultpath = windows_user or os.getenv("HOME") or "~" or "/",
  forcedefault = false, --force navigation to start from defaultpath instead of currently playing file

  --list of paths to ignore. the value is anything that returns true for if-statement.
  --directory ignore entries must end with a trailing slash,
  --but files and all symlinks (even to dirs) must be without slash!
  --to help you with the format, simply run "ls -1p <parent folder>" in a terminal,
  --and you will see if the file/folder to ignore is listed as "file" or "folder/" (trailing slash).
  --you can ignore children without ignoring their parent.
  ignorePaths = {
    --general linux system paths (some are used by macOS too):
    ['/bin/']='1',['/boot/']='1',['/cdrom/']='1',['/dev/']='1',['/etc/']='1',['/lib/']='1',['/lib32/']='1',['/lib64/']='1',['/tmp/']='1',
    ['/srv/']='1',['/sys/']='1',['/snap/']='1',['/root/']='1',['/sbin/']='1',['/proc/']='1',['/opt/']='1',['/usr/']='1',['/run/']='1',
    --useless macOS system paths (some of these standard folders are actually files (symlinks) into /private/ subpaths, hence some repetition):
    ['/cores/']='1',['/etc']='1',['/installer.failurerequests']='1',['/net/']='1',['/private/']='1',['/tmp']='1',['/var']='1'
  },

  compatible_file_extensions = {
    "264","265","3g2","3ga","3ga2","3gp","3gp2","3gpp","3iv","a52","aac","adt","adts","ahn","aif","aifc","aiff","amr","ape","asf","au","avc","avi","awb","ay",
    "bmp","cue","divx","dts","dtshd","dts-hd","dv","dvr","dvr-ms","eac3","evo","evob","f4a","flac","flc","fli","flic","flv","gbs","gif","gxf","gym",
    "h264","h265","hdmov","hdv","hes","hevc","jpeg","jpg","kss","lpcm","m1a","m1v","m2a","m2t","m2ts","m2v","m3u","m3u8","m4a","m4v","mk3d","mka","mkv",
    "mlp","mod","mov","mp1","mp2","mp2v","mp3","mp4","mp4v","mp4v","mpa","mpe","mpeg","mpeg2","mpeg4","mpg","mpg4","mpv","mpv2","mts","mtv","mxf","nsf",
    "nsfe","nsv","nut","oga","ogg","ogm","ogv","ogx","opus","pcm","pls","png","qt","ra","ram","rm","rmvb","sap","snd","spc","spx","svg","thd","thd+ac3",
    "tif","tiff","tod","trp","truehd","true-hd","ts","tsa","tsv","tta","tts","vfw","vgm","vgz","vob","vro","wav","weba","webm","webp","wm","wma","wmv","wtv",
    "wv","x264","x265","xvid","y4m","yuv"
  },

  subtitleformats = {
    'srt', 'ass', 'lrc', 'ssa', 'ttml', 'sbv', 'vtt', 'txt'
  },

  menu_timeout = true,         --menu timeouts and closes itself after navigator_duration seconds, else will be toggled by keybind
  navigator_duration = 13,     --osd duration before the navigator closes, if timeout is set to true
  visible_item_count = 32,     --how many menu items to show per screen

  --font size scales by window, if false requires larger font and padding sizes
  scale_by_window = true,
  --paddings from top left corner
  text_padding_x = 6,
  text_padding_y = 10,
  --ass style overrides inside curly brackets, \keyvalue is one field, extra \ for escape in lua
  --example {\\fnUbuntu\\fs10\\b0\\bord1} equals: font=Ubuntu, size=10, bold=no, border=1
  --read http://docs.aegisub.org/3.2/ASS_Tags/ for reference of tags
  --undeclared tags will use default osd settings
  --these styles will be used for the whole navigator
  style_ass_tags = "{\\fs7\\b0\\bord1}",
  --you can also use the ass tags mentioned above. For example:
  --selection_prefix="{\\c&HFF00FF&}● " - to add a color for selected file. However, if you
  --use ass tags you need to set them for both name and selection prefix (see https://github.com/jonniek/mpv-playlistmanager/issues/20)
  name_prefix = "○ ",
  folder_prefix = "□ ",
  selection_prefix = "● ",
  folder_sel_prefix = "■ ",
  name_col = "{\\1c&HABABAB&}",
  folder_col = "{\\1c&HFCE788&}",
  selection_col = "{\\1c&H669950&}",
}

mpopts.read_options(settings)

--escape a file or directory path for use in shell arguments
function escapepath(dir, escapechar)
  return string.gsub(dir, escapechar, '\\'..escapechar)
end

local sub_lookup = {}
for _, ext in ipairs(settings.subtitleformats) do
  sub_lookup[ext] = true
end


--ensures directories never accidentally end in "//" due to our added slash
function stripdoubleslash(dir)
  if (string.sub(dir, -2) == "//") then
    return string.sub(dir, 1, -2) --negative 2 removes the last character
  else
    return dir
  end
end

function os.capture(cmd, raw)
  local f = assert(io.popen(cmd, 'r'))
  local s = assert(f:read('*a'))
  f:close()
  return string.sub(s, 0, -2)
end

local first_use = true
local first_dir = ""
dir = nil
path = nil
cursor = 0
last_cursor = 0
length = 0
--osd handler that displays your navigation and information
function handler()
  add_keybinds()
  timer:kill()
  local ass = assdraw.ass_new()
  ass:new_event()
  ass:pos(settings.text_padding_x, settings.text_padding_y)
  ass:append(settings.style_ass_tags)

  if not path then
    if mp.get_property('path') and not settings.forcedefault then
      if first_use then 
        first_dir = mp.get_property("working-directory") 
        first_use = false
      end
      --determine path from currently playing file...
      local workingdir = mp.get_property("working-directory")
      local playfilename = mp.get_property("filename") --just the filename, without path
      local playpath = mp.get_property("path") --can be relative or absolute depending on what args mpv was given
      local firstchar = string.sub(playpath, 1, 1)
      --first we need to remove the filename (may give us empty path if mpv was started in same dir as file)
      path = string.sub(playpath, 1, string.len(playpath)-string.len(playfilename))
      if (firstchar ~= "/" and not ON_WINDOWS) then --the path of the playing file wasn't absolute, so we need to add mpv's working dir to it
        path = workingdir.."/"..path
      end
      --now resolve that path (to resolve things like "/home/anon/Movies/../Movies/foo.mkv")
      path = resolvedir(path)
      --lastly, check if the folder exists, and if not then fall back to the current mpv working dir
      if (not isfolder(path)) then
        if ON_WINDOWS then
          path = workingdir..SEPARATOR_WINDOWS
        else
          path = workingdir
        end
      end
    else path = settings.defaultpath end
    dir,length = scandirectory(path)
  end

  if first_dir == string.sub(path, 1, -2) then ass:append("{\\u1}"..path.."\\N\\N{\\u0}")
  else ass:append(settings.folder_col.."{\\u1}"..path.."\\N\\N{\\u0}") end
  
  local b = cursor - math.floor(settings.visible_item_count / 2)
  if b > 0 then ass:append("...\\N") end
  if b < 0 then b=0 end
  for a=b,(b+settings.visible_item_count),1 do
    if a==length then break end
    local prefix = settings.name_prefix
    local ass_col = settings.name_col
    if isfolder(dir[a]) then 
      prefix = (a == cursor and settings.folder_sel_prefix or settings.folder_prefix)
      ass_col = (a == cursor and settings.selection_col or settings.folder_col)
    else
      prefix = (a == cursor and settings.selection_prefix or settings.name_prefix)
      ass_col = (a == cursor and settings.selection_col or settings.name_col)
    end
    ass:append(ass_col)
    ass:append(prefix.. dir[a].."\\N")
    if a == (b+settings.visible_item_count) then
      ass:append(settings.name_col)
      ass:append("...")
    end
  end
  local w, h = mp.get_osd_size()
  if settings.scale_by_window then w,h = 0, 0 end
  mp.command("")
  mp.set_osd_ass(w, h, ass.text)
  if settings.menu_timeout then
    timer:resume()
  end
end

function navdown()
  if cursor~=length-1 then
    cursor = cursor+1
  else
    cursor = 0
  end
  handler()
end

function navup()
  if cursor~=0 then
    cursor = cursor-1
  else
    cursor = length-1
  end
  handler()
end

function action()
  if isfolder(dir[cursor]) then childdir()
  else opendir() end
end

--moves into selected directory
function childdir()
  local item = dir[cursor]

  -- windows only
  if ON_WINDOWS then
    if WINDOWS_ROOTDIR then
      WINDOWS_ROOTDIR = false
    end
    if item then
      local newdir = utils.join_path(path, item):gsub(SEPARATOR, SEPARATOR_WINDOWS)..SEPARATOR_WINDOWS
      local info, error = utils.file_info(newdir)

      if info and info.is_dir then
        last_cursor = cursor
        cursor = 0
        changepath(newdir)
      elseif issubtitle(item) then
        loadsubs(utils.join_path(path, item))
      end
      handler()
    end

    return
  end

  if item then
    if isfolder(utils.join_path(path, item)) then
      local newdir = stripdoubleslash(utils.join_path(path, dir[cursor].."/"))
      last_cursor = cursor
      cursor = 0
      changepath(newdir)
    elseif issubtitle(item) then
      loadsubs(utils.join_path(path, item))
    end
    handler()
  end
end

function issubtitle(file)
  local ext = file:match("^.+%.(.+)$")
  return ext and sub_lookup[ext:lower()]
end

function loadsubs(file)
  mp.commandv("sub_add", file)
  mp.osd_message("Loaded subtitle: "..file)
end

--replace current playlist with directory or file
--if directory, mpv will recursively queue all items found in the directory and its subfolders
function opendir()
  local item = dir[cursor]

  if item then
    remove_keybinds()

    local filepath = utils.join_path(path, item)
    if ON_WINDOWS then
      filepath = filepath:gsub(SEPARATOR, SEPARATOR_WINDOWS)
    end

    if issubtitle(item) then
      return loadsubs(filepath)
    end

    mp.commandv("loadfile", filepath, "replace")
  end
end

--changes the directory to the path in argument
function changepath(args)
  path = args
  if WINDOWS_ROOTDIR then
    path = WINDOWS_ROOT_DESC
  end
  dir,length = scandirectory(path)
  handler()
end

--move up to the parent directory
function parentdir()
  -- windows only
  if ON_WINDOWS then
    if path:sub(-1) == SEPARATOR_WINDOWS then
      path = path:sub(1, -2)
    end
    local parent = utils.split_path(path)
    if path == parent then
      WINDOWS_ROOTDIR = true
    end
    cursor = last_cursor
    changepath(parent)
    return
  end

  --if path doesn't exist or can't be entered, this returns "/" (root of the drive) as the parent
  local parent = stripdoubleslash(os.capture('cd "'..escapepath(path, '"')..'" 2>/dev/null && cd .. 2>/dev/null && pwd').."/")

  cursor = last_cursor
  changepath(parent)
end

--resolves relative paths such as "/home/foo/../foo/Music" (to "/home/foo/Music") if the folder exists!
function resolvedir(dir)
  local safedir = escapepath(dir, '"')

  -- windows only
  if ON_WINDOWS then
    local resolved = stripdoubleslash(os.capture('cd /d "'..safedir..'" && cd'))
    return resolved..SEPARATOR_WINDOWS
  end

  --if dir doesn't exist or can't be entered, this returns "/" (root of the drive) as the resolved path
  local resolved = stripdoubleslash(os.capture('cd "'..safedir..'" 2>/dev/null && pwd').."/")
  return resolved
end

--true if path exists and is a folder, otherwise false
function isfolder(dir)
  -- windows only
  if ON_WINDOWS then
    local info, error = utils.file_info(dir)
    return info and info.is_dir or nil
  end

  local lua51returncode, _, lua52returncode = os.execute('test -d "'..escapepath(dir, '"')..'"')
  return lua51returncode == 0 or lua52returncode == 0
end

function scandirectory(searchdir)
  local directory = {}
  --list all files, using universal utilities and flags available on both Linux and macOS
  --  ls: -1 = list one file per line, -p = append "/" indicator to the end of directory names, -v = display in natural order
  --  stderr messages are ignored by sending them to /dev/null
  --  hidden files ("." prefix) are skipped, since they exist everywhere and never contain media
  --  if we cannot list the contents (due to no permissions, etc), this returns an empty list

  -- windows only
  if ON_WINDOWS then
    -- handle drive letters
    if WINDOWS_ROOTDIR then
      local popen, err = io.popen("wmic logicaldisk get caption")
      local i = 0
      if popen then
        for direntry in popen:lines() do
          -- only single letter followed by colon (:) are valid
          if string.find(direntry, "^%a:") then
            direntry = string.sub(direntry, 1, 2)
            local compatible = false
            for k,pattern in pairs(settings.compatible_file_extensions) do
              if direntry:find('.'..pattern) or isfolder(direntry) then
                compatible = true
                break --don't waste time scanning further patterns
              end
            end
            if compatible and not settings.ignorePaths[path..direntry] then
              directory[i] = direntry
              i=i+1
            end
          end
        end
        popen:close()
      else
        mp.msg.error("Could not scan for files :"..(err or ""))
      end

      return directory, i
    end

    local i = 0
    local files = utils.readdir(searchdir)

    if not files then
      mp.msg.error("Could not scan for files :"..(err or ""))
      return directory, i
    end

    for _, direntry in ipairs(files) do
      local compatible = false
      for k,pattern in pairs(settings.compatible_file_extensions) do
        if direntry:find('.'..pattern) or isfolder(direntry) and not direntry:match('.*') then
          compatible = true
          break --don't waste time scanning further patterns
        end
      end
      if compatible and not settings.ignorePaths[path..direntry] then
        directory[i] = direntry
        i=i+1
      end
    end

    return directory, i
  end

  local popen, err = io.popen('ls -1vp "'..escapepath(searchdir, '"')..'" 2>/dev/null')
  local i = 0
  if popen then
    for direntry in popen:lines() do
      local compatible = false
      for k,pattern in pairs(settings.compatible_file_extensions) do
        if direntry:find('.'..pattern) or isfolder(direntry) and not direntry:match('.*') then
          compatible = true
          break --don't waste time scanning further patterns
        end
      end
      if compatible and not settings.ignorePaths[path..direntry] then
        directory[i] = direntry
        i=i+1
      end
    end
    popen:close()
  else
    mp.msg.error("Could not scan for files :"..(err or ""))
  end
  return directory, i
end

function nothin() end

function add_keybinds()
  mp.add_forced_key_binding(settings.key_navdown, "navdown", navdown, "repeatable")
  mp.add_forced_key_binding(settings.key_navup, "navup", navup, "repeatable")
  mp.add_forced_key_binding(settings.key_action, "navdo", action)
  mp.add_forced_key_binding(settings.key_navclose, "navclose", remove_keybinds)
end

function remove_keybinds()
  timer:kill()
  mp.set_osd_ass(0, 0, "")
  if settings.dynamic_binds then
    mp.remove_key_binding('navdown')
    mp.remove_key_binding('navup')
    mp.remove_key_binding('navdo')
    mp.remove_key_binding('navclose')
  end
end

timer = mp.add_periodic_timer(settings.navigator_duration, remove_keybinds)
timer:kill()

if not settings.dynamic_binds then
  add_keybinds()
end

active=false
function activate()
  if settings.menu_timeout then
    handler()
  else
    if active then
      remove_keybinds()
      active=false
    else
      handler()
      active=true
    end
  end
end

mp.add_forced_key_binding(settings.navigator_mainkey, "navigator", activate)