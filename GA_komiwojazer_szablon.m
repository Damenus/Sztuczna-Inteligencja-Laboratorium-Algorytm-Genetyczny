%xy=pobieranieDanych;
load('kwiatek.mat');
%load('tarcza.mat');

%liczba miast
nmiast=size(xy,1);

%macierz odleglosci miedzy miastami
odleglosci = zeros(nmiast, nmiast);
for i=1:nmiast
    for j=1:nmiast
        odleglosci(i,j) = sqrt((xy(i,1)-xy(j,1))^2 + (xy(i,2)-xy(j,2))^2); 
    end
end

%liczba osobnikow w populacji
nosobnikow = 80;

pMut = 0.03;      %p-wo mutacji
pCross = 0;     %p-wo krzy�owania

%inicjalizacja populacji
pop = zeros(nosobnikow,nmiast);
for n=1:nosobnikow
    pop(n,:)=randperm(nmiast); %ka�dy osobnik to losowa trasa
end

newpop = zeros(size(pop));


maxepochs = 10000;
historia = zeros(1,maxepochs);

%wy�wietlenie dw�ch okien obok siebie
h1 = gcf;
set(h1,'Units','normalize');
outerpos = get(h1,'OuterPosition');
outerpos(1) = (1-2*outerpos(3))/2;
set(h1,'OuterPosition',outerpos);
h2 = figure;
set(h2,'Units','normalize');
outerpos(1) = (1-2*outerpos(3))/2+outerpos(3);
set(h2,'OuterPosition',outerpos);

showInterval = 50;

%g��wna p�tla algorytmu
for epoka=1:maxepochs
    
    %ocena
    dlugosciTras = zeros(1,nosobnikow);
    
    %UZUPE�NIJ TUTAJ
    
    ilemiast = nmiast-1;
    for osob = 1:nosobnikow
        for miasa = 1:ilemiast
            dlugosciTras(1,osob) =  dlugosciTras(1,osob) + odleglosci(pop(osob,miasa),pop(osob,miasa+1));
        end
        dlugosciTras(1,osob) =  dlugosciTras(1,osob) + odleglosci(pop(osob,1),pop(osob,nmiast)); %popwrót do miejsca wyruszenia
    end
    
    
    %znalezienie i zapisanie najlepszej trasy (dla elitaryzmu)
    [historia(epoka),bestidx] = min(dlugosciTras);
    besttrasa = pop(bestidx,:);
    
    
    %selekcja turniejowa (lub ruletkowa)

    %UZUPE�NIJ TUTAJ (newpop uzupe�niona wyselekcjonowanymi osobnikami z pop)
    newpop = zeros(nosobnikow,nmiast);
    for na = 1:nosobnikow %(nosobnikow/2)
       los1 = fix( 1 + (nosobnikow - 1).*rand(1,1));
       los2 = fix( 1 + (nosobnikow - 1).*rand(1,1));
       if dlugosciTras(1,los1) < dlugosciTras(1,los2)
           newpop(na,:) = pop(los1,:);
       else
           newpop(na,:) = pop(los2,:);
       end       
    end
    
    
    %krzyzowanie
    for n = 1:ceil(pCross*nosobnikow/2)
        [newpop(2*n-1,:), newpop(2*n,:)] = ...
            orderedCrossover(newpop(2*n-1,:), newpop(2*n,:));
    end
    
    
    %mutacje
    
    %mutacja rodzaj 1 (switching)
    %np. [1 2 3 4 5 6] -> [1 5 3 4 2 6]
    
    %UZUPE�NIJ TUTAJ
    
    for mutanumer = 1:(pMut * nosobnikow / 2)
        %losowanie wiersza
         los = fix( 1 + (nosobnikow - 1).*rand(1,1));
         mutowanywiersz = newpop(los,:);
         %losowanie kolumn
         los1 = fix( 1 + (nmiast - 1).*rand(1,1));
         los2 = fix( 1 + (nmiast - 1).*rand(1,1));
         %zamiana dwóch elementów
         tmpa = mutowanywiersz(1,los1);
         mutowanywiersz(1,los1) = mutowanywiersz(1,los2);
         mutowanywiersz(1,los2) = tmpa;  
         
         newpop(los,:) =   mutowanywiersz(1,:); 
    end
    
    
    %mutacja rodzaj 2 (inversion) fliplr
    %np. [1 2 3 4 5 6] -> [1 5 4 3 2 6]
    
    %UZUPE�NIJ TUTAJ
    
     for mutanumer = 1:(pMut * nosobnikow / 2)
         los = fix( 1 + (nosobnikow - 1).*rand(1,1));
         mutowanywiersz = newpop(los,:);
         
         los1 = fix( 1 + (nmiast - 1).*rand(1,1));
         los2 = fix( 1 + (nmiast - 1).*rand(1,1));
         
         %odwrucenie ciagu
         if los1 < los2
            tmpb = fliplr(mutowanywiersz(1,los1:los2));
            mutowanywiersz(1,los1:los2) = tmpb;
         else
            tmpb = fliplr(mutowanywiersz(1,los2:los1));
            mutowanywiersz(1,los2:los1) = tmpb;
         end
         
        newpop(los,:) =   mutowanywiersz(1,:); 
    end
    
    
    
    %mutacja rodzaj 3 (translation)
    %np. [1 2 3 4 5 6] -> [1 5 6 2 3 4]
    
    %UZUPE�NIJ TUTAJ
    
     for mutanumer = 1:(pMut * nosobnikow / 2)
         los = fix( 1 + (nosobnikow - 1).*rand(1,1));
         mutowanywiersz = newpop(los,:);
         
         los1 = fix( 1 + (nmiast - 1).*rand(1,1));
         los2 = fix( 1 + (nmiast - 1).*rand(1,1));
         
         %wyciecie kawałka z lini i doklejenie go na koniec
         tmpc = mutowanywiersz(1,los1:los2);
         mutowanywiersz(los1:los2) = [];
         mutowanywiersz = [mutowanywiersz tmpc];
         
         newpop(los,:) =   mutowanywiersz(1,:); 
    end
    
    
    %zmiana pokolenia 
    pop = newpop;
    
    %elitaryzm
    pop(nosobnikow,:) = besttrasa;
    
    if mod(epoka,showInterval) == 0
        %wyswietlenie najlepszego (trasa)
        %wyczyszczenie poprzedniej trasy
        set(0,'CurrentFigure',h1)
        clf(h1);           
        %narysowanie nowej
        plot(xy(:,1),xy(:,2),'ro');
        line([xy(besttrasa,1)' xy(besttrasa(1),1)],[xy(besttrasa,2)' xy(besttrasa(1),2)])
        axis([0 10 0 10])

        set(0,'CurrentFigure',h2)
        plot(historia(1:epoka))
        title('Zmiana d�ugo�ci trasy najlepszego osobnika w kolejnych populacjach.');
        xlabel('Epoka');
        ylabel('D�ugo�� trasy');
        pause(0.01)
    end
end