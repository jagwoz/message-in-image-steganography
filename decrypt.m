imageWithSecret = imread('image_with_secret.bmp');
red = imageWithSecret(:, :, 1);

%key = '%!*%@!$%!%$%!@$%!@%$!@%$    U!U!@I!U@I!@IU@!IU!IU@!IU@I!@H!J@JG!@VHGJ!HG@HJVJGHCDHSDHsdsghgasdhgadgshasg*%!%@& !&%@*%&! @&%!*&!()(@*)(!*(@) *!@*((*!@(*!@( !#$!%$^@^@%&@&%!&*!^*^@*@*^@(*(&@(@';
key = input('key: ', 's');
delimitter = reshape(dec2bin(key, 8).'-'0',1,[]);

rng(sum(double(key)))

[numRowsPixels, numColsPixels] = size(red);
fullImage =  red(1, :);
for i = 2 : numRowsPixels, fullImage = [fullImage, red(i, :)]; end

keyFill = [];
for i = 1 : length(fullImage)
    if (rand(1,1) <= rand(1,1)), keyFill = [keyFill, 1];
    else keyFill = [keyFill, 0]; end
end

firstIndex = sum(double(key));
redBin = de2bi(fullImage(1, firstIndex));
codeNumber = redBin(1); 
disp(['First index: ', num2str(firstIndex)])

secretBin = [];
iterator = firstIndex + 1;
while (iterator ~= firstIndex)
    if (keyFill(1, iterator) == codeNumber)
        redBin = de2bi(fullImage(1, iterator), 8);
        secretBin = [secretBin, redBin(1)];
    end
    iterator = iterator + 1;
    if (iterator > length(fullImage)) iterator = 1; end
    if (length(secretBin) > 3 * length(delimitter))
        if (strfind(secretBin(end - 3 * length(delimitter) + 1 : end), [delimitter, delimitter, delimitter]))
            secretBin = secretBin(1 : strfind(secretBin, [delimitter, delimitter, delimitter]) - 1);
            message = convertCharsToStrings( char(bin2dec(reshape(char(secretBin+'0'), 8,[]).')) );
            disp(message);
            clear
            return; 
        end
    end
end

disp('The picture contains no message or the key is invalid')
clear