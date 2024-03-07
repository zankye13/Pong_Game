push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 -- raket hızı 

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
        resizable = false,
        vsync = true
    })

    -- raketlerin y eksenindeki konumları (sadece yukarı aşağı hareket edebilirler)
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50

    -- topun başlangıç anındaki pozisyonu (x ve y eksenine göre)
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2

    -- topun x eksenindeki hızını belirler 
    ballDX = math.random(2) == 1 and 100 or -100 -- 1 veya 2 değerlerini rastgele olarak seçer

    -- topun y eksenindeki hızını belirler
    -- topun y eksenindeki hareketine bir rastgelelik ekler ve topun farklı açılardan sektirebilmesini sağlar
    ballDY = math.random(-50, 50)

    gameState = 'start'
end

function love.update(dt) -- oyuncuların hareketlerini kontrol eden fonksiyon
    -- 1. oyuncunun hareketleri
    if love.keyboard.isDown('w') then -- klavyeden ilgili tuşun basılıp basılmadığını kontrol eder
        
        -- raketin ekrandan çıkmamasını sağlar
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
        -- player1Y değerini 0 ile VIRTUAL_HEIGHT - 20 arasında sınırlar
        
    
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    -- 2. oyuncunun hareketleri
    if love.keyboard.isDown('up') then
        -- raketin ekrandan çıkmamasını sağlar
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
        -- player2Y değerini 0 ile VIRTUAL_HEIGHT - 20 arasında sınırlar

    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    if gameState == 'play' then -- eğer oyun "play" durumunda ise topun hareketini günceller
        ballX = ballX + ballDX * dt -- topun x konumu güncellenir
        ballY = ballY + ballDY * dt -- topun y konumu güncellenir
    end
end

function love.keypressed(key)
    -- eğer escape tuşuna basılıysa oyundan çıkar
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then -- enter veya return e basılırsa
        if gameState == 'start' then -- oyun durumu "start" ise
            gameState = 'play'-- oyun durumu play olarak değişir
        else -- oyun durumu "start" değilse
            gameState = 'start' -- oyun durumu start olarak değişir
            
            -- topun pozisyonu ekranın ortasına yerleştirilir
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

            -- topun rastgele olarak hızını belirler (x ve y ekseninde)
            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
    end
end 

function love.draw()

    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    -- ekranın arka plan rengini temizler 40 45 52(koyu mavi) ve 255 alfa (tam opaklık)kullanılır

    love.graphics.setFont(smallFont)

    if gameState == 'start' then -- oyun durumu "start ise"
        love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
        -- ekrana "h. start state" yazar

    else -- oyun durumu "start" değilse
        love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
        -- ekrana "h. play state" yazar
    end

    -- sol taraftaki oyuncunun raketi çizilir
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    -- Dikdörtgenin sol üst köşesi (10, player1Y) noktasında, 5 birim genişlikte ve 20 birim yükseklikte bir dikdörtgen çizilir.


    -- sağ taraftaki oyuncunun raketi
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
     -- VIRTUAL_WIDTH - 10, ekranın sağ kenarına yakın bir konumda dikdörtgenin sol üst köşesini temsil eder. 
    -- player2Y, sağ taraftaki oyuncunun paletinin yüksekliğini belirler.

    -- merkeze 4x4 pixel boyutlarında top çizilir
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)

    -- snaal çözünürlükte işlemeyi (render) sonlandırır
    push:apply('end')
end

-- BURADA HENÜZ ÇARPIŞMALAR (COLLISION) OLMADIĞI İÇİN TOPUN RAKETLER İÇERİSİNDEN DOĞRUDAN GEÇTİĞİ GÖZLEMLENİR