Hacker = {}

-- Creates the new object
function Hacker:new()
  local o = {}
  setmetatable(o, {__index = self})

  o.currentInput = "" -- What is currently being typed
  o.blink = "_" -- Blinks the blinky thingy at the end of the input
  o.time = 0 -- Time spent between blinks
  o.characterCount = 0 -- Limits the number of characters typed to 61
  o.display = {} -- List of already inputted texts and response texts

  o.commands = HackerCommands:new() -- Holds the hacker commands
  o.commands:setDisplay(o.display) -- So HackerCommands has access to the display
  o.previousCommand = "" -- Holds the previous command
  o.secondInput = false -- Used for passwords

  o.currentTerminal = nil

  return o
end

-- Blinky thingy
function Hacker:update(dt)
  self.time = self.time + dt
  if self.time <= 0.5 then -- Blinks on for half a second...
    self.blink = "_"
  elseif self.time <= 1 then -- Blinks off for half a second
    self.blink = ""
  else
    self.time = 0; -- Reset time
  end

  if table.getn(self.display) > 8 then -- Makes sure the command screen doesn't get past 8 commands shown at a time
    for i = 2, table.getn(self.display),1 do
      self.display[i-1] = self.display[i] -- Move all variables down
    end
    self.display[table.getn(self.display)] = nil -- Remove the last element in the table
  end
end

-- Get the input
function Hacker:input(text)
  if self.characterCount <= 61 then -- 61 character limit
    self.currentInput = self.currentInput .. text
    self.characterCount = self.characterCount + 1
  end
end

-- Special cases
function Hacker:keyInput(key)
  if key == "backspace" then -- Delete stuff
    self.currentInput = string.sub(self.currentInput, 0, string.len(self.currentInput) - 1)
    self.characterCount = self.characterCount - 1
  elseif key == "return" then -- Runs the command display
    table.insert(self.display, "> " .. self.currentInput) -- Adds the last thing written to the list
    self:runCommand(self.currentInput) -- Runs the command written
    self.currentInput = "" -- Resets the command prompt
    self.characterCount = 0 -- Resets the character count
  end
end

-- Will run commands using the submitInput variable once we have commands to run
function Hacker:runCommand(text)
  local command = "" -- Command that runs
  local object = "" -- Everything that follows the command
  local prompt = text -- Holds the line of text

  if prompt == "" then -- If no text, do nothing
    return nil
  end

  if secondInput then -- If password needed, ignore the commands
    if previousCommand == "access" then -- If password needed...
      self.commands:password(text)
      secondInput = false
      return nil
    end
  end

  local index = string.find(prompt, " ") -- Finds the first space
  if not (index == nil) then
    command = string.sub(prompt, 1, index-1)
    object = string.sub(prompt, index+1)
  else
    command = prompt -- If there is no space, command becomes the entire line
  end

  if command == "change" or command == "mode" then -- Runs changeMode
    self.commands:changeMode(object)
  elseif command == "access" then -- Runs access
    if self.commands:access(object) then
      previousCommand = "access"
      secondInput = true
    end
  elseif command == "toggle" then
    self.commands:toggleVBox(object)
  elseif command == "quit" then -- Quits. (Why did I add this?)
    table.insert(self.display, "WHY WOULD YOU DO THIS")
    love.event.quit()
  else -- Catch errors
    table.insert(self.display, "ERROR: Command not recognized")
  end
end

function Hacker:setCurrentTerminal(terminal)
  self.currentTerminal = terminal
  self.commands.currentTerminal = terminal
end

-- Draw the stuff
function Hacker:draw()
  love.graphics.setColor(0, 0, 0)
  love.graphics.rectangle("fill", 0, love.graphics.getHeight() / 3 * 2, love.graphics.getWidth(), love.graphics.getHeight() / 3)
  love.graphics.setColor(0,255,0)
  love.graphics.rectangle("fill", 0, love.graphics.getHeight() / 3 * 2, love.graphics.getWidth(), 1)

  love.graphics.setColor(0, 255, 0)
	love.graphics.setFont(hackerFont)
  love.graphics.print("> " .. self.currentInput .. self.blink, 10, love.graphics.getHeight()-25) -- Prints the command line

  local yVal = love.graphics.getHeight() - 45 -- Spaces inbetween previous inputs
  local fade = 255 -- Fades the text into the background
  local numLength = (table.getn(self.display)) -- Length of previous input list
  for i = numLength, 1, -1 do -- Goes through the list backwards
    love.graphics.print(self.display[i], 10, yVal)
    yVal = yVal - 20
    fade = fade - 32
    love.graphics.setColor(0,255,0,fade)
  end

  love.graphics.setColor(255, 255, 255)
  if self.currentTerminal then
    love.graphics.print(self.currentTerminal.terminalName, 10, 10)
  end
end
