-- test_math.adb
with AUnit.Assertions; use AUnit.Assertions;
with Math_Core;

package body Test_Math is

   function Name (T : Test_Case) return AUnit.Message_String is
   begin
      return AUnit.Format ("Math Core Tests");
   end Name;

   procedure Register_Tests (T : in out Test_Case) is
   begin
      -- Map the string name to the actual procedure
      Register_Routine (T, Test_Addition'Access, "Test Basic Addition");
   end Register_Tests;

   procedure Test_Addition (T : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      -- AUnit assertion
      Assert (Math_Core.Add (2, 2) = 4, "Addition failed!");
   end Test_Addition;

end Test_Math;
