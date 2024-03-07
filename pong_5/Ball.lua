Ball = Class{} -- ball sınıfı oluşturulur

function Ball:init(x, y, width, height) -- ball sınıfını başlatan işlev
    -- topun başlangıç konumu
    self.x = x
    self.y = y
    -- topun genişliği ve yüksekliği
    self.width = width
    self.height = height

    -- topun y eksenindeki (yukarı, aşağı) hızı
    self.dy = math.random(2) == 1 and -100 or 100
    -- topun x eksenindeki (sağa,sola) hızı
    self.dx = math.random(-50, 50)
end


function Ball:reset() -- topu sıfırlama işlevi
    -- topoun başlangıç konumu ekranın ortasına ayarlanır
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    -- topun y eksenindeki hızı yeniden rastgele olarak belirlenir
    self.dy = math.random(2) == 1 and -100 or 100
    -- topun x eksenindeki hızı yeniden rastgele olarak belirlenir
    self.dx = math.random(-50, 50)
end


function Ball:update(dt) -- topu güncelleme işlevi
    -- topun x ve y konumunu günceller
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render() -- topu çizen işlev
    -- self x ve y konumunda; self width ve height pixel boyutlarında çizer
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end