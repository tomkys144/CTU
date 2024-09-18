% Read input images (drawing and scribbles):

pic = double(imread('data/drawing.png'));
usr = double(imread('data/scribbles.png'));

% Setting scale for edge capacities between two white pixels:

EK = 2000;

% Setting scale for edge capacities that correspond to soft scribbles:

SK = 200;

% Getting drawing dimensions:

w = size(pic, 1);
h = size(pic, 2);

% Setting indices of auxillary source "S" and sink "T" terminal vertices:

S = w * h + 1;
T = w * h + 2;

green(1) = 14; % setup green color RGB values
green(2) = 138;
green(3) = 8;

% Prepare an array "id" that assign unique index to each pixel (x,y) and
% inverted arrays "idx" and "idy" that for the given vertex index returns
% x and y coordiantes of its corresponding pixel [1.5 point]:
id = zeros(w, h);
idx = zeros(1, w * h);
idy = zeros(1, w * h);

for x = 1:w

    for y = 1:h
        vid = ((x - 1) * h) + y; % vertex index

        id(x, y) = vid;
        idx(vid) = x;
        idy(vid) = y;
    end

end

% Setup directed edges going from the source terminal "S" to all pixels
% and from all pixels to the sink terminal "T" and set their capacities
% according to scribbles stored in "usr" (use "SK") [3 points]:
source = zeros(1, (2 * w * h) + (2 * (w -1) * (h - 1)));
target = zeros(1, (2 * w * h) + (2 * (w -1) * (h - 1)));
capacity = zeros(1, (2 * w * h) + (2 * (w -1) * (h - 1)));

eid = 1; % edge index

for x = 1:w

    for y = 1:h
        % Graph edges are specified using three index arrays:

        % "source(eid)" = index of source (from) graph vertex
        % "target(eid)" = index of target (to) graph vertex
        % "capacity(eid)" = edge capacity
        source(eid) = S;
        target(eid) = id(x, y);

        source(eid + 1) = id(x, y);
        target(eid + 1) = T;

        color = reshape(usr(x, y, :), 1, []);

        if color == green % has green scribble
            capacity(eid) = 0;
            capacity(eid + 1) = SK;

        elseif all(color == 255) % has white scribble
            capacity(eid) = SK;
            capacity(eid + 1) = 0;

        else % does not have skribble
            capacity(eid) = 0;
            capacity(eid + 1) = 0;
        end

        eid = eid + 2;
    end

end

% Setup capacities of undirected edges between neighbour pixels
% (undirected edge = two directed edges in opposite direction with
% the same capacity). As a capacity use "EK" scaled in proportion to
% pixel's intensity. You can use gamma correction to improve contrast
% between white and dark pixels (remember that edge capacity between
% pixels shouldn't be equal to zero) [4 points]:
gamma = 6;
l_pic = 0.3 * (pic(:, :, 1) / 255) + 0.59 * (pic(:, :, 2) / 255) + ...
    0.11 * (pic(:, :, 3) / 255);
gamma_pic = l_pic .^ gamma;

for x = 1:w

    for y = 1:h

        if mod(x, 2) == mod(y, 2)

            if x - 1 >= 1
                source(eid) = id(x - 1, y);
                target(eid) = id(x, y);

                source(eid + 1) = id(x, y);
                target(eid + 1) = id(x - 1, y);

                color = min([gamma_pic(x, y) gamma_pic(x - 1, y)]);

                capacity(eid) = color * EK + 1;
                capacity(eid + 1) = color * EK + 1;

                eid = eid + 2;
            end

            if y - 1 >= 1
                source(eid) = id(x, y - 1);
                target(eid) = id(x, y);

                source(eid + 1) = id(x, y);
                target(eid + 1) = id(x, y - 1);

                color = min([gamma_pic(x, y) gamma_pic(x, y - 1)]);

                capacity(eid) = color * (EK - 1) + 1;
                capacity(eid + 1) = color * (EK - 1) + 1;

                eid = eid + 2;
            end

            if x + 1 <= w
                source(eid) = id(x + 1, y);
                target(eid) = id(x, y);

                source(eid + 1) = id(x, y);
                target(eid + 1) = id(x + 1, y);

                color = min([gamma_pic(x, y) gamma_pic(x + 1, y)]);

                capacity(eid) = color * (EK - 1) + 1;
                capacity(eid + 1) = color * (EK - 1) + 1;

                eid = eid + 2;
            end

            if y + 1 <= h
                source(eid) = id(x, y +1);
                target(eid) = id(x, y);

                source(eid + 1) = id(x, y);
                target(eid + 1) = id(x, y + 1);

                color = min([gamma_pic(x, y) gamma_pic(x, y + 1)]);

                capacity(eid) = color * (EK - 1) + 1;
                capacity(eid + 1) = color * (EK - 1) + 1;

                eid = eid + 2;
            end

        end

    end

end

% Construct a directed graph "G" and solve for maximum flow between
% source "S" and sink "T" terminal vertices. Use "source", "target",
% and "capacity" arrays prepared in previous steps:

G = digraph(source, target, capacity);

[MF, GF, CS, CT] = maxflow(G, S, T);

% Get indices of pixels labelled as belonging to terminal "T" stored
% in the array "CT" and colorize them by multiplying their original
% intensity with the color components of the green color. Use "idx"
% and "idy" to lookup pixel coordiantes [1.5 points]:

out = pic; % copy the input drawing to the output

for id = 1:size(CT)
    vid = CT(id);

    if vid == T
        continue
    end

    x = idx(vid);
    y = idy(vid);

    pix = out(x, y, :) / 255;
    col_new = reshape(green, 1, 1, 3);
    pix_out = pix .* col_new;
    out(x, y, :) = pix_out;
end

% Save the resulting colorized image:
figure()
subplot(131)
imshow(pic / 255);
subplot(132)
imshow(usr / 255);
subplot(133);
imshow(out / 255)
imwrite(out / 255, 'output.png');
