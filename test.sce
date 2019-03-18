clear;
f = scf(0);
f0 = figure(0);
test = uicontrol(f0, "style", "text", ...
    "string", "Ceci est une figure", ...
    "position", [10 350 100 100]);
scene = uicontrol(f0, "style", "text", ...
    "string", "Ceci est une figure qui sera la scene", ...
    "position", [200 25 400 400]);

button1 = uicontrol("style", "pushbutton", ...
          "string", "Choose a file", ...
          "position", [10, 100, 150, 100], ...
          "callback", "x = loadImage();" + ...
                      "hist = histogramme(x);" + ...
                      "luminance(x, hist);");
                
                      
function x = loadImage() 
    myFile = uigetfile();
    x = imread(myFile);
    imshow(x);
endfunction

function saveImage(x)
    ret = imwrite(x, "modif.png");
endfunction

function hist = histogramme(x)
    [nl, nc] = size(x);
    hist = zeros([1:256]);

    for i = 1:nl
        for j = 1:nc
            //val = x(i,j);
            //hist(val) = hist(val)+1;
            //disp("i= " + string(i) + "j = " + string(j) + "x(i, j) = " + string(x(i,j)));
            if x(i, j) == 255 then 
                hist(256) = hist(256) + 1;
            else    
                hist(x(i,j) + 1) = hist(x(i,j) + 1) + 1;
            end,
        end;
    end
endfunction

function [maxi, mini] = dynamique(hist)
    maxi = 0
    mini = 0
    for i = 1:256
        if hist(i) ~= 0 then
            mini = i;
            disp(string(hist(i)) + " " + string(i))
            break
        end;
    end
    for j = 256:-1:1
        if hist(j) ~= 0 then
            maxi = j;
            disp(string(hist(j)) + " " + string(i))
            break
        end;
    end
    disp("maxi " + string(maxi) + " mini " + string(mini))
endfunction

function luminance(x)
    [nl, nc] = size(x);
    newX = x;
    lumi = -100;
    disp("lumi " + string(lumi));
    for i = 1:nl
        for j = 1:nc
            if lumi > 0 // On va vers 255
                if newX(i, j) < 255 - lumi
                    newX(i, j) = newX(i, j) + lumi;
                
                else
                    newX(i, j) = 255;
                end;
            else        // On va vers 0
                if newX(i, j) > 0 - lumi
                    newX(i, j) = newX(i, j) + lumi;
                else
                    newX(i, j) = 0;
               end;
            end;
        end;
    end
    imshow(newX);
    saveImage(newX);
endfunction
 

function contraste(x)
    [nl, nc] = size(x)
    disp(string(nl) + " " + string(nc))
    hist = histogramme(x)
    [maxi, mini] = dynamique(hist)
    
    for ng = 1 : 256
        lut(ng) = (256*(ng - mini))/(maxi - mini)
    end;
    
    for i = 1:nl
        for j = 1 : nc
            x2(i, j) = lut(x(i,j))
        end;
    end
    imshow(x2);
endfunction
