with AUnit.Assertions; use AUnit.Assertions;
with Math_Core;

package body Test_Math is

   function Name (T : Test_Case) return AUnit.Message_String is
   begin
      return AUnit.Format ("Math Core Tests");
   end Name;

   procedure Register_Tests (T : in out Test_Case) is
   begin
      Register_Routine (T, Test_Addition_Basic'Access, "Test Basic Addition");
      Register_Routine (T, Test_Addition_Negative'Access, "Test Negative Addition");
      Register_Routine (T, Test_Subtraction_Basic'Access, "Test Basic Subtraction");
      Register_Routine (T, Test_Subtraction_Negative'Access, "Test Negative Subtraction");
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

end Test_Math;
