with Ada.Text_IO; use Ada.Text_IO;

procedure Gradebook is

   Max_Students : constant Integer := 5;
   Max_Tests    : constant Integer := 3;

   type Score_Array is array (1 .. Max_Tests) of Integer;

   type Student is record
      Name   : String (1 .. 20);
      Length : Natural := 0;
      Scores : Score_Array;
   end record;

   type Student_List is array (1 .. Max_Students) of Student;

   procedure Set_Student(
      S       : out Student;
      N       : in String;
      S1, S2, S3 : in Integer
   ) is
   begin
      S.Length := N'Length;
      for I in 1 .. N'Length loop
         S.Name(I) := N(I);
      end loop;

      for I in N'Length + 1 .. 20 loop
         S.Name(I) := ' ';
      end loop;

      S.Scores(1) := S1;
      S.Scores(2) := S2;
      S.Scores(3) := S3;
   end Set_Student;

   function Average(S : Student) return Integer is
      Sum : Integer := 0;
   begin
      for I in S.Scores'Range loop
         Sum := Sum + S.Scores(I);
      end loop;
      return Sum / Max_Tests;
   end Average;

   procedure Print_Student(S : Student) is
   begin
      Put_Line("Student: " & S.Name(1 .. S.Length));
      Put("Scores: ");
      for I in S.Scores'Range loop
         Put(Integer'Image(S.Scores(I)));
      end loop;
      New_Line;
      Put_Line("Average: " & Integer'Image(Average(S)));
      New_Line;
   end Print_Student;

   Students : Student_List;
   Highest  : Integer := -1;
   Lowest   : Integer := 999;
   High_Name : String (1 .. 20);
   Low_Name  : String (1 .. 20);
   High_Len  : Natural := 0;
   Low_Len   : Natural := 0;

begin
   Set_Student(Students(1), "Alice", 90, 85, 92);
   Set_Student(Students(2), "Bob",   78, 82, 80);
   Set_Student(Students(3), "Carol", 88, 91, 84);
   Set_Student(Students(4), "Dave",  70, 75, 72);
   Set_Student(Students(5), "Eve",   95, 93, 97);

   for I in Students'Range loop
      declare
         A : Integer := Average(Students(I));
      begin
         Print_Student(Students(I));

         if A > Highest then
            Highest := A;
            High_Name := Students(I).Name;
            High_Len  := Students(I).Length;
         end if;

         if A < Lowest then
            Lowest := A;
            Low_Name := Students(I).Name;
            Low_Len  := Students(I).Length;
         end if;
      end;
   end loop;

   Put_Line("Class Highest Average: " &
      High_Name(1 .. High_Len) & " (" & Integer'Image(Highest) & ")");

   Put_Line("Class Lowest Average: " &
      Low_Name(1 .. Low_Len) & " (" & Integer'Image(Lowest) & ")");

end Gradebook;
