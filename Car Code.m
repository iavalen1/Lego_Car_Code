%brick = ConnectBrick('EV3');
global key
InitKeyboard();
while 1
    pause(0.01);
    brick.ResetMotorAngle('AD');
     switch key
        
        case 'uparrow'
            disp('up arrow');
            brick.MoveMotor('AD', -35);
            while key == 'uparrow'
                pause(0.01);
            end
            brick.StopMotor('AD', 'Coast');
            
        case 'downarrow'
            disp('down arrow');
            brick.MoveMotor('AD', 35);
            while key == 'downarrow'
                pause(0.01);
            end
            brick.StopMotor('AD', 'Coast');
            
        case 'rightarrow'
            disp('right arrow');
            brick.MoveMotor('D', -35);
            while key == 'rightarrow'
                pause(0.01);
            end
            brick.StopMotor('D', 'Brake');
            
        case 'leftarrow'
            disp('left arrow');
            brick.MoveMotor('A', -35);
            while key == 'leftarrow'
                pause(0.01);
            end
            brick.StopMotor('A', 'Brake');
            
        case 'p'
            disp('Pause');
            brick.StopAllMotors('Brake');
            
        case 'w'
            disp('Move claw up');
            brick.MoveMotor('B', -30);
            while key == 'w'
                pause(0.01);
            end
            brick.StopMotor('B', 'Coast');
            
        case 's'
            disp('Move claw down');
            brick.MoveMotor('B', 10);
            while key == 's'
                pause(0.01);
            end
            brick.StopMotor('B', 'Coast');
            
        case 'q'
            
            %STARTS THE MOTOR
            brick.MoveMotor('D', -75);
            brick.MoveMotor('A', -75);
            
            while 2
                
                %UPDATES COLOR
                color = brick.ColorColor(1);
                
                %ACTIONS WHEN COLOR IS RED
                if color == 5
                    brick.StopMotor('AD', 'Brake');
                    pause(1);
                    brick.MoveMotor('AD', -75);
                    while color == 5	%CONTINUES MOVING UNTIL OUT OF RED ZONE
                        color = brick.ColorColor(1);
                    end
                end
                
                %ACTIONS WHEN COLOR IS YELLOW
                if color == 6
                    brick.StopMotor('AD', 'Coast');
                    pause(1);
                    brick.MoveMotorAngleRel('B', 35, 90, 'Coast');
                    pause(1);
                    brick.MoveMotorAngleRel('AD', 35, 90, 'Brake');
                    pause(1);
                    break;    %ENDS THE PROGRAM
                end
                
                %UPDATES COLOR AND TOUCH SENSOR
                distance = brick.UltrasonicDist(4);
                
                %WALL GUIDE
                if distance < 15
                    brick.MoveMotor('D', -40);
                    pause(0.1);
                    brick.MoveMotor('D', -75);
                elseif distance > 20 && distance < 39
                    brick.MoveMotor('A', -40);
                    pause(0.1);
                    brick.MoveMotor('A', -75);
                end
                
                %UPDATES TOUCH SENSOR
                reading1 = brick.TouchPressed(3);
                reading2 = brick.TouchPressed(2);
                
                %HANDLES TURNING
                if  distance > 50   %OPENING ON RIGHT
                    brick.MoveMotorAngleRel('AD', -75, 200, 'Brake');
                    brick.WaitForMotor('AD');
                    brick.MoveMotorAngleRel('D', -35, 475, 'Brake');
                    brick.WaitForMotor('D');
                    brick.MoveMotorAngleRel('AD', -75, 300, 'Brake');
                    brick.WaitForMotor('AD');
                    brick.MoveMotor('AD', -75);
                elseif distance < 40 && (reading1 == 1 || reading2 == 1)    %WALL ON RIGHT AND WALL AHEAD
                    brick.StopMotor('AD', 'Brake');
                    brick.MoveMotorAngleRel('AD', 75, 250, 'Brake');
                    brick.WaitForMotor('AD');
                    brick.MoveMotorAngleRel('A', -35, 475, 'Brake');
                    brick.WaitForMotor('A');
                    brick.MoveMotor('AD', -75);
                end
            end
    end
end