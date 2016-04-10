clear

%Funkcja do optymalizacji:
[x y]=meshgrid(-5:0.05:5);
z=funea(x,y);
surf(x,y,z);
pause
close


%meta parametry:
maxEpok = 25;   %maksymalna liczba epok (prosty warunek zakonczenia petli)
PopSize=100;    %wielkosc populacji
pKrzyz=0.8;     %prawdopodobienstwo krzyzowania
pMut=0.05;      %prawdopodobienstwo mutacji
p=0.1; %wartoœæ minimalna funkcji oceny (aby daæ szansê najgorszym)




% Inicjowanie populacji (w)
w=10*rand(PopSize,2)-5;

%g³owna petla algorytmu
epoka=0;
while epoka<maxEpok
    
    % -------------Miara jakoœci (Fitness measure)-------------------------
    fit=funea(w(:,1),w(:,2));
    
    wmax=max(fit);
    wmin=min(fit);
    fit2=((1-p)*fit+p*wmin-wmax)/(wmin-wmax);
    
    % -------------Selekcja (ruletkowa)------------------------------------
    
    % Policzenie dystrybuanty (d)
    sumf=sum(fit2);
    prob=fit2/sumf;
    d = zeros(1,PopSize);
    d(1)=prob(1);
    for i=2:PopSize 
        d(i)=d(i-1)+prob(i);
    end;
    
    % powy¿sze mo¿na by napisaæ bardziej 'matlabowo':
%     d = cumsum(fit2);
%     d = d / d(end);
    
    %ruletka
    neww = zeros(size(w));
    for k=1:PopSize
        r=rand;
        t=r>d;
        isel=sum(t)+1;
        neww(k,:)=w(isel,:);
    end;
    w=neww;
    
    % Crossover
    
    vol=0.5;
    for i=1:ceil(pKrzyz*PopSize/2)
        dw1=w(2*i,1)-w(2*i-1,1);
        dw2=w(2*i,2)-w(2*i-1,2);
        alpha=vol*(rand-0.5);
        
        w(2*i-1,:)=[w(2*i-1,1)+dw1*alpha w(2*i-1,2)+dw2*alpha];
        w(2*i,:)=[w(2*i,1)-dw1*alpha w(2*i,2)-dw2*alpha];
    end; 
    
    % Mutation
    
    % Selecting one individual
    for i=1:ceil(pMut*PopSize)
        idx=ceil(rand*100);
        w(idx,:)=w(idx,:)+randn(1,2);
    end
    
    
    % Wizualizacja
    
    [x y]=meshgrid(-5:0.05:5);
    z=funea(x,y);
    contour(x,y,z,10);
    hold on;
    plot(w(:,1),w(:,2),'ko');
    hold off;
    pause(0.1)
    
    epoka=epoka + 1;
    [best ii]=min(funea(w(:,1),w(:,2))); 
    % [ok  best w(ii,:)]
end;