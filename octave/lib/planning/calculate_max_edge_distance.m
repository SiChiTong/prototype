function dmax = calculate_max_edge_distance(nodes)
    dmax = 0;
    start = 0;
    finish = 0;
    n = length(nodes);

    for i = 1:n
        for j = i:n
            dx = nodes(i, 1) - nodes(j, 1);
            dy = nodes(i, 2) - nodes(j, 2);
            d = sqrt(double(dx^2 + dy^2));

            if (d > dmax)
                dmax = d;
                start = i;
                finish = j;
            end
        end
    end
end