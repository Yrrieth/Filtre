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

function saveImage(x, nomFichier)
    ret = imwrite(x, nomFichier);
endfunction

function hist = histogramme(x)
    [nl, nc] = size(x);
    hist = zeros([1:256]);

    for i = 1:nl
        for j = 1:nc
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
    //disp("lumi " + string(lumi));
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
    saveImage(newX, "luminance.png");
endfunction
 

function contraste(x)
    [nl, nc] = size(x);
    x2 = x
    hist = histogramme(x);
    [maxi, mini] = dynamique(hist);
    
    for ng = 1 : 256
        lut(ng) = (255*(ng - mini))/(maxi - mini)
    end;
    
    for i = 1:nl
        for j = 1 : nc
            //disp(string(lut(x(i, j))) + " i : " + string(i) + " j : " + string(j))
            if x(i,j) == 0
                x2(i, j) = lut(1)
            else
                x2(i, j) = lut(x(i,j))
            end;
            //disp(x2(i, j))
        end;
    end
    imshow(x2);
    saveImage(x2, "contraste.png")
endfunction

function negatif(x)
    [nl, nc] = size(x);
    newX = x;
    for i = 1:nl
        for j = 1:nc
            newX(i, j) = 255 - newX(i, j)
        end;
    end
    imshow(newX);
    saveImage(newX, "negatif.png");
endfunction

function egalisationNB(x)
    [nl, nc] = size(x);
    newX = x; 
    hist = histogramme(x);
    histCumule = zeros([1:256]);
    
    for i = 1:256
        histCumule(i + 1) = histCumule(i) + hist(i);
    end
    
    for i = 1:nl
        for j = 1:nc
            if x(i,j) == 0
                newX(i, j) = (histCumule() * 255) / length(x);
            else
                newX(i, j) = (histCumule(x(i, j)) * 255) / length(x);
            end;
        end;
    end
    
    imshow(newX);
    saveImage(newX, "egalisationNB.png");
endfunction

function grisR(x)
    r = x(:,:,1);
    imshow(r);
    saveImage(r, "grisR.png");
endfunction

function grisV(x)
    v = x(:,:,2);
    imshow(v);
    saveImage(v, "grisV.png");
endfunction

function grisB(x)
    b = x(:,:,3);
    imshow(b);
    saveImage(b, "grisB.png");
endfunction
