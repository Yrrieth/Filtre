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
    // Sert à mettre en niveau de gris les images colorées
    if nl * nc ~= length(x) then
        //x = rgb2gray(x);
        couleur = 1
    else
        couleur = 0
    end
    newX = x;
    lumi = -100;
    
    //disp("lumi " + string(lumi));
    for i = 1:nl
        for j = 1:nc
            // Si l'image est en couleur
            if couleur == 1 then
                for k = 1:3
                    if lumi > 0 // On va vers 255
                        if newX(i, j, k) < 255 - lumi
                            newX(i, j, k) = newX(i, j) + lumi;
                        
                        else
                            newX(i, j, k) = 255;
                        end;
                    else        // On va vers 0
                        if newX(i, j, k) > 0 - lumi
                            newX(i, j, k) = newX(i, j) + lumi;
                        else
                            newX(i, j, k) = 0;
                       end;
                    end;
                end;
                
            else  // Sinon, l'image est en noir et blanc
            
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
    // Sert à mettre en niveau de gris les images colorées
    if nl * nc ~= length(x) then
        x = rgb2gray(x);
    end
    
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
    // Sert à mettre en niveau de gris les images colorées
    if nl * nc ~= length(x) then
        x = rgb2gray(x);
    end
    
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
    // Sert à mettre en niveau de gris les images colorées
    if nl * nc ~= length(x) then
        x = rgb2gray(x);
    end
    
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
    // Sert à mettre en niveau de gris les images colorées
    if nl * nc ~= length(x) then
        x = rgb2gray(x);
    end
    
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

function passeHaut(x)
    [nl, nc] = size(x);
    // Sert à mettre en niveau de gris les images colorées
    if nl * nc ~= length(x) then
        x = rgb2gray(x);
    end
    
    Gx = imfilter(x, [-1 0 1; -2 0 2; -1 0 1]);
    Gy = imfilter(x, [1 2 1; 0 0 0; -1 -2 -1]);
    g = Gx + Gy;

    imshow(g);
    saveImage(g, "passeHaut.png");
endfunction

function passeBas(x, rayonNoyau)
    [nl, nc] = size(x);
    // Sert à mettre en niveau de gris les images colorées
    if nl * nc ~= length(x) then
        x = rgb2gray(x);
    end
    
    // Si diametreNoyau == 1, alors tailleNoyau = 3
    tailleNoyau = 2 * rayonNoyau + 1;
    moy = 1 / (tailleNoyau ^ 2);  // Si diametreNoyau == 1, alors moy = 1 / 9
    noyau = moy * ones(tailleNoyau, tailleNoyau);  // Initialise le noyau de convolution
    
    x = imfilter(x, noyau);

    imshow(x);
    saveImage(x, "passeBas.png");
endfunction
