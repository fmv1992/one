with AUnit.Assertions; use AUnit.Assertions;
with AUnit.Test_Cases;
with Math_Core;
with Ada.Directories;
with Ada.Text_IO; use Ada.Text_IO;

package body Test_Math is

   function Name (T : Test_Case) return AUnit.Message_String is
   begin
      return AUnit.Format ("Math Core Tests");
   end Name;

   procedure Register_Tests (T : in out Test_Case) is
   begin
      AUnit.Test_Cases.Registration.Register_Routine
         (T, Test_Addition_Basic'Access, "Test Basic Addition");
      AUnit.Test_Cases.Registration.Register_Routine
         (T, Test_Addition_Negative'Access, "Test Negative Addition");
      AUnit.Test_Cases.Registration.Register_Routine
         (T, Test_Subtraction_Basic'Access, "Test Basic Subtraction");
      AUnit.Test_Cases.Registration.Register_Routine
         (T, Test_Subtraction_Negative'Access, "Test Negative Subtraction");
      AUnit.Test_Cases.Registration.Register_Routine
         (T, Test_Ensure_Tests_Are_Run'Access, "Test runner execution");
   end Register_Tests;

   procedure Test_Addition_Basic (T : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (Math_Core.Add (2, 2) = 4, "Basic addition failed!");
   end Test_Addition_Basic;

   procedure Test_Addition_Negative (T : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (Math_Core.Add (-5, 3) = -2, "Negative addition failed!");
   end Test_Addition_Negative;

   procedure Test_Subtraction_Basic (T : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (Math_Core.Subtract (5, 3) = 2, "Basic subtraction failed!");
   end Test_Subtraction_Basic;

   procedure Test_Subtraction_Negative (T : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      Assert (Math_Core.Subtract (-2, -3) = 1, "Negative subtraction failed!");
   end Test_Subtraction_Negative;

   procedure Test_Ensure_Tests_Are_Run (T : in out AUnit.Test_Cases.Test_Case'Class) is
      Test_Mark_File : constant String := Ada.Directories.Compose
         (Containing_Directory => "tmp",
          Name                 => ".test_mark.txt");
      File : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Create
         (File => File,
          Mode => Ada.Text_IO.Out_File,
          Name => Test_Mark_File);
      Ada.Text_IO.Close (File);
   end Test_Ensure_Tests_Are_Run;

end Test_Math;
