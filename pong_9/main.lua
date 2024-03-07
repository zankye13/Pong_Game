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

    -- açılan oyun penceresinin ismi yazılır
    love.window.setTitle('Pong')
    
    -- oyunun her tekrarlanışında topun yönü ve hızı için rastgele değerler üretir. böylece oyunun tekrarlanabilirliği artar
    math.randomseed(os.time())

    -- herhangi bir metin kullanılabilecek küçük yazı tipi nesnesi
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- skor tablosu daha büyük bir fontla ekrana yazılır
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- aktif yazı tipi küçük font nesnesine ayarlanır
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- başlangıçta oyuncuların skoru 0 olarak ayarlanır
    player1Score = 0
    player2Score = 0

    -- kim sayı aldıysa o servis atar
    -- servingPlayer son sayıyı alan oyuncuyu ifade eder
    servingPlayer = 1

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

    -- oyunun mevcut durumu serve ise
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50) -- dikey hız rastgele ayarlanır
        if servingPlayer == 1 then -- servis yapan oyuncu; 1. oyuncu ise yatay hız sağa doğru rastgele bir aralıkta ayarlanır
            ball.dx = math.random(140, 200)
        else -- servis yapan oyuncu ; 2. oyuncu ise yatay hız sola doğru rastgele bir aralıkta ayarlanır 
            ball.dx = -math.random(140, 200)
        end

    elseif gameState == 'play' then -- oyunun mevcut durumu "play" ise

        -- 1. oyuncu için çarpışmalar
        if ball:collides(player1) then 
            ball.dx = -ball.dx * 1.03 -- topun yatay hızı tersine çevrilip (çünkü duvarlarla çarpışma gerçekleştiğinde ters yönde gitmesi gerekir) hızı arttırır
            ball.x = player1.x + 5 -- topun pozisyonunu oyuncu 1'in raketinin hemen yanına yerleştir (reketle çarpışma gerçekleşiyor)

            
            if ball.dy < 0 then -- top oyun penceresinin üst çerçevesine çarparsa
                ball.dy = -math.random(10, 150) -- topun dikey hızı rastgele negatif bir değere ayarlanır
            else -- top oyun penceresinin alt çerçevesine çarparsa
                ball.dy = math.random(10, 150) -- topun dikey hızı rastgele pozitif bir değere ayarlanır
            end
        end

        -- 2. oyuncu için çarpışmalar
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        -- topun ekranın üst tarafına çarptığı durumu kontrol eder
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
        end
        
        -- topun ekranın alt tarafına çarptığı durumu kontrol eder
        if ball.y >= VIRTUAL_HEIGHT - 4 then 
            ball.y = VIRTUAL_HEIGHT -4
            ball.dy = -ball.dy -- topun hızının zıttı atanarak yönünün değişmesi sağlanır
        end
    end

    -- eğer topun x eksenindeki değeri 0 dan küçükse (ekranın sol tarafından sonsuza gittiyse)
    if ball.x < 0 then
        servingPlayer = 1 
        player2Score = player2Score + 1 -- 2. oyuncu sayı almış olur
        ball:reset() -- sayı alındıktan sonra top tekrardan eski konumuna döner
        gameState = 'serve' -- oyunun mecvut durumu servis e ayarlanır
    end
    
    -- eğer topun x eksenindeki değeri sanal genişlikten büyükse (ekranın sağ tarafından sonsuza gitti::yse)
    if ball.x > VIRTUAL_WIDTH then
        servingPlayer = 2 
        player1Score = player1Score + 1  -- bu durumda 1. oyuncu sayı almış olur
        ball:reset()
        gameState = 'serve' 
    end    

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
        if gameState == 'start' then -- oyunun mevcut durumunu "start" tan "servis" e geçer
            gameState = 'serve'
        elseif gameState == 'serve' then -- oyun "servis" durumunda ise "play" durumuna geçer
            gameState = 'play'
        end
    end
end

function love.draw()
    -- sanal çözünürlükte çizime başlar
    push:apply('start')

   -- ekranın arka plan rengini temizler 40 45 52(koyu mavi) ve 255 alfa (tam opaklık)kullanılır
    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    love.graphics.setFont(smallFont)

    displayScore()

    -- oyunun mevcut durumu "start" ise
    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    
    -- oyunun mevcut durumu "servis" ise    
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. tostring(servingPlayer) .. "'s serve!", -- servis atan oyuncunun kim olduğuna göre ekrana yazdırılır 
            0, 10, VIRTUAL_WIDTH, 'center')

        -- ekrana "servis atmak için enter a tıklayın" yazar    
        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'play' then
    end

    -- oyuncuların raketleri, "paddle" sınıfının "render" metodu çağırılarak çizilir
    player1:render()
    player2:render()

    -- top, "ball" sınıfının "render" metodu çağırılarak çizilir
    ball:render()

    -- ekrana fps i yazdırır
    displayFPS()

    -- sanal çözünürlükteki çizimi sonlandırır
    push:apply('end')
end

-- ekranda fps i gösterir
function displayFPS()
    
    love.graphics.setFont(smallFont) -- yazı tipi küçük font olarak ayarlanır
    love.graphics.setColor(0, 255/255, 0, 255/255) -- yazı rengi yeşil olarak ayarlanır
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
    -- love.timer.getFPS() fonksiyonu, oyunun mevcut FPS (saniyedeki kare sayısı) değerini döndürür
    -- güncel fps değerini eklemek için tostring işlemi uygulanır
end

-- ekrana skor tablosunu yazar
function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
    VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
    VIRTUAL_HEIGHT / 3)
end    

-- BURADA SKOR TABLOSU EKRANA YAZDIRILIR VE SERVİS 1. OYUNCUDAN BAŞLAMAK ÜZERE SIRAYLA ATILIR