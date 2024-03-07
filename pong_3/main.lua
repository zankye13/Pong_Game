push = require 'push'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200 -- raket hızı 

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- herhangi bir metin kullanılabilecek küçük yazı tipi nesnesi
    smallFont = love.graphics.newFont('font.ttf', 8)

    -- skoru ekrana yazan daha büyük font
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- aktif yazı tipi küçük font nesnesine ayarlanır
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    -- başlangıç değerleri olarak her iki oyuncu için 0 değeri verilir
    player1Score = 0
    player2Score = 0

    -- raketlerin y eksenindeki konumları (sadece yukarı aşağı hareket edebilirler)
    player1Y = 30
    player2Y = VIRTUAL_HEIGHT - 50
end


function love.update(dt) -- oyuncuların hareketlerini kontrol eden fonksiyon
    -- 1. oyuncunun hareketleri
    if love.keyboard.isDown('w') then -- klavyeden ilgili tuşun basılıp basılmadığını kontrol eder
        player1Y = player1Y + -PADDLE_SPEED * dt
        -- raket hızını delta_time ile çarparak çerçeveler arası sabit hareket sağlar (negatif olarak)
    
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
        -- raket hızını delta_time ile çarparak çerçeveler arası sabit hareket sağlar (pozitif olarak)
    end

    -- 2. oyuncunun hareketleri
    if love.keyboard.isDown('up') then
        player2Y = player2Y + -PADDLE_SPEED * dt
        -- delta_time a bağlı olarak negatif raket hareketi sağlar
    elseif love.keyboard.isDown('down') then
        
        player2Y = player2Y + PADDLE_SPEED * dt
        -- delta_time a bağlı olarak pozitif raket hareketi sağlar
    end
end
-- GENEL OLARAK BU FONKSİYON KLAVYE GİRİŞLERİNE GÖRE RAKETLERİ HAREKET ETTİRİR 


function love.keypressed(key)
   
    if key == 'escape' then
        love.event.quit()
    end
end


function love.draw()

    push:apply('start')

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)
    -- ekranın arka plan rengini temizler 40 45 52(koyu mavi) ve 255 alfa (tam opaklık)kullanılır

    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')


    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, 
        VIRTUAL_HEIGHT / 3) -- 1. oyuncunun skoru yazılır (tostring fonksiyonu skoru metin formatına dönüştürerek ekrana yazar)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
        VIRTUAL_HEIGHT / 3) -- 2. oyuncunun skoru yazılır

    -- sol taraftaki oyuncunun raketi çizilir
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    -- Dikdörtgenin sol üst köşesi (10, player1Y) noktasında, 5 birim genişlikte ve 20 birim yükseklikte bir dikdörtgen çizilir.


    -- sağ taraftaki oyuncunun raketi
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
     -- VIRTUAL_WIDTH - 10, ekranın sağ kenarına yakın bir konumda dikdörtgenin sol üst köşesini temsil eder. 
    -- player2Y, sağ taraftaki oyuncunun paletinin yüksekliğini belirler.

    -- merkezdeki top
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4) --4x4 boyutunda top

    push:apply('end')
end
