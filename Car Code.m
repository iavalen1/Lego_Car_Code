%brick = ConnectBrick('MaxSpaz');
global key
InitKeyboard();
while 1

    switch key
        case 'uparrow'
            disp('up arrow');
            brick.MoveMotor('AD', 25);
        
        case 'downarrow'
            disp('down arrow');
            brick.MoveMotor('AD', -25);
			
        case 'rightarrow'
            disp('right arrow');
            brick.MoveMotorAngleRel('A', 25, 30);
          
        case 'leftarrow'
            disp('left arrow');
            brick.MoveMotorAngleRel('D', 25, 30);
      
        case 'p'
            disp('Pause');
            brick.StopAllMotors('Brake');
			
        case 'w'
            disp('Move claw up');
            brick.MoveMotor('B', 25);
            pause(1);
            brick.StopMotor('B', 'Brake');
			
        case 's'
            disp('Move claw down');
            brick.MoveMotor('B', -20);
            pause(.75);
            brick.StopMotor('B', 'Brake');
			
        case 'q'
		
            while 2	
			
				%UPDATES THE SENSORS
				disp('Proceed');
                reading = brick.TouchPressed(3);
				color = brick.ColorColor(1);
				distance = brick.UltrasonicDist(4);
                display(color);
					
				%STARTS THE MOTOR
				brick.MoveMotor('AD', 35);
					
				%HANDLES TURNING
				if distance > 30 && reading == 0    %OPENING ON LEFT AND NO WALL AHEAD
					brick.MoveMotorAngleAbs('D', 35, 45, 'Brake'); 
                    pause(1.45);
                    brick.StopMotor('AD', 'Brake');
					pause(1);
					brick.MoveMotor('AD', 35);
					while reading == 0    %CONTINUES MOVING UNTIL WALL AHEAD
						reading = brick.TouchPressed(3);
					end
				elseif distance > 30 && reading == 1    %OPENING ON LEFT AND WALL AHEAD
					brick.StopMotor('AD', 'Brake');
                    pause(1);
                    brick.MoveMotor('AD', -35);
                    pause(2);
                    brick.StopMotor('AD', 'Brake');
                    pause(1);
                    brick.MoveMotor('AD', 35);
					brick.MoveMotorAngleAbs('D', 35, 45, 'Brake'); 
                    pause(1.45);
                    brick.StopMotor('AD', 'Brake');
					pause(1);
				elseif distance < 30 && reading == 1    %WALL ON LEFT AND WALL AHEAD
					brick.StopMotor('AD', 'Brake');
                    pause(1);
                    brick.MoveMotor('AD', -35);
                    pause(2);
                    brick.StopMotor('AD', 'Brake');
                    pause(1);
                    brick.MoveMotor('AD', 35);
					brick.MoveMotorAngleAbs('A', 35, 45, 'Brake');
                    pause(2);
                    brick.StopMotor('AD', 'Brake');
					pause(1);
				end
				
				%ACTIONS WHEN COLOR IS RED
                if color == 5
                    brick.StopMotor('AD', 'Coast');
                    pause(1);
					brick.MoveMotor('AD', 35);
					while color == 5	%CONTINUES MOVING UNTIL OUT OF RED ZONE
						color = brick.ColorColor(1);
					end
                end
                
				%ACTIONS WHEN COLOR IS WHITE
                if color == 6
                    brick.StopMotor('AD', 'Coast');
					pause(1);
                    brick.MoveMotor('B', -15);
                    pause(1);
                    brick.MoveMotor('AD', -20);
					pause(1);
                    brick.StopMotor('AD', 'Brake');
                    break;    %ENDS THE PROGRAM
				end
			end
        end
    end
end
