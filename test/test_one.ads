with AUnit.Test_Cases;

package Test_Math is
   type Test_Case is new AUnit.Test_Cases.Test_Case with null record;

   -- Register the test name.
   function Name (T : Test_Case) return AUnit.Message_String;

   -- Register the actual test procedures to run.
   procedure Register_Tests (T : in out Test_Case);

   -- Individual test routines.
   procedure Test_Addition (T : in out AUnit.Test_Cases.Test_Case'Class);

   -- Individual test routines.
   procedure Test_Addition (T : in out AUnit.Test_Cases.Test_Case'Class);
end Test_Math;
