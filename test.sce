clear;

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

function seuillage(x)
    [nl, nc] = size(x);
    seuil = 128;
    for i = 1:nl
        for j = 1:nc
           if x(i, j) > seuil
               x(i, j) = 255;
           else
               x(i, j) = 0;
           end;
        end
    end
    imshow(x);
    saveImage(x, "seuil.png");
endfunction

function passeBas(x)
    [nl, nc] = size(x);
    noyau = 3;
    for i = 1:nl
        for j = 1:nc
            i_tmp = i;
            j_tmp = j;
            moy = 0;
            if i <= (noyau - 1) / 2
                i_start = 1;
            else
                i_start = i - ((noyau - 1) / 2);
            end;
            if i >= nl - ((noyau - 1) / 2)
                i_end = nl;
            else
                i_end = i + ((noyau - 1) / 2);
            end;
            if j <= ((noyau - 1) / 2)
                j_start = 1;
            else
                j_start = j - ((noyau - 1) / 2);
            end;
            if j >= nc - ((noyau - 1) / 2)
                j_end = nc;
            else
                j_end = j + ((noyau - 1) / 2);
            end;
            //disp("i_start = " + string(i_start) + " j_start = " + string(j_start));
            //disp("i_end = " + string(i_end) + " j_end = " + string(j_end));
            for i_noy = i_start:i_end
                for j_noy = j_start:j_end
                    moy = moy + x(i_noy, j_noy);
                end;
            end;
            i = i_tmp;
            j = j_tmp;
            moy = moy / 9;
            x(i, j) = moy;    
        end;
    end
    imshow(x);
    saveImage(x, "passeBas.png");
endfunction
