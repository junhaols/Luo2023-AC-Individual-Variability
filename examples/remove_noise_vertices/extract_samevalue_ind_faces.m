
function border_index  = extract_samevalue_ind_faces(ss)

for i = 1:length(ss)
    tmp = ss(i);
    ss0 = ss - tmp;
    ss_sum = sum(logical(ss0));
    if ss_sum == 2 % not the border node
        no_border = i;
        break
    end
end

border_index = setdiff([1,2,3],no_border);

