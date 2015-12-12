uses
        crt;

type
        Tsnake = record
                length: integer;
                headView: string;
                bodyView: string;
                body: array [1..255] of record
			x,y: byte;
		end;
                direction: (TOP, RIGHT, BOTTOM, LEFT);
        end;

        Tfood = record
                x: byte;
                y: byte;
		view: string;
        end;

const
	MAP_SCALE_X = 3;
        MAP_WIDTH = 20;
        MAP_HEIGHT = 25;
        MAP_FIELD : array[1..MAP_HEIGHT, 1..MAP_WIDTH] of byte = (
                (5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,6),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
		(2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
		(2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
		(2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
		(2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
		(2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3),
                (5,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,6)
        );

var
        key: char;
        map: array[1..MAP_HEIGHT] of array[1..MAP_WIDTH] of byte;
        snake: Tsnake;
        food: Tfood;
        gameLoopCounter: integer;

procedure throwFood();
var
        stop: boolean;
        i: byte;
begin
        repeat begin
                food.x := random(MAP_WIDTH) + 1;
                food.y := random(MAP_HEIGHT) + 1;
                stop := (MAP_FIELD[food.y, food.x] = 0);

                if stop then begin
                        for i := 1 to snake.length do begin
                                if (food.x = snake.body[i].x) and (food.y = snake.body[i].y) then begin
                                        stop := false;
                                        break;
                                end;
                        end;
                end;
        end
        until (stop);
end;

procedure init();
var
        i: byte;
begin
        clrscr;
        randomize;
        snake.length := 4;
        snake.headView := '(x)';
        snake.bodyView := '[o]';
        snake.direction := TOP;
        for i := 1 to 100 do begin
                snake.body[i].x := -1;
                snake.body[i].y := -1;
        end;
        for i := snake.length downto 1 do begin
                snake.body[snake.length - i + 1].x := 10;
                snake.body[snake.length - i + 1].y := MAP_HEIGHT - i;
        end;
        gameLoopCounter := 0;
        key := chr(0);		
	food.view := '[+]';
        throwFood();
end;

procedure drawMap();
var
        i, j, k: byte;
begin
        for i := 1 to MAP_HEIGHT do begin
                for j := 1 to MAP_WIDTH do begin
                        gotoxy(j * MAP_SCALE_X, i);
                        case MAP_FIELD[i, j] of
                                0: begin
					write('   ');
				end;
                                2: begin
					write('  |');
				end;
                                3: begin
					write('|');
				end;
                                4: begin
					write('---');
				end;		
				5: begin
					write('  +');
				end;
				6: begin
					write('+');
				end;
                        end;
                end;
        end;

	textcolor(2);
	if food.view = '[+]' then
		food.view := '  '
	else
		food.view := '[+]';
        gotoxy(food.x * MAP_SCALE_X, food.y);
        write(food.view);
	textcolor(7);

	gotoxy(MAP_WIDTH * MAP_SCALE_X + 5, 2);
	write('SCORE: ', snake.length - 4);
end;

procedure drawSnake();
var
        i: byte;
begin
        for i := 1 to snake.length do begin
                gotoxy(snake.body[i].x * MAP_SCALE_X, snake.body[i].y);
                if i = 1 then begin
                        write(snake.headView);
                end
		else begin
			write(snake.bodyView);
		end;
        end;
        gotoxy(0, MAP_HEIGHT + 2);
        write(' ');
end;

procedure moveSnake();
var
        i: integer;
begin
        for i := snake.length downto 2 do begin
                snake.body[i].x := snake.body[i-1].x;
                snake.body[i].y := snake.body[i-1].y;
        end;

        case snake.direction of
                TOP: begin
                         snake.body[1].x := snake.body[1].x;
                         snake.body[1].y := snake.body[1].y - 1;
                end;

                RIGHT: begin
                         snake.body[1].x := snake.body[1].x + 1;
                         snake.body[1].y := snake.body[1].y;
                end;

                BOTTOM: begin
                         snake.body[1].x := snake.body[1].x;
                         snake.body[1].y := snake.body[1].y + 1;
                end;

                LEFT: begin
                         snake.body[1].x := snake.body[1].x - 1;
                         snake.body[1].y := snake.body[1].y;
                end;
        end;
end;

procedure detectColisions();
var
        i, j: integer;
begin
        for i := 1 to MAP_HEIGHT do begin
                for j := 1 to MAP_WIDTH do begin
                        if MAP_FIELD[snake.body[1].y, snake.body[1].x] <> 0 then begin
                                init();
                        end;
                end;
        end;

        for i := 2 to snake.length do begin
                if (snake.body[1].x = snake.body[i].x) and (snake.body[1].y = snake.body[i].y) then begin
                        init();
                end;
        end;

        if (snake.body[1].x = food.x) and (snake.body[1].y = food.y) then begin
                inc(snake.length);
                throwFood();
        end;
end;

procedure handleInput();
begin
		case ord(key) of
                72: begin
                        if snake.direction <> BOTTOM then snake.direction := TOP;
                end;
                77: begin
                        if snake.direction <> LEFT then snake.direction := RIGHT;
                end;
                80: begin
                        if snake.direction <> TOP then snake.direction := BOTTOM;
                end;
                75: begin
                        if snake.direction <> RIGHT then snake.direction := LEFT;
                end;
		13: begin
			gotoxy((MAP_WIDTH div 2) * MAP_SCALE_X - 12, MAP_HEIGHT div 2);
			write('Pause... return to continue.');
			readln;
			key := chr(0);
		end;
        end;
end;

begin
        init();
        while true do begin
                if keypressed() then key := readkey();
		if ord(key) = 27 then break;
                if gameLoopCounter = 10 then begin
		        handleInput();
                        moveSnake();
                        detectColisions();
                        drawMap();
                        drawSnake();
                        gameLoopCounter := 0;
                end;
                inc(gameLoopCounter);
                delay(16);
        end;
end.
