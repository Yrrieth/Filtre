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

function hist = histogramme(x)
    [nc, nl] = size(x);
    hist = zeros([1:256]);

    for i = 1:nc
        for j = 1:nl
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
    mini = 256;
    maxi = 0;
    for i = 1:256
        if hist(i) < mini
            mini = i;
        end;
    end
    disp("maxi " + string(maxi) + " mini " + string(mini))
endfunction

function luminance(x)
    [nc, nl] = size(x);
    newX = x;
    lumi = -50;
    disp("lumi " + string(lumi));
    for i = 1:nc
        for j = 1:nl
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
endfunction

function moy = moyenne(x)
    [nc, nl] = size(x); 
    moy = 0;
    for i = 1:nc
        for j = 1:nl
            moy = moy + x(i, j);
        end;
    end
    n = nl * nc;
    //disp(n);
    disp(moy);
    moy = moy / n
    
endfunction

