
1) Flex Builder 3 install
   check out the sources from branches/refactor2/
   copy GA_AS3_refactor2.as to GA_AS3_refactor2.tmp
   
   in FB3 
   create an ActionScript project named "GA_AS3_refactor2"
   
   main source folder : src
   source path:
     lib/ES4a
     lib/ASTUce
     lib/edenRR
     tests/GAv4
   
   then overwrite GA_AS3_refactor2.as with your GA_AS3_refactor2.tmp content
 
 2) FB setup
    in project properties
    
    a) ActionScript Applications
       add GA_TestRunner.as
    
    b) Run/Debug Settings
       create 2 configurations
       GA_AS3_refactor2 for src/GA_AS3_refactor2
       and
       GA_TestRunner for src/GA_TestRunner
       


