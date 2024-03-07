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
        resizable = true,
        vsync = true
    })

    -- başlangıçta oyuncuların skoru 0 olarak ayarlanır
    player1Score = 0
    player2Score = 0

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
    if gameState == 'play' then -- oyunun mevcut durumu "play" ise

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

    love.graphics.setFont(scoreFont) -- skor fontu ayarlanır
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3)
    -- (tostring player1Score ve player2Score değişkenlerini metin formatına dönüştürür)    
    -- 1. oyuncunun skoru ekrana yazdırılır (verilen değerlere göre ekranın ortasına yakın bir konumda görünür)    
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3)
    -- 2. oyuncunun skoru ekrana yazdırılır    

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

-- çarpışmalar 1. ve 2. oyuncuya göre ayarlanırken de çerçevenin alt ve üstüne topun çarpıp çarpmadığı kontrol edilirken aynı zamanda aşağıdaki if ifadelerinde de raketlere çarpmadığı durumda alt ve üste çarpıp çaromadığı kontrol ediliyor
-- BURADA TOP OYUN ÇERÇEVESİNİN SINIRLARI İÇERİSİNDE HAREKET EDİP AMA YİNE DE SAĞ VE SOLDAN SONSUZA DOĞRU GİTMEYE DEVAM EDİYOR VE OYUNCULARIN ALDIĞI SAYILAR SKOR TABLOSUNA YAZILMIYOR