function xy=pobieranieDanych 

xy = [];
n = 0;

%pobieranie danych
axis([0 10 0 10])
hold on
but = 1;
while but == 1
   
    [xi,yi,but] = ginput(1);
    if but == 1
 
       plot(xi,yi,'ro')
       n = n+1;
       xy(n,:) = [xi,yi];
    end;
end 
hold off