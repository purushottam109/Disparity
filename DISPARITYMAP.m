function [ dispMap ] = DISPARITYMAP( imgL, imgR, scanwinsize )
    %The function takes in the left and right grayscale stereo pair as imgl
    %and imgr resp.And the size of the scanning window scanwinsize.Its an
    %improvement over the method as it computes in a region around the
    %pixel.

    maxrows = size(imgL, 1) +1 -scanwinsize;
    maxcols = size(imgL, 2) +1 -scanwinsize;
    Scale= 3; %Right Large Search Window Scale
    for row = 1: maxrows
         disp(['Processing Row ',num2str(row), ' of ', num2str(maxrows)]);
        for col = 1: maxcols  
            WL = ScanWindow(imgL, col, row, scanwinsize, 1);      
            WRwidth = scanwinsize*Scale;            
            WRlargeX = col - (scanwinsize * ((Scale-1)/2)) - ((scanwinsize-1)/2);  
            WRlargeY = row ;
            if (WRlargeX < 1)
                WRlargeX = 1;
            end           
            if (WRlargeX > 1 + size(imgL, 2) - WRwidth)
                WRlargeX = 1 + size(imgL, 2) - WRwidth;
            end
            if (WRlargeY < 1)
                WRlargeY = 1;
            end
            if (WRlargeY > 1 + size(imgL, 1) - WRwidth)
                WRlargeY = 1 + size(imgL, 1) - WRwidth;
            end   
            WRlarge = ScanWindow(imgR, WRlargeX, WRlargeY, scanwinsize, Scale);             
            matchX = 1;
            maxDisp = -9999999;
            arrWidth = (Scale * scanwinsize) - (scanwinsize -1 );
            xMid = ((arrWidth - 1) / 2) + 1;
            for yrCurr = 1 : 1 + (size(WRlarge, 1) -scanwinsize)
                for xrCurr = 1 : 1 + (size(WRlarge, 2) - scanwinsize)
                    pollWindow = ScanWindow(WRlarge, xrCurr, yrCurr, scanwinsize, 1);                    
                    tempDisp = SSD(WL, pollWindow);                    
                    if (tempDisp > maxDisp)
                        maxDisp = tempDisp;
                        matchX = xrCurr;   
                    end
                end
            end
            x = matchX - xMid + (2 * (xMid - matchX));
            mappedVal = (255 / (xMid -1)) * abs(x);            
            dispMap(row, col, 1) = uint8(mappedVal);
        end
    end  
end

