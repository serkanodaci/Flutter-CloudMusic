class  CountTostr{
  static String chage(int i)
  {
    String value;
    if(i>10000&&i<100000000)
    {
      value=(i/10000.0).round().toString()+'万';
    }
    else if(i>100000000)
    {
      value=(i/100000000.0).round().toString()+'亿';
    }
    else 
    {
      value=i.toString();
    }
    return value;
  }
  static String commentCountChange(int i)
  {
    String value=i>0?i.toString():'';
    if(i>1000&&i<10000)
    {
      value='999+';
    }
    else if(i>10000&&i<100000)
    {
      value='1w+';
    }
    else if(i>100000)
    {
      value='10w+';
    }
    return value;
  }
}