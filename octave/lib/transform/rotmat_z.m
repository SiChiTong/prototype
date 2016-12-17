function Rz = rotmat_y(theta)
    Rz = [cos(theta), sin(theta), 0.0;
          -sin(theta), cos(theta), 0.0;
          0.0, 0.0, 1.0];
endfunction