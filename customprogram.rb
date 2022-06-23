require 'gosu'

module ZOrder
    BACKGROUND, PLAYER, CHICKEN, BULLET, BLOOD ,EXPLOSION, BOSS, HEART, COIN, BOSSLASER ,UI = *0..10
  end




class FarmInvaders < Gosu::Window
    MAX_ENEMIES = 200
     WIDTH = 1000
    HEIGHT = 800
    def initialize
        super(WIDTH, HEIGHT)  #create window game
        self.caption = "Farm Invader"
         #setting up the start screen of the game
        @background_image = Gosu::Image.new('images/start_screen.png')
        @background_game = Gosu::Image.new('images/space.jpg')
        @image_theme = Gosu::Image.load_tiles('images/themestart.png', 100, 100)
        @image_theme1 = Gosu::Image.load_tiles('images/chicken.png', 32, 32)
        @image_index = 0
        @image_index1 = 0
        @scene = :start
        @font = Gosu::Font.new(25)
        @start_music = Gosu::Song.new('sounds/maintheme.mp3')
        @start_music.play(true)
        @enemy_rate = 0.01
        @choice = Gosu::Color::BLACK
        @choice1 = Gosu::Color::BLACK
        @choice2 = Gosu::Color::BLACK     
        
    end


    def initialize_game
        #setting up the ingame screen
      
        @player = Player.new(500,400)
        @enemies_appeared = 0
        @chickens_destroyed = 0
        @bloods =[]
        @coins = []
        @boss = []
        @bosslaser = []
        @chickens = []
        @bullets = []
        @explosions = []
        @hearts = []
        @scene = :ingame
        @game_music = Gosu::Song.new('sounds/ingame.mp3')
        @game_music.play(true)
        @chicken_sound = Gosu::Sample.new('sounds/cluck.wav')
        @shooting_sound = Gosu::Sample.new('sounds/shoot.mp3')
        @hit_sound = Gosu::Sample.new('sounds/bum.mp3')
        @coin_absorp = Gosu::Sample.new('sounds/coins.mp3') 
    end

    def initialize_end(ending)
        #setting up the end screen
        case ending
            when :survived
                @message = "You survived it! Your score is #{@player.score}.!!!"
                
            when :dead
                @message = "You DIED!!!"
                @message2 = "Before you die, "
                @message2 += "your score is #{@player.score}."
          
        end
        @bottom_message = "Press P to play again, or Q to quit."
        @message_font = Gosu::Font.new(30)
        @scene = :end
        @end_music = Gosu::Song.new('sounds/endingtheme.mp3')
        @end_music.play(true)
    end
    class Player

        attr_accessor :x, :y, :center, :image, :lives, :score
    
        def initialize(x,y)
            @x = x
            @y = y
            @image = Gosu::Image.load_tiles('images/ship.png', 60 , 152)
            @center = 20
            @lives = 5
            @score = 0
        
        end
    end

    
    def move_left(player)
        player.x -=7
        if player.x <= 0 
            player.x = 0 
        end 
    end
    def move_right(player)
        player.x +=7
        if player.x >= WIDTH - 2 * player.center
            player.x = WIDTH - 2 * player.center
        end 
    end
    def move_up(player)
        player.y -=7
        if player.y <= 0
            player.y = 0 
        end 
    end
    def move_down(player)
            player.y +=7
            if player.y >= 800
                player.y = 800 
            end 
    end
    def draw_player(player)
        current_img = player.image[Gosu.milliseconds / 20 % 
            player.image.length] 
                current_img.draw(player.x, player.y, ZOrder::PLAYER) 
        end


        
        class Chicken
            
            attr_accessor :x, :y, :center, :image, :vel_x, :vel_y
            
            def initialize()          
                @x = rand(WIDTH)
                @y = 0
                @vel_x = rand(-4..4)
                @vel_y = rand(3..5)
                @center = 22
                @image = Gosu::Image.load_tiles('images/chicks.png', 40, 50)
            end
        end
    def move_chick(chick)
        chick.y += chick.vel_y
        chick.x += chick.vel_x
        chick.vel_x *= -1 if (chick.x + chick.center > 1000) || chick.x < 0
    end 
    def draw_chick(chick)
        current_img = chick.image[Gosu.milliseconds / 120 % 
            chick.image.length] 
                current_img.draw(chick.x, chick.y, ZOrder::CHICKEN) 
    end

    class Bullet

        attr_accessor :x, :y, :center, :image, :center, :vel_y
    
        def initialize(x,y)
            @x = x
            @y = y
            @vel_y = 10
            @image = Gosu::Image.load_tiles('images/laser.png', 20, 20)
            @center = 3
        end
    end
    def shoot(bullet)
        bullet.y -= bullet.vel_y
    end 
    def draw_bullet(bullet)
        current_img = bullet.image[Gosu.milliseconds / 20 % 
            bullet.image.length] 
                current_img.draw(bullet.x, bullet.y,ZOrder::BULLET) 
    end


    class Explosion

        attr_accessor :x, :y, :center,:image, :finished, :index
    
        def initialize(x, y)
            @x = x
            @y = y
            @center = 30
            @image = Gosu::Image.load_tiles('images/explosions.png', 60, 60)
            @index = 0
            @finished = false
        end
    end
    def draw_explosion(explosion) 
        current_img = explosion.image[Gosu.milliseconds / 50 % 
    explosion.image.length] 
        current_img.draw(explosion.x, explosion.y, ZOrder::EXPLOSION) 
        if current_img == explosion.image[explosion.image.length - 1] 
            explosion.finished = true 
        end 
    end 
    #remove explosions tiles    
    def remove_explosions 
        @explosions.reject! do |explosion| 
         if explosion.finished 
            true 
          else 
            false 
          end 
        end 
      end 
    
      class Blood

        attr_accessor :x, :y, :center,:image, :sound,:finished, :index
    
        def initialize(x, y)
            @x = x
            @y = y
            @center = 30
            @image = Gosu::Image.load_tiles('images/blood.png', 50, 50)
            @index = 0
            @finished = false
        end
    end
    def draw_blood(blood) 
        current_img = blood.image[Gosu.milliseconds / 50 % 
    blood.image.length] 
        current_img.draw(blood.x, blood.y, ZOrder::BLOOD) 
        if current_img == blood.image[blood.image.length - 1] 
            blood.finished = true 
        end 
    end 
    #remove bloods tiles
    def remove_bloods 
        @bloods.reject! do |blood| 
         if blood.finished 
            true 
          else 
            false 
          end 
        end 
      end 
    
     



      
      class Heart
        attr_accessor :x, :y, :center, :image, :vel_y
    
        def initialize()
            @x =  rand(WIDTH)
            @y =  0
            @image = Gosu::Image.new('images/heart.png')
            @center = 20
            @vel_y = 5 
        end
    end
        def move_heart(heart)
            heart.y += heart.vel_y
        end
        def draw_heart(heart)
            heart.image.draw(heart.x, heart.y, ZOrder::HEART)
        end 

        class Coin
            attr_accessor :x, :y, :center, :image, :vel_y
        
            def initialize(x,y)
                @x =  x
                @y =  y
                @image = Gosu::Image.load_tiles('images/coins.png' , 40, 36)
                @center = 20
                @vel_y = 5 
            end
        end
            def move_coin(coin)
                coin.y += coin.vel_y
            end
            def draw_coin(coin)
                current_img = coin.image[Gosu.milliseconds / 120 % 
                    coin.image.length] 
                        current_img.draw(coin.x, coin.y, ZOrder::COIN) 
            end
    
            class Boss
                attr_accessor :x, :y, :center, :vel_x, :hp, :image
            
                def initialize()
                    
                    
                    @x =  0
                    @y =  rand(50..300)
                    @image = Gosu::Image.load_tiles('images/alien.png' , 48, 42)
                    @vel_x = 2
                    @center = 24
                    @hp = 5
                end
            end
            def move_boss(boss)
                boss.x += boss.vel_x
                
            end 
            def draw_boss(boss)
                current_img = boss.image[Gosu.milliseconds / 120 % 
                    boss.image.length] 
                        current_img.draw(boss.x, boss.y, ZOrder::BOSS) 
            end


            class Bosslaser

                attr_accessor :x, :y, :center, :image, :center, :vel_y
            
                def initialize(x,y)
                    @x = x
                    @y = y
                    @vel_y = 5
                    @image = Gosu::Image.load_tiles('images/bosslaser.png' , 32, 32)
                    @center = 3
                end
            end
            def boss_shoot(bosslaser)
                bosslaser.y += bosslaser.vel_y
            end 
            def draw_bosslaser(bosslaser)
                current_img = bosslaser.image[Gosu.milliseconds / 20 % 
                    bosslaser.image.length] 
                        current_img.draw(bosslaser.x, bosslaser.y, ZOrder::BOSSLASER) 
            end

    


    def update_start
        #create button for player to select difficulties
        if mouse_over_button(mouse_x, mouse_y,300,100,450,150)
            @choice = Gosu::Color::BLUE
        else 
            @choice = Gosu::Color::BLACK 
        end 
        if mouse_over_button(mouse_x, mouse_y,300,200,450,250)
            @choice1 = Gosu::Color::BLUE
        else 
            @choice1 = Gosu::Color::BLACK 
        end 
        if mouse_over_button(mouse_x, mouse_y,300,300,450,350)
            @choice2 = Gosu::Color::BLUE
        else 
            @choice2 = Gosu::Color::BLACK 
        end 
    end  
        

  
        
    def update_game
        #moving function of player
        move_left @player if Gosu.button_down? Gosu::KB_LEFT 
        move_right @player if Gosu.button_down? Gosu::KB_RIGHT
        move_up @player if Gosu.button_down? Gosu::KB_UP
        move_down @player if Gosu.button_down? Gosu::KB_DOWN
        if rand < @enemy_rate
            @chickens.push (Chicken.new())
            @enemies_appeared +=1
        end
        #moving function for each chicken
        @chickens.each do |chick|
            move_chick(chick)
        #moving function for each bullet
        end
        @bullets.each do |bullet|
            shoot(bullet)
        end
        #generate heart 
        if rand(200) == 1
            @hearts.push (Heart.new())
        end
        #moving function for each heart
        @hearts.each do |heart|
            move_heart(heart)
        end
        #moving function for each coin
        @coins.each do |coin|
            move_coin(coin)
        end
        #randomly generate boss
        if rand(200) == 1
            @boss.push (Boss.new())
        end
        #moving function for each boss
        @boss.each do |boss|
            move_boss(boss)
            if rand(30) == 1   #generate bullet which are shot by boss
                @bosslaser.push (Bosslaser.new(boss.x,boss.y))
            end
        end
        @bosslaser.each do |bosslaser| #moving function for each boss bullet
            boss_shoot(bosslaser)
        end
        
        #delete boss if player shoot down 
        @boss.each do |boss|
            @bullets.each do |bullet|
                distance = Gosu.distance(boss.x, boss.y, bullet.x, bullet.y)
                if distance < boss.center + bullet.center
                    boss.hp -=1
                    
                    @explosions.push Explosion.new(boss.x, boss.y)
                    @bullets.delete bullet
                    @hit_sound.play
                  
                end
                if boss.hp == 0 
                    @boss.delete boss
                end
            end
        end
        #decrease health if boss hit player
        @boss.each do |boss|
            
            distance = Gosu.distance(boss.x, boss.y, @player.x, @player.y)
            if distance < boss.center + @player.center
                @boss.delete boss
                @explosions.push Explosion.new(boss.x, boss.y)
                
                @player.lives -= 5
                @hit_sound.play
            end
    
    end

        
        
        
        #delete chicken if player shoot down chicken

        @chickens.each do |chick|
            @bullets.each do |bullet|
                distance = Gosu.distance(chick.x, chick.y, bullet.x, bullet.y)
                if distance < chick.center + bullet.center
                    @chickens.delete chick
                    @explosions.push Explosion.new(chick.x, chick.y)
                    @coins.push Coin.new(chick.x, chick.y)
                    @bullets.delete bullet
                    @chicken_sound.play
                  
                end
            end
        end

        #delete chicken and decrease player's health if chicken hit the player
        @chickens.each do |chick|
            
                distance = Gosu.distance(chick.x, chick.y, @player.x, @player.y)
                if distance < chick.center + @player.center
                    @chickens.delete chick
                    @explosions.push Explosion.new(chick.x, chick.y)
                    
                    @player.lives -=1
                    @hit_sound.play
                    @player.score +=20
                end
        
        end
        #decrease player's health if boss shoots the player successfully
        @bosslaser.each do |bosslaser|
            
            distance = Gosu.distance(bosslaser.x, bosslaser.y, @player.x, @player.y)
            if distance < bosslaser.center + @player.center
                @bosslaser.delete bosslaser
                @explosions.push Explosion.new(bosslaser.x, bosslaser.y)
                @player.lives -=1
                @hit_sound.play
            end
        end
        #increase health if player hit the heart
        @hearts.each do |heart|
            
            distance = Gosu.distance(heart.x, heart.y, @player.x, @player.y)
            if distance < heart.center + @player.center
                @hearts.delete heart
                @bloods.push Blood.new(heart.x, heart.y)
                
                @player.lives +=1
                @coin_absorp.play
            end

            
            @coins.each do |coin|   #increase score if player hit the coin
            
                distance = Gosu.distance(coin.x, coin.y, @player.x, @player.y)
                if distance < coin.center + @player.center
                    @coins.delete coin
                    @bloods.push Blood.new(heart.x, heart.y)
                    
                    @player.score +=100
                    @coin_absorp.play
                end
            end
    
    end

        self.remove_bloods
        self.remove_explosions
        if @player.lives <= 0
            initialize_end(:dead)
           end 
           initialize_end(:survived) if @enemies_appeared > MAX_ENEMIES
    end

    def button_down(id)
        case @scene
            when :start
                button_down_start(id)
            when :ingame
                button_down_game(id)
            when :end    
                button_down_end(id)
        end
    end

    def button_down_start(id)
        if id == Gosu::MsLeft #enemy rate in easy mode
            if mouse_over_button(mouse_x, mouse_y,300,100,450,150)
                @enemy_rate = 0.01
            end
        end
        if id == Gosu::MsLeft   #enemy rate in hard mode
            if mouse_over_button(mouse_x, mouse_y,300,200,450,250) 
                @enemy_rate = 0.03
            end
        end
        if id == Gosu::MsLeft    #enemy rate in insane mode
            if mouse_over_button(mouse_x, mouse_y,300,300,450,350) 
            
                @enemy_rate = 0.1
                @player.lives = 15
            end
        end
        initialize_game
        
    end

    def button_down_game(id)
        if id == Gosu::KbSpace
          
            @bullets.push Bullet.new(@player.x+ @player.center, @player.y)
            @shooting_sound.play(1) 
        end 
    end

    def button_down_end(id)
        if id == Gosu::KbP
            initialize
        elsif id == Gosu::KbQ
            close
        end
    end
     
    def need_cursor?
        true 
    end
    
    def mouse_over_button(mouse_x, mouse_y ,leftX,topY,rightX ,botY)
        if (mouse_x > leftX) and (mouse_x < rightX) and (mouse_y > topY) and (mouse_y < botY)
            true
         else
           false
         end
    end
    

    def draw_start
        @background_image.draw(0,0,0) 
        if @image_index < @image_theme.count
            @image_theme[@image_index].draw(100, 100 , 2)
            
            @image_index +=1 
            if @image_index == @image_theme.count
                @image_index = 0 
            end 
        end 
        if @image_index1 < @image_theme1.count
            @image_theme1[@image_index1].draw(650, 115 , 2)  #draw button
            sleep(0.05)
            @image_theme1[@image_index1].draw(650, 215 , 2)
            sleep(0.05)
            @image_theme1[@image_index1].draw(650, 315 , 2)
            sleep(0.05)
            @image_index1 +=1 
            if @image_index1 == @image_theme1.count
                @image_index1 = 0 
            end 
        end
        @font.draw("TRY TO SURVIVE THE INVASION OF CHICKENS!!!!!",200,500, 0)
        @font.draw("EASY MODE",500,125, 0)
        @font.draw("HARD MODE",500,225, 0)
        @font.draw("INSANE MODE",500,325, 0)
        Gosu.draw_rect(290,90,170,70, @choice)
        Gosu.draw_rect(290,190,170,70, @choice1)
        Gosu.draw_rect(290,290,170,70, @choice2)
        Gosu.draw_rect(300 ,100, 150, 50, Gosu::Color::GREEN)
        Gosu.draw_rect(300 ,200, 150, 50, Gosu::Color::YELLOW)
        Gosu.draw_rect(300 ,300, 150, 50, Gosu::Color::RED)
        
    end
    def draw_game 
        @background_game.draw(0,0, ZOrder::BACKGROUND)
        draw_player(@player)
        @chickens.each do |chick| 
        draw_chick(chick) 
        end
        @bullets.each do |bullet| 
            draw_bullet(bullet) 
        end
        @explosions.each do |explosion|
            draw_explosion(explosion)
        end
        @hearts.each do |heart|
            draw_heart(heart)
        end
        @bloods.each do |blood|
            draw_blood(blood)
        end
        @coins.each do |coin|
            draw_coin(coin)
        end
        @boss.each do |boss|
            draw_boss(boss)
        end
        @bosslaser.each do |bosslaser|
            draw_bosslaser(bosslaser)
        end
        @font.draw("Enemies left: #{MAX_ENEMIES - @enemies_appeared}", 600,0,ZOrder::UI)
        @font.draw("Score: #{@player.score}", 600,50,ZOrder::UI)
        @font.draw("Lives: #{@player.lives}", 800,50,ZOrder::UI)
        #@font.draw("Ammo: #{@reload}", 800,0,0)
        
    end


    def draw_end        
        @message_font.draw(@message,40,240,ZOrder::UI,1,1,Gosu::Color::RED)
        @message_font.draw(@message2,40,275,ZOrder::UI,1,1,Gosu::Color::RED)
        @message_font.draw(@bottom_message,180,540,ZOrder::UI,1,1,Gosu::Color::RED)
    end

    def update
        if @scene == :start 
                update_start
        end
        if @scene == :ingame
                update_game
        end
    end

    

    def draw
        case @scene
            when :start
                draw_start
            when :ingame
                draw_game
            when :end
                draw_end
        end
    end

end


 FarmInvaders.new.show

 
