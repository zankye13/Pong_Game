push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
-- pencere boyutları

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
-- sanal pencere boyutları

function love.load() -- oyun yüklenir
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf',8)
    
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.keypressed(key) -- klavye girişleri işlenir

    if key == 'escape' then -- basılan tuş escape ise...
      
        love.event.quit() -- bu işlev bir tuşa basıldığında oyunu kapatır
    end
end

function love.draw()
    
    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    -- ekranın arka plan rengini temizler 40 45 52(koyu mavi) ve 255 alfa (tam opaklık)kullanılır

    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')

    -- sol taraftaki oyuncunun (10,30) koordinatlarına ve 5x20 pixel boyutlarına sahip raketi
    love.graphics.rectangle('fill', 10, 30, 5, 20)

    -- sağ taraftaki oyuncunun raketi
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 50, 5, 20)

    -- oyun penceresinin tam ortasındaki top çizilir. Boyutu 4x4 pixeldir
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    push:apply('end')
end    