function micky_animation()
    % space for ball movement
    height = 10;
    width = 7.5;

    % handle Figure window with the assignment of the close window event handler
    % -> termination of the loop
    figureHandle = figure("CloseRequestFcn", @closeWindowEvent);

    try
        axesHandle = axes(figureHandle, 'box', 'off');
        hold(axesHandle, 'on');
        axis(axesHandle, 'equal');
    
        % each column represents one ball (for the for loop)
        % in each column: [x; y; r; v_x; v_y]
        %  x, y - positions
        %  r - radius
        %  v_x, v_y - velocity
        %  
        balls = [];
        % handle objects for the plot results
        ballHandles = {};
        
        for i = 1:30
            x = rand() * width;
            y = rand() * height;
            [balls, ballHandles] = addBall(axesHandle, balls, ballHandles, x, y);
        end
        
        % rectangle defining the reflection space for balls
        boundaries = plot(axesHandle, [0, width, width, 0, 0], [0, 0, height, height, 0], 'k-', 'LineWidth', 2);
        
        % could be a better solution than using a global variable
        global exitProgram
        exitProgram = false;
    
        dt = 0; % time per frame - delta t
        while ~exitProgram
            tic_start = tic;
            
            balls = updateBalls(balls, ballHandles, dt, height, width);
    
            drawnow
            dt = toc(tic_start);
            % fprintf("exitProgram: %d\n", exitProgram);
        end
    catch e
        close(figureHandle);  % close the window by deleting its handle
        rethrow(e);
    end
    close(figureHandle);  % close the window by deleting its handle
end

function [balls, ballHandles] = addBall(axesHandle, balls, ballHandles, x, y)
    radius = 0.05 + rand() * 0.1;
    alpha = rand() * 2 * pi;
    velocity = rand() * 7 + 1;
    v_x = velocity * cos(alpha);
    v_y = velocity * sin(alpha);

    t = [linspace(0, 2 * pi, 50), 0];  % closed curve
    Xk = x + radius * cos(t);
    Yk = y + radius * sin(t);
    lineHandle = plot(axesHandle, Xk, Yk, 'r-', 'LineWidth', 2);
    ballHandles{end + 1} = lineHandle;

    ball = [x; y; radius; v_x; v_y];
    balls = [balls, ball];  % extension by another column
end

function balls = updateBalls(balls, ballHandles, dt, height, width)
    
    for i = 1:size(balls, 2)
        % extracting values
        x = balls(1, i);
        x_old = x;
        y = balls(2, i);
        y_old = y;
        radius = balls(3, i);
        v_x = balls(4, i);
        v_y = balls(5, i);
        lineHandle = ballHandles{i};
        % Euler's method
        x = x + v_x * dt;
        y = y + v_y * dt;

        % collisions are calculated with respect to the ball's edge, so it's necessary to consider +- radius

        if x - radius < 0 % reflection from the left wall
            x = radius;
            v_x = -v_x;
            balls(4, i) = v_x;
        elseif x + radius > width  % reflection from the right wall
            x = width - radius;
            v_x = -v_x;
            balls(4, i) = v_x;
        end

        if y - radius < 0 % reflection from the top wall
            y = radius;
            v_y = -v_y;
            balls(5, i) = v_y;
        elseif y + radius > height  % reflection from the bottom wall
            y = height - radius;
            v_y = -v_y;
            balls(5, i) = v_y;
        end

        Xk = x + radius * cos(t);
        Yk = y + radius * sin(t);
        lineHandle.XData = Xk;
        lineHandle.YData = Yk;

        % saving back (for simplicity, update all values)
        balls(:, i) = [x; y; radius; v_x; v_y];
    end
end

function closeWindowEvent(f, event)
    global exitProgram
    exitProgram = true;
    % don't close the window, just note that the program should terminate
end
