int[]LineGrid = new int [63];
final int PlayerNumber = 4;
boolean []PlayerCanMove = {true, true, true, true};
int [][]PlayerPosition = new int [PlayerNumber][2];
int []TurnOnHostel = new int [PlayerNumber];
int CaseSize = 30;
int plateauY = 0;
int CurrentPlayerID = 0;
color Background = 51;
color EmptyCase = color(255, 255, 255);

final color RED = color(255, 0, 0);
final color BLUE = color(0,0 , 255);
final color GREEN = color(0, 255, 0);
final color GREY = color(255/2, 255/2, 255/2);
final int POSITION = 0;
final int LASTPOSITION =1; 

boolean IsPlaying = true;

final int puits = 3;
final int hotel = 19;
final int labyrinthe = 42;
final int prison = 52;
final int skull = 58;

final int SCREENSIZEX = 1920;
final int SCREENSIZEY = 1080;

////INIT

void setup()
{
  size(1920,1080);
  background(Background);
  rectMode(CENTER);

  InitGrid();
  InitPlayer();
  DisplayGrid();
  DisplayPlayer(CurrentPlayerID);
}


///MAIN LOOP
void draw ()
{
}


void mouseClicked()
{
  if(IsPlaying)
  PlayTurn();
  
  
}


void PlayTurn()
{
  int D1 = ThrowDice();
  int D2 = ThrowDice();
  int total = D1 + D2;

  CheckDice(D1, D2);


  
  if (PlayerCanMove[CurrentPlayerID])
  {
    PlayerPosition[CurrentPlayerID][POSITION] += total;
  } 
  else
  {
    GetNextPlayer();
  }

  CheckMove();
  CheckSpecialCase();
  CheckPlayerOnSameCases();
  CallMovePlayer();
  
  if(CheckWinCondition())
  {
    DrawWinRect();
  }
  
  
  
  GetNextPlayer();


}


public void InitPlayer()
{
  for(int i = 0; i < 4; i++)
  {
    DisplayPlayer(i);
  }
}

public boolean CheckDice(int D1, int D2)
{
  if ((D1 == 3 && D2 == 6) || (D1 == 6 && D2 == 3))
  {
    PlayerPosition[CurrentPlayerID][POSITION] = 26 -1;
    PlayerCanMove[CurrentPlayerID] = true;
    return false;
  } else if ((D1 == 4 && D2 == 5) || (D1 == 5 && D2 == 4))
  {
    PlayerPosition[CurrentPlayerID][POSITION] = 53 - 1;
    PlayerCanMove[CurrentPlayerID] = true;
    return false;
  } else if ((D1 + D2) == 6)
  {
    PlayerPosition[CurrentPlayerID][POSITION] = 12 - 1;
    PlayerCanMove[CurrentPlayerID] = true;
    return false;
  }
  return true;
}


/////////////////SPECIALE CASE
public boolean CheckSpecialCase()
{
  String str = "Player " + CurrentPlayerID + " is on : ";
  switch(PlayerPosition[CurrentPlayerID][POSITION])
  {
  case puits :
    OnPuis();
    println(str + "Puits");
    return false;

  case hotel :
    println(str + "hotel");
    OnHotel();
    return false;

  case labyrinthe :
    println(str + "labyrinthe");
    OnLabyrinthe();
    return false;

  case prison :
    println(str + "prison");
    OnPrison();
    return false;

  case skull :
    println(str + "skull");
    PlayerPosition[CurrentPlayerID][POSITION] = 0;
    return false;

  default:

    return true;
  }
}

void OnLabyrinthe()
{
  PlayerPosition[CurrentPlayerID][POSITION] = 30 - 1;
}


void OnHotel()
{
  if (TurnOnHostel[CurrentPlayerID] >= 2)
  {
    HotelEffect();
  } else
  {
    TurnOnHostel[CurrentPlayerID]++;
    PlayerCanMove[CurrentPlayerID] = false;
  }
}

void HotelEffect()
{
  PlayerPosition[CurrentPlayerID][POSITION]++;
  MovePlayers();
  TurnOnHostel[CurrentPlayerID] = 0;
}

void OnPrison()
{
  int AlreadyONCAsPlayerID = WichPlayerOnSameCase();
  if (AlreadyONCAsPlayerID < 0 )
  {
    PlayerCanMove[CurrentPlayerID] = false;
  } else if (AlreadyONCAsPlayerID >= 0)
  {
    PlayerCanMove[AlreadyONCAsPlayerID] = true;
    PlayerPosition[AlreadyONCAsPlayerID][POSITION] = PlayerPosition[CurrentPlayerID][LASTPOSITION];
    PlayerCanMove[CurrentPlayerID] = false;
  }
}

void OnPuis()
{
  int AlreadyONCAsPlayerID = WichPlayerOnSameCase();
  if (AlreadyONCAsPlayerID < 0 )
  {
    BlockPlayer(CurrentPlayerID);
  } else if (AlreadyONCAsPlayerID >=0)
  {
    PlayerCanMove[CurrentPlayerID] = false;
    PlayerCanMove[AlreadyONCAsPlayerID] = true;
    PlayerPosition[CurrentPlayerID][POSITION] = 3;
    PlayerPosition[AlreadyONCAsPlayerID][POSITION] = 2;
  }
}


///UTILITIES

int ThrowDice()
{
  return (int)random(0, 6);
}

void InitGrid() {
  for (int i=0; i < LineGrid.length; i++)
  {
    LineGrid[i]= GetCaseXPosition(i);
  }
}


void GetNextPlayer()
{
  
  CurrentPlayerID++;
  if (CurrentPlayerID > 3)
  {
    CurrentPlayerID = 0;
  }
}


//CHECKING

boolean CheckWinCondition()
{
   if (PlayerPosition[CurrentPlayerID][POSITION] == 62)
   {
     IsPlaying = false;
     return true;
   }
   return false;
}


int WichPlayerOnSameCase()
{
  for (int i = 0; i < PlayerPosition.length; i++)
  {
    if (i != CurrentPlayerID)
    {
      if (PlayerPosition[CurrentPlayerID][POSITION] == PlayerPosition[i][POSITION])
      {
        println(i ," Est a la meme case que ", CurrentPlayerID);
        return i;
      }
    }
  }
  return -1;
}


void CheckPlayerOnSameCases()
{
  int PlayerOnSameCase = WichPlayerOnSameCase();
  if (PlayerOnSameCase != -1)
  {
    println("Current positon : ",PlayerPosition[PlayerOnSameCase][POSITION]," ",PlayerPosition[CurrentPlayerID][LASTPOSITION]);
    PlayerPosition[PlayerOnSameCase][POSITION] = PlayerPosition[CurrentPlayerID][LASTPOSITION];
    MovePlayers();
  }
}





void CheckMove()
{

  if (PlayerPosition[CurrentPlayerID][POSITION] > 62)
  {
    int Diff = PlayerPosition[CurrentPlayerID][POSITION] - 62;
    PlayerPosition[CurrentPlayerID][POSITION] = 62 - Diff;
  } 

}

void CallMovePlayer()
{
   MovePlayers();
   for(int i = 0; i < 4 ; i++)
   {
     PlayerPosition[i][LASTPOSITION] = PlayerPosition[i][POSITION];
   }
}




void DrawWinRect()
{
  int Xsize = 1000;
  int Ysize = 300;
  fill(232,178,91);
  rect(SCREENSIZEX/2, SCREENSIZEY/2, Xsize, Ysize);
  fill(GetPlayerColor(CurrentPlayerID));
  rect(SCREENSIZEX/2, SCREENSIZEY/2,Xsize /1.02 , Ysize/1.05);
  /////////////////////////////////////////////////////////////
  fill(0);
  textSize(120);
  text("You win",SCREENSIZEX/2 , SCREENSIZEY/2);
  textAlign(CENTER, CENTER);
}

void BlockPlayer(int PlayerID)
{
  PlayerCanMove[PlayerID] = false;
}

void MovePlayers()
{
  for(int i = 0; i < PlayerPosition.length; i++)
  {
   MovePlayer(i); 
  }
}


void MovePlayer(int ID)
{
 
  if (ID == 0)
  {
    DisplayCase(PlayerPosition[ID][LASTPOSITION], ID, EmptyCase, false);
    DisplayCaseNumber(PlayerPosition[ID][LASTPOSITION], PlayerPosition[ID][LASTPOSITION]+1);
  } else
  {
    DisplayCase(PlayerPosition[ID][LASTPOSITION], ID, Background, false);
  }
  DisplayPlayer(ID);

}

void DisplayPlayer(int PlayerID)
{
  DisplayCase(PlayerPosition[PlayerID][POSITION], PlayerID, GetPlayerColor(PlayerID), false);
}

void DisplayGrid()
{
  for (int i = 0; i < LineGrid.length; i++)
  {
    DisplayCase(i, 0, EmptyCase, true);
    DisplayCaseNumber(i, i+1);
  }
}




void DisplayCaseNumber(int caseID, int NumberDisplayed)
{
  fill(0);
  text(NumberDisplayed, ((CaseSize)  * caseID) + CaseSize/2, CaseSize/2);
  textAlign(CENTER, CENTER);
}

color GetPlayerColor(int PlayerID)
{
  switch(PlayerID)
  {
    case 0:
    return RED;
    
    case 1:
    return BLUE;
    
    case 2:
    return GREEN;
    
    case 3:
    return GREY;
    
    default:
    return color (0,0,0);
    
  }
}



int GetCaseXPosition(int x)
{
  return (x * CaseSize)+ CaseSize / 2;
}
int GetPositionY(int Y)
{
  return (Y * (CaseSize)) + CaseSize/2;
}

void DisplayCase(int X, int Y, color _color, boolean IsStroked)
{
  if (!IsStroked)
  {
    noStroke();
  }
  fill(_color);
  rect(LineGrid[X], GetPositionY(Y), CaseSize, CaseSize);
}
