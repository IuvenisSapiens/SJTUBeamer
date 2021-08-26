#!/usr/bin/env texlua

-- Windows MikTeX still have l3build bug!
-- Use ubuntu to compile.
-- https://github.com/latex3/l3build/issues/185
-- The fix has not been released yet.

module           = "sjtubeamer"

sourcefiledir    = "source"
sourcefiles      = {"*.ins","*.dtx","*logo.pdf","sjtubadge.pdf","sjtubg.pdf","sjtubg.png","sjtuphoto.jpg"}
installfiles     = {"*.sty","*logo.pdf","sjtubadge.pdf","sjtubg.pdf","sjtubg.png","sjtuphoto.jpg"}

docfiledir       = "doc"
typesetexe       = "xelatex"
-- typesetfiles     = {"sjtubeamermintheme.tex","sjtubeamermindevguide.tex"}
typesetfiles     = {}
-- typesetruns      = 1 -- for debug. Some reference may not be linked.
typesetdemofiles = {"main.tex","min.tex","cover-*.tex"}
-- typesetdemofiles = {"cover.tex"} -- for debug
typesetsuppfiles = {"head.png","plant.jpg","test.csv","testgraph.tex","ref.bib","contents/"}

packtdszip       = true -- recommended for "tree" layouts

tagfiles = {"*.dtx","README.md","*.ins","sjtubeamermintheme.tex","sjtubeamermindevguide.tex"}

-- Detail how to set the version automatically
function update_tag(file,content,tagname,tagdate)
    local iso = "%d%d%d%d%/%d%d%/%d%d"
    if string.match(content,"%(C%)%s*[%d%-,]+") then
        local year = os.date("%Y")
        content = string.gsub(content,
            "%(C%)%s*([%d%-,]+)",
            "(C) %1," .. year)
        content = string.gsub(content,year .. "," .. year,year)
        content = string.gsub(content,
        "%-" .. math.tointeger(year - 1) .. "," .. year,
        "-" .. year)
        content = string.gsub(content,
        math.tointeger(year - 2) .. "," .. math.tointeger(year - 1) .. "," .. year,
        math.tointeger(year - 2) .. "-" .. year)
    end
    local now = os.date("%Y/%m/%d")
    if string.match(file,"%.dtx$") then
        content = string.gsub(content,
            "\n\\ProvidesPackage" .. "({%w+})%[" .. iso .. "([^%]]+) v%d%.%d%.%d]",
            "\n\\ProvidesPackage%1[" .. now .. "%2 " .. tagname .. "]")
        return content
    elseif string.match(file,"%.tex$") then
        return string.gsub(content,
            "\n\\date%{%d%.%d ([^%}]+)%}\n",
            "\n\\date{" .. tagname .. " %1}\n")
    end
    return content
end