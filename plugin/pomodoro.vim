" plugin/pomodoro.vim
" Author:   Maximilian Nickel <max@inmachina.com>
" License:  MIT License 
"
" Vim plugin for the Pomodoro time management technique. 
"
" Commands:
" 	:PomodoroStart [name] 	- 	Start a new pomodoro. [name] is optional.
"
" Configuration: 
" 	g:pomodoro_time_work 	-	Duration of a pomodoro 
" 	g:pomodoro_time_slack 	- 	Duration of a break 
" 	g:pomodoro_log_file 	- 	Path to log file

if &cp || exists("g:pomodoro_loaded") && g:pomodoro_loaded
  finish
endif

let g:pomodoro_loaded = 1
let g:pomodoro_started = 0
let g:pomodoro_started_at = -1 

if !exists('g:pomodoro_time_work')
  let g:pomodoro_time_work = 25
endif
if !exists('g:pomodoro_time_slack')
  let g:pomodoro_time_slack = 5
endif

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=* PomodoroStart call s:PomodoroStart(<q-args>)
command! PomodoroStatus echo PomodoroStatus()
nmap <F7> <ESC>:PomodoroStart<CR>

function! PomodoroStatus()
	if g:pomodoro_started == 0
		return "Pomodoro inactive"
	elseif g:pomodoro_started == 1
		return "Pomodoro started (remaining: " . pomodorocommands#remaining_time() . " minutes)"
	elseif g:pomodoro_started == 2
		return "Pomodoro break started"
	endif
endfunction

function! s:PomodoroStart(name)
	if g:pomodoro_started != 1
		if a:name == ''
			let name = '(unnamed)'
		else 
			let name = a:name
		endif
    let tempTimer = timer_start(g:pomodoro_time_work * 60 * 1000, function('pomodorohandlers#pause', [name]))
		let g:pomodoro_started_at = localtime()
		let g:pomodoro_started = 1 
    echom "Pomodoro Started at: " . strftime('%I:%M:%S %d/%m/%Y')
	endif
endfunction
