--[[
Bloxstrap: Executor Edition

Initiate.lua -> Starts the script, and enabled FFlags and modifications.

Credits:
-> qwertyui: main dev
]]--

export type section = {} --> qwerty doesnt know how to use typescript :pensive:
export type textbox = {}
export type dropdown = {}
export type toggle = {}
local Bloxstrap: table = loadfile("Bloxstrap/Main/Bloxstrap.lua")() --> Loars all the functions required to use Bloxstrap
Bloxstrap.start() --> Begins the actual script