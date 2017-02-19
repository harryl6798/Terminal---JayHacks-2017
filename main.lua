HC =  require 'HC'
vector = require 'hump.vector'

require 'GameState'
require 'GameStates/SplashScreen'
require 'GameStates/TitleMenu'
require 'GameStates/Level01'

require 'Gamepad'
require 'Hacker'
require 'HackerCommands'
require 'Spy'
require 'Wall'
require 'Terminal'
require 'VBox'
require 'Door'
require 'Trap'

objectFont = love.graphics.setNewFont("cour.ttf", 7)
hackerFont = love.graphics.setNewFont("cour.ttf", 13)

function love.load()
  love.window.setTitle("I wish that I had Jesse\'s Girl")
	love.window.setFullscreen(false)

  --sets up global reference for all objects

  gamepadList = {}
  hackerList = {}
  spyList = {}
  wallList = {}
  terminalList = {}
  vboxList = {}
  doorList = {}
  trapList = {}

  updateableLists = {gamepadList, hackerList, spyList}
  drawableLists = {vboxList, terminalList, spyList, wallList, trapList, doorList, hackerList}

  local joysticks = love.joystick.getJoysticks()
	table.insert(gamepadList, Gamepad:new(joysticks[1]))

	gameTime = 0
  state = GameState:new()

  love.keyboard.setKeyRepeat(true)
end

function love.update(dt)
  gameTime = gameTime + dt

  state:changeState(stateName)
	state:updateState(dt)
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
  if key == "backspace" then
    state:keyInput(key)
  elseif key == "return" then
    state:keyInput(key)
  end
end

function love.textinput(text)
	state:input(text)
end

function love.draw()
  state:draw()
end
