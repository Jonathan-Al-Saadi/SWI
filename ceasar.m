function coded = ceasar(V, shift)

tmp1 = double(V-32);

for i = 1:length(tmp1)
    if tmp1(i) + shift >= 0 && tmp1(i) + shift <= 94
        tmp1(i) = tmp1(i) + shift;
    elseif tmp1(i) + shift > 94
        x = fix((tmp1(i) + shift)/95);
        x2 = tmp1(i) + shift - 95*x;
        tmp1(i) = x2;
    elseif tmp1(i) + shift < 0
        x = tmp1(i) + shift; 
        x2 = abs(fix(x/95));
        shift = x2*95 + shift;
        x3 = tmp1(i) + shift + 95;
        tmp1(i) = x3;
    end
end

coded = char(tmp1+32);