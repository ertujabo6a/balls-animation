clear
% space for ball movement
height = 10;
width = 7.5;

figure(1)
clf

% each column represents one ball (for the for loop)
% in each column: [x; y; r; v_x; v_y]
%  x, y - positions
%  r - radius
%  v_x, v_y - velocity
%  
balls = [];

for i = 1:30
    x = rand() * width;
    y = rand() * height;

    radius = 0.05 + rand() * 0.1;
    alpha = rand() * 2 * pi;
    velocity = rand() * 7 + 1;
    v_x = velocity * cos(alpha);
    v_y = velocity * sin(alpha);

    balls(:, i) = [x; y; radius; v_x; v_y];
end

% unit circle to be scaled and translated
alpha = [linspace(0, 2 * pi, 10), 0];  % closed curve
Xjk = cos(alpha);
Yjk = sin(alpha);

dt = 0.05; % time per frame - delta t
for t = 0:dt:20
    % rectangle defining the reflection space for balls
    plot([0, width, width, 0, 0], [0, 0, height, height, 0], 'k-', 'LineWidth', 2);
    hold('on')
    for i = 1:size(balls, 2)
        x = balls(1, i);
        x_old = x;
        y = balls(2, i);
        y_old = y;
        radius = balls(3, i);
        v_x = balls(4, i);
        v_y = balls(5, i);
        
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

        Xk = x + radius * Xjk;
        Yk = y + radius * Yjk;
        plot(Xk, Yk, 'r-', [x_old, x], [y_old, y], 'b--')

        balls(1, i) = x;
        balls(2, i) = y;
    end    
    hold('off')
    axis('equal')
    title(sprintf('t = %.3f', t))
    pause(dt * 0.75)
end
