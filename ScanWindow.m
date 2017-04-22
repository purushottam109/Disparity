function [ window ] = ScanWindow( imageMatrix, Col, Row, size, scale)
    
    width = scale * size;
    width = width - 1; 
    window = imageMatrix(:,Col:Col+width);  
    window = window(Row:Row+size-1,:);

end


