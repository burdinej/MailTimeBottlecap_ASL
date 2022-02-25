state("MailTime-Win64-Shipping")
{
    uint bottleCapCountPtr : "MailTime-Win64-Shipping.exe", 0x04601F10, 0x8, 0x8, 0x740, 0x840, 0x908, 0x460, 0x9C0, 0x160;
    uint startTimerPtr : "MailTime-Win64-Shipping.exe", 0x45B4C08;
    uint quickStart: "MailTime-Win64-Shipping.exe", 0x4601F24;
}

init
{
    print("I connected!");
    Thread.Sleep(15000);
}

startup
{
    refreshRate = 60;
    vars.startFlag = false;
    vars.holdStart = false;
    vars.caps = 0;
}

update
{
    if ((current.quickStart != 0x00000003) && (current.startTimerPtr - old.startTimerPtr == 0x8000000) && vars.holdStart == false)
    {
       vars.startFlag = true;
       print("start!");
    }
}

start
{
    if (vars.startFlag == true && vars.holdStart == false)
    {
        vars.holdStart = true;
        return true;
    }
}

split
{
    if (vars.startFlag == true && current.bottleCapCountPtr > old.bottleCapCountPtr)
    {
      if (vars.caps < 5)
      {
          vars.caps++;
          print("here");
          return true;
      }
      else if (current.bottleCapCountPtr == 6)
      {
          print("you did it!");
          return true;
      }
      else {}
    }
}

reset
{
    if ((current.quickStart == 3) && (vars.startFlag == true))
    {
        vars.startFlag = false;
        vars.holdStart = false;
        vars.caps = 0;
        return true;
    }
}
