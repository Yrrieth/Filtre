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
                      "luminance(x);");
                
                      
function x = loadImage() 
    myFile = uigetfile();
    x = imread(myFile);
    imshow(x);
endfunction

function hist = histogramme(x)
    [nl, nc] = size(x);
    hist = zeros([1:256]);
    
    for i = 1:nl
        for j = 1:nc
            val = x(i,j);
            hist(val) = hist(val)+1;
        end;
    end
endfunction

function luminance2(x)
    [nl, nc] = size(x);
    newX = x;
    lumi = 50;
    for i = 1:nl
        for j = 1:nc
            newX(i , j) = 255;
        end;
    end
    imshow(newX);
endfunction

function luminance(x)
    [nl, nc] = size(x);
    newX = x;
    lumi = 50;
    for i = 1:nl
        for j = 1:nc
            if lumi > 0 // On va vers 255
                if (newX(i, j) + lumi) < 255
                    newX(i, j) = newX(i, j) + lumi;
                else
                    newX(i, j) = 255;
                    //disp("x : " + string(x(i,j)) + ", newX : " + string(newX(i,j)));
                end;
            else        // On va vers 0
                if (newX(i, j) + lumi) > 0
                    newX(i, j) = newX(i, j) + lumi;
                else
                    newX(i, j) = 0;
               end;
            end;
        end;
    end
    imshow(newX);
endfunction

