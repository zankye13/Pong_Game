push = require 'push'
Class = require 'class'
require 'Paddle'
require 'Ball'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- oyunun her tekrarlanışında topun yönü ve hızı için rastgele değerler üretir. böylece oyunun tekrarlanabilirliği artar
    math.randomseed(os.time())

    -- herhangi bir metin kullanılabilecek küçük yazı tipi nesnesi
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- aktif yazı tipi küçük font nesnesine ayarlanır
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    -- raketler oluşturulur
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- topu ekranın ortasına yerleştirir
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- oyunun farklı bölümleri arasında geçiş yapmak için kullanılan oyun durumu değişkeni
    -- (başlangıç, menüler, ana oyun, yüksek puan listesi vb. için kullanılır)
    -- oluşturma ve güncelleme sırasındaki davranışı belirlemek için bunu kullanacağız
    gameState = 'start'
end

function love.update(dt)
    -- 1. oyuncunun hareketi
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- 2. oyuncunun hareketi
    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    -- oyun "play" durumunda ise topu günceller
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)

    if key == 'escape' then
        love.event.quit()-- esc ile oyundan çıkar

    elseif key == 'enter' or key == 'return' then -- enter ya da return olduğunda
        if gameState == 'start' then -- oyunun mevcut durumunu "start" tan "play" e geçer
            gameState = 'play'
        else
            gameState = 'start' -- oyun "play" durumunda ise "start" durumuna geçer

            -- top resetlenir
            ball:reset()
        end
    end
end

function love.draw()
    -- sanal ççözünürlükte çizime başlar
    push:apply('start')

   -- ekranın arka plan rengini temizler 40 45 52(koyu mavi) ve 255 alfa (tam opaklık)kullanılır
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
    end

    -- oyuncuların raketleri, "paddle" sınıfının "render" metodu çağırılarak çizilir
    player1:render()
    player2:render()

    -- top, "ball" sınıfının "render" metodu çağırılarak çizilir
    ball:render()

    -- sanal çözünürlükteki çizimi sonlandırır
    push:apply('end')
end

-- BURADA TOP RAKETLERE DOĞRU HAREKET ETMEZ VE SADECE ÇAPRAZ BİR ŞEKİLDE YUKARI VEYA AŞAĞI YÖNDE 
-- HAREKET EDER. AYNI ZAMANDA TOP ÇERÇEVENİN AŞAĞI VE YUKARI KISIMLARINDAN SONSUZA DOĞRU GİDER