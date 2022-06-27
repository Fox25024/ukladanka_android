import java.util.Collections;

int poziom=3;
int x,y;
PImage tlo;
int ile_ukladanek=14;
int wielkosc=400;
int wybrana;
class art{
  public
  int x;
  int cx;
  int cy;
  int y;
  PImage photo;
  PImage miniaturka;
  art(PImage temp)
  {
    photo=temp;
    miniaturka=photo;
    miniaturka.resize(wielkosc,wielkosc); 
    miniaturka.loadPixels();
  }
  void rysuj_miniaturki()
  {
    image(miniaturka,x,y);
  }
};
class puzzle{
  public
  PImage photo;
  int x;
  int y;
  int xx;
  int yy;
  puzzle(int w,int xx,int yy)
  {
    photo=createImage(w,w,RGB);
    photo.updatePixels();
    x=xx;
    y=yy;
    
  }
  void los(int xi, int yi)
  {
    xx=xi;
    yy=yi;
  }
  void rysuj()
  {
    image(photo,xx,yy);
  }
  void rysujorg()
  {
    image(photo,x,y);
  }
};
art[] u = new art[ile_ukladanek]; 

void ukladanki()
{
  PImage temp;
  for(int i=0; i<ile_ukladanek; i++)
  {
    temp= loadImage("u"+(i+1)+".jpg");
    u[i]=new art(temp); 
  }
}

void setup()
{
  orientation(PORTRAIT);
  ///frameRate(200);
  x=width;
  y=height;
  
  tlo = loadImage("tlo.jpg");
  tlo.resize(x,y); 
  tlo.loadPixels();
  smaltlo();
  ukladanki();
  
}
int ile_dod=0;
int pask(int o)
{
  int k=x-o*2;
  if(k%3==0)
  {
    return k/3;
  }
  else 
  {
    ile_dod=k&3;
    k=k-k%3;
    return k/3;
  }
  
}

void wartosci_startowe_art()
{
  int start=wielkosc;
  int paski=pask(wielkosc);
  int odstep=paski+ile_dod;//wymair obrazka
  int kontrola=0;
  for(int i=0; i<ile_ukladanek; i++)
  {
    kontrola++;
    if(i%2==0)
    {
      u[i].x=paski;
      u[i].y=start;
      
    }
    else if(i%2!=0)
    {
      u[i].y=start;
      u[i].x=wielkosc+paski+odstep;
    }
    if(kontrola%2==0)
    {
      kontrola=0;
      start=start+wielkosc+100;
    }
  }
}
PImage stlo;
void smaltlo()
{
  stlo=createImage(x,wielkosc,RGB);
  for(int i=0; i<x*wielkosc; i++ )
  {
    stlo.pixels[i]=tlo.pixels[i];
  }
  stlo.updatePixels();
}
boolean czy_nadane=false;
void menu()
{
  wzor=false;
  if(!czy_nadane)
  {
    wartosci_startowe_art();
    czy_nadane=true;
  }
  textSize(120);
  textAlign(CENTER);
  fill(0);
  text("Wybierz ukladanke",x/2, 200);
  for(int i=0;i<ile_ukladanek; i++)
  {
    u[i].rysuj_miniaturki();
  }
  image(stlo,0,0);
  textSize(120);
  textAlign(CENTER);
  fill(0);
  text("Wybierz ukladanke",x/2, 200); 
}
boolean wzor=true;

void rysuj()
{
  int indeks=0;
  for(int i=0; i<poziom; i++)
  {
    for(int j=0; j<poziom; j++)
    {
      p[indeks].rysuj();
      indeks++;
      if(indeks==poziom*poziom-1) break;
    }
  }
  image(u[wybrana].photo,wx,wy,wielkosc/2,wielkosc/2);
}



puzzle[] p;
int[] tlos;
int zwr_indeks(int ind)
{
  ind+=1;
  if(ind==poziom*poziom)ind=0;
  int indeks=0;
  for(int i=0; i<poziom*poziom;i++)
  {
    if(tlos[i]==ind)
    {
      indeks=i;
      break;
    }
  }
  return indeks;
}
void generujpuzzle()
{
  p=new puzzle[poziom*poziom];
  u[wybrana].photo.resize(pwymiar,pwymiar);
  u[wybrana].photo.loadPixels();

  for(int i=0; i<poziom*poziom; i++)
  {
    int[] temp = new int [2];
    temp=w.get(i);
    p[i]=new puzzle(pwymiar/poziom,temp[0],temp[1]);
    temp=w.get(zwr_indeks(i));

    p[i].los(temp[0],temp[1]);
    for(int j=0; j<pwymiar/poziom; j++)
    {
      for(int k=0; k<pwymiar/poziom; k++)
      {
        p[i].photo.pixels[j*pwymiar/poziom+k]=u[wybrana].photo.pixels[(i%poziom*pwymiar/poziom)+j*pwymiar+k+(i/poziom*pwymiar*pwymiar/poziom)];
      }
      
    }
    p[i].photo.updatePixels();
    
  }
  
}
PImage t2;
boolean plansza=true;
int pwymiar;
int ppaski=40;

void wgrajt()
{
  t2=loadImage("tlo2.jpg");
  int k=(x-(ppaski*2))/poziom;
  pwymiar=k*poziom;
  k=k*poziom+ppaski*2;
  k=x-k;
  k=k/2;
  ppaski+=k;
  t2.resize(pwymiar,pwymiar); 
  t2.loadPixels();
  plansza=false;
  
}
int tx,ty;
int wx,wy;
ArrayList<int[]> w = new ArrayList<int[]>();
ArrayList<int[]> w2 = new ArrayList<int[]>();
int[] wart= new int [poziom*poziom];

void warunek_dla_ukladanek()
{
  int temp=spr_inwersje();
  int pukladanki=poziom%2;
  if(pukladanki==1 && temp%2==0)
  {
    //spelnione
  }
  else 
  {
    los_tab();
  }
}

int spr_inwersje()
{
  int inwersja=0;
  for(int i=0; i<poziom*poziom; i++)
  {
    if(tlos[i]==0)continue;
      for(int j=i; j<poziom*poziom; j++)
      {
        if(tlos[i]>tlos[j] && tlos[j]!=0)
        {
          inwersja++;
        }
    }  
  }
  return inwersja;
  
}

void los_tab()
{
  tlos=new int [poziom*poziom];
  for(int i=0; i<poziom*poziom;i++)
  {
    tlos[i]=i+1;
    if(tlos[i]==poziom*poziom) tlos[i]=0;
  }
  for(int i=poziom*poziom-1; i>0; i--)
  {
    int a=tlos[i];
    int b=int(random(i));
    tlos[i]=tlos[b];
    tlos[b]=a;
  }
  warunek_dla_ukladanek();
  
}
void wspolp()
{
  los_tab();
  for(int i=0; i<poziom; i++)
  {
    for(int j=0; j<poziom; j++)
    {
      int[] temp= new int [2];
      temp[0]=j*(pwymiar/poziom)+tx;
      temp[1]=i*(pwymiar/poziom)+ty;
      w.add(temp);
    }
  }   
}
void draw()
{
  image(tlo,0,0);  
  if(wybrane)
  {
    menu();
  }
  else
  {
    if(plansza)
    {
      ///tu jeszcze wybieranie poziomów być powinno ale malymi kroczkami
      wgrajt();
      tx=ppaski;
      ty=y/2-pwymiar/2;
      wspolp();
      generujpuzzle();
      wx=tx+pwymiar-wielkosc/2;
      wy=ty-ppaski-wielkosc/2;
    }
    else
    {
      image(t2,tx,ty);
      rysuj();
    }
    
  }
  ///text(frameRate,300,100);
  
}
void czy_poprawne()
{
  int temp=0;
  for(int i=0; i<poziom*poziom; i++)
  {
    if(p[i].x==p[i].xx && p[i].y==p[i].yy)
    {
      temp++;
    }
  }
  if(temp==poziom*poziom)
  {
    exit();
  }
}

int my=0;
int my2=0;
void mousePressed()
{
  my=mouseY;
  
}
void mouseDragged()
{
    if(wybrane)
    {
    my2=my-mouseY;
    
      for(int i=0; i<ile_ukladanek; i++)
      {
        if((u[0].y>=wielkosc && my2<0) ||u[ile_ukladanek-1].y<=height-700 && my2>0)
        {
          if(u[0].y>=wielkosc && my2<0)
          {
            wartosci_startowe_art();
            break;
          }
          else if(u[ile_ukladanek-1].y<=height-500 && my2>0)
          {
            break;
          }
        }
        
        u[i].y=u[i].y-my2;
      }
      my=mouseY;
    }
  else if(!wybrane && mouseX>wx && mouseX<wx+wielkosc/2 && mouseY>wy && mouseY< wy+wielkosc/2)
  {
    image(u[wybrana].photo,tx,ty,pwymiar,pwymiar);
  }
    
}
boolean wybrane=true;
int sx,sy;
void touchStarted()
{
  sx=mouseX;
  sy=mouseY;
  if(!wybrane && !plansza)
  {
    sx=mouseX;
    sy=mouseY;
  }
}
void touchEnded()
{
  if(wybrane)
  {
    for(int i=0; i<ile_ukladanek; i++)
    {
      if(mouseY>wielkosc && mouseY<y && mouseX==sx && mouseY==sy && u[i].x<mouseX && u[i].x+wielkosc>mouseX && u[i].y<mouseY && u[i].y+wielkosc>mouseY)
      {
        wybrana=i;
        wybrane=false;
      }
    }
  }
  else if(!wybrane && !plansza && mouseX==sx && mouseY==sy)
  {
    for(int i=0; i<poziom*poziom; i++)
    {
      if(sx>p[i].xx && sx<p[i].xx+pwymiar/poziom && sy>p[i].yy && sy<p[i].yy+pwymiar/poziom)
      {
        if((p[i].xx+pwymiar/poziom==p[poziom*poziom-1].xx && p[i].yy == p[poziom*poziom-1].yy)||
          (p[i].xx-pwymiar/poziom==p[poziom*poziom-1].xx && p[i].yy == p[poziom*poziom-1].yy))
          {
            int Nx=p[i].xx;
            p[i].xx=p[poziom*poziom-1].xx;
            p[poziom*poziom-1].xx=Nx;
            break;
        }
        else if((p[i].xx==p[poziom*poziom-1].xx && p[i].yy == p[poziom*poziom-1].yy+pwymiar/poziom)||
                (p[i].xx==p[poziom*poziom-1].xx && p[i].yy == p[poziom*poziom-1].yy-pwymiar/poziom))
        {
          int Nx=p[i].yy;
          p[i].yy=p[poziom*poziom-1].yy;
          p[poziom*poziom-1].yy=Nx;
          break;
        } 
        czy_poprawne();
        break;
      }
    }
    
  }
}

void onBackPressed()//callback
{
  if(!wybrane)
  {
    wybrane=true;
    plansza=true;
    u[wybrana].photo.resize(wielkosc,wielkosc);
    u[wybrana].photo.loadPixels();
  }
  

  
}
