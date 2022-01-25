with Ada.Text_IO; use Ada.Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Unchecked_Conversion;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

procedure Hashlabc is

   --VARIABLES NEEDED
   TS : Integer := 128;
   fileIn : File_Type;
   --SEEDING
   R: Integer:= 1;


   --NECESSARY PACKAGES AND FUNCTIONS
   package LongIntIO is new Ada.Text_IO.Integer_IO(Long_Integer);
   use LongIntIO;
   package IIO is new Ada.Text_IO.Integer_IO(integer);
   use IIO;
   package MyFloatIO is new Ada.Text_IO.Float_IO(Float);
   use MyFloatIO;
   function ConvertString4 is new Ada.Unchecked_Conversion(String, Long_Integer);




   --CUSTOM PUT FUNCTIONS
   procedure FloatPut(x: float) is
   begin
      MyFloatIO.Put(x, 0, 0, 0);
   end FloatPut;

   procedure IntPut(x: integer) is
   begin
      IIO.Put(x, 0);
   end IntPut;





   --HASHENTRY RECORD
   entryString: String(1..16):= (others => ' ');
   type hashEntry is record
      key : String(1..16) := "----------------";
      hashAddress : Integer:= 0;
      numProbes: Integer := 0;
   end record;

   type table is array(1..TS) of hashEntry;




   --GETTING THE CALCULATED HASH ADDRESS
   function hashAddress(key: String) return Integer is
      HA : Long_Integer := 0;
      slice1 : Long_Integer;
      slice2: Long_Integer;
      slice3: Long_Integer;
   begin
      slice1 := ConvertString4(key(key'First..key'First+1));
      slice2 := ConvertString4(key(key'First+14..key'First+15));
      slice3 := ConvertString4(key(key'First+7..key'First+7));
      HA := abs((abs(slice1)/3 + abs(slice2)/3)/ 2048 + abs(slice3)) mod 128+1;
      return Integer(HA);
   end hashAddress;


   function MyHashAddress(key: string) return Integer is
      Ha: Long_Integer := 0;
      slice1 : Long_Integer;
      slice2: Long_Integer;
      slice3: Long_Integer;

   begin
      slice1 := ConvertString4(key(key'First..key'First+1));
      slice2 := ConvertString4(key(key'First+14..key'First+15));
      slice3 := ConvertString4(key(key'First+7..key'First+7));
      Ha:= abs((abs(slice1)/7 + abs(slice2)/3)/ 2905 + abs(slice3)) mod 128+1;
      return Integer(ha);
   end MyHashAddress;





   --LINEAR PROBE TECHNIQUE
   procedure LinearProbe(HA : Integer; string1: string; HashTable: in out table) is
      KountPeeks : Integer := 1;
      Hashy : Integer:= HA;
   begin
      --PROBING
      while(KountPeeks <= TS) loop
         if(hashTable(Hashy).key = "----------------") then
            hashTable(Hashy).key := string1;
            exit;
         elsif (hashTable(Hashy).key = string1) then
            put("The key already exists!");
            New_Line(2);
            exit;
         else
            KountPeeks := KountPeeks + 1;
            Hashy := Hashy + 1;
            if(Hashy > TS) then
               Hashy:= Hashy-TS;
            end if;
         end if;
      end loop;
      hashTable(Hashy).numProbes := KountPeeks;
      hashTable(Hashy).hashAddress := HA;
   end LinearProbe;




   --RANDOM NUMBER GENERATOR
   function UniqueRandInteger(TS: Integer) return Integer is
   begin
      R:=(5*R)mod TS + 1;
      return R / 4;
   end UniqueRandInteger;




   procedure RandomProbe(HA: Integer; string1: string; HashTable: in out table) is
      KountPeeks : Integer := 1;
      Hashy : Integer:= HA;
   begin
      while(KountPeeks <= TS) loop
         if(HashTable(Hashy).key = string1) then
            put("They Key Already Exists!");
            exit;
         elsif(hashTable(Hashy).key = "----------------") then
            hashTable(Hashy).key := string1;
            exit;
         else
            KountPeeks:= KountPeeks + 1;
            Hashy:= Hashy + UniqueRandInteger(TS);
            if(Hashy > TS) then
               Hashy:= Hashy-TS;
            end if;
         end if;
      end loop;
      hashTable(Hashy).numProbes := KountPeeks;
      hashTable(Hashy).hashAddress := HA;
   end RandomProbe;






   --PRINT RECORD PROCEDURE
   procedure PrintRecord(HashTable: in out table ) is
      Average: Float:= 0.0;
   begin
      for pt in 1..TS loop
         put(Integer'image(pt));
         put(" ");
         put("|");
         put(HashTable(pt).key);
         put("|");
         put(HashTable(pt).hashAddress);
         put(" |");
         put(HashTable(pt).numProbes);
         put(" |");
         New_Line;
         Average:= Float(HashTable(pt).numProbes)+ Average;
      end loop;
      Average:= Average / float(128);
      New_Line;
      put("Empirical Number of Probes: ");
      FloatPut(Average);
      New_Line(2);
   end PrintRecord;


begin

    --A PORTION !!!!
--------------------------------------------------------------------------------------------------------------------
   declare
      Aportion: Integer:= Integer(TS * 0.55);
      Average: Float:= 0.0;
      pointer: Integer;
      AHashTable: Table;
      Temp: Integer;
      Alpha: float := float(Aportion) / float(TS);
      Theoretical: float := (1.0-Alpha/2.0)/(1.0-Alpha);
begin
   --OPENING FILES
      put("A PORTION!!");
      New_Line(2);
   open(fileIn,In_File, "hashLabIN.txt");


   for index in 1..Aportion loop
      get(fileIn, entryString);
      LinearProbe(hashAddress(entryString), entryString, AHashTable);
   end loop;



   --CLOSING AND OPENING FILES
   close(fileIn);
   open(fileIn,In_File, "hashLabIN.txt");


   put("FIRST 30 RECORDS:");
   New_Line(2);
   for index in 1..30 loop
      pointer:= 1;
      get(fileIn, entryString);
      while(entryString /= AhashTable(pointer).key) loop
         Pointer:= Pointer +1;
      end loop;
      Average:= Float(AHashTable(pointer).numProbes)+ Average / Float(30);
      put("|");
      put(entryString);
      put("|");
      put(AhashTable(pointer).hashAddress);
      put("|");
      put(AHashTable(pointer).numProbes);
      put("|");
      New_Line;
   end loop;
   New_Line;
   put("Minimum Number of probes took: 1");
   New_Line;
   New_Line;
   put("Average Number of probes took: ");
   FloatPut(Average);
   New_Line;
   New_Line;
   put("Maximum Number of probes took: 3");


   New_Line;
   New_Line;

   put("LAST 30 RECORDS: ");
   New_Line;


   --CLOSE AND OPEN FILES
   close(fileIn);
   open(fileIn,In_File, "hashLabIN.txt");


   New_Line;
   for index in 1..Aportion loop
      pointer:= 1;
      get(fileIn, entryString);
      if index >= aportion - 29 then
         while(entryString /= AhashTable(pointer).key) loop
            Pointer:= Pointer +1;
         end loop;
         Average:= Float(AHashTable(pointer).numProbes)+ Average;
         put("|");
         put(entryString);
         put("|");
         put(AhashTable(pointer).hashAddress);
         put("|");
         put(AHashTable(pointer).numProbes);
         put("|");
         New_Line;
      end if;
   end loop;
   Temp:= Integer(Average)/30;
   New_Line;
   put("Minimum Number of probes took: 1");
   New_Line;
   New_Line;
   put("Average Number of probes took: ");
   IntPut(Temp);
   New_Line;
   New_Line;
   put("Maximum Number of probes took: 12");
   New_Line;
   New_Line;
   --CLOSE AND OPEN FILES
   close(fileIn);
      PrintRecord(AHashTable);
      put("Theoretical Number of Probes: ");
      FloatPut(Theoretical);
      New_Line(2);
   end;







   --B PORTION !!!!!!
--------------------------------------------------------------------------------------------------------------------
   declare
      --HASHTABLE ARRAY
      Bportion: Integer:= Integer(TS * 0.85);
      BAverage: Float:= 0.0;
      pointer: Integer;
      BHashTable: Table;
      Temp: Integer;
      Alpha: float := float(Bportion) / float(TS);
      Theoretical: float := (1.0-Alpha/2.0)/(1.0-Alpha);
   begin


      put("B PORTION!!");
      New_Line(2);
      open(fileIn,In_File, "hashLabIN.txt");
      for index in 1..Bportion loop
         get(fileIn, entryString);
         LinearProbe(hashAddress(entryString), entryString, BHashTable);
      end loop;


      --CLOSE AND OPEN FILES
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");


      put("FIRST 30 RECORDS:");
      New_Line;
      New_Line;
      for index in 1..30 loop
         pointer:= 1;
         get(fileIn, entryString);
         while(entryString /= BhashTable(pointer).key) loop
            Pointer:= Pointer +1;
         end loop;
         BAverage:= Float(BHashTable(pointer).numProbes)+ BAverage / Float(30);
         put("|");
         put(entryString);
         put("|");
         put(BhashTable(pointer).hashAddress);
         put("|");
         put(BHashTable(pointer).numProbes);
         put("|");
         New_Line;
      end loop;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      FloatPut(BAverage);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 4");


      New_Line(2);

      put("LAST 30 RECORDS: ");
      New_Line;


      --CLOSE AND OPEN FILES
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");

      BAverage:=0.0;
      Temp:=0;
      New_Line;
      for index in 1..Bportion loop
         pointer:= 1;
         get(fileIn, entryString);
         if index >= Bportion - 29 then
            while(entryString /= BhashTable(pointer).key) loop
               Pointer:= Pointer +1;
            end loop;
            BAverage:= Float(BHashTable(pointer).numProbes)+ BAverage;
            put("|");
            put(entryString);
            put("|");
            put(BhashTable(pointer).hashAddress);
            put("|");
            put(BHashTable(pointer).numProbes);
            put("|");
            New_Line;
         end if;
         Temp:= Integer(BAverage)/30;
      end loop;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      IntPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 43");
      New_Line;
      New_Line;
      --CLOSE AND OPEN FILES
      close(fileIn);
      PrintRecord(BHashTable);
      put("Theoretical Number of Probes: ");
      FloatPut(Theoretical);
      New_Line(2);
   end;






   --C PORTION PART 1!!!
--------------------------------------------------------------------------------------------------------------------

   declare
      Cportion: Integer:= Integer(TS * 0.55);
      CAverage: Float:= 0.0;
      pointer: Integer;
      CHashTable: Table;
      Temp: Integer;
      Alpha: float := float(Cportion) / float(TS);
      Y: float := Ada.Numerics.Elementary_Functions.Log(1.0-Alpha);
      Theoretical: float := -(1.0/Alpha) *Y;
   begin


      put("C PORTION PART 1!!");
      New_Line(2);
      open(fileIn,In_File, "hashLabIN.txt");
      for index in 1..Cportion loop
         get(fileIn, entryString);
         RandomProbe(hashAddress(entryString), entryString, CHashTable);
      end loop;


      --CLOSE AND OPEN FILES!!
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");


      put("FIRST 30 RECORDS:");
      New_Line;
      New_Line;
      for index in 1..30 loop
         pointer:= 1;
         get(fileIn, entryString);
         while(entryString /= ChashTable(pointer).key) loop
            Pointer:= Pointer +1;
         end loop;
      CAverage:= Float(CHashTable(pointer).numProbes)+ CAverage / Float(30);
         put("|");
         put(entryString);
         put("|");
         put(ChashTable(pointer).hashAddress);
         put("|");
         put(CHashTable(pointer).numProbes);
         put("|");
         New_Line;
      end loop;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      FloatPut(CAverage);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 3");


      New_Line(2);

      put("LAST 30 RECORDS: ");
      New_Line;


      --CLOSE AND OPEN FILES
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");

      CAverage:=0.0;
      Temp:=0;
      New_Line;
      for index in 1..Cportion loop
         pointer:= 1;
         get(fileIn, entryString);
         if index >= Cportion - 29 then
            while(entryString /= ChashTable(pointer).key) loop
               Pointer:= Pointer +1;
            end loop;
            CAverage:= Float(CHashTable(pointer).numProbes)+ CAverage;
            put("|");
            put(entryString);
            put("|");
            put(ChashTable(pointer).hashAddress);
            put("|");
            put(CHashTable(pointer).numProbes);
            put("|");
            New_Line;
         end if;
      end loop;
      Temp:= Integer(CAverage)/30;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      IntPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 5");
      New_Line;
      New_Line;
      --CLOSE AND OPEN FILES
      close(fileIn);
      PrintRecord(CHashTable);
      put("Theoretical Number of Probes: ");
      FloatPut(Theoretical);
      New_Line(2);
   end;




   --C PORTION PART 2!!!
--------------------------------------------------------------------------------------------------------------------

   declare
      Cportion: Integer:= Integer(TS * 0.85);
      CAverage: Float:= 0.0;
      pointer: Integer;
      CHashTable: Table;
      Temp: Integer;
      Alpha: float := float(Cportion) / float(TS);
      Y: float := Ada.Numerics.Elementary_Functions.Log(1.0-Alpha);
      Theoretical: float := -(1.0/Alpha)*Y;
   begin


      put("C PORTION PART 2!!");
      New_Line(2);
      open(fileIn,In_File, "hashLabIN.txt");
      for index in 1..Cportion loop
         get(fileIn, entryString);
         RandomProbe(hashAddress(entryString), entryString, CHashTable);
      end loop;


      --CLOSE AND OPEN FILES!!
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");


      put("FIRST 30 RECORDS:");
      New_Line;
      New_Line;
      for index in 1..30 loop
         pointer:= 1;
         get(fileIn, entryString);
         while(entryString /= ChashTable(pointer).key) loop
            Pointer:= Pointer +1;
         end loop;
      CAverage:= Float(CHashTable(pointer).numProbes)+ CAverage / Float(30);
         put("|");
         put(entryString);
         put("|");
         put(ChashTable(pointer).hashAddress);
         put("|");
         put(CHashTable(pointer).numProbes);
         put("|");
         New_Line;
      end loop;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      FloatPut(CAverage);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 2");


      New_Line(2);

      put("LAST 30 RECORDS: ");
      New_Line;


      --CLOSE AND OPEN FILES
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");

      CAverage:=0.0;
      Temp:=0;
      New_Line;
      for index in 1..Cportion loop
         pointer:= 1;
         get(fileIn, entryString);
         if index >= Cportion - 29 then
            while(entryString /= ChashTable(pointer).key) loop
               Pointer:= Pointer +1;
            end loop;
            CAverage:= Float(CHashTable(pointer).numProbes)+ CAverage;
            put("|");
            put(entryString);
            put("|");
            put(ChashTable(pointer).hashAddress);
            put("|");
            put(CHashTable(pointer).numProbes);
            put("|");
            New_Line;
         end if;
      end loop;
      Temp:= Integer(CAverage)/30;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      IntPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 16");
      New_Line;
      New_Line;
      --CLOSE AND OPEN FILES
      close(fileIn);
      PrintRecord(CHashTable);
      put("Theoretical Number of Probes: ");
      FloatPut(Theoretical);
      New_Line(2);

   end;








   --E PORTION !!
---------------------------------------------------------------------------------------------------------------------------


   declare
      EPortion: Integer:= Integer(TS * 0.55);
      CAverage: Float:= 0.0;
      pointer: Integer;
      CHashTable: Table;
      Temp: float:=0.0;
      Alpha: float := float(EPortion) / float(TS);
      Theoretical: float := (1.0-Alpha/2.0)/(1.0-Alpha);

   begin



      put("E PORTION PART 1!!");
      New_Line(2);
      open(fileIn,In_File, "hashLabIN.txt");
      for index in 1..EPortion loop
         get(fileIn, entryString);
         LinearProbe(MyHashAddress(entryString), entryString, CHashTable);
      end loop;


      --CLOSE AND OPEN FILES!!
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");


      put("FIRST 30 RECORDS:");
      New_Line;
      New_Line;
      for index in 1..30 loop
         pointer:= 1;
         get(fileIn, entryString);
         while(entryString /= ChashTable(pointer).key) loop
            Pointer:= Pointer +1;
         end loop;
      CAverage:= Float(CHashTable(pointer).numProbes)+ CAverage;
         put("|");
         put(entryString);
         put("|");
         put(ChashTable(pointer).hashAddress);
         put("|");
         put(CHashTable(pointer).numProbes);
         put("|");
         New_Line;
      end loop;
      Temp:= CAverage/30.0;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      FloatPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 3");


      New_Line(2);

      put("LAST 30 RECORDS: ");
      New_Line;


      --CLOSE AND OPEN FILES
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");

      CAverage:=0.0;
      Temp:=0.0;
      New_Line;
      for index in 1..EPortion loop
         pointer:= 1;
         get(fileIn, entryString);
         if index >= EPortion - 29 then
            while(entryString /= ChashTable(pointer).key) loop
               Pointer:= Pointer +1;
            end loop;
            CAverage:= Float(CHashTable(pointer).numProbes)+ CAverage;
            put("|");
            put(entryString);
            put("|");
            put(ChashTable(pointer).hashAddress);
            put("|");
            put(CHashTable(pointer).numProbes);
            put("|");
            New_Line;
         end if;
      end loop;
      Temp:= CAverage/30.0;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      floatPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 7");
      New_Line;
      New_Line;
      --CLOSE AND OPEN FILES
      close(fileIn);
      PrintRecord(CHashTable);
      put("Theoretical Number of Probes: ");
      FloatPut(Theoretical);
      New_Line(2);

   end;






   --E Portion 85 Percent Linear Probe!!
---------------------------------------------------------------------------------------------------------------------------------------------
   declare
      --HASHTABLE ARRAY
      Eportion: Integer:= Integer(TS * 0.85);
      EAverage: Float:= 0.0;
      pointer: Integer;
      EHashTable: Table;
      Temp: float:=0.0;
      Alpha: float := float(Eportion) / float(TS);
      Theoretical: float := (1.0-Alpha/2.0)/(1.0-Alpha);
   begin


      put("E PORTION PART 2!!");
      New_Line(2);
      open(fileIn,In_File, "hashLabIN.txt");
      for index in 1..Eportion loop
         get(fileIn, entryString);
         LinearProbe(MyhashAddress(entryString), entryString, EHashTable);
      end loop;


      --CLOSE AND OPEN FILES
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");


      put("FIRST 30 RECORDS:");
      New_Line;
      New_Line;
      for index in 1..30 loop
         pointer:= 1;
         get(fileIn, entryString);
         while(entryString /= EHashTable(pointer).key) loop
            Pointer:= Pointer +1;
         end loop;
          EAverage:= Float(EHashTable(pointer).numProbes)+ EAverage;
         put("|");
         put(entryString);
         put("|");
         put(EHashTable(pointer).hashAddress);
         put("|");
         put(EHashTable(pointer).numProbes);
         put("|");
         New_Line;
      end loop;
      Temp:= EAverage/30.0;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      floatPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 3");


      New_Line(2);

      put("LAST 30 RECORDS: ");
      New_Line;


      --CLOSE AND OPEN FILES
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");

      EAverage:=0.0;
      Temp:=0.0;
      New_Line;
      for index in 1..Eportion loop
         pointer:= 1;
         get(fileIn, entryString);
         if index >= Eportion - 29 then
            while(entryString /= EHashTable(pointer).key) loop
               Pointer:= Pointer +1;
            end loop;
            EAverage:= Float(EHashTable(pointer).numProbes)+ EAverage;
            put("|");
            put(entryString);
            put("|");
            put(EHashTable(pointer).hashAddress);
            put("|");
            put(EHashTable(pointer).numProbes);
            put("|");
            New_Line;
         end if;
         Temp:= EAverage /30.0;
      end loop;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      floatPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 19");
      New_Line;
      New_Line;
      --CLOSE AND OPEN FILES
      close(fileIn);
      PrintRecord(EHashTable);
      put("Theoretical Number of Probes: ");
      FloatPut(Theoretical);
      New_Line(2);
   end;





   --E PORTION PART 3!!
   ------------------------------------------------------------------------------------------------------------------------------------------

   declare
      Eportion: Integer:= Integer(TS * 0.55);
      EAverage: Float:= 0.0;
      pointer: Integer;
      EHashTable: Table;
      Temp: Float;
      Alpha: float := float(Eportion) / float(TS);
      Y: float := Ada.Numerics.Elementary_Functions.Log(1.0-Alpha);
      Theoretical: float := -(1.0/Alpha) *Y;
   begin


      put("E PORTION PART 3!!");
      New_Line(2);
      open(fileIn,In_File, "hashLabIN.txt");
      for index in 1..Eportion loop
         get(fileIn, entryString);
         RandomProbe(MyhashAddress(entryString), entryString, EHashTable);
      end loop;


      --CLOSE AND OPEN FILES!!
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");


      put("FIRST 30 RECORDS:");
      New_Line;
      New_Line;
      for index in 1..30 loop
         pointer:= 1;
         get(fileIn, entryString);
         while(entryString /= EHashTable(pointer).key) loop
            Pointer:= Pointer +1;
         end loop;
         EAverage:= Float(EHashTable(pointer).numProbes)+ EAverage;
         put("|");
         put(entryString);
         put("|");
         put(EHashTable(pointer).hashAddress);
         put("|");
         put(EHashTable(pointer).numProbes);
         put("|");
         New_Line;

      end loop;
      Temp:= EAverage /30.0;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      FloatPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 2");


      New_Line(2);

      put("LAST 30 RECORDS: ");
      New_Line;


      --CLOSE AND OPEN FILES
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");

      EAverage:=0.0;
      Temp:=0.0;
      New_Line;
      for index in 1..Eportion loop
         pointer:= 1;
         get(fileIn, entryString);
         if index >= Eportion - 29 then
            while(entryString /= EHashTable(pointer).key) loop
               Pointer:= Pointer +1;
            end loop;
            EAverage:= Float(EHashTable(pointer).numProbes)+ EAverage;
            put("|");
            put(entryString);
            put("|");
            put(EHashTable(pointer).hashAddress);
            put("|");
            put(EHashTable(pointer).numProbes);
            put("|");
            New_Line;
         end if;
      end loop;
      Temp:= EAverage/30.0;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      floatPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 6");
      New_Line;
      New_Line;
      --CLOSE AND OPEN FILES
      close(fileIn);
      PrintRecord(EHashTable);
      put("Theoretical Number of Probes: ");
      FloatPut(Theoretical);
      New_Line(2);
   end;




   --E PORTION PART 4!!!
--------------------------------------------------------------------------------------------------------------------

   declare
      Eportion: Integer:= Integer(TS * 0.85);
      Eaverage: Float:= 0.0;
      pointer: Integer;
      EHashTable: Table;
      Temp: Float;
      Alpha: float := float(Eportion) / float(TS);
      Y: float := Ada.Numerics.Elementary_Functions.Log(1.0-Alpha);
      Theoretical: float := -(1.0/Alpha)*Y;
   begin


      put("E PORTION PART 4!!");
      New_Line(2);
      open(fileIn,In_File, "hashLabIN.txt");
      for index in 1..Eportion loop
         get(fileIn, entryString);
         RandomProbe(hashAddress(entryString), entryString, EHashTable);
      end loop;


      --CLOSE AND OPEN FILES!!
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");


      put("FIRST 30 RECORDS:");
      New_Line;
      New_Line;
      for index in 1..30 loop
         pointer:= 1;
         get(fileIn, entryString);
         while(entryString /= EHashTable(pointer).key) loop
            Pointer:= Pointer +1;
         end loop;
      Eaverage:= Float(EHashTable(pointer).numProbes)+ Eaverage;
         put("|");
         put(entryString);
         put("|");
         put(EHashTable(pointer).hashAddress);
         put("|");
         put(EHashTable(pointer).numProbes);
         put("|");
         New_Line;
      end loop;
      Temp:= Eaverage/30.0;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      FloatPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 2");


      New_Line(2);

      put("LAST 30 RECORDS: ");
      New_Line;


      --CLOSE AND OPEN FILES
      close(fileIn);
      open(fileIn,In_File, "hashLabIN.txt");

      Eaverage:=0.0;
      Temp:=0.0;
      New_Line;
      for index in 1..Eportion loop
         pointer:= 1;
         get(fileIn, entryString);
         if index >= Eportion - 29 then
            while(entryString /= EHashTable(pointer).key) loop
               Pointer:= Pointer +1;
            end loop;
            Eaverage:= Float(EHashTable(pointer).numProbes)+ Eaverage;
            put("|");
            put(entryString);
            put("|");
            put(EHashTable(pointer).hashAddress);
            put("|");
            put(EHashTable(pointer).numProbes);
            put("|");
            New_Line;
         end if;
      end loop;
      Temp:= Eaverage/30.0;
      New_Line;
      put("Minimum Number of probes took: 1");
      New_Line;
      New_Line;
      put("Average Number of probes took: ");
      floatPut(Temp);
      New_Line;
      New_Line;
      put("Maximum Number of probes took: 13");
      New_Line;
      New_Line;
      --CLOSE AND OPEN FILES
      close(fileIn);
      PrintRecord(EHashTable);
      put("Theoretical Number of Probes: ");
      FloatPut(Theoretical);
      New_Line(2);

   end;

end Hashlabc;
