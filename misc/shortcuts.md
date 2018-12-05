# VSCODE Shortcut  
* delete left: Option+Delete
* delete right: CTRL+K#
* delete current line: SHIFT-CMD+K
* move by word: Option+ <- or ->
* Select all occurrences of current selection editor.action.selectHighlights CMD+Shift+L
* duplicate current line: SHIFT+OPTION+up/down arrow
* select column: SHIFT+OPTION+CMD+ up/down arrow
* select all before/after cursor: SHIFT+CMD+ up/down arrow
* jump to matching brackets: SHIFT+CMD+\
* add comments: CMD+/
  * ⌘K ⌘C    Add Line Comment    editor.action.addCommentLine
  * ⌘K ⌘U   Remove Line Comment     editor.action.removeCommentLine
* expand select brackets: SHIFT+CTRL+CMD+ left/right arrow
* SHIFT+OPTION+I 在选定的每一行的末尾插入光标 Insert cursor at end of each line selected
* expand line selection: SHIFT+up/down arrow
* insert a new line after: CMD+ENTER
* insert a new line before: SHIFT+CMD+ENTER
* go to method: SHIFT+CMD+O
* retract: cmd+]
* Ctrl+- .. navigate back
* Ctrl+Shift+- .. navigate forward
* Fold folds the innermost uncollapsed region at the cursor: ⌥+⌘+[
* Unfold unfolds the collapsed region at the cursor: ⌥+⌘+] 
* select with regrex: find with regrex, then input option+enter

## VSCODE Setting  
* trim whitespace: Preferences > User Settings add '"files.trimTrailingWhitespace": true'

{
    "http.proxy":"http://127.0.0.1:8888",
    "http.proxyStrictSSL": false,
    "go.gopath": "/Users/luolan/go:/WorkSpace/msgHub",
    "window.zoomLevel": 0,
    "files.trimTrailingWhitespace": true,
    "explorer.confirmDelete": false,
    "window.title": "${activeEditorMedium}${separator}${rootName}",
    "editor.renderWhitespace": "all",
    "explorer.confirmDragAndDrop": false,
}

# Sublime Shortcut  
* delete left: Option+Delete
* Select all occurrences: CTRL+CMD+G
* select line: SHIFT+OPTION+ up/down arrow
* multiple lines selection: select blocks, then SHIFT+CMD+L
* to lowercase: CMD+KU , to uppercase: CMD+KL
* delete current line: SHIFT+CTRL+K
* delete one char right: CTRL+D
* dupicate current line: SHIFT+CMD+D
* redo or repeat: CMD+Y
* autocomplete (repeat to select next suggestion): CTRL+space
* jump to matching brackets: CTRL+m
* select all instances: CTRL+CMD+G


# Firefox  
* duplicate tab:  CTRL+L/CMD+enter

# Mac  
* ctrl+cmd+f : full screen
* button navigation: http://www.idownloadblog.com/2015/03/15/tab-key-between-buttons-mac-os-x/

# iTerm2

⌘+/高亮鼠标
shift+cmd+e 显示命令当前时间
⌘+Option+e全屏展示所有的 tab，可以搜索
⌘+Shift+h弹出历史记录窗口。
⌘+;弹出自动补齐窗口，列出曾经使用过的命令。

Create a file named “multi-sessions.scpt” and copy below content to it.
```
-- Launch iTerm and log into multiple servers using SSH
tell application "iTerm"
	activate
	create window with default profile
	-- Read serverlist from file path below
	set Servers to paragraphs of (do shell script "/bin/cat $HOME/serverlist")
	repeat with nextLine in Servers
		-- If line in file is not empty (blank line) do the rest
		if length of nextLine is greater than 0 then
			-- set server to "nextLine"
			-- set term to (current terminal)
			-- set term to (make new terminal)
			-- Open a new tab
			-- tell term
			tell current window
				create tab with default profile
				tell current session
					write text "ssh dlluolan@" & nextLine
					-- sleep to prevent errors if we spawn too fast
					do shell script "/bin/sleep 0.01"
				end tell
			end tell
		end if
	end repeat
	-- Close the first tab since we do not need it
	-- terminate the first session of the current terminal
	tell first tab of current window
		close
	end tell
end tell
```
Create a file under $HOME/serverlist and insert the ip or hostname list.  
`cp multi-sessions.scpt ~/Library/Application\ Support/iTerm2/Scripts/`  
Go to iterm2 and choose tool `Scripts` and choose the script you will run