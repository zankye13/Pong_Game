push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
-- pencere boyutları

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
-- sanal pencere boyutları

function love.load() -- oyun yüklenir
    love.graphics.setDefaultFilter('nearest', 'nearest')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end
-- bu fonksiyonda sanal ekran boyutları ve pencerenin gerçek boyutları temsil edilir ve bunların yanında ek ayarlar belirlenir

function love.keypressed(key) -- klavye girişleri işlenir

    if key == 'escape' then -- basılan tuş escape ise...
      
        love.event.quit() -- bu işlev bir tuşa basıldığında oyunu kapatır
    end
end

function love.draw() -- oyun çizilir
    push:apply('start') -- push kütüphanesi kullanılarak çizim başlatılır

    love.graphics.printf('Hello Pong!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center') -- ekranın ortasına yazar

    push:apply('end') -- çizimi sonlandırır
end
