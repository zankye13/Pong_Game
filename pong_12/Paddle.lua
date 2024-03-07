Paddle = Class{} -- paddle sınıfı oluşturulur

function Paddle:init(x, y, width, height) -- paddle sınıfını başlatma işlevi
    -- raketin başlangıç konumu
    self.x = x
    self.y = y
    -- raketin genişliği ve yüksekliği
    self.width = width
    self.height = height
    -- raketin y eksenindeki yönünü belirler
    self.dy = 0
end

function Paddle:update(dt) -- paddle ın güncelleme işlevi
    -- raketin hareketi güncellenir
    -- self.dy raketin y eksenindeki yönünü belirler. 
    if self.dy < 0 then -- bu değişkenin değeri negatif ise (raket yukarı yönde hareket ediyorsa)
        -- yukarı yönlü hareket için raketin konumu güncellenir (raketin ekranın üst kenarına çıkmamasını sağlar)
        self.y = math.max(0, self.y + self.dy * dt)   
    else
        -- aşağı yönlü hareket için raketin konumu güncellenir
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end    

function Paddle:render() -- raket çizimi 
    -- self x ve y konumunda; self width ve height pixel boyutlarında çizer
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end