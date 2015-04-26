%from http://stackoverflow.com/questions/466972/array-of-matrices-in-matlab
function result = createArrays(nArrays, arraySize)
    result = cell(1, nArrays);
    for i = 1 : nArrays
        result{i} = zeros(arraySize);
    end
end