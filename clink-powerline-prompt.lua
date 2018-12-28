local function executeCommand(command)
    local output = nil
    local p = io.popen(command .. ' 2>nul')
    if (p ~= nil) then
        output = p:read('*all')
    end
    p.close()
    return output
end

local function setBackgroundColor(colorName)
    local colors = {
        BLACK = 40,
        RED = 41,
        GREEN = 42,
        YELLOW = 43,
        BLUE = 44,
        MAGENTA = 45,
        CYAN = 46,
        WHITE = 47,
        BRIGHT_BLACK = 100,
        BRIGHT_RED = 101,
        BRIGHT_GREEN = 102,
        BRIGHT_YELLOW = 103,
        BRIGHT_BLUE = 104,
        BRIGHT_MAGENTA = 105,
        BRIGHT_CYAN = 106,
        BRIGHT_WHITE = 107
    }
    return '\x1b[' .. colors[colorName] .. 'm'
end

local function setForegroundColor(colorName)
    local colors = {
        BLACK = 30,
        RED = 31,
        GREEN = 32,
        YELLOW = 33,
        BLUE = 34,
        MAGENTA = 35,
        CYAN = 36,
        WHITE = 37,
        BRIGHT_BLACK = 90,
        BRIGHT_RED = 91,
        BRIGHT_GREEN = 92,
        BRIGHT_YELLOW = 93,
        BRIGHT_BLUE = 94,
        BRIGHT_MAGENTA = 95,
        BRIGHT_CYAN = 96,
        BRIGHT_WHITE = 97
    }
    return '\x1b[' .. colors[colorName] .. 'm'
end

local function resetColor()
    return '\x1b[0m'
end

local function insertSegmentSeparator(previousColor, nextColor)
    local separator = clink.get_env('POWERLINE_SEGMENT_SEPARATOR') or ''
    return setForegroundColor(previousColor) .. setBackgroundColor(nextColor) .. separator
end

local function insertInnerSeparator(color)
    local separator = clink.get_env('POWERLINE_INNER_SEPARATOR') or ''
    if (color == nil) then
        return separator
    end
    return setForegroundColor(color) .. separator
end

local segments = {}

function segments.clock()
    local background = clink.get_env('POWERLINE_CLOCK_BG') or 'WHITE'
    local foreground = clink.get_env('POWERLINE_CLOCK_FG') or 'BLACK'

    return function()
        local segment = {}
        segment.background = background
        segment.content = setForegroundColor(foreground) .. os.date('%X')
        return segment
    end
end

function segments.path()
    local iconDrive = clink.get_env('POWERLINE_ICON_DRIVE') or ''
    local iconHome = clink.get_env('POWERLINE_ICON_HOME') or ''
    local background = clink.get_env('POWERLINE_PATH_BG') or 'BLUE'
    local foreground = clink.get_env('POWERLINE_PATH_FG') or 'WHITE'

    return function()
        local segment = {}
        segment.background = background
        segment.content = setForegroundColor(foreground)
        local home = clink.get_env('USERPROFILE')
        local cwd = clink.get_cwd()
        if (cwd:find(home) == 1) then
            segment.content = segment.content .. iconHome .. ' ' .. clink.get_env('USERNAME')
            if (#cwd > #home) then
                cwd:sub(#home + 2):gsub(
                    '[^\\]+',
                    function(s)
                        segment.content = segment.content .. ' ' .. insertInnerSeparator() .. ' ' .. s
                    end
                )
            end
        else
            segment.content = segment.content .. iconDrive .. ' ' .. cwd:sub(1, 2)
            cwd:sub(4):gsub(
                '[^\\]+',
                function(s)
                    segment.content = segment.content .. ' ' .. insertInnerSeparator() .. ' ' .. s
                end
            )
        end
        return segment
    end
end

function segments.git()
    local iconBranch = clink.get_env('POWERLINE_ICON_BRANCH') or ''
    local iconCommit = clink.get_env('POWERLINE_ICON_COMMIT') or 'ﰖ'

    local iconClean = clink.get_env('POWERLINE_ICON_CLEAN') or ''
    local iconCleanColor = clink.get_env('POWERLINE_GIT_ICON_CLEAN_COLOR') or 'GREEN'

    local iconStaged = clink.get_env('POWERLINE_ICON_STAGED') or ''
    local iconStagedColor = clink.get_env('POWERLINE_GIT_ICON_STAGED_COLOR') or 'BLUE'

    local iconUnstaged = clink.get_env('POWERLINE_ICON_UNSTAGED') or ''
    local iconUnstagedColor = clink.get_env('POWERLINE_GIT_ICON_UNSTAGED_COLOR') or 'YELLOW'

    local iconUnmerged = clink.get_env('POWERLINE_ICON_UNMERGED') or ''
    local iconUnmergedColor = clink.get_env('POWERLINE_GIT_ICON_UNMERGED_COLOR') or 'RED'

    local iconUntracked = clink.get_env('POWERLINE_ICON_UNTRACKED') or ''
    local iconUntrackedColor = clink.get_env('POWERLINE_GIT_ICON_UNTRACKED_COLOR') or 'MAGENTA'

    local background = clink.get_env('POWERLINE_GIT_BG') or 'WHITE'
    local foreground = clink.get_env('POWERLINE_GIT_FG') or 'BLACK'

    local getParent = function(path)
        local i = path:find('[\\/][^\\/]*$')
        if (i ~= nil) then
            return path:sub(1, i - 1)
        end
    end

    local isRepository = function(path)
        repeat
            if (clink.is_dir(path .. '\\.git')) then
                return true
            end
            path = getParent(path)
        until (path == nil)
        return false
    end

    local getInfo = function()
        local status = executeCommand('git status')
        local info = {}
        if (status:find('On branch') ~= nil) then
            info.branch = iconBranch .. ' ' .. status:sub(1, status:find('\n') - 1):sub(11)
        elseif (status:find('HEAD detached from') ~= nil) then
            info.branch = iconCommit .. ' ' .. executeCommand('git rev-parse HEAD'):sub(1, 7)
        elseif (status:find('HEAD detached at') ~= nil) then
            info.branch = iconCommit .. ' ' .. status:sub(1, status:find('\n') - 1):sub(18)
        else
            return nil
        end
        info.hasStagedChanges = status:find('Changes to be committed') ~= nil
        info.hasUnstagedChanges = status:find('Changes not staged for commit') ~= nil
        info.hasUntrackedFiles = status:find('Untracked files') ~= nil
        info.hasUnmergedPaths = status:find('Unmerged paths') ~= nil
        info.isClean = not (info.hasStagedChanges or info.hasUnstagedChanges or info.hasUntrackedFiles or info.hasUnmergedPaths)
        return info
    end

    return function()
        if (isRepository(clink.get_cwd())) then
            local segment = {}
            local info = getInfo()
            if (info == nil) then
                return nil
            end
            segment.background = background
            segment.content = setForegroundColor(foreground) .. info.branch
            if (info.isClean) then
                segment.content = segment.content .. ' ' .. setForegroundColor(iconCleanColor) .. iconClean
            else
                if (info.hasStagedChanges) then
                    segment.content = segment.content .. ' ' .. setForegroundColor(iconStagedColor) .. iconStaged
                end
                if (info.hasUnstagedChanges) then
                    segment.content = segment.content .. ' ' .. setForegroundColor(iconUnstagedColor) .. iconUnstaged
                end
                if (info.hasUnmergedPaths) then
                    segment.content = segment.content .. ' ' .. setForegroundColor(iconUnmergedColor) .. iconUnmerged
                end
                if (info.hasUntrackedFiles) then
                    segment.content = segment.content .. ' ' .. setForegroundColor(iconUntrackedColor) .. iconUntracked
                end
            end
            return segment
        end
    end
end

function segments.readonly()
    local iconReadOnly = clink.get_env('POWERLINE_ICON_READONLY') or ''
    local background = clink.get_env('POWERLINE_READONLY_BG') or 'RED'
    local foreground = clink.get_env('POWERLINE_READONLY_FG') or 'WHITE'

    local checkWritable = function(path)
        math.randomseed(os.time())
        local testfile = path .. '\\' .. math.random(10000000, 99999999) .. '.tmp'
        local file = io.open(testfile, 'a')
        if (file == nil) then
            return false
        end
        file:close()
        os.remove(testfile)
        return true
    end

    return function()
        if (not checkWritable(clink.get_cwd())) then
            local segment = {}
            segment.background = background
            segment.content = setForegroundColor(foreground) .. iconReadOnly
            return segment
        end
    end
end

function segments.tail()
    local adminPromptCharColor = clink.get_env('POWERLINE_ADMIN_PROMPT_CHAR_COLOR') or 'BRIGHT_YELLOW'
    local adminPromptChar = clink.get_env('POWERLINE_ADMIN_PROMPT_CHAR') or '#'
    local promptChar = clink.get_env('POWERLINE_PROMPT_CHAR') or '$'
    local promptCharColor = clink.get_env('POWERLINE_PROMPT_CHAR_COLOR') or 'BRIGHT_GREEN'

    local isAdmin = false
    if (executeCommand('dir /b %windir%\\system32\\config\\sam'):find('SAM') == 1) then
        isAdmin = true
    end

    return function()
        local segment = {}
        segment.background = 'BLACK'
        if (isAdmin) then
            segment.content = '\r\n' .. setForegroundColor(adminPromptCharColor) .. adminPromptChar .. resetColor()
        else
            segment.content = '\r\n' .. setForegroundColor(promptCharColor) .. promptChar .. resetColor()
        end
        return segment
    end
end

local function init()
    local order = clink.get_env('POWERLINE_PROMPT_ORDER') or 'clock path git readonly tail'
    local list = {}
    order:gsub(
        '[^ ]+',
        function(s)
            table.insert(list, segments[s]())
        end
    )
    return list
end

local function render(list)
    local result = ''
    local previousColor = nil
    for i = 1, #list do
        local segment = list[i]()
        if (segment ~= nil) then
            if (previousColor ~= nil) then
                result = result .. insertSegmentSeparator(previousColor, segment.background)
            else
                result = result .. setBackgroundColor(segment.background)
            end
            result = result .. ' ' .. segment.content .. ' '
            previousColor = segment.background
        end
    end
    return result
end

local list = init()

local function apply()
    clink.prompt.value = render(list)
end

clink.prompt.register_filter(apply, 99)
